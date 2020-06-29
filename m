Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A05920E7F7
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732968AbgF2WBo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 18:01:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726285AbgF2SfY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 661FE246F4;
        Mon, 29 Jun 2020 15:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444038;
        bh=QzOTcZupd2bkxq8x7aWHVHFNfXkXtl9rpvhQrlewe4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kNBdPHXDLTM5/At0rwIr6hyUiCo/15EPaR3SEaWyq93NMEP1Ou8gjOPu/jaqfPS9E
         yFQb7JmO24Q0MksS2d/c+gn17q2lvbJSFKZRqoJwGPP44mek9v6mNIbsv0A6Yo3wjl
         Eg+iFa+2dkgpFjSstbJ+7BqUoMTpD53VUOgGsFhc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anson Huang <Anson.Huang@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 145/265] soc: imx8m: Correct i.MX8MP UID fuse offset
Date:   Mon, 29 Jun 2020 11:16:18 -0400
Message-Id: <20200629151818.2493727-146-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anson Huang <Anson.Huang@nxp.com>

[ Upstream commit c95c9693b112f312b59c5d100fd09a1349970fab ]

Correct i.MX8MP UID fuse offset according to fuse map:

UID_LOW: 0x420
UID_HIGH: 0x430

Fixes: fc40200ebf82 ("soc: imx: increase build coverage for imx8m soc driver")
Fixes: 18f662a73862 ("soc: imx: Add i.MX8MP SoC driver support")
Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
Reviewed-by: Iuliana Prodan <iuliana.prodan@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/imx/soc-imx8m.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/imx/soc-imx8m.c b/drivers/soc/imx/soc-imx8m.c
index 719e1f189ebf2..ada0d8804d84c 100644
--- a/drivers/soc/imx/soc-imx8m.c
+++ b/drivers/soc/imx/soc-imx8m.c
@@ -22,6 +22,8 @@
 #define OCOTP_UID_LOW			0x410
 #define OCOTP_UID_HIGH			0x420
 
+#define IMX8MP_OCOTP_UID_OFFSET		0x10
+
 /* Same as ANADIG_DIGPROG_IMX7D */
 #define ANADIG_DIGPROG_IMX8MM	0x800
 
@@ -88,6 +90,8 @@ static void __init imx8mm_soc_uid(void)
 {
 	void __iomem *ocotp_base;
 	struct device_node *np;
+	u32 offset = of_machine_is_compatible("fsl,imx8mp") ?
+		     IMX8MP_OCOTP_UID_OFFSET : 0;
 
 	np = of_find_compatible_node(NULL, NULL, "fsl,imx8mm-ocotp");
 	if (!np)
@@ -96,9 +100,9 @@ static void __init imx8mm_soc_uid(void)
 	ocotp_base = of_iomap(np, 0);
 	WARN_ON(!ocotp_base);
 
-	soc_uid = readl_relaxed(ocotp_base + OCOTP_UID_HIGH);
+	soc_uid = readl_relaxed(ocotp_base + OCOTP_UID_HIGH + offset);
 	soc_uid <<= 32;
-	soc_uid |= readl_relaxed(ocotp_base + OCOTP_UID_LOW);
+	soc_uid |= readl_relaxed(ocotp_base + OCOTP_UID_LOW + offset);
 
 	iounmap(ocotp_base);
 	of_node_put(np);
-- 
2.25.1

