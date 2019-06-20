Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5148D4D6BA
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728739AbfFTSLT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:11:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:39038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728528AbfFTSLT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:11:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EE3B21655;
        Thu, 20 Jun 2019 18:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054278;
        bh=Laoy70k62g0UXtcA4QneYYsZX8FcLuyj5fOnQpigcnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hkB7Z8Sonm544y7QF8lbIytrByelyVoB55wjQRjWBx1Z1132A94ErRZTx5347p3PZ
         5Qt4LcZ8700GJgfwTIo5oVlEI36PjZlEsCbCK1+bcXVPdN1uFTNHACh37yuIBX9nIJ
         C9xGPW/VpttNDi83HHccGLUZGUuec9/ohxz26gY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Jander <david@protonic.nl>,
        Lucas Stach <l.stach@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 34/61] drm/etnaviv: lock MMU while dumping core
Date:   Thu, 20 Jun 2019 19:57:29 +0200
Message-Id: <20190620174343.281111868@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174336.357373754@linuxfoundation.org>
References: <20190620174336.357373754@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



