Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4851579C38
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240949AbiGSMhZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240682AbiGSMgs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:36:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 160B86464;
        Tue, 19 Jul 2022 05:14:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1507861746;
        Tue, 19 Jul 2022 12:13:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB04C341C6;
        Tue, 19 Jul 2022 12:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232831;
        bh=USoxJJmNigTeOjCpA6MsQrQcsLyDaGVfZyfTu4lJXjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fCQ5TWP8OSY0HL8Y6eY2opfFQ2VkoG8w9ICHRuvpztYdBlGXT0sjdqycYNSUqPOtj
         AQoGWia25V/BJMzJ/RequBmy1Do4JSOnHmXHD1ZgA8pwjlaydf6RHnSaNVkdICjSo1
         QSU6qWC7B1WZystVnfBOpp0KtihwJ4d6RMKwl9+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 081/167] bnxt_en: Fix bnxt_refclk_read()
Date:   Tue, 19 Jul 2022 13:53:33 +0200
Message-Id: <20220719114704.408719777@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
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
index 62a931de5b1a..a78cc65a38f2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -61,14 +61,23 @@ static int bnxt_refclk_read(struct bnxt *bp, struct ptp_system_timestamp *sts,
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



