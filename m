Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3C424C7582
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237840AbiB1RzQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:55:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240253AbiB1RyI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:54:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9867DB12F2;
        Mon, 28 Feb 2022 09:41:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2631615B4;
        Mon, 28 Feb 2022 17:41:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAE0BC340F0;
        Mon, 28 Feb 2022 17:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070113;
        bh=5KaqpvvluzjEctSnCemTvMxDjNe7IYUy995fPKndeGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x0xCdOKVJCfftkCEMKlL95QeR0kvbVo/q0auswIuph78iKYs7W0gwJNEzcjlROhVX
         rXcumEcyvXXayi9N7AN83bUhy8c3s5sqg3A1AycHJJO1SCRI3ObcSQWzaCE59DlfTM
         U50wYfD46kHOXHvKu/wJ+Ap5zolcetnY5D4DnPDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vladimir Olovyannikov <vladimir.olovyannikov@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 091/139] bnxt_en: Increase firmware message response DMA wait time
Date:   Mon, 28 Feb 2022 18:24:25 +0100
Message-Id: <20220228172357.182578542@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit b891106da52b2c12dbaf73400f6d225b06a38d80 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c | 12 +++++++++---
 drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h |  2 +-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
index 8171f4912fa01..3a0eeb3737767 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
@@ -595,18 +595,24 @@ static int __hwrm_send(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
 
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
 			if (!(ctx->flags & BNXT_HWRM_CTX_SILENT))
 				netdev_err(bp->dev, "Error (timeout: %u) msg {0x%x 0x%x} len:%d v:%d\n",
-					   hwrm_total_timeout(i),
+					   hwrm_total_timeout(i) + j,
 					   le16_to_cpu(ctx->req->req_type),
 					   le16_to_cpu(ctx->req->seq_id), len,
 					   *valid);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h
index 9a9fc4e8041b6..380ef69afb51b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h
@@ -94,7 +94,7 @@ static inline unsigned int hwrm_total_timeout(unsigned int n)
 }
 
 
-#define HWRM_VALID_BIT_DELAY_USEC	150
+#define HWRM_VALID_BIT_DELAY_USEC	50000
 
 static inline bool bnxt_cfa_hwrm_message(u16 req_type)
 {
-- 
2.34.1



