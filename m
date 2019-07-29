Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 239EA795EC
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390253AbfG2TrB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:47:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:36526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389901AbfG2TrA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:47:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D5B52054F;
        Mon, 29 Jul 2019 19:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429620;
        bh=P5U4o4WKb59SFHAyXNC8P7Bgk1YTKDn1oZLBMjNrS4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VqpMr7gMLzylUgEzNJAHYQaky555sq131mvKcOMFt+oiikv/Sp4KDIhF7hWgeIR8A
         jvF8PtR8eKgWC5NuexgQFpDVlsdN+MBx530dxz/k+jTvOaTnuMODI9g7KVG68uf+3z
         9RkWyxON+ogI/r6JKbDsTtEbJPdn6mTH1SxG3M4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 042/215] gpu: host1x: Increase maximum DMA segment size
Date:   Mon, 29 Jul 2019 21:20:38 +0200
Message-Id: <20190729190747.812253328@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



