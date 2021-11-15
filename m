Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF87E4510F0
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243331AbhKOS4m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:56:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:54766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243232AbhKOSxo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:53:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8A6B6329A;
        Mon, 15 Nov 2021 18:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999856;
        bh=P3n1iU+XDSmNn9Wv45OUkkcMGKMcBFFjXS6p2abEXEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xLQ0OmNQJIKwj+nrg2WJObC6/phkchSx9Y875MsQwPK9LyklGeTDg5/X3RD1ziHR7
         UmPua/q//Mva5fQFF1RKdB8Vjac1baC7YNy4SdJTO80HyalrlnDWgGh4GZXWoeC7xM
         BPecZsadxu41JAG5iyUjE/kfi4se6yez7tlO1Geo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lang Yu <lang.yu@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 448/849] drm/amdkfd: Fix an inappropriate error handling in allloc memory of gpu
Date:   Mon, 15 Nov 2021 17:58:51 +0100
Message-Id: <20211115165435.442844988@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lang Yu <lang.yu@amd.com>

[ Upstream commit 5aeeac6fa38fca450faed9770f75b1470c0e2073 ]

We should unreference a gem object instead of an amdgpu bo here.

Fixes: fd9a9f8801de ("drm/amdgpu: Use GEM obj reference for KFD BOs")

Signed-off-by: Lang Yu <lang.yu@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index b18c0697356c1..05a3c021738a1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1490,7 +1490,7 @@ allocate_init_user_pages_failed:
 	remove_kgd_mem_from_kfd_bo_list(*mem, avm->process_info);
 	drm_vma_node_revoke(&gobj->vma_node, drm_priv);
 err_node_allow:
-	amdgpu_bo_unref(&bo);
+	drm_gem_object_put(gobj);
 	/* Don't unreserve system mem limit twice */
 	goto err_reserve_limit;
 err_bo_create:
-- 
2.33.0



