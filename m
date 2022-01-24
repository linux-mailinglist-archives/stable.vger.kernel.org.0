Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9BD4999F7
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378201AbiAXVix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:38:53 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41684 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449207AbiAXV2W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:28:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34FA8B815B0;
        Mon, 24 Jan 2022 21:28:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 618C3C340E8;
        Mon, 24 Jan 2022 21:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059691;
        bh=35lOTX6cm3m1nD+3sw8XpEL6aINTmKJuCTuO6dclzwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bQuRHEZcTqyNPV91LVDf3kYVGiB7f8brIbslg0f7Q5nWAZq2xohyGBdz8F4bzfeEu
         QqiF9FvyXiF/LUb1kJ/YNPhN3iVyt6uVR9OuVbZpo8hqJbr626/ftmqltGirqbB+w5
         KuSi4k955uqne2Df+HpztccqaHZHKytO7Cg2aL8E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Kuehling <Felix.Kuehling@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        David Yat Sin <david.yatsin@amd.com>,
        Rajneesh Bhardwaj <rajneesh.bhardwaj@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0702/1039] drm/amdgpu: Dont inherit GEM object VMAs in child process
Date:   Mon, 24 Jan 2022 19:41:31 +0100
Message-Id: <20220124184148.931014095@linuxfoundation.org>
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



