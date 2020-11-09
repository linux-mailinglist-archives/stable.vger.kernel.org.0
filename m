Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 481A12ABABE
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387825AbgKINV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:21:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:49906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388145AbgKINV4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:21:56 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03AC320663;
        Mon,  9 Nov 2020 13:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604928115;
        bh=99bqU9YnZZeya7Q8pD2A8nL0JndviI2vVwrA03SaOCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jq3CvTXc0HnZnIfYPcpZVYviy9t8M0OWMKBrQn5ywNBguh2hVLInxXNWgSANqFrCy
         /ldqmmfGM+rF0T3itTv6mLcosOoCD3M4Miy8p6whvdOctLSdNedtjXqcL9Qu8mkYox
         boX9aex6GTjM/2G4bs+9TGmLMYXXCK2XhNZGNR+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ralph Campbell <rcampbell@nvidia.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 102/133] drm/nouveau/nouveau: fix the start/end range for migration
Date:   Mon,  9 Nov 2020 13:56:04 +0100
Message-Id: <20201109125035.594854742@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 2df1c04605594..4f69e4c3dafde 100644
--- a/drivers/gpu/drm/nouveau/nouveau_svm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_svm.c
@@ -105,11 +105,11 @@ nouveau_svmm_bind(struct drm_device *dev, void *data,
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
@@ -118,8 +118,6 @@ nouveau_svmm_bind(struct drm_device *dev, void *data,
 		return -EINVAL;
 	if (args->va_start >= args->va_end)
 		return -EINVAL;
-	if (!args->npages)
-		return -EINVAL;
 
 	cmd = args->header >> NOUVEAU_SVM_BIND_COMMAND_SHIFT;
 	cmd &= NOUVEAU_SVM_BIND_COMMAND_MASK;
@@ -151,12 +149,6 @@ nouveau_svmm_bind(struct drm_device *dev, void *data,
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
@@ -171,7 +163,7 @@ nouveau_svmm_bind(struct drm_device *dev, void *data,
 		return -EINVAL;
 	}
 
-	for (addr = args->va_start, end = args->va_start + size; addr < end;) {
+	for (addr = args->va_start, end = args->va_end; addr < end;) {
 		struct vm_area_struct *vma;
 		unsigned long next;
 
-- 
2.27.0



