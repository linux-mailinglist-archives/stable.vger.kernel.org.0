Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5F54522C2
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354296AbhKPBQB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:16:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:43004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244471AbhKOTPE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:15:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92594632B6;
        Mon, 15 Nov 2021 18:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000473;
        bh=A6OVzBYof/SjrMJz25bL99VDMk3icOgup9qlFoiyCRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iPeZlga4POLGjXTzXuaLqC5iyxgDfloSUxgXO8AD4R8NuDZQAR6LGM/ufZVieJ1yM
         fvfBuPcy6UjQ18xoGOH6dZDO673MUnk1ZneEScQYVtSnyVHoIfUr+WvcMW3tP9tIWr
         c57heaP2HN5RjJUAwn16xhEyJWDsEs28UxqKo2yE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Peng Fan <peng.fan@nxp.com>,
        Dong Aisheng <aisheng.dong@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 671/849] remoteproc: imx_rproc: Fix TCM io memory type
Date:   Mon, 15 Nov 2021 18:02:34 +0100
Message-Id: <20211115165442.963675767@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dong Aisheng <aisheng.dong@nxp.com>

[ Upstream commit 91bb26637353f35241f5472eedf3202ebe13e2e5 ]

is_iomem was introduced in the commit 40df0a91b2a5 ("remoteproc: add
is_iomem to da_to_va"), but the driver seemed missed to provide the io
type correctly.
This patch updates remoteproc driver to indicate the TCM on IMX are io
memories. Without the change, remoteproc kick will fail.

Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Peng Fan <peng.fan@nxp.com>
Reviewed-and-tested-by: Peng Fan <peng.fan@nxp.com>
Fixes: 79806d32d5aa ("remoteproc: imx_rproc: support i.MX8MN/P")
Signed-off-by: Dong Aisheng <aisheng.dong@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210910090621.3073540-4-peng.fan@oss.nxp.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/imx_rproc.c | 35 ++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/remoteproc/imx_rproc.c b/drivers/remoteproc/imx_rproc.c
index d88f76f5305eb..71dcc6dd32e40 100644
--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -71,6 +71,7 @@ struct imx_rproc_mem {
 /* att flags */
 /* M4 own area. Can be mapped at probe */
 #define ATT_OWN		BIT(1)
+#define ATT_IOMEM	BIT(2)
 
 /* address translation table */
 struct imx_rproc_att {
@@ -117,7 +118,7 @@ struct imx_rproc {
 static const struct imx_rproc_att imx_rproc_att_imx8mn[] = {
 	/* dev addr , sys addr  , size	    , flags */
 	/* ITCM   */
-	{ 0x00000000, 0x007E0000, 0x00020000, ATT_OWN },
+	{ 0x00000000, 0x007E0000, 0x00020000, ATT_OWN | ATT_IOMEM },
 	/* OCRAM_S */
 	{ 0x00180000, 0x00180000, 0x00009000, 0 },
 	/* OCRAM */
@@ -131,7 +132,7 @@ static const struct imx_rproc_att imx_rproc_att_imx8mn[] = {
 	/* DDR (Code) - alias */
 	{ 0x10000000, 0x40000000, 0x0FFE0000, 0 },
 	/* DTCM */
-	{ 0x20000000, 0x00800000, 0x00020000, ATT_OWN },
+	{ 0x20000000, 0x00800000, 0x00020000, ATT_OWN | ATT_IOMEM },
 	/* OCRAM_S - alias */
 	{ 0x20180000, 0x00180000, 0x00008000, ATT_OWN },
 	/* OCRAM */
@@ -147,7 +148,7 @@ static const struct imx_rproc_att imx_rproc_att_imx8mn[] = {
 static const struct imx_rproc_att imx_rproc_att_imx8mq[] = {
 	/* dev addr , sys addr  , size	    , flags */
 	/* TCML - alias */
-	{ 0x00000000, 0x007e0000, 0x00020000, 0 },
+	{ 0x00000000, 0x007e0000, 0x00020000, ATT_IOMEM},
 	/* OCRAM_S */
 	{ 0x00180000, 0x00180000, 0x00008000, 0 },
 	/* OCRAM */
@@ -159,9 +160,9 @@ static const struct imx_rproc_att imx_rproc_att_imx8mq[] = {
 	/* DDR (Code) - alias */
 	{ 0x10000000, 0x80000000, 0x0FFE0000, 0 },
 	/* TCML */
-	{ 0x1FFE0000, 0x007E0000, 0x00020000, ATT_OWN },
+	{ 0x1FFE0000, 0x007E0000, 0x00020000, ATT_OWN  | ATT_IOMEM},
 	/* TCMU */
-	{ 0x20000000, 0x00800000, 0x00020000, ATT_OWN },
+	{ 0x20000000, 0x00800000, 0x00020000, ATT_OWN  | ATT_IOMEM},
 	/* OCRAM_S */
 	{ 0x20180000, 0x00180000, 0x00008000, ATT_OWN },
 	/* OCRAM */
@@ -199,12 +200,12 @@ static const struct imx_rproc_att imx_rproc_att_imx7d[] = {
 	/* OCRAM_PXP (Code) - alias */
 	{ 0x00940000, 0x00940000, 0x00008000, 0 },
 	/* TCML (Code) */
-	{ 0x1FFF8000, 0x007F8000, 0x00008000, ATT_OWN },
+	{ 0x1FFF8000, 0x007F8000, 0x00008000, ATT_OWN | ATT_IOMEM },
 	/* DDR (Code) - alias, first part of DDR (Data) */
 	{ 0x10000000, 0x80000000, 0x0FFF0000, 0 },
 
 	/* TCMU (Data) */
-	{ 0x20000000, 0x00800000, 0x00008000, ATT_OWN },
+	{ 0x20000000, 0x00800000, 0x00008000, ATT_OWN | ATT_IOMEM },
 	/* OCRAM (Data) */
 	{ 0x20200000, 0x00900000, 0x00020000, 0 },
 	/* OCRAM_EPDC (Data) */
@@ -218,18 +219,18 @@ static const struct imx_rproc_att imx_rproc_att_imx7d[] = {
 static const struct imx_rproc_att imx_rproc_att_imx6sx[] = {
 	/* dev addr , sys addr  , size	    , flags */
 	/* TCML (M4 Boot Code) - alias */
-	{ 0x00000000, 0x007F8000, 0x00008000, 0 },
+	{ 0x00000000, 0x007F8000, 0x00008000, ATT_IOMEM },
 	/* OCRAM_S (Code) */
 	{ 0x00180000, 0x008F8000, 0x00004000, 0 },
 	/* OCRAM_S (Code) - alias */
 	{ 0x00180000, 0x008FC000, 0x00004000, 0 },
 	/* TCML (Code) */
-	{ 0x1FFF8000, 0x007F8000, 0x00008000, ATT_OWN },
+	{ 0x1FFF8000, 0x007F8000, 0x00008000, ATT_OWN | ATT_IOMEM },
 	/* DDR (Code) - alias, first part of DDR (Data) */
 	{ 0x10000000, 0x80000000, 0x0FFF8000, 0 },
 
 	/* TCMU (Data) */
-	{ 0x20000000, 0x00800000, 0x00008000, ATT_OWN },
+	{ 0x20000000, 0x00800000, 0x00008000, ATT_OWN | ATT_IOMEM },
 	/* OCRAM_S (Data) - alias? */
 	{ 0x208F8000, 0x008F8000, 0x00004000, 0 },
 	/* DDR (Data) */
@@ -341,7 +342,7 @@ static int imx_rproc_stop(struct rproc *rproc)
 }
 
 static int imx_rproc_da_to_sys(struct imx_rproc *priv, u64 da,
-			       size_t len, u64 *sys)
+			       size_t len, u64 *sys, bool *is_iomem)
 {
 	const struct imx_rproc_dcfg *dcfg = priv->dcfg;
 	int i;
@@ -354,6 +355,8 @@ static int imx_rproc_da_to_sys(struct imx_rproc *priv, u64 da,
 			unsigned int offset = da - att->da;
 
 			*sys = att->sa + offset;
+			if (is_iomem)
+				*is_iomem = att->flags & ATT_IOMEM;
 			return 0;
 		}
 	}
@@ -377,7 +380,7 @@ static void *imx_rproc_da_to_va(struct rproc *rproc, u64 da, size_t len, bool *i
 	 * On device side we have many aliases, so we need to convert device
 	 * address (M4) to system bus address first.
 	 */
-	if (imx_rproc_da_to_sys(priv, da, len, &sys))
+	if (imx_rproc_da_to_sys(priv, da, len, &sys, is_iomem))
 		return NULL;
 
 	for (i = 0; i < IMX_RPROC_MEM_MAX; i++) {
@@ -553,8 +556,12 @@ static int imx_rproc_addr_init(struct imx_rproc *priv,
 		if (b >= IMX_RPROC_MEM_MAX)
 			break;
 
-		priv->mem[b].cpu_addr = devm_ioremap(&pdev->dev,
-						     att->sa, att->size);
+		if (att->flags & ATT_IOMEM)
+			priv->mem[b].cpu_addr = devm_ioremap(&pdev->dev,
+							     att->sa, att->size);
+		else
+			priv->mem[b].cpu_addr = devm_ioremap_wc(&pdev->dev,
+								att->sa, att->size);
 		if (!priv->mem[b].cpu_addr) {
 			dev_err(dev, "failed to remap %#x bytes from %#x\n", att->size, att->sa);
 			return -ENOMEM;
-- 
2.33.0



