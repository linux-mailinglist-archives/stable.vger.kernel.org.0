Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47CB3475EB7
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245445AbhLORYM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:24:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44490 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245350AbhLORXr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:23:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DB45619C9;
        Wed, 15 Dec 2021 17:23:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15531C36AE2;
        Wed, 15 Dec 2021 17:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639589026;
        bh=43vaTSWzCeqdaVI0fvsU4SSsHbOGCmzqdI+/gtOBR5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M1o6PSh6m25IM2urr5s3efVGb7So/bhEHYt3WjpqKtQF2w6hX8fOVlpaZhn8wyrlO
         TB5hs4OwNpzrNaKV7PD68Au4YWmeODaBrBh1a2QDZOJ0SDgBgXj7B1bloS+dbnTY35
         w7tk1SQNfujMoasJP4nX7TKAlOYhi1goDmUE9RnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philip Yang <Philip.Yang@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 36/42] drm/amdkfd: fix double free mem structure
Date:   Wed, 15 Dec 2021 18:21:17 +0100
Message-Id: <20211215172027.886545805@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215172026.641863587@linuxfoundation.org>
References: <20211215172026.641863587@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit 494f2e42ce4a9ddffb5d8c5b2db816425ef90397 ]

drm_gem_object_put calls release_notify callback to free the mem
structure and unreserve_mem_limit, move it down after the last access
of mem and make it conditional call.

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index cdf46bd0d8d5b..ab36cce59d2e4 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1393,7 +1393,7 @@ int amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu(
 	struct sg_table *sg = NULL;
 	uint64_t user_addr = 0;
 	struct amdgpu_bo *bo;
-	struct drm_gem_object *gobj;
+	struct drm_gem_object *gobj = NULL;
 	u32 domain, alloc_domain;
 	u64 alloc_flags;
 	int ret;
@@ -1503,14 +1503,16 @@ int amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu(
 	remove_kgd_mem_from_kfd_bo_list(*mem, avm->process_info);
 	drm_vma_node_revoke(&gobj->vma_node, drm_priv);
 err_node_allow:
-	drm_gem_object_put(gobj);
 	/* Don't unreserve system mem limit twice */
 	goto err_reserve_limit;
 err_bo_create:
 	unreserve_mem_limit(adev, size, alloc_domain, !!sg);
 err_reserve_limit:
 	mutex_destroy(&(*mem)->lock);
-	kfree(*mem);
+	if (gobj)
+		drm_gem_object_put(gobj);
+	else
+		kfree(*mem);
 err:
 	if (sg) {
 		sg_free_table(sg);
-- 
2.33.0



