Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25BB313E32E
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387808AbgAPRAe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:00:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:50346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387850AbgAPRAd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:00:33 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E9DB22525;
        Thu, 16 Jan 2020 17:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194033;
        bh=f/u8zFAjCNc6rmpGCQzhfg7rSXfsqqu01yrugzFPqnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mhAK8F9zNRfWD3lqS9+U//x/26on7daYc7kU3/vfSUu6fqkOawI1gmiZZ+akS4Fzd
         F0Fjcio953FuUZi5Vw0yQ2zYhVLN05UL3egu2swPm7z3EBeGS+cUCVJAe2rl24T/XA
         R0pSOIn4/KHwHn3Nnrg/xZsKUPVP1zcDE/lnuI94=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>,
        Julien Grall <julien.grall@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, xen-devel@lists.xenproject.org
Subject: [PATCH AUTOSEL 4.19 152/671] drm/xen-front: Fix mmap attributes for display buffers
Date:   Thu, 16 Jan 2020 11:51:01 -0500
Message-Id: <20200116165940.10720-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>

[ Upstream commit 24ded292a5c2ed476f01c77fee65f8320552cd27 ]

When GEM backing storage is allocated those are normal pages,
so there is no point using pgprot_writecombine while mmaping.
This fixes mismatch of buffer pages' memory attributes between
the frontend and backend which may cause screen artifacts.

Fixes: c575b7eeb89f ("drm/xen-front: Add support for Xen PV display frontend")

Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Suggested-by: Julien Grall <julien.grall@arm.com>
Acked-by: Julien Grall <julien.grall@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190129150422.19867-1-andr2000@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xen/xen_drm_front_gem.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/xen/xen_drm_front_gem.c b/drivers/gpu/drm/xen/xen_drm_front_gem.c
index c85bfe7571cb..802662839e7e 100644
--- a/drivers/gpu/drm/xen/xen_drm_front_gem.c
+++ b/drivers/gpu/drm/xen/xen_drm_front_gem.c
@@ -236,8 +236,14 @@ static int gem_mmap_obj(struct xen_gem_object *xen_obj,
 	vma->vm_flags &= ~VM_PFNMAP;
 	vma->vm_flags |= VM_MIXEDMAP;
 	vma->vm_pgoff = 0;
-	vma->vm_page_prot =
-			pgprot_writecombine(vm_get_page_prot(vma->vm_flags));
+	/*
+	 * According to Xen on ARM ABI (xen/include/public/arch-arm.h):
+	 * all memory which is shared with other entities in the system
+	 * (including the hypervisor and other guests) must reside in memory
+	 * which is mapped as Normal Inner Write-Back Outer Write-Back
+	 * Inner-Shareable.
+	 */
+	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 
 	/*
 	 * vm_operations_struct.fault handler will be called if CPU access
@@ -283,8 +289,9 @@ void *xen_drm_front_gem_prime_vmap(struct drm_gem_object *gem_obj)
 	if (!xen_obj->pages)
 		return NULL;
 
+	/* Please see comment in gem_mmap_obj on mapping and attributes. */
 	return vmap(xen_obj->pages, xen_obj->num_pages,
-		    VM_MAP, pgprot_writecombine(PAGE_KERNEL));
+		    VM_MAP, PAGE_KERNEL);
 }
 
 void xen_drm_front_gem_prime_vunmap(struct drm_gem_object *gem_obj,
-- 
2.20.1

