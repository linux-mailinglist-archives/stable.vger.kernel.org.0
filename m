Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6154FCB47
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 03:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238905AbiDLBEF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 21:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343849AbiDLA5I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:57:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3DF824BEF;
        Mon, 11 Apr 2022 17:49:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D097B819C5;
        Tue, 12 Apr 2022 00:49:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E5CC385A3;
        Tue, 12 Apr 2022 00:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724573;
        bh=hnSeruQ5WyddU9pPERbn+e7vShbePPJJ1EYBzggJ3bY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cXgab4OYl8/Dw45eR/3Y/PwbcIDroy2vSOb7aF+m64gmC7dnGv50O2HntXUXM7hlb
         XST+qTnwCOBktylr8wskKB/9ilqr7rmZEfvy7tOno3kn12wbqXnRmu0FEyP74J5KDs
         DfHpuX/pgUywrLEVA/0LDmpgpWBV4Dx6ygjaTDCW7VTsE4BWbQLJRg+I4uuESY5LPZ
         H1uUsmjpWXWuKcI4+JyZeocja51CTFgmFq6BjkefJ/xxWB9jRhFTpnOnaaecHWJHnZ
         JV4jM+udhfNJGGJj6Szz7/eQoP4ai8xA8u1Drt40zkojTv+vAbuYPi+kB7L4ua82I1
         u0RzjjN4zC80w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tushar Patel <tushar.patel@amd.com>,
        Felix Kuehling <felix.kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        Felix.Kuehling@amd.com, evan.quan@amd.com,
        mario.limonciello@amd.com, andrey.grodzovsky@amd.com,
        solomon.chiu@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 07/30] drm/amdkfd: Fix Incorrect VMIDs passed to HWS
Date:   Mon, 11 Apr 2022 20:48:41 -0400
Message-Id: <20220412004906.350678-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004906.350678-1-sashal@kernel.org>
References: <20220412004906.350678-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tushar Patel <tushar.patel@amd.com>

[ Upstream commit b7dfbd2e601f3fee545bc158feceba4f340fe7cf ]

Compute-only GPUs have more than 8 VMIDs allocated to KFD. Fix
this by passing correct number of VMIDs to HWS

v2: squash in warning fix (Alex)

Signed-off-by: Tushar Patel <tushar.patel@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c |  2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_device.c | 11 +++--------
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index ed13a2f76884..30659c1776e8 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -632,7 +632,7 @@ MODULE_PARM_DESC(sched_policy,
  * Maximum number of processes that HWS can schedule concurrently. The maximum is the
  * number of VMIDs assigned to the HWS, which is also the default.
  */
-int hws_max_conc_proc = 8;
+int hws_max_conc_proc = -1;
 module_param(hws_max_conc_proc, int, 0444);
 MODULE_PARM_DESC(hws_max_conc_proc,
 	"Max # processes HWS can execute concurrently when sched_policy=0 (0 = no concurrency, #VMIDs for KFD = Maximum(default))");
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device.c b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
index 84313135c2ea..148e43dee657 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
@@ -664,15 +664,10 @@ bool kgd2kfd_device_init(struct kfd_dev *kfd,
 			- kfd->vm_info.first_vmid_kfd + 1;
 
 	/* Verify module parameters regarding mapped process number*/
-	if ((hws_max_conc_proc < 0)
-			|| (hws_max_conc_proc > kfd->vm_info.vmid_num_kfd)) {
-		dev_err(kfd_device,
-			"hws_max_conc_proc %d must be between 0 and %d, use %d instead\n",
-			hws_max_conc_proc, kfd->vm_info.vmid_num_kfd,
-			kfd->vm_info.vmid_num_kfd);
+	if (hws_max_conc_proc >= 0)
+		kfd->max_proc_per_quantum = min((u32)hws_max_conc_proc, kfd->vm_info.vmid_num_kfd);
+	else
 		kfd->max_proc_per_quantum = kfd->vm_info.vmid_num_kfd;
-	} else
-		kfd->max_proc_per_quantum = hws_max_conc_proc;
 
 	/* calculate max size of mqds needed for queues */
 	size = max_num_of_queues_per_device *
-- 
2.35.1

