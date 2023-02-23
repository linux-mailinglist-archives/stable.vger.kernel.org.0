Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4CE6A099E
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233338AbjBWNIi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:08:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233819AbjBWNIa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:08:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3601A4EC4
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:08:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7AA1B81A02
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:08:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A08EC433EF;
        Thu, 23 Feb 2023 13:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157706;
        bh=FqFJWUAzxIajb3kN1r86rt4j4/zmmP/0XqtS3nOLSfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k9EQfMSgA4j6rcc5skEp9g1mEAXq/hd7g3Y4KS8mXHjm0a+h8Jcx70Eyv3787FgNP
         rQnfmUO4eKvtWm5zSJxyExIG+HMPhtLMDBlA42RyPqIrhTWivKF6E09Q2AVwerQ9eV
         nyZv5O1TlPiJoCnHAUaxcxd8ET2m2KqzPiYxHqcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yi xin Zhu <yzhu@maxlinear.com>,
        Rahul Tanwar <rtanwar@maxlinear.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 05/25] clk: mxl: Add option to override gate clks
Date:   Thu, 23 Feb 2023 14:06:22 +0100
Message-Id: <20230223130427.024627546@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130426.817998725@linuxfoundation.org>
References: <20230223130426.817998725@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rahul Tanwar <rtanwar@maxlinear.com>

[ Upstream commit a5d49bd369b8588c0ee9d4d0a2c0160558a3ab69 ]

In MxL's LGM SoC, gate clocks can be controlled either from CGU clk driver
i.e. this driver or directly from power management driver/daemon. It is
dependent on the power policy/profile requirements of the end product.

To support such use cases, provide option to override gate clks enable/disable
by adding a flag GATE_CLK_HW which controls if these gate clks are controlled
by HW i.e. this driver or overridden in order to allow it to be controlled
by power profiles instead.

Reviewed-by: Yi xin Zhu <yzhu@maxlinear.com>
Signed-off-by: Rahul Tanwar <rtanwar@maxlinear.com>
Link: https://lore.kernel.org/r/bdc9c89317b5d338a6c4f1d49386b696e947a672.1665642720.git.rtanwar@maxlinear.com
[sboyd@kernel.org: Add braces on many line if-else]
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Stable-dep-of: 106ef3bda210 ("clk: mxl: Fix a clk entry by adding relevant flags")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/x86/clk-cgu.c | 16 +++++++++++++++-
 drivers/clk/x86/clk-cgu.h |  1 +
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/x86/clk-cgu.c b/drivers/clk/x86/clk-cgu.c
index 1f7e93de67bc0..4278a687076c9 100644
--- a/drivers/clk/x86/clk-cgu.c
+++ b/drivers/clk/x86/clk-cgu.c
@@ -354,8 +354,22 @@ int lgm_clk_register_branches(struct lgm_clk_provider *ctx,
 			hw = lgm_clk_register_fixed_factor(ctx, list);
 			break;
 		case CLK_TYPE_GATE:
-			hw = lgm_clk_register_gate(ctx, list);
+			if (list->gate_flags & GATE_CLK_HW) {
+				hw = lgm_clk_register_gate(ctx, list);
+			} else {
+				/*
+				 * GATE_CLKs can be controlled either from
+				 * CGU clk driver i.e. this driver or directly
+				 * from power management driver/daemon. It is
+				 * dependent on the power policy/profile requirements
+				 * of the end product. To override control of gate
+				 * clks from this driver, provide NULL for this index
+				 * of gate clk provider.
+				 */
+				hw = NULL;
+			}
 			break;
+
 		default:
 			dev_err(ctx->dev, "invalid clk type\n");
 			return -EINVAL;
diff --git a/drivers/clk/x86/clk-cgu.h b/drivers/clk/x86/clk-cgu.h
index 0aa0f35d63a0b..73ce84345f81e 100644
--- a/drivers/clk/x86/clk-cgu.h
+++ b/drivers/clk/x86/clk-cgu.h
@@ -197,6 +197,7 @@ struct lgm_clk_branch {
 /* clock flags definition */
 #define CLOCK_FLAG_VAL_INIT	BIT(16)
 #define MUX_CLK_SW		BIT(17)
+#define GATE_CLK_HW		BIT(18)
 
 #define LGM_MUX(_id, _name, _pdata, _f, _reg,		\
 		_shift, _width, _cf, _v)		\
-- 
2.39.0



