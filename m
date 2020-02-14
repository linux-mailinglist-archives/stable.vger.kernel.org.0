Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 915B315EF12
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:45:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389430AbgBNQCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:02:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:49228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389426AbgBNQCk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:02:40 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1AE924682;
        Fri, 14 Feb 2020 16:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696159;
        bh=B57KRccJ758jF0xN74+wxNnwCOVOgwAYcSyGiizN5Pg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=patKauYOv1Gm8bS7CNJyBbQRftyNuCaM909J0UVmvPkdxF/OT0QsvXJkuD54Mt9zn
         cowXyrdAUqpJYwEgK9AGQF0eWhw0m3Tec4axviCKqRhlJPzi8Pt5QfviYx9aeL+nUr
         EMbhXg9c5xYejSWScMjIVLjf3U3Qpl4yd8Q+ZAV4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chen-Yu Tsai <wens@csie.org>, Maxime Ripard <mripard@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 037/459] media: sun4i-csi: Deal with DRAM offset
Date:   Fri, 14 Feb 2020 10:54:47 -0500
Message-Id: <20200214160149.11681-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit 249b286171fa9c358e8d5c825b48c4ebea97c498 ]

On Allwinner SoCs, some high memory bandwidth devices do DMA directly
over the memory bus (called MBUS), instead of the system bus. These
devices include the CSI camera sensor interface, video (codec) engine,
display subsystem, etc.. The memory bus has a different addressing
scheme without the DRAM starting offset.

Deal with this using the "interconnects" property from the device tree,
or if that is not available, set dev->dma_pfn_offset to PHYS_PFN_OFFSET.

Fixes: 577bbf23b758 ("media: sunxi: Add A10 CSI driver")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Acked-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../platform/sunxi/sun4i-csi/sun4i_csi.c      | 22 +++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/media/platform/sunxi/sun4i-csi/sun4i_csi.c b/drivers/media/platform/sunxi/sun4i-csi/sun4i_csi.c
index f36dc6258900e..b8b07c1de2a8e 100644
--- a/drivers/media/platform/sunxi/sun4i-csi/sun4i_csi.c
+++ b/drivers/media/platform/sunxi/sun4i-csi/sun4i_csi.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/of_graph.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
@@ -155,6 +156,27 @@ static int sun4i_csi_probe(struct platform_device *pdev)
 	subdev = &csi->subdev;
 	vdev = &csi->vdev;
 
+	/*
+	 * On Allwinner SoCs, some high memory bandwidth devices do DMA
+	 * directly over the memory bus (called MBUS), instead of the
+	 * system bus. The memory bus has a different addressing scheme
+	 * without the DRAM starting offset.
+	 *
+	 * In some cases this can be described by an interconnect in
+	 * the device tree. In other cases where the hardware is not
+	 * fully understood and the interconnect is left out of the
+	 * device tree, fall back to a default offset.
+	 */
+	if (of_find_property(csi->dev->of_node, "interconnects", NULL)) {
+		ret = of_dma_configure(csi->dev, csi->dev->of_node, true);
+		if (ret)
+			return ret;
+	} else {
+#ifdef PHYS_PFN_OFFSET
+		csi->dev->dma_pfn_offset = PHYS_PFN_OFFSET;
+#endif
+	}
+
 	csi->mdev.dev = csi->dev;
 	strscpy(csi->mdev.model, "Allwinner Video Capture Device",
 		sizeof(csi->mdev.model));
-- 
2.20.1

