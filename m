Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB4249A282
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365794AbiAXXvn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:51:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382994AbiAXWxz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:53:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 605E1C055AB2;
        Mon, 24 Jan 2022 13:08:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F39DE611C8;
        Mon, 24 Jan 2022 21:08:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC52BC340E5;
        Mon, 24 Jan 2022 21:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058522;
        bh=AGVcsL5Qg8R5tXC51h+0QVmhQuDGSTsNbuHUgh2FqcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ScHgq0uihkKx5Pqo31KSkV3GM7xQ9wagW+SLXfYPqcyl/EWNm3JkuDKaXzMqMqo+3
         PeKpUQeYCSrznEeT64oIsZh7TSY5Yc6gWnTEI7+9KA1VkAq7XLEy14bCcnP501GyGw
         C8OgADb9feBhwFh8T5qcekNCJzeymQSuLvvVXXlU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thierry Reding <thierry.reding@gmail.com>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        dri-devel@lists.freedesktop.org,
        Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0299/1039] drm/tegra: vic: Fix DMA API misuse
Date:   Mon, 24 Jan 2022 19:34:48 +0100
Message-Id: <20220124184135.352393486@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 5566174cb10a5167d59b0793871cab7990b149b8 ]

Upon failure, dma_alloc_coherent() returns NULL. If that does happen,
passing some uninitialised stack contents to dma_mapping_error() - which
belongs to a different API in the first place - has precious little
chance of detecting it.

Also include the correct header, because the fragile transitive
inclusion currently providing it is going to break soon.

Fixes: 20e7dce255e9 ("drm/tegra: Remove memory allocation from Falcon library")
CC: Thierry Reding <thierry.reding@gmail.com>
CC: Mikko Perttunen <mperttunen@nvidia.com>
CC: dri-devel@lists.freedesktop.org
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/vic.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/tegra/vic.c b/drivers/gpu/drm/tegra/vic.c
index c02010ff2b7f2..da4af53719917 100644
--- a/drivers/gpu/drm/tegra/vic.c
+++ b/drivers/gpu/drm/tegra/vic.c
@@ -5,6 +5,7 @@
 
 #include <linux/clk.h>
 #include <linux/delay.h>
+#include <linux/dma-mapping.h>
 #include <linux/host1x.h>
 #include <linux/iommu.h>
 #include <linux/module.h>
@@ -232,10 +233,8 @@ static int vic_load_firmware(struct vic *vic)
 
 	if (!client->group) {
 		virt = dma_alloc_coherent(vic->dev, size, &iova, GFP_KERNEL);
-
-		err = dma_mapping_error(vic->dev, iova);
-		if (err < 0)
-			return err;
+		if (!virt)
+			return -ENOMEM;
 	} else {
 		virt = tegra_drm_alloc(tegra, size, &iova);
 	}
-- 
2.34.1



