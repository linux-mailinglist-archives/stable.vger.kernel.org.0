Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFFF4513C4
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345884AbhKOT4B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:56:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:45386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344030AbhKOTXI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:23:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F5B36361A;
        Mon, 15 Nov 2021 18:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002235;
        bh=S9aNWYG0lSNA4jj4C01uo6Hl2ZdQBm7B1wHPSWUwog0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zo3lmJH9kEpzemBqLcp3g63WIIa4Ami904pq0FYay+1cJ+dKqkCSyfJIc9O/lN2e0
         CiORkeM8R3eF7pzn8kXOdIDAeAKqPup9AuegaLxHlEhywjKBzQunS8sKp9PlCnV30e
         wC07hr/+hVpGUT9aV6o0lh6by2JY+cpPRG0tOhKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lang Yu <lang.yu@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 456/917] drm/amdkfd: Fix an inappropriate error handling in allloc memory of gpu
Date:   Mon, 15 Nov 2021 17:59:11 +0100
Message-Id: <20211115165444.243544693@linuxfoundation.org>
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
index 054c1a224defb..cdf46bd0d8d5b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1503,7 +1503,7 @@ allocate_init_user_pages_failed:
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



