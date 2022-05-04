Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B13551A8FC
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354466AbiEDRNK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356795AbiEDRJo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2FC1D31B;
        Wed,  4 May 2022 09:55:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 879A2B8279A;
        Wed,  4 May 2022 16:55:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3761BC385AA;
        Wed,  4 May 2022 16:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683334;
        bh=kZKq3ZishqK+X0zTlISgnwHroEnNga+xVwSdyqmmg1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AlSNrCuzZ4TiF0c9GdBOBMvGgL0HWvdyb8xJ+5iMUBqT/eZW+Xqljs3McHSawOY1N
         W02PHyO8Xjc/OCO3HHDDKtg2B1Tj+H5hogDcv6sEH+FR7LbTXw+RizURXVyrK5n7HU
         X3dXcvP0uLCZlGD+9TftpfG3gsmZ3c5ixXf1I47o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH 5.17 021/225] usb: typec: ucsi: Fix role swapping
Date:   Wed,  4 May 2022 18:44:19 +0200
Message-Id: <20220504153112.215490080@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
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
@@ -958,14 +958,18 @@ static int ucsi_dr_swap(struct typec_por
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
@@ -996,11 +1000,13 @@ static int ucsi_pr_swap(struct typec_por
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


