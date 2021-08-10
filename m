Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3E5D3E80AE
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232076AbhHJRvW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:51:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:39034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237054AbhHJRuC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:50:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57A4061252;
        Tue, 10 Aug 2021 17:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617328;
        bh=24OCDiKUxGTTwAF8265t9ns1qjJQyRKFJxM+h29WG8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g0W1zgVFXoJfSIpEXVy51fSA6dixVHRSV0Y5EWNzoId1QateufLIAQgg33l0MXqCD
         yvLGSG7+c7V2IkzgegTKADzYl8lgQlTnyzhkWCT5lr9dKRbJr7/5Yg2yjlavbDln14
         MuVF4k9TogDsTUhHaOouuZ+oB3ypDJg00ayIT6rA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Peng Fan <peng.fan@nxp.com>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 011/175] Revert "soc: imx8m: change to use platform driver"
Date:   Tue, 10 Aug 2021 19:28:39 +0200
Message-Id: <20210810173001.319866215@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit ac34de14ac30ba4484d68f8845a54b6b6c23db42 ]

With the SoC matching changed to a platform driver the match data
is available only after other drivers, which may rely on it are
already probed. This breaks at least the CAAM driver on i.MX8M.
Revert the change until all those drivers have been audited and
changed to be able to eal with match data being available later
in the boot process.

Fixes: 7d981405d0fd ("soc: imx8m: change to use platform driver")
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Tested-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Acked-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/imx/soc-imx8m.c | 84 ++++++-------------------------------
 1 file changed, 12 insertions(+), 72 deletions(-)

diff --git a/drivers/soc/imx/soc-imx8m.c b/drivers/soc/imx/soc-imx8m.c
index 071e14496e4b..cc57a384d74d 100644
--- a/drivers/soc/imx/soc-imx8m.c
+++ b/drivers/soc/imx/soc-imx8m.c
@@ -5,8 +5,6 @@
 
 #include <linux/init.h>
 #include <linux/io.h>
-#include <linux/module.h>
-#include <linux/nvmem-consumer.h>
 #include <linux/of_address.h>
 #include <linux/slab.h>
 #include <linux/sys_soc.h>
@@ -31,7 +29,7 @@
 
 struct imx8_soc_data {
 	char *name;
-	u32 (*soc_revision)(struct device *dev);
+	u32 (*soc_revision)(void);
 };
 
 static u64 soc_uid;
@@ -52,7 +50,7 @@ static u32 imx8mq_soc_revision_from_atf(void)
 static inline u32 imx8mq_soc_revision_from_atf(void) { return 0; };
 #endif
 
-static u32 __init imx8mq_soc_revision(struct device *dev)
+static u32 __init imx8mq_soc_revision(void)
 {
 	struct device_node *np;
 	void __iomem *ocotp_base;
@@ -77,20 +75,9 @@ static u32 __init imx8mq_soc_revision(struct device *dev)
 			rev = REV_B1;
 	}
 
-	if (dev) {
-		int ret;
-
-		ret = nvmem_cell_read_u64(dev, "soc_unique_id", &soc_uid);
-		if (ret) {
-			iounmap(ocotp_base);
-			of_node_put(np);
-			return ret;
-		}
-	} else {
-		soc_uid = readl_relaxed(ocotp_base + OCOTP_UID_HIGH);
-		soc_uid <<= 32;
-		soc_uid |= readl_relaxed(ocotp_base + OCOTP_UID_LOW);
-	}
+	soc_uid = readl_relaxed(ocotp_base + OCOTP_UID_HIGH);
+	soc_uid <<= 32;
+	soc_uid |= readl_relaxed(ocotp_base + OCOTP_UID_LOW);
 
 	iounmap(ocotp_base);
 	of_node_put(np);
@@ -120,7 +107,7 @@ static void __init imx8mm_soc_uid(void)
 	of_node_put(np);
 }
 
-static u32 __init imx8mm_soc_revision(struct device *dev)
+static u32 __init imx8mm_soc_revision(void)
 {
 	struct device_node *np;
 	void __iomem *anatop_base;
@@ -138,15 +125,7 @@ static u32 __init imx8mm_soc_revision(struct device *dev)
 	iounmap(anatop_base);
 	of_node_put(np);
 
-	if (dev) {
-		int ret;
-
-		ret = nvmem_cell_read_u64(dev, "soc_unique_id", &soc_uid);
-		if (ret)
-			return ret;
-	} else {
-		imx8mm_soc_uid();
-	}
+	imx8mm_soc_uid();
 
 	return rev;
 }
@@ -171,7 +150,7 @@ static const struct imx8_soc_data imx8mp_soc_data = {
 	.soc_revision = imx8mm_soc_revision,
 };
 
-static __maybe_unused const struct of_device_id imx8_machine_match[] = {
+static __maybe_unused const struct of_device_id imx8_soc_match[] = {
 	{ .compatible = "fsl,imx8mq", .data = &imx8mq_soc_data, },
 	{ .compatible = "fsl,imx8mm", .data = &imx8mm_soc_data, },
 	{ .compatible = "fsl,imx8mn", .data = &imx8mn_soc_data, },
@@ -179,20 +158,12 @@ static __maybe_unused const struct of_device_id imx8_machine_match[] = {
 	{ }
 };
 
-static __maybe_unused const struct of_device_id imx8_soc_match[] = {
-	{ .compatible = "fsl,imx8mq-soc", .data = &imx8mq_soc_data, },
-	{ .compatible = "fsl,imx8mm-soc", .data = &imx8mm_soc_data, },
-	{ .compatible = "fsl,imx8mn-soc", .data = &imx8mn_soc_data, },
-	{ .compatible = "fsl,imx8mp-soc", .data = &imx8mp_soc_data, },
-	{ }
-};
-
 #define imx8_revision(soc_rev) \
 	soc_rev ? \
 	kasprintf(GFP_KERNEL, "%d.%d", (soc_rev >> 4) & 0xf,  soc_rev & 0xf) : \
 	"unknown"
 
-static int imx8_soc_info(struct platform_device *pdev)
+static int __init imx8_soc_init(void)
 {
 	struct soc_device_attribute *soc_dev_attr;
 	struct soc_device *soc_dev;
@@ -211,10 +182,7 @@ static int imx8_soc_info(struct platform_device *pdev)
 	if (ret)
 		goto free_soc;
 
-	if (pdev)
-		id = of_match_node(imx8_soc_match, pdev->dev.of_node);
-	else
-		id = of_match_node(imx8_machine_match, of_root);
+	id = of_match_node(imx8_soc_match, of_root);
 	if (!id) {
 		ret = -ENODEV;
 		goto free_soc;
@@ -223,16 +191,8 @@ static int imx8_soc_info(struct platform_device *pdev)
 	data = id->data;
 	if (data) {
 		soc_dev_attr->soc_id = data->name;
-		if (data->soc_revision) {
-			if (pdev) {
-				soc_rev = data->soc_revision(&pdev->dev);
-				ret = soc_rev;
-				if (ret < 0)
-					goto free_soc;
-			} else {
-				soc_rev = data->soc_revision(NULL);
-			}
-		}
+		if (data->soc_revision)
+			soc_rev = data->soc_revision();
 	}
 
 	soc_dev_attr->revision = imx8_revision(soc_rev);
@@ -270,24 +230,4 @@ free_soc:
 	kfree(soc_dev_attr);
 	return ret;
 }
-
-/* Retain device_initcall is for backward compatibility with DTS. */
-static int __init imx8_soc_init(void)
-{
-	if (of_find_matching_node_and_match(NULL, imx8_soc_match, NULL))
-		return 0;
-
-	return imx8_soc_info(NULL);
-}
 device_initcall(imx8_soc_init);
-
-static struct platform_driver imx8_soc_info_driver = {
-	.probe = imx8_soc_info,
-	.driver = {
-		.name = "imx8_soc_info",
-		.of_match_table = imx8_soc_match,
-	},
-};
-
-module_platform_driver(imx8_soc_info_driver);
-MODULE_LICENSE("GPL v2");
-- 
2.30.2



