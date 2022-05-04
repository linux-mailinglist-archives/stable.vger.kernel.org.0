Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B21D451A7CB
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355244AbiEDRHS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355106AbiEDREI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:04:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C1544D9C1;
        Wed,  4 May 2022 09:52:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8457D61852;
        Wed,  4 May 2022 16:52:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1120C385AA;
        Wed,  4 May 2022 16:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683154;
        bh=WHbh4A6ClgjOu6hZJxIoyBalRcJQ3ef8RTnB7wCBapM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ILDNNaCdr6W+qCIjF2lL0rYWgiGb1UaLDzvstx+KV5HvXAljjByIdtDB0ad4iVYFI
         EBhQVvX6JPfwjzYesZdkbHWei4MtfuXIGSpTvYLgzuR0SfIKKlXVbL8VZloWfaTeRz
         uBZ1iAiIAg4HmNCbrQhexVs25brw3CGw7P+bb+YE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH 5.15 019/177] usb: typec: ucsi: Fix role swapping
Date:   Wed,  4 May 2022 18:43:32 +0200
Message-Id: <20220504153055.052584435@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
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
@@ -964,14 +964,18 @@ static int ucsi_dr_swap(struct typec_por
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
@@ -1002,11 +1006,13 @@ static int ucsi_pr_swap(struct typec_por
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


