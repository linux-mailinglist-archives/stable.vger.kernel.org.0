Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A899C4513A8
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348588AbhKOTyJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:54:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:44632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343742AbhKOTV4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DE0763296;
        Mon, 15 Nov 2021 18:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001928;
        bh=aFwVWyObgqDnVTp1yQd/rsY+wDdJUy/Sircfosmh8CU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h82CuuZE/0Z5iZSIJzmL56lOJgaOucw0zRSPpfmWxyfNKlZHBvP96qrb3hJ/Sqo2m
         yFj1sRu+3WVZ0DEgrIjy/A4ZVawosYQKuBqiAegQmuR35mPdw88JDsxRhVhmGgooDx
         tUiyRUMECL0q+Kcsd7IcbhNKy7TxZ9x8AsJ2IyEc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Auld <matthew.auld@intel.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 373/917] drm/ttm: stop calling tt_swapin in vm_access
Date:   Mon, 15 Nov 2021 17:57:48 +0100
Message-Id: <20211115165441.410239317@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Auld <matthew.auld@intel.com>

[ Upstream commit f5d28856b89baab4232a9f841e565763fcebcdf9 ]

In commit:

commit 09ac4fcb3f255e9225967c75f5893325c116cdbe
Author: Felix Kuehling <Felix.Kuehling@amd.com>
Date:   Thu Jul 13 17:01:16 2017 -0400

    drm/ttm: Implement vm_operations_struct.access v2

we added the vm_access hook, where we also directly call tt_swapin for
some reason. If something is swapped-out then the ttm_tt must also be
unpopulated, and since access_kmap should also call tt_populate, if
needed, then swapping-in will already be handled there.

If anything, calling tt_swapin directly here would likely always fail
since the tt->pages won't yet be populated, or worse since the tt->pages
array is never actually cleared in unpopulate this might lead to a nasty
uaf.

Fixes: 09ac4fcb3f25 ("drm/ttm: Implement vm_operations_struct.access v2")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Christian König <christian.koenig@amd.com>
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210927114114.152310-1-matthew.auld@intel.com
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ttm/ttm_bo_vm.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo_vm.c b/drivers/gpu/drm/ttm/ttm_bo_vm.c
index f56be5bc0861e..5b9b7fd01a692 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_vm.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_vm.c
@@ -519,11 +519,6 @@ int ttm_bo_vm_access(struct vm_area_struct *vma, unsigned long addr,
 
 	switch (bo->resource->mem_type) {
 	case TTM_PL_SYSTEM:
-		if (unlikely(bo->ttm->page_flags & TTM_PAGE_FLAG_SWAPPED)) {
-			ret = ttm_tt_swapin(bo->ttm);
-			if (unlikely(ret != 0))
-				return ret;
-		}
 		fallthrough;
 	case TTM_PL_TT:
 		ret = ttm_bo_vm_access_kmap(bo, offset, buf, len, write);
-- 
2.33.0



