Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F31FB40627A
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbhIJAp5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:45:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233808AbhIJAVu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:21:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83A3A61167;
        Fri, 10 Sep 2021 00:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233240;
        bh=ThNscb1eXMOwmXv1J52+3yPD7APMCFSDNbyH5NyxMi8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=um8PFoQqtohXcToZBGDsgs0NLDG9urRyBiVtyXvI0LlA83yfqAOJGicpEwXr2oLmc
         RD4OHCRv7AkUzI7oPyBJgx7B0pDZX3oNI8Sva+1KywVUoaQrk3aR8MqgXF2ct0uLCe
         OlVCGqs/RmHz76GLWQ8WEAlg0W7dgOzFFtU3cuMSmhghIz33UHdsFQNymZVx6QQNH5
         wL+90yJ6V47czymkFxOTfzdKSuPVY1njEvmKylYYnE+zZArRefXIsq00mzQgASUF/Q
         ZR3WChCHFt3esrmUHIIFhPHhzfoQiY1mJsOzfInnF+TpLsMtfJAFntFJnLBtto98wK
         rXxRcKr1QfgfQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 08/53] pinctrl: renesas: Fix pin control matching on R-Car H3e-2G
Date:   Thu,  9 Sep 2021 20:19:43 -0400
Message-Id: <20210910002028.175174-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002028.175174-1-sashal@kernel.org>
References: <20210910002028.175174-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 91d1be9fb7d667ae136f05cc645276eb2c9fa40e ]

As R-Car H3 ES1.x (R8A77950) and R-Car ES2.0+ (R8A77951) use the same
compatible value, the pin control driver relies on soc_device_match()
with soc_id = "r8a7795" and the (non)matching of revision = "ES1.*" to
match with and distinguish between the two SoC variants.  The
corresponding entries in the normal of_match_table are present only to
make the optional sanity checks work.

The R-Car H3e-2G (R8A779M1) SoC is a different grading of the R-Car H3
ES3.0 (R8A77951) SoC.  It uses the same compatible values for individual
devices, but has an additional compatible value for the root node.
When running on an R-Car H3e-2G SoC, soc_device_match() with soc_id =
"r8a7795" does not return a match.  Hence the pin control driver falls
back to the normal of_match_table, and, as the R8A77950 entry is listed
first, incorrectly uses the sub-driver for R-Car H3 ES1.x.

Fix this by moving the entry for R8A77951 before the entry for R8A77950.
Simplify sh_pfc_quirk_match() to only handle R-Car H3 ES1,x, as R-Car H3
ES2.0+ can now be matched using the normal of_match_table as well.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/6cdc5bfa424461105779b56f455387e03560cf66.1626707688.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/core.c   | 29 ++++++++++++-----------------
 drivers/pinctrl/renesas/sh_pfc.h |  4 ++--
 2 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/drivers/pinctrl/renesas/core.c b/drivers/pinctrl/renesas/core.c
index c528c124fb0e..c2a2f1b3de06 100644
--- a/drivers/pinctrl/renesas/core.c
+++ b/drivers/pinctrl/renesas/core.c
@@ -581,17 +581,21 @@ static const struct of_device_id sh_pfc_of_table[] = {
 		.data = &r8a7794_pinmux_info,
 	},
 #endif
-/* Both r8a7795 entries must be present to make sanity checks work */
-#ifdef CONFIG_PINCTRL_PFC_R8A77950
+/*
+ * Both r8a7795 entries must be present to make sanity checks work, but only
+ * the first entry is actually used.
+ * R-Car H3 ES1.x is matched using soc_device_match() instead.
+ */
+#ifdef CONFIG_PINCTRL_PFC_R8A77951
 	{
 		.compatible = "renesas,pfc-r8a7795",
-		.data = &r8a77950_pinmux_info,
+		.data = &r8a77951_pinmux_info,
 	},
 #endif
-#ifdef CONFIG_PINCTRL_PFC_R8A77951
+#ifdef CONFIG_PINCTRL_PFC_R8A77950
 	{
 		.compatible = "renesas,pfc-r8a7795",
-		.data = &r8a77951_pinmux_info,
+		.data = &r8a77950_pinmux_info,
 	},
 #endif
 #ifdef CONFIG_PINCTRL_PFC_R8A77960
@@ -1085,26 +1089,20 @@ static inline void sh_pfc_check_driver(struct platform_driver *pdrv) {}
 #ifdef CONFIG_OF
 static const void *sh_pfc_quirk_match(void)
 {
-#if defined(CONFIG_PINCTRL_PFC_R8A77950) || \
-    defined(CONFIG_PINCTRL_PFC_R8A77951)
+#ifdef CONFIG_PINCTRL_PFC_R8A77950
 	const struct soc_device_attribute *match;
 	static const struct soc_device_attribute quirks[] = {
 		{
 			.soc_id = "r8a7795", .revision = "ES1.*",
 			.data = &r8a77950_pinmux_info,
 		},
-		{
-			.soc_id = "r8a7795",
-			.data = &r8a77951_pinmux_info,
-		},
-
 		{ /* sentinel */ }
 	};
 
 	match = soc_device_match(quirks);
 	if (match)
-		return match->data ?: ERR_PTR(-ENODEV);
-#endif /* CONFIG_PINCTRL_PFC_R8A77950 || CONFIG_PINCTRL_PFC_R8A77951 */
+		return match->data;
+#endif /* CONFIG_PINCTRL_PFC_R8A77950 */
 
 	return NULL;
 }
@@ -1119,9 +1117,6 @@ static int sh_pfc_probe(struct platform_device *pdev)
 #ifdef CONFIG_OF
 	if (pdev->dev.of_node) {
 		info = sh_pfc_quirk_match();
-		if (IS_ERR(info))
-			return PTR_ERR(info);
-
 		if (!info)
 			info = of_device_get_match_data(&pdev->dev);
 	} else
diff --git a/drivers/pinctrl/renesas/sh_pfc.h b/drivers/pinctrl/renesas/sh_pfc.h
index eff1bb872325..0d3f13230fe9 100644
--- a/drivers/pinctrl/renesas/sh_pfc.h
+++ b/drivers/pinctrl/renesas/sh_pfc.h
@@ -320,8 +320,8 @@ extern const struct sh_pfc_soc_info r8a7791_pinmux_info;
 extern const struct sh_pfc_soc_info r8a7792_pinmux_info;
 extern const struct sh_pfc_soc_info r8a7793_pinmux_info;
 extern const struct sh_pfc_soc_info r8a7794_pinmux_info;
-extern const struct sh_pfc_soc_info r8a77950_pinmux_info __weak;
-extern const struct sh_pfc_soc_info r8a77951_pinmux_info __weak;
+extern const struct sh_pfc_soc_info r8a77950_pinmux_info;
+extern const struct sh_pfc_soc_info r8a77951_pinmux_info;
 extern const struct sh_pfc_soc_info r8a77960_pinmux_info;
 extern const struct sh_pfc_soc_info r8a77961_pinmux_info;
 extern const struct sh_pfc_soc_info r8a77965_pinmux_info;
-- 
2.30.2

