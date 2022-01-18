Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCFC8491A58
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344058AbiARC73 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:59:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349095AbiARCrc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:47:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF5C8C061199;
        Mon, 17 Jan 2022 18:39:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31F20B81249;
        Tue, 18 Jan 2022 02:39:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42EEBC36AE3;
        Tue, 18 Jan 2022 02:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473542;
        bh=35lOTX6cm3m1nD+3sw8XpEL6aINTmKJuCTuO6dclzwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sYjQmGk9UZ6e3l+mPw9aokQi66da3K8KW81fIOy3NE0MLpi+knX9ORHkrciYAfCss
         Wr1SfBAJh+xYYt64WDUVxdjit5Ys/R2liWlmtvR+qa9O8oj9gmabXbB3fLWYwqkY2v
         Kg3vCbTXIrn3KQfzJVpR7aLKihf/dgcwNlhABLqZUZxT7yCrvgwUTpI9xLxERln3T5
         NrlDCPhcbieEL550/4q2TdGHVgvp8wXBvDn9Ve2djA78twQjQUgNFhhztrlE+cpF9p
         tdjdEAu9PPnXU4UxtmsM21bolwW63DVK/J8JvtAdCUvnPbOFclSdi3Tid8/ESILbsi
         EWSL9Bls49gBg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rajneesh Bhardwaj <rajneesh.bhardwaj@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        David Yat Sin <david.yatsin@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, Xinhui.Pan@amd.com,
        airlied@linux.ie, daniel@ffwll.ch, JinhuiEric.Huang@amd.com,
        nirmoy.das@amd.com, evan.quan@amd.com, tzimmermann@suse.de,
        colin.king@intel.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 158/188] drm/amdgpu: Don't inherit GEM object VMAs in child process
Date:   Mon, 17 Jan 2022 21:31:22 -0500
Message-Id: <20220118023152.1948105-158-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rajneesh Bhardwaj <rajneesh.bhardwaj@amd.com>

[ Upstream commit fbcdbfde87509d523132b59f661a355c731139d0 ]

When an application having open file access to a node forks, its shared
mappings also get reflected in the address space of child process even
though it cannot access them with the object permissions applied. With the
existing permission checks on the gem objects, it might be reasonable to
also create the VMAs with VM_DONTCOPY flag so a user space application
doesn't need to explicitly call the madvise(addr, len, MADV_DONTFORK)
system call to prevent the pages in the mapped range to appear in the
address space of the child process. It also prevents the memory leaks
due to additional reference counts on the mapped BOs in the child
process that prevented freeing the memory in the parent for which we had
worked around earlier in the user space inside the thunk library.

Additionally, we faced this issue when using CRIU to checkpoint restore
an application that had such inherited mappings in the child which
confuse CRIU when it mmaps on restore. Having this flag set for the
render node VMAs helps. VMAs mapped via KFD already take care of this so
this is needed only for the render nodes.

To limit the impact of the change to user space consumers such as OpenGL
etc, limit it to KFD BOs only.

Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: David Yat Sin <david.yatsin@amd.com>
Signed-off-by: Rajneesh Bhardwaj <rajneesh.bhardwaj@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
index a1e63ba4c54a5..630dc99e49086 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
@@ -264,6 +264,9 @@ static int amdgpu_gem_object_mmap(struct drm_gem_object *obj, struct vm_area_str
 	    !(vma->vm_flags & (VM_READ | VM_WRITE | VM_EXEC)))
 		vma->vm_flags &= ~VM_MAYWRITE;
 
+	if (bo->kfd_bo)
+		vma->vm_flags |= VM_DONTCOPY;
+
 	return drm_gem_ttm_mmap(obj, vma);
 }
 
-- 
2.34.1

