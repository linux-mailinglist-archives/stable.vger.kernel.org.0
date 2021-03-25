Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59214348F3A
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbhCYL0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:26:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:34206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230347AbhCYLZv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:25:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E05161A17;
        Thu, 25 Mar 2021 11:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671550;
        bh=nrYPgSlh1MX6DNy97a1bWl/b0r03TbP9jp2zLQMAbqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PdnRVF8QrSajy2xe38Bru4YlKhyhI1TyU3KJtFx+44WLhQEzZ/qV3jdtuCdfiOudY
         S5IJ50NpTXFB9ruwrPfwOSq7zE2vGwtao7AV0/o5KD4ZAxwvkaOTDJubxGSvKVp1yM
         D/1EA7G3Mm/3Ij29nRAwJROxDSH2Xn6y72S0nr7HVwak5C+C2pR12GjHhu1B/Yl8Ct
         V2+33uAtoR87JpKK3X5La9HGfbAImap0qB5P/EPTygrJiKYxQYwSk5lkktMvMWAgHH
         CBjTa0VCo5lPC7qMAh6B+YFLn6xGWm2nuM/8AAvBb+C3SUxApdH/4v+hiQKy8yisqq
         s6Hcn7nS1p3xg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tobias Klausmann <tobias.klausmann@freenet.de>,
        Dave Airlie <airlied@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.11 39/44] nouveau: Skip unvailable ttm page entries
Date:   Thu, 25 Mar 2021 07:24:54 -0400
Message-Id: <20210325112459.1926846-39-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112459.1926846-1-sashal@kernel.org>
References: <20210325112459.1926846-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tobias Klausmann <tobias.klausmann@freenet.de>

[ Upstream commit e94c55b8e0a0bbe9a026250cf31e2fa45957d776 ]

Starting with commit f295c8cfec833c2707ff1512da10d65386dde7af
("drm/nouveau: fix dma syncing warning with debugging on.")
the following oops occures:

   BUG: kernel NULL pointer dereference, address: 0000000000000000
   #PF: supervisor read access in kernel mode
   #PF: error_code(0x0000) - not-present page
   PGD 0 P4D 0
   Oops: 0000 [#1] PREEMPT SMP PTI
   CPU: 6 PID: 1013 Comm: Xorg.bin Tainted: G E     5.11.0-desktop-rc0+ #2
   Hardware name: Acer Aspire VN7-593G/Pluto_KLS, BIOS V1.11 08/01/2018
   RIP: 0010:nouveau_bo_sync_for_device+0x40/0xb0 [nouveau]
   Call Trace:
    nouveau_bo_validate+0x5d/0x80 [nouveau]
    nouveau_gem_ioctl_pushbuf+0x662/0x1120 [nouveau]
    ? nouveau_gem_ioctl_new+0xf0/0xf0 [nouveau]
    drm_ioctl_kernel+0xa6/0xf0 [drm]
    drm_ioctl+0x1f4/0x3a0 [drm]
    ? nouveau_gem_ioctl_new+0xf0/0xf0 [nouveau]
    nouveau_drm_ioctl+0x50/0xa0 [nouveau]
    __x64_sys_ioctl+0x7e/0xb0
    do_syscall_64+0x33/0x80
    entry_SYSCALL_64_after_hwframe+0x44/0xae
   ---[ end trace ccfb1e7f4064374f ]---
   RIP: 0010:nouveau_bo_sync_for_device+0x40/0xb0 [nouveau]

The underlying problem is not introduced by the commit, yet it uncovered the
underlying issue. The cited commit relies on valid pages. This is not given for
due to some bugs. For now, just warn and work around the issue by just ignoring
the bad ttm objects.
Below is some debug info gathered while debugging this issue:

nouveau 0000:01:00.0: DRM: ttm_dma->num_pages: 2048
nouveau 0000:01:00.0: DRM: ttm_dma->pages is NULL
nouveau 0000:01:00.0: DRM: ttm_dma: 00000000e96058e7
nouveau 0000:01:00.0: DRM: ttm_dma->page_flags:
nouveau 0000:01:00.0: DRM: ttm_dma:   Populated: 1
nouveau 0000:01:00.0: DRM: ttm_dma:   No Retry: 0
nouveau 0000:01:00.0: DRM: ttm_dma:   SG: 256
nouveau 0000:01:00.0: DRM: ttm_dma:   Zero Alloc: 0
nouveau 0000:01:00.0: DRM: ttm_dma:   Swapped: 0

Signed-off-by: Tobias Klausmann <tobias.klausmann@freenet.de>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210313222159.3346-1-tobias.klausmann@freenet.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_bo.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index f1c9a22083be..e05565f284dc 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -551,6 +551,10 @@ nouveau_bo_sync_for_device(struct nouveau_bo *nvbo)
 
 	if (!ttm_dma)
 		return;
+	if (!ttm_dma->pages) {
+		NV_DEBUG(drm, "ttm_dma 0x%p: pages NULL\n", ttm_dma);
+		return;
+	}
 
 	/* Don't waste time looping if the object is coherent */
 	if (nvbo->force_coherent)
@@ -583,6 +587,10 @@ nouveau_bo_sync_for_cpu(struct nouveau_bo *nvbo)
 
 	if (!ttm_dma)
 		return;
+	if (!ttm_dma->pages) {
+		NV_DEBUG(drm, "ttm_dma 0x%p: pages NULL\n", ttm_dma);
+		return;
+	}
 
 	/* Don't waste time looping if the object is coherent */
 	if (nvbo->force_coherent)
-- 
2.30.1

