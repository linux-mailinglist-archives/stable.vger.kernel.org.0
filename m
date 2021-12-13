Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6747472571
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234794AbhLMJnq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:43:46 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:35576 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234819AbhLMJlS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:41:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3F67ECE0E29;
        Mon, 13 Dec 2021 09:41:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F69C341C5;
        Mon, 13 Dec 2021 09:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388474;
        bh=zatavcxwREI+5Jc3Vrzg5H/iMUWRcUJjtWgyS1cmf44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wrW2IWK9GgkTUOlLpNwYFFXM/218zygHDx3+//jYsBAGDf1X3UngGn95gJuZF/L3f
         Npk4EA584k28Uef0w/xUwm4ACmPwykGnnfzz/WbQKzWTe0VBdcH5QGyiK8mgjV8Ild
         0/N7svFxmnrIxUUViU9UQJtwTB410XRmUPsO3Yfs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 4.19 29/74] clk: qcom: regmap-mux: fix parent clock lookup
Date:   Mon, 13 Dec 2021 10:30:00 +0100
Message-Id: <20211213092931.784850569@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092930.763200615@linuxfoundation.org>
References: <20211213092930.763200615@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

commit 9a61f813fcc8d56d85fcf9ca6119cf2b5ac91dd5 upstream.

The function mux_get_parent() uses qcom_find_src_index() to find the
parent clock index, which is incorrect: qcom_find_src_index() uses src
enum for the lookup, while mux_get_parent() should use cfg field (which
corresponds to the register value). Add qcom_find_cfg_index() function
doing this kind of lookup and use it for mux parent lookup.

Fixes: df964016490b ("clk: qcom: add parent map for regmap mux")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20211115233407.1046179-1-dmitry.baryshkov@linaro.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/clk-regmap-mux.c |    2 +-
 drivers/clk/qcom/common.c         |   12 ++++++++++++
 drivers/clk/qcom/common.h         |    2 ++
 3 files changed, 15 insertions(+), 1 deletion(-)

--- a/drivers/clk/qcom/clk-regmap-mux.c
+++ b/drivers/clk/qcom/clk-regmap-mux.c
@@ -36,7 +36,7 @@ static u8 mux_get_parent(struct clk_hw *
 	val &= mask;
 
 	if (mux->parent_map)
-		return qcom_find_src_index(hw, mux->parent_map, val);
+		return qcom_find_cfg_index(hw, mux->parent_map, val);
 
 	return val;
 }
--- a/drivers/clk/qcom/common.c
+++ b/drivers/clk/qcom/common.c
@@ -69,6 +69,18 @@ int qcom_find_src_index(struct clk_hw *h
 }
 EXPORT_SYMBOL_GPL(qcom_find_src_index);
 
+int qcom_find_cfg_index(struct clk_hw *hw, const struct parent_map *map, u8 cfg)
+{
+	int i, num_parents = clk_hw_get_num_parents(hw);
+
+	for (i = 0; i < num_parents; i++)
+		if (cfg == map[i].cfg)
+			return i;
+
+	return -ENOENT;
+}
+EXPORT_SYMBOL_GPL(qcom_find_cfg_index);
+
 struct regmap *
 qcom_cc_map(struct platform_device *pdev, const struct qcom_cc_desc *desc)
 {
--- a/drivers/clk/qcom/common.h
+++ b/drivers/clk/qcom/common.h
@@ -47,6 +47,8 @@ extern void
 qcom_pll_set_fsm_mode(struct regmap *m, u32 reg, u8 bias_count, u8 lock_count);
 extern int qcom_find_src_index(struct clk_hw *hw, const struct parent_map *map,
 			       u8 src);
+extern int qcom_find_cfg_index(struct clk_hw *hw, const struct parent_map *map,
+			       u8 cfg);
 
 extern int qcom_cc_register_board_clk(struct device *dev, const char *path,
 				      const char *name, unsigned long rate);


