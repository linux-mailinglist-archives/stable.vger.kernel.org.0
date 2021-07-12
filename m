Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 438C43C53A9
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242933AbhGLHzd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:55:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:36140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350587AbhGLHvK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88BB261C21;
        Mon, 12 Jul 2021 07:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075983;
        bh=0FprIICP4/Q+6zNTs8COhv4QIVgzEv6vhWyXc7wABuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J7B3RbvAa5xdzwFNLT4h2MG9uTdumBKzZJ6EfLpUVPRGL4HbeA8f44dOcVizAKOOL
         xoai1jjKS3Etms4cRZpTqReirgeiK1/TY6WIa0Y2p368lLSLiCyZraTfy804aiog3A
         XSTTtHDK89dw7fAOzeMa5S7w8UcJeVakZPT9AltY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Ceresoli <luca@lucaceresoli.net>,
        Adam Ford <aford173@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 448/800] clk: vc5: fix output disabling when enabling a FOD
Date:   Mon, 12 Jul 2021 08:07:51 +0200
Message-Id: <20210712061014.779604880@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Ceresoli <luca@lucaceresoli.net>

[ Upstream commit fc336ae622df0ec114dbe5551a4d2760c535ecd0 ]

On 5P49V6965, when an output is enabled we enable the corresponding
FOD. When this happens for the first time, and specifically when writing
register VC5_OUT_DIV_CONTROL in vc5_clk_out_prepare(), all other outputs
are stopped for a short time and then restarted.

According to Renesas support this is intended: "The reason for that is VC6E
has synced up all output function".

This behaviour can be disabled at least on VersaClock 6E devices, of which
only the 5P49V6965 is currently implemented by this driver. This requires
writing bit 7 (bypass_sync{1..4}) in register 0x20..0x50.  Those registers
are named "Unused Factory Reserved Register", and the bits are documented
as "Skip VDDO<N> verification", which does not clearly explain the relation
to FOD sync. However according to Renesas support as well as my testing
setting this bit does prevent disabling of all clock outputs when enabling
a FOD.

See "VersaClock ® 6E Family Register Descriptions and Programming Guide"
(August 30, 2018), Table 116 "Power Up VDD check", page 58:
https://www.renesas.com/us/en/document/mau/versaclock-6e-family-register-descriptions-and-programming-guide

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
Reviewed-by: Adam Ford <aford173@gmail.com>
Link: https://lore.kernel.org/r/20210527211647.1520720-1-luca@lucaceresoli.net
Fixes: 2bda748e6ad8 ("clk: vc5: Add support for IDT VersaClock 5P49V6965")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-versaclock5.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/clk-versaclock5.c b/drivers/clk/clk-versaclock5.c
index 344cd6c61188..3c737742c2a9 100644
--- a/drivers/clk/clk-versaclock5.c
+++ b/drivers/clk/clk-versaclock5.c
@@ -69,7 +69,10 @@
 #define VC5_FEEDBACK_FRAC_DIV(n)		(0x19 + (n))
 #define VC5_RC_CONTROL0				0x1e
 #define VC5_RC_CONTROL1				0x1f
-/* Register 0x20 is factory reserved */
+
+/* These registers are named "Unused Factory Reserved Registers" */
+#define VC5_RESERVED_X0(idx)		(0x20 + ((idx) * 0x10))
+#define VC5_RESERVED_X0_BYPASS_SYNC	BIT(7) /* bypass_sync<idx> bit */
 
 /* Output divider control for divider 1,2,3,4 */
 #define VC5_OUT_DIV_CONTROL(idx)	(0x21 + ((idx) * 0x10))
@@ -87,7 +90,6 @@
 #define VC5_OUT_DIV_SKEW_INT(idx, n)	(0x2b + ((idx) * 0x10) + (n))
 #define VC5_OUT_DIV_INT(idx, n)		(0x2d + ((idx) * 0x10) + (n))
 #define VC5_OUT_DIV_SKEW_FRAC(idx)	(0x2f + ((idx) * 0x10))
-/* Registers 0x30, 0x40, 0x50 are factory reserved */
 
 /* Clock control register for clock 1,2 */
 #define VC5_CLK_OUTPUT_CFG(idx, n)	(0x60 + ((idx) * 0x2) + (n))
@@ -140,6 +142,8 @@
 #define VC5_HAS_INTERNAL_XTAL	BIT(0)
 /* chip has PFD requency doubler */
 #define VC5_HAS_PFD_FREQ_DBL	BIT(1)
+/* chip has bits to disable FOD sync */
+#define VC5_HAS_BYPASS_SYNC_BIT	BIT(2)
 
 /* Supported IDT VC5 models. */
 enum vc5_model {
@@ -581,6 +585,23 @@ static int vc5_clk_out_prepare(struct clk_hw *hw)
 	unsigned int src;
 	int ret;
 
+	/*
+	 * When enabling a FOD, all currently enabled FODs are briefly
+	 * stopped in order to synchronize all of them. This causes a clock
+	 * disruption to any unrelated chips that might be already using
+	 * other clock outputs. Bypass the sync feature to avoid the issue,
+	 * which is possible on the VersaClock 6E family via reserved
+	 * registers.
+	 */
+	if (vc5->chip_info->flags & VC5_HAS_BYPASS_SYNC_BIT) {
+		ret = regmap_update_bits(vc5->regmap,
+					 VC5_RESERVED_X0(hwdata->num),
+					 VC5_RESERVED_X0_BYPASS_SYNC,
+					 VC5_RESERVED_X0_BYPASS_SYNC);
+		if (ret)
+			return ret;
+	}
+
 	/*
 	 * If the input mux is disabled, enable it first and
 	 * select source from matching FOD.
@@ -1166,7 +1187,7 @@ static const struct vc5_chip_info idt_5p49v6965_info = {
 	.model = IDT_VC6_5P49V6965,
 	.clk_fod_cnt = 4,
 	.clk_out_cnt = 5,
-	.flags = 0,
+	.flags = VC5_HAS_BYPASS_SYNC_BIT,
 };
 
 static const struct i2c_device_id vc5_id[] = {
-- 
2.30.2



