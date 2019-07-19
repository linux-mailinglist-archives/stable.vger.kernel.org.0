Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0DE96D9EC
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 05:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbfGSD6V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 23:58:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727891AbfGSD6V (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 23:58:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D51721855;
        Fri, 19 Jul 2019 03:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508701;
        bh=A8V1gvm+yaht1CTUyJ/J+QZqRvGR/yXURvSy6UwnNUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VlaiSkmGPPBkB1SzAYxXkk6pDs/G0SZZXYxPab2j1TSRBEI01Q1eSH0Fv1mvqSAX5
         y8Gfamd5N3cRDIE3TDxs7WdRz8kA0zCpR//MNxuNGVDAIUp9XmwfsaoccTpDahRNz8
         KpKPj3cq8FVTB/E041J8sd0ONAqQP/vQT0TUZoDM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 040/171] gpu: host1x: Increase maximum DMA segment size
Date:   Thu, 18 Jul 2019 23:54:31 -0400
Message-Id: <20190719035643.14300-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit 1e390478cfb527e34c9ab89ba57212cb05c33c51 ]

Recent versions of the DMA API debug code have started to warn about
violations of the maximum DMA segment size. This is because the segment
size defaults to 64 KiB, which can easily be exceeded in large buffer
allocations such as used in DRM/KMS for framebuffers.

Technically the Tegra SMMU and ARM SMMU don't have a maximum segment
size (they map individual pages irrespective of whether they are
contiguous or not), so the choice of 4 MiB is a bit arbitrary here. The
maximum segment size is a 32-bit unsigned integer, though, so we can't
set it to the correct maximum size, which would be the size of the
aperture.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/host1x/bus.c | 3 +++
 include/linux/host1x.h   | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/gpu/host1x/bus.c b/drivers/gpu/host1x/bus.c
index 9797ccb0a073..6387302c1245 100644
--- a/drivers/gpu/host1x/bus.c
+++ b/drivers/gpu/host1x/bus.c
@@ -414,6 +414,9 @@ static int host1x_device_add(struct host1x *host1x,
 
 	of_dma_configure(&device->dev, host1x->dev->of_node, true);
 
+	device->dev.dma_parms = &device->dma_parms;
+	dma_set_max_seg_size(&device->dev, SZ_4M);
+
 	err = host1x_device_parse_dt(device, driver);
 	if (err < 0) {
 		kfree(device);
diff --git a/include/linux/host1x.h b/include/linux/host1x.h
index cfff30b9a62e..e6eea45e1154 100644
--- a/include/linux/host1x.h
+++ b/include/linux/host1x.h
@@ -297,6 +297,8 @@ struct host1x_device {
 	struct list_head clients;
 
 	bool registered;
+
+	struct device_dma_parameters dma_parms;
 };
 
 static inline struct host1x_device *to_host1x_device(struct device *dev)
-- 
2.20.1

