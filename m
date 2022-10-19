Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE4A60441D
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 13:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbiJSL6W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 07:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbiJSL5s (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 07:57:48 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E52F1ACABD;
        Wed, 19 Oct 2022 04:36:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 577A5CE216B;
        Wed, 19 Oct 2022 09:04:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35F0BC433D6;
        Wed, 19 Oct 2022 09:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170280;
        bh=whpjSLgFOwluMyDP5s1KRTKjvJu5FSA0Wxy6pCWsZP8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vC6rFeFDcHSkD4BYNql2sXIVED+bCLX4qhYQ/caqiPxcHhizr188+QOo4IIQT0Rsp
         ueJ3U/kEtVnayqp9h1dVfsClUnD+dGFe8NuCMEg3SGewh4gzNa0bqTbeDHq/FFFcaH
         Ccj59ScWI3CVb0BZG0HnPdsp+0yaYBVhq5h3kBWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 594/862] clk: baikal-t1: Add SATA internal ref clock buffer
Date:   Wed, 19 Oct 2022 10:31:21 +0200
Message-Id: <20221019083316.219632209@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

[ Upstream commit 081a9b7c74eae4e12b2cb1b86720f836a8f29247 ]

It turns out the internal SATA reference clock signal will stay
unavailable for the SATA interface consumer until the buffer on it's way
is ungated. So aside with having the actual clock divider enabled we need
to ungate a buffer placed on the signal way to the SATA controller (most
likely some rudiment from the initial SoC release). Seeing the switch flag
is placed in the same register as the SATA-ref clock divider at a
non-standard ffset, let's implement it as a separate clock controller with
the set-rate propagation to the parental clock divider wrapper. As such
we'll be able to disable/enable and still change the original clock source
rate.

Fixes: 353afa3a8d2e ("clk: Add Baikal-T1 CCU Dividers driver")
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Link: https://lore.kernel.org/r/20220929225402.9696-5-Sergey.Semin@baikalelectronics.ru
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/baikal-t1/ccu-div.c     | 64 +++++++++++++++++++++++++++++
 drivers/clk/baikal-t1/ccu-div.h     |  4 ++
 drivers/clk/baikal-t1/clk-ccu-div.c | 18 +++++++-
 3 files changed, 85 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/baikal-t1/ccu-div.c b/drivers/clk/baikal-t1/ccu-div.c
index bbfa3526ee10..a6642f3d33d4 100644
--- a/drivers/clk/baikal-t1/ccu-div.c
+++ b/drivers/clk/baikal-t1/ccu-div.c
@@ -34,6 +34,7 @@
 #define CCU_DIV_CTL_CLKDIV_MASK(_width) \
 	GENMASK((_width) + CCU_DIV_CTL_CLKDIV_FLD - 1, CCU_DIV_CTL_CLKDIV_FLD)
 #define CCU_DIV_CTL_LOCK_SHIFTED	BIT(27)
+#define CCU_DIV_CTL_GATE_REF_BUF	BIT(28)
 #define CCU_DIV_CTL_LOCK_NORMAL		BIT(31)
 
 #define CCU_DIV_RST_DELAY_US		1
@@ -170,6 +171,40 @@ static int ccu_div_gate_is_enabled(struct clk_hw *hw)
 	return !!(val & CCU_DIV_CTL_EN);
 }
 
+static int ccu_div_buf_enable(struct clk_hw *hw)
+{
+	struct ccu_div *div = to_ccu_div(hw);
+	unsigned long flags;
+
+	spin_lock_irqsave(&div->lock, flags);
+	regmap_update_bits(div->sys_regs, div->reg_ctl,
+			   CCU_DIV_CTL_GATE_REF_BUF, 0);
+	spin_unlock_irqrestore(&div->lock, flags);
+
+	return 0;
+}
+
+static void ccu_div_buf_disable(struct clk_hw *hw)
+{
+	struct ccu_div *div = to_ccu_div(hw);
+	unsigned long flags;
+
+	spin_lock_irqsave(&div->lock, flags);
+	regmap_update_bits(div->sys_regs, div->reg_ctl,
+			   CCU_DIV_CTL_GATE_REF_BUF, CCU_DIV_CTL_GATE_REF_BUF);
+	spin_unlock_irqrestore(&div->lock, flags);
+}
+
+static int ccu_div_buf_is_enabled(struct clk_hw *hw)
+{
+	struct ccu_div *div = to_ccu_div(hw);
+	u32 val = 0;
+
+	regmap_read(div->sys_regs, div->reg_ctl, &val);
+
+	return !(val & CCU_DIV_CTL_GATE_REF_BUF);
+}
+
 static unsigned long ccu_div_var_recalc_rate(struct clk_hw *hw,
 					     unsigned long parent_rate)
 {
@@ -323,6 +358,7 @@ static const struct ccu_div_dbgfs_bit ccu_div_bits[] = {
 	CCU_DIV_DBGFS_BIT_ATTR("div_en", CCU_DIV_CTL_EN),
 	CCU_DIV_DBGFS_BIT_ATTR("div_rst", CCU_DIV_CTL_RST),
 	CCU_DIV_DBGFS_BIT_ATTR("div_bypass", CCU_DIV_CTL_SET_CLKDIV),
+	CCU_DIV_DBGFS_BIT_ATTR("div_buf", CCU_DIV_CTL_GATE_REF_BUF),
 	CCU_DIV_DBGFS_BIT_ATTR("div_lock", CCU_DIV_CTL_LOCK_NORMAL)
 };
 
@@ -441,6 +477,9 @@ static void ccu_div_var_debug_init(struct clk_hw *hw, struct dentry *dentry)
 			continue;
 		}
 
+		if (!strcmp("div_buf", name))
+			continue;
+
 		bits[didx] = ccu_div_bits[bidx];
 		bits[didx].div = div;
 
@@ -477,6 +516,21 @@ static void ccu_div_gate_debug_init(struct clk_hw *hw, struct dentry *dentry)
 				   &ccu_div_dbgfs_fixed_clkdiv_fops);
 }
 
+static void ccu_div_buf_debug_init(struct clk_hw *hw, struct dentry *dentry)
+{
+	struct ccu_div *div = to_ccu_div(hw);
+	struct ccu_div_dbgfs_bit *bit;
+
+	bit = kmalloc(sizeof(*bit), GFP_KERNEL);
+	if (!bit)
+		return;
+
+	*bit = ccu_div_bits[3];
+	bit->div = div;
+	debugfs_create_file_unsafe(bit->name, ccu_div_dbgfs_mode, dentry, bit,
+				   &ccu_div_dbgfs_bit_fops);
+}
+
 static void ccu_div_fixed_debug_init(struct clk_hw *hw, struct dentry *dentry)
 {
 	struct ccu_div *div = to_ccu_div(hw);
@@ -489,6 +543,7 @@ static void ccu_div_fixed_debug_init(struct clk_hw *hw, struct dentry *dentry)
 
 #define ccu_div_var_debug_init NULL
 #define ccu_div_gate_debug_init NULL
+#define ccu_div_buf_debug_init NULL
 #define ccu_div_fixed_debug_init NULL
 
 #endif /* !CONFIG_DEBUG_FS */
@@ -520,6 +575,13 @@ static const struct clk_ops ccu_div_gate_ops = {
 	.debug_init = ccu_div_gate_debug_init
 };
 
+static const struct clk_ops ccu_div_buf_ops = {
+	.enable = ccu_div_buf_enable,
+	.disable = ccu_div_buf_disable,
+	.is_enabled = ccu_div_buf_is_enabled,
+	.debug_init = ccu_div_buf_debug_init
+};
+
 static const struct clk_ops ccu_div_fixed_ops = {
 	.recalc_rate = ccu_div_fixed_recalc_rate,
 	.round_rate = ccu_div_fixed_round_rate,
@@ -566,6 +628,8 @@ struct ccu_div *ccu_div_hw_register(const struct ccu_div_init_data *div_init)
 	} else if (div_init->type == CCU_DIV_GATE) {
 		hw_init.ops = &ccu_div_gate_ops;
 		div->divider = div_init->divider;
+	} else if (div_init->type == CCU_DIV_BUF) {
+		hw_init.ops = &ccu_div_buf_ops;
 	} else if (div_init->type == CCU_DIV_FIXED) {
 		hw_init.ops = &ccu_div_fixed_ops;
 		div->divider = div_init->divider;
diff --git a/drivers/clk/baikal-t1/ccu-div.h b/drivers/clk/baikal-t1/ccu-div.h
index b6a9c8e45318..4eb49ff4803c 100644
--- a/drivers/clk/baikal-t1/ccu-div.h
+++ b/drivers/clk/baikal-t1/ccu-div.h
@@ -15,8 +15,10 @@
 
 /*
  * CCU Divider private clock IDs
+ * @CCU_SYS_SATA_CLK: CCU SATA internal clock
  * @CCU_SYS_XGMAC_CLK: CCU XGMAC internal clock
  */
+#define CCU_SYS_SATA_CLK		-1
 #define CCU_SYS_XGMAC_CLK		-2
 
 /*
@@ -37,11 +39,13 @@
  * enum ccu_div_type - CCU Divider types
  * @CCU_DIV_VAR: Clocks gate with variable divider.
  * @CCU_DIV_GATE: Clocks gate with fixed divider.
+ * @CCU_DIV_BUF: Clock gate with no divider.
  * @CCU_DIV_FIXED: Ungateable clock with fixed divider.
  */
 enum ccu_div_type {
 	CCU_DIV_VAR,
 	CCU_DIV_GATE,
+	CCU_DIV_BUF,
 	CCU_DIV_FIXED
 };
 
diff --git a/drivers/clk/baikal-t1/clk-ccu-div.c b/drivers/clk/baikal-t1/clk-ccu-div.c
index 3953ae5664be..90f4fda406ee 100644
--- a/drivers/clk/baikal-t1/clk-ccu-div.c
+++ b/drivers/clk/baikal-t1/clk-ccu-div.c
@@ -76,6 +76,16 @@
 		.divider = _divider				\
 	}
 
+#define CCU_DIV_BUF_INFO(_id, _name, _pname, _base, _flags)	\
+	{							\
+		.id = _id,					\
+		.name = _name,					\
+		.parent_name = _pname,				\
+		.base = _base,					\
+		.type = CCU_DIV_BUF,				\
+		.flags = _flags					\
+	}
+
 #define CCU_DIV_FIXED_INFO(_id, _name, _pname, _divider)	\
 	{							\
 		.id = _id,					\
@@ -188,11 +198,14 @@ static const struct ccu_div_rst_map axi_rst_map[] = {
  * for the SoC devices registers IO-operations.
  */
 static const struct ccu_div_info sys_info[] = {
-	CCU_DIV_VAR_INFO(CCU_SYS_SATA_REF_CLK, "sys_sata_ref_clk",
+	CCU_DIV_VAR_INFO(CCU_SYS_SATA_CLK, "sys_sata_clk",
 			 "sata_clk", CCU_SYS_SATA_REF_BASE, 4,
 			 CLK_SET_RATE_GATE,
 			 CCU_DIV_SKIP_ONE | CCU_DIV_LOCK_SHIFTED |
 			 CCU_DIV_RESET_DOMAIN),
+	CCU_DIV_BUF_INFO(CCU_SYS_SATA_REF_CLK, "sys_sata_ref_clk",
+			 "sys_sata_clk", CCU_SYS_SATA_REF_BASE,
+			 CLK_SET_RATE_PARENT),
 	CCU_DIV_VAR_INFO(CCU_SYS_APB_CLK, "sys_apb_clk",
 			 "pcie_clk", CCU_SYS_APB_BASE, 5,
 			 CLK_IS_CRITICAL, CCU_DIV_RESET_DOMAIN),
@@ -398,6 +411,9 @@ static int ccu_div_clk_register(struct ccu_div_data *data)
 			init.base = info->base;
 			init.sys_regs = data->sys_regs;
 			init.divider = info->divider;
+		} else if (init.type == CCU_DIV_BUF) {
+			init.base = info->base;
+			init.sys_regs = data->sys_regs;
 		} else {
 			init.divider = info->divider;
 		}
-- 
2.35.1



