Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E576A2A3923
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 02:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbgKCBXh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 20:23:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:35530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728163AbgKCBUh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 20:20:37 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8A85223AB;
        Tue,  3 Nov 2020 01:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604366436;
        bh=LElm6Zafo7BTS/lgiCEqVaMi8wJy5DkDg9vX2n7H3tQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UvKsiKGOgGC5x8Zpp4If5zQ4bHuVb2MncYrbGcHPTpxGEAD2jTZ+9dklg+dmHWAVp
         eAlLIGIXTEVY9g3uaFr3z1Ub4JHqZgkjUsHjwH8HW0aSgd1zRbt6M0QmJFZdwbEbP4
         eavw6flvj3z2yzhCaRfhbcaktpNT87Fy8/z6vSOA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ralph Campbell <rcampbell@nvidia.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 22/24] drm/nouveau/nouveau: fix the start/end range for migration
Date:   Mon,  2 Nov 2020 20:20:05 -0500
Message-Id: <20201103012007.183429-22-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201103012007.183429-1-sashal@kernel.org>
References: <20201103012007.183429-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ralph Campbell <rcampbell@nvidia.com>

[ Upstream commit cfa736f5a6f31ca8a05459b5720aac030247ad1b ]

The user level OpenCL code shouldn't have to align start and end
addresses to a page boundary. That is better handled in the nouveau
driver. The npages field is also redundant since it can be computed
from the start and end addresses.

Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_svm.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_svm.c b/drivers/gpu/drm/nouveau/nouveau_svm.c
index 824654742a604..0be4668c780bf 100644
--- a/drivers/gpu/drm/nouveau/nouveau_svm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_svm.c
@@ -112,11 +112,11 @@ nouveau_svmm_bind(struct drm_device *dev, void *data,
 	struct nouveau_cli *cli = nouveau_cli(file_priv);
 	struct drm_nouveau_svm_bind *args = data;
 	unsigned target, cmd, priority;
-	unsigned long addr, end, size;
+	unsigned long addr, end;
 	struct mm_struct *mm;
 
 	args->va_start &= PAGE_MASK;
-	args->va_end &= PAGE_MASK;
+	args->va_end = ALIGN(args->va_end, PAGE_SIZE);
 
 	/* Sanity check arguments */
 	if (args->reserved0 || args->reserved1)
@@ -125,8 +125,6 @@ nouveau_svmm_bind(struct drm_device *dev, void *data,
 		return -EINVAL;
 	if (args->va_start >= args->va_end)
 		return -EINVAL;
-	if (!args->npages)
-		return -EINVAL;
 
 	cmd = args->header >> NOUVEAU_SVM_BIND_COMMAND_SHIFT;
 	cmd &= NOUVEAU_SVM_BIND_COMMAND_MASK;
@@ -158,12 +156,6 @@ nouveau_svmm_bind(struct drm_device *dev, void *data,
 	if (args->stride)
 		return -EINVAL;
 
-	size = ((unsigned long)args->npages) << PAGE_SHIFT;
-	if ((args->va_start + size) <= args->va_start)
-		return -EINVAL;
-	if ((args->va_start + size) > args->va_end)
-		return -EINVAL;
-
 	/*
 	 * Ok we are ask to do something sane, for now we only support migrate
 	 * commands but we will add things like memory policy (what to do on
@@ -178,7 +170,7 @@ nouveau_svmm_bind(struct drm_device *dev, void *data,
 		return -EINVAL;
 	}
 
-	for (addr = args->va_start, end = args->va_start + size; addr < end;) {
+	for (addr = args->va_start, end = args->va_end; addr < end;) {
 		struct vm_area_struct *vma;
 		unsigned long next;
 
-- 
2.27.0

