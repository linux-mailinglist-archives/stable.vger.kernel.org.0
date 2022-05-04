Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D01451A751
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354912AbiEDRDQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354572AbiEDQ6w (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:58:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD512BE5;
        Wed,  4 May 2022 09:50:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C59661720;
        Wed,  4 May 2022 16:50:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 611BCC385A4;
        Wed,  4 May 2022 16:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683028;
        bh=HY6g3a2YqxarSW+yXg6O1VC2q4lgiVbKF4W9sWwGzdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zaTamPKZPPLtzHhKJrI2hXzg9c3SQGUl+417X73sXD5CaRQ3bAdnuwHakW2Dqgu15
         8sigOraE5hls2S5O/I6DaUay7a7b1eafNXWWEKxcR5+/xaEo24Il4/CTAkOc2o6Uum
         GiwF7PbQ1ZW8OrQ7PWKvOqoZb/+zVjolIPhrCwNc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH 5.10 019/129] usb: typec: ucsi: Fix role swapping
Date:   Wed,  4 May 2022 18:43:31 +0200
Message-Id: <20220504153022.838977126@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153021.299025455@linuxfoundation.org>
References: <20220504153021.299025455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit eb5d7ff3cf0d55093c619b5ad107cd5c05ce8134 upstream.

All attempts to swap the roles timed out because the
completion was done without releasing the port lock. Fixing
that by releasing the lock before starting to wait for the
completion.

Link: https://lore.kernel.org/linux-usb/037de7ac-e210-bdf5-ec7a-8c0c88a0be20@gmail.com/
Fixes: ad74b8649bea ("usb: typec: ucsi: Preliminary support for alternate modes")
Cc: stable@vger.kernel.org
Reported-and-tested-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20220405134824.68067-3-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -937,14 +937,18 @@ static int ucsi_dr_swap(struct typec_por
 	if (ret < 0)
 		goto out_unlock;
 
+	mutex_unlock(&con->lock);
+
 	if (!wait_for_completion_timeout(&con->complete,
-					msecs_to_jiffies(UCSI_SWAP_TIMEOUT_MS)))
-		ret = -ETIMEDOUT;
+					 msecs_to_jiffies(UCSI_SWAP_TIMEOUT_MS)))
+		return -ETIMEDOUT;
+
+	return 0;
 
 out_unlock:
 	mutex_unlock(&con->lock);
 
-	return ret < 0 ? ret : 0;
+	return ret;
 }
 
 static int ucsi_pr_swap(struct typec_port *port, enum typec_role role)
@@ -975,11 +979,13 @@ static int ucsi_pr_swap(struct typec_por
 	if (ret < 0)
 		goto out_unlock;
 
+	mutex_unlock(&con->lock);
+
 	if (!wait_for_completion_timeout(&con->complete,
-				msecs_to_jiffies(UCSI_SWAP_TIMEOUT_MS))) {
-		ret = -ETIMEDOUT;
-		goto out_unlock;
-	}
+					 msecs_to_jiffies(UCSI_SWAP_TIMEOUT_MS)))
+		return -ETIMEDOUT;
+
+	mutex_lock(&con->lock);
 
 	/* Something has gone wrong while swapping the role */
 	if (UCSI_CONSTAT_PWR_OPMODE(con->status.flags) !=


