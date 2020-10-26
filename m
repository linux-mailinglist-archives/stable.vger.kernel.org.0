Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80DBD29A102
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443546AbgJ0AbM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:31:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:53686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409600AbgJZXwA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:52:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E823C20882;
        Mon, 26 Oct 2020 23:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756319;
        bh=xrteNirigUZc9HRoT/v/LZx8ZHqqq4+FtG69/NB7AcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2QdUMr0hwjVkwiq0gxXbdK3huS9HOaV6ZJfupiTu0ra2klv5XLxArqoc1NPufqelw
         Xl+lf1cEIvXLSPwf2BeVVbuqNTtQZz/cl+rw90haGEXBiOZO4TSmPJMq6sFvxFo7WM
         qMRiMlt4kX0CwFjm9ysWb6z6V5eHlTLt0cjHuVDg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.9 141/147] soc: ti: k3: ringacc: add am65x sr2.0 support
Date:   Mon, 26 Oct 2020 19:48:59 -0400
Message-Id: <20201026234905.1022767-141-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026234905.1022767-1-sashal@kernel.org>
References: <20201026234905.1022767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit 95e7be062aea6d2e09116cd4d28957d310c04781 ]

The AM65x SR2.0 Ringacc has fixed errata i2023 "RINGACC, UDMA: RINGACC and
UDMA Ring State Interoperability Issue after Channel Teardown". This errata
also fixed for J271E SoC.

Use SOC bus data for K3 SoC identification and enable i2023 errate w/a only
for the AM65x SR1.0. This also makes obsolete "ti,dma-ring-reset-quirk" DT
property.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ti/k3-ringacc.c | 33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/drivers/soc/ti/k3-ringacc.c b/drivers/soc/ti/k3-ringacc.c
index 6dcc21dde0cb7..1147dc4c1d596 100644
--- a/drivers/soc/ti/k3-ringacc.c
+++ b/drivers/soc/ti/k3-ringacc.c
@@ -10,6 +10,7 @@
 #include <linux/init.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
+#include <linux/sys_soc.h>
 #include <linux/soc/ti/k3-ringacc.h>
 #include <linux/soc/ti/ti_sci_protocol.h>
 #include <linux/soc/ti/ti_sci_inta_msi.h>
@@ -208,6 +209,15 @@ struct k3_ringacc {
 	const struct k3_ringacc_ops *ops;
 };
 
+/**
+ * struct k3_ringacc - Rings accelerator SoC data
+ *
+ * @dma_ring_reset_quirk:  DMA reset w/a enable
+ */
+struct k3_ringacc_soc_data {
+	unsigned dma_ring_reset_quirk:1;
+};
+
 static long k3_ringacc_ring_get_fifo_pos(struct k3_ring *ring)
 {
 	return K3_RINGACC_FIFO_WINDOW_SIZE_BYTES -
@@ -1051,9 +1061,6 @@ static int k3_ringacc_probe_dt(struct k3_ringacc *ringacc)
 		return ret;
 	}
 
-	ringacc->dma_ring_reset_quirk =
-			of_property_read_bool(node, "ti,dma-ring-reset-quirk");
-
 	ringacc->tisci = ti_sci_get_by_phandle(node, "ti,sci");
 	if (IS_ERR(ringacc->tisci)) {
 		ret = PTR_ERR(ringacc->tisci);
@@ -1084,9 +1091,22 @@ static int k3_ringacc_probe_dt(struct k3_ringacc *ringacc)
 						 ringacc->rm_gp_range);
 }
 
+static const struct k3_ringacc_soc_data k3_ringacc_soc_data_sr1 = {
+	.dma_ring_reset_quirk = 1,
+};
+
+static const struct soc_device_attribute k3_ringacc_socinfo[] = {
+	{ .family = "AM65X",
+	  .revision = "SR1.0",
+	  .data = &k3_ringacc_soc_data_sr1
+	},
+	{/* sentinel */}
+};
+
 static int k3_ringacc_init(struct platform_device *pdev,
 			   struct k3_ringacc *ringacc)
 {
+	const struct soc_device_attribute *soc;
 	void __iomem *base_fifo, *base_rt;
 	struct device *dev = &pdev->dev;
 	struct resource *res;
@@ -1103,6 +1123,13 @@ static int k3_ringacc_init(struct platform_device *pdev,
 	if (ret)
 		return ret;
 
+	soc = soc_device_match(k3_ringacc_socinfo);
+	if (soc && soc->data) {
+		const struct k3_ringacc_soc_data *soc_data = soc->data;
+
+		ringacc->dma_ring_reset_quirk = soc_data->dma_ring_reset_quirk;
+	}
+
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "rt");
 	base_rt = devm_ioremap_resource(dev, res);
 	if (IS_ERR(base_rt))
-- 
2.25.1

