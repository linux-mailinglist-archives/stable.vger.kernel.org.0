Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77D8D51A881
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356158AbiEDRLU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356904AbiEDRJs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C8054706E;
        Wed,  4 May 2022 09:56:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7832BB8279A;
        Wed,  4 May 2022 16:56:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F163C385A5;
        Wed,  4 May 2022 16:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683380;
        bh=Ds5qoX0AhajCnRZJt91gG+L121nA7JmXmRUluaT3mYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SxPIYlqhC8uYC2AV27bQbffNBpwMAKN343fFuYHbfsbHHsZoaUoC9n57uo/aDbLq7
         Ksqi0Uze5+YpP9dXV9JwLJqJXpfuQBxJ9dK+RC1genqhqwjiNd5dq8R1EekX1h0Pqj
         6hP6R3mhLrhRsilnCz/AheXsbNJk4a+/kv5Nr3vM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuanhong Guo <gch981213@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 065/225] mtd: rawnand: fix ecc parameters for mt7622
Date:   Wed,  4 May 2022 18:45:03 +0200
Message-Id: <20220504153115.976420693@linuxfoundation.org>
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

From: Chuanhong Guo <gch981213@gmail.com>

[ Upstream commit 9fe4e0d3cbfe90152137963cc024ecb63db6e8e6 ]

According to the datasheet, mt7622 only has 5 ECC capabilities instead
of 7, and the decoding error register is arranged  as follows:
+------+---------+---------+---------+---------+
| Bits |  19:15  |  14:10  |   9:5   |   4:0   |
+------+---------+---------+---------+---------+
| Name | ERRNUM3 | ERRNUM2 | ERRNUM1 | ERRNUM0 |
+------+---------+---------+---------+---------+
This means err_mask should be 0x1f instead of 0x3f and the number of
bits shifted in mtk_ecc_get_stats should be 5 instead of 8.

This commit introduces err_shift for the difference in this register
and fix other existing parameters.

Public MT7622 reference manual can be found on [0] and the info this
commit is based on is from page 656 and page 660.

[0]: https://wiki.banana-pi.org/Banana_Pi_BPI-R64#Documents

Fixes: 98dea8d71931 ("mtd: nand: mtk: Support MT7622 NAND flash controller.")
Signed-off-by: Chuanhong Guo <gch981213@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220402160315.919094-1-gch981213@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/mtk_ecc.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/raw/mtk_ecc.c b/drivers/mtd/nand/raw/mtk_ecc.c
index 1b47964cb6da..4f6adb657c89 100644
--- a/drivers/mtd/nand/raw/mtk_ecc.c
+++ b/drivers/mtd/nand/raw/mtk_ecc.c
@@ -43,6 +43,7 @@
 
 struct mtk_ecc_caps {
 	u32 err_mask;
+	u32 err_shift;
 	const u8 *ecc_strength;
 	const u32 *ecc_regs;
 	u8 num_ecc_strength;
@@ -76,7 +77,7 @@ static const u8 ecc_strength_mt2712[] = {
 };
 
 static const u8 ecc_strength_mt7622[] = {
-	4, 6, 8, 10, 12, 14, 16
+	4, 6, 8, 10, 12
 };
 
 enum mtk_ecc_regs {
@@ -221,7 +222,7 @@ void mtk_ecc_get_stats(struct mtk_ecc *ecc, struct mtk_ecc_stats *stats,
 	for (i = 0; i < sectors; i++) {
 		offset = (i >> 2) << 2;
 		err = readl(ecc->regs + ECC_DECENUM0 + offset);
-		err = err >> ((i % 4) * 8);
+		err = err >> ((i % 4) * ecc->caps->err_shift);
 		err &= ecc->caps->err_mask;
 		if (err == ecc->caps->err_mask) {
 			/* uncorrectable errors */
@@ -449,6 +450,7 @@ EXPORT_SYMBOL(mtk_ecc_get_parity_bits);
 
 static const struct mtk_ecc_caps mtk_ecc_caps_mt2701 = {
 	.err_mask = 0x3f,
+	.err_shift = 8,
 	.ecc_strength = ecc_strength_mt2701,
 	.ecc_regs = mt2701_ecc_regs,
 	.num_ecc_strength = 20,
@@ -459,6 +461,7 @@ static const struct mtk_ecc_caps mtk_ecc_caps_mt2701 = {
 
 static const struct mtk_ecc_caps mtk_ecc_caps_mt2712 = {
 	.err_mask = 0x7f,
+	.err_shift = 8,
 	.ecc_strength = ecc_strength_mt2712,
 	.ecc_regs = mt2712_ecc_regs,
 	.num_ecc_strength = 23,
@@ -468,10 +471,11 @@ static const struct mtk_ecc_caps mtk_ecc_caps_mt2712 = {
 };
 
 static const struct mtk_ecc_caps mtk_ecc_caps_mt7622 = {
-	.err_mask = 0x3f,
+	.err_mask = 0x1f,
+	.err_shift = 5,
 	.ecc_strength = ecc_strength_mt7622,
 	.ecc_regs = mt7622_ecc_regs,
-	.num_ecc_strength = 7,
+	.num_ecc_strength = 5,
 	.ecc_mode_shift = 4,
 	.parity_bits = 13,
 	.pg_irq_sel = 0,
-- 
2.35.1



