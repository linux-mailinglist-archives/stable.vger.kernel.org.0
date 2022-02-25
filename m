Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A71304C48B4
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 16:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242001AbiBYPXm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 10:23:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242004AbiBYPXl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 10:23:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C0CF49CA2
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 07:23:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11135B830B8
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 15:23:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 626D6C340E7;
        Fri, 25 Feb 2022 15:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645802585;
        bh=BSJDPV4Z1bjZxpa+NOGeoCAqgj/tAJ5tJIkCui4CqUk=;
        h=Subject:To:Cc:From:Date:From;
        b=xZElDl0Ptq9bFBc4Cs8ydPTQohJ4XdKYt90sYqKid3prQIhtsjWLnaufxulKpdiiB
         TKRLBcAtoZPUIWJBzZ+BUxjWw1JEBn3NAzLMovMVg2UY4K4C8g93OBXjrR63xsCM4b
         sNxi/9wn8PauoVsgVdpxqCenDoArHthPKsY7ptEc=
Subject: FAILED: patch "[PATCH] bnxt_en: Increase firmware message response DMA wait time" failed to apply to 5.15-stable tree
To:     michael.chan@broadcom.com, davem@davemloft.net,
        vladimir.olovyannikov@broadcom.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 25 Feb 2022 16:22:58 +0100
Message-ID: <164580257814783@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b891106da52b2c12dbaf73400f6d225b06a38d80 Mon Sep 17 00:00:00 2001
From: Michael Chan <michael.chan@broadcom.com>
Date: Sun, 20 Feb 2022 04:05:52 -0500
Subject: [PATCH] bnxt_en: Increase firmware message response DMA wait time

When polling for the firmware message response, we first poll for the
response message header.  Once the valid length is detected in the
header, we poll for the valid bit at the end of the message which
signals DMA completion.  Normally, this poll time for DMA completion
is extremely short (0 to a few usec).  But on some devices under some
rare conditions, it can be up to about 20 msec.

Increase this delay to 50 msec and use udelay() for the first 10 usec
for the common case, and usleep_range() beyond that.

Also, change the error message to include the above delay time when
printing the timeout value.

Fixes: 3c8c20db769c ("bnxt_en: move HWRM API implementation into separate file")
Reviewed-by: Vladimir Olovyannikov <vladimir.olovyannikov@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
index 566c9487ef55..b01d42928a53 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
@@ -644,17 +644,23 @@ static int __hwrm_send(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
 
 		/* Last byte of resp contains valid bit */
 		valid = ((u8 *)ctx->resp) + len - 1;
-		for (j = 0; j < HWRM_VALID_BIT_DELAY_USEC; j++) {
+		for (j = 0; j < HWRM_VALID_BIT_DELAY_USEC; ) {
 			/* make sure we read from updated DMA memory */
 			dma_rmb();
 			if (*valid)
 				break;
-			usleep_range(1, 5);
+			if (j < 10) {
+				udelay(1);
+				j++;
+			} else {
+				usleep_range(20, 30);
+				j += 20;
+			}
 		}
 
 		if (j >= HWRM_VALID_BIT_DELAY_USEC) {
 			hwrm_err(bp, ctx, "Error (timeout: %u) msg {0x%x 0x%x} len:%d v:%d\n",
-				 hwrm_total_timeout(i), req_type,
+				 hwrm_total_timeout(i) + j, req_type,
 				 le16_to_cpu(ctx->req->seq_id), len, *valid);
 			goto exit;
 		}
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h
index d52bd2d63aec..c98032e38188 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h
@@ -90,7 +90,7 @@ static inline unsigned int hwrm_total_timeout(unsigned int n)
 }
 
 
-#define HWRM_VALID_BIT_DELAY_USEC	150
+#define HWRM_VALID_BIT_DELAY_USEC	50000
 
 static inline bool bnxt_cfa_hwrm_message(u16 req_type)
 {

