Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05AE639DBD
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 13:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728794AbfFHLnf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 07:43:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:60920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728784AbfFHLnc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Jun 2019 07:43:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36AB8214C6;
        Sat,  8 Jun 2019 11:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994211;
        bh=U43gp4ER5JVDxFLFOVHwt1cW9WDip0sBv7jyk0GXFHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xfbbcTZ+4yW8Nu2DT260Aweck9rGJoK1IA0oWNLZ+S7XZbmJA58NGbjz+DFIKLiAz
         nj6dxtKxXffGLX6RBNriig+yGrVoW2WYQpbdJKiiSVkoeLJ7aaXx3NRmBbIXm4AmKU
         afSUdBQpP33Nns2ue4ZT/Z4IHCMf23bxiJ1eEYX8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lucas Stach <l.stach@pengutronix.de>,
        David Jander <david@protonic.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 23/49] drm/etnaviv: lock MMU while dumping core
Date:   Sat,  8 Jun 2019 07:42:04 -0400
Message-Id: <20190608114232.8731-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608114232.8731-1-sashal@kernel.org>
References: <20190608114232.8731-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit 1396500d673bd027683a0609ff84dca7eb6ea2e7 ]

The devcoredump needs to operate on a stable state of the MMU while
it is writing the MMU state to the coredump. The missing lock
allowed both the userspace submit, as well as the GPU job finish
paths to mutate the MMU state while a coredump is under way.

Fixes: a8c21a5451d8 (drm/etnaviv: add initial etnaviv DRM driver)
Reported-by: David Jander <david@protonic.nl>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Tested-by: David Jander <david@protonic.nl>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_dump.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_dump.c b/drivers/gpu/drm/etnaviv/etnaviv_dump.c
index 9146e30e24a6..468dff2f7904 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_dump.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_dump.c
@@ -124,6 +124,8 @@ void etnaviv_core_dump(struct etnaviv_gpu *gpu)
 		return;
 	etnaviv_dump_core = false;
 
+	mutex_lock(&gpu->mmu->lock);
+
 	mmu_size = etnaviv_iommu_dump_size(gpu->mmu);
 
 	/* We always dump registers, mmu, ring and end marker */
@@ -166,6 +168,7 @@ void etnaviv_core_dump(struct etnaviv_gpu *gpu)
 	iter.start = __vmalloc(file_size, GFP_KERNEL | __GFP_NOWARN | __GFP_NORETRY,
 			       PAGE_KERNEL);
 	if (!iter.start) {
+		mutex_unlock(&gpu->mmu->lock);
 		dev_warn(gpu->dev, "failed to allocate devcoredump file\n");
 		return;
 	}
@@ -233,6 +236,8 @@ void etnaviv_core_dump(struct etnaviv_gpu *gpu)
 					 obj->base.size);
 	}
 
+	mutex_unlock(&gpu->mmu->lock);
+
 	etnaviv_core_dump_header(&iter, ETDUMP_BUF_END, iter.data);
 
 	dev_coredumpv(gpu->dev, iter.start, iter.data - iter.start, GFP_KERNEL);
-- 
2.20.1

