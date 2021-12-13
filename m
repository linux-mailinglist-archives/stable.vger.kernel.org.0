Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 191054729AC
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:24:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245699AbhLMKXx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:23:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244978AbhLMKTA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:19:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D17C061371;
        Mon, 13 Dec 2021 01:57:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA722B80E2F;
        Mon, 13 Dec 2021 09:56:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C276C34600;
        Mon, 13 Dec 2021 09:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389418;
        bh=CDXo2h4vz+YwBBOpxTJoGDGKPvgQg9+CFfdB73paPyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fW3MNulUbEc48aFLV/qFDGqgNRv91SyjyI0xsPQkqmuIH0Hv2hJo/H3WppiJtNqEn
         q7v5Q3F7sBSNdWgNiUFeJ2ZKVr+ThQEtSCTzQD7Bwffurnlztia+BsaDM6lojzNBZD
         FlNwhkjG+ZUugENAQQzSZLn6DKH9T80n+pjL52iY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.15 090/171] clk: qcom: regmap-mux: fix parent clock lookup
Date:   Mon, 13 Dec 2021 10:30:05 +0100
Message-Id: <20211213092948.080794524@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
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
@@ -28,7 +28,7 @@ static u8 mux_get_parent(struct clk_hw *
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
@@ -49,6 +49,8 @@ extern void
 qcom_pll_set_fsm_mode(struct regmap *m, u32 reg, u8 bias_count, u8 lock_count);
 extern int qcom_find_src_index(struct clk_hw *hw, const struct parent_map *map,
 			       u8 src);
+extern int qcom_find_cfg_index(struct clk_hw *hw, const struct parent_map *map,
+			       u8 cfg);
 
 extern int qcom_cc_register_board_clk(struct device *dev, const char *path,
 				      const char *name, unsigned long rate);


