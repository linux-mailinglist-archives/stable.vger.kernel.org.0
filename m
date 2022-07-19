Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36A89579E28
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242533AbiGSM6f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238226AbiGSM6E (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:58:04 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B4624F1A1;
        Tue, 19 Jul 2022 05:23:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B48ABCE1BE6;
        Tue, 19 Jul 2022 12:23:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C7D2C341C6;
        Tue, 19 Jul 2022 12:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233397;
        bh=DSnmKI9BAc5haUNJPV0pkaM7GGOJqSGfP80wvs2MKMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qqyJowF/LHnsBt4HKShnH9G4togqBBGM1l/FJWRUj28HwzIfO2SZ4M+oSqm1n6y/O
         URNGt65XBPo/7yi3o7cpu9VlBJ6oc3O3QrnNXTBG6wfXfLVwMgOZoWY1sQmA2TlwER
         ZKn4+Mz0zjqWqW1CBUmT5o7FmdepGtW6GWRL4AI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 108/231] bnxt_en: Fix bnxt_refclk_read()
Date:   Tue, 19 Jul 2022 13:53:13 +0200
Message-Id: <20220719114723.694600153@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

[ Upstream commit ddde5412fdaa5048bbca31529d46cb8da882870c ]

The upper 32-bit PHC register is not latched when reading the lower
32-bit PHC register.  Current code leaves a small window where we may
not read correct higher order bits if the lower order bits are just about
to wrap around.

This patch fixes this by reading higher order bits twice and makes
sure that final value is correctly paired with its lower 32 bits.

Fixes: 30e96f487f64 ("bnxt_en: Do not read the PTP PHC during chip reset")
Cc: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
index f9c94e5fe718..3221911e25fe 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -76,14 +76,23 @@ static int bnxt_refclk_read(struct bnxt *bp, struct ptp_system_timestamp *sts,
 			    u64 *ns)
 {
 	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
+	u32 high_before, high_now, low;
 
 	if (test_bit(BNXT_STATE_IN_FW_RESET, &bp->state))
 		return -EIO;
 
+	high_before = readl(bp->bar0 + ptp->refclk_mapped_regs[1]);
 	ptp_read_system_prets(sts);
-	*ns = readl(bp->bar0 + ptp->refclk_mapped_regs[0]);
+	low = readl(bp->bar0 + ptp->refclk_mapped_regs[0]);
 	ptp_read_system_postts(sts);
-	*ns |= (u64)readl(bp->bar0 + ptp->refclk_mapped_regs[1]) << 32;
+	high_now = readl(bp->bar0 + ptp->refclk_mapped_regs[1]);
+	if (high_now != high_before) {
+		ptp_read_system_prets(sts);
+		low = readl(bp->bar0 + ptp->refclk_mapped_regs[0]);
+		ptp_read_system_postts(sts);
+	}
+	*ns = ((u64)high_now << 32) | low;
+
 	return 0;
 }
 
-- 
2.35.1



