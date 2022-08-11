Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5E7C590018
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236157AbiHKPhZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236153AbiHKPg1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:36:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FEBB85AAE;
        Thu, 11 Aug 2022 08:33:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF551B82160;
        Thu, 11 Aug 2022 15:33:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC002C433D6;
        Thu, 11 Aug 2022 15:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660231996;
        bh=KfQaVgWres62C/86ChqTdJmTDD2+hCoGEybwHudOPAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tO7kdzDLI0d7eO6JX2e/Mam1XVrjida4tVtZa4htXSTiVHRsFzVgQv2W5GPUBzUXm
         yNuMHJCNaK57ybv7ZFoRXMFz5h4qO0ruFRC1VgUTIFHzqEq59E8k4Iclz8lJ7CYHQB
         CqDRld619MuDKDtqFzrnmfVnejEUwoJLeJyahaBbbeBB9ifxjnpypU0r+CZwhOxswO
         mHONbVDK+21byFthODXzVj2ICFE35rb08Jb8R8+ViCioqj0UQhUnYb0HBi3nqR7XW5
         tBLv6rIOl9ULGVcc65/ntAVsd4NjfocBEsPOmaCwIDBQt/0uqtx9Nk6y5BBt9E/qI6
         r6Gug+64aAMNg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Philip Yang <Philip.Yang@amd.com>,
        Graham Sider <Graham.Sider@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, Felix.Kuehling@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 044/105] drm/amdkfd: Free queue after unmap queue success
Date:   Thu, 11 Aug 2022 11:27:28 -0400
Message-Id: <20220811152851.1520029-44-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit ab8529b0cdb271d9b222cbbddb2641f3fca5df8f ]

After queue unmap or remove from MES successfully, free queue sysfs
entries, doorbell and remove from queue list. Otherwise, application may
destroy queue again, cause below kernel warning or crash backtrace.

For outstanding queues, either application forget to destroy or failed
to destroy, kfd_process_notifier_release will remove queue sysfs
entries, kfd_process_wq_release will free queue doorbell.

v2: decrement_queue_count for MES queue

 refcount_t: underflow; use-after-free.
 WARNING: CPU: 7 PID: 3053 at lib/refcount.c:28
  Call Trace:
   kobject_put+0xd6/0x1a0
   kfd_procfs_del_queue+0x27/0x30 [amdgpu]
   pqm_destroy_queue+0xeb/0x240 [amdgpu]
   kfd_ioctl_destroy_queue+0x32/0x70 [amdgpu]
   kfd_ioctl+0x27d/0x500 [amdgpu]
   do_syscall_64+0x35/0x80

 WARNING: CPU: 2 PID: 3053 at drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_device_queue_manager.c:400
  Call Trace:
   deallocate_doorbell.isra.0+0x39/0x40 [amdgpu]
   destroy_queue_cpsch+0xb3/0x270 [amdgpu]
   pqm_destroy_queue+0x108/0x240 [amdgpu]
   kfd_ioctl_destroy_queue+0x32/0x70 [amdgpu]
   kfd_ioctl+0x27d/0x500 [amdgpu]

 general protection fault, probably for non-canonical address
0xdead000000000108:
 Call Trace:
  pqm_destroy_queue+0xf0/0x200 [amdgpu]
  kfd_ioctl_destroy_queue+0x2f/0x60 [amdgpu]
  kfd_ioctl+0x19b/0x600 [amdgpu]

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Graham Sider <Graham.Sider@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/amdkfd/kfd_device_queue_manager.c | 28 +++++++++++--------
 .../amd/amdkfd/kfd_process_queue_manager.c    |  2 +-
 2 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
index e1797657b04c..e017b4240472 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -1873,6 +1873,22 @@ static int destroy_queue_cpsch(struct device_queue_manager *dqm,
 
 	}
 
+	if (q->properties.is_active) {
+		if (!dqm->dev->shared_resources.enable_mes) {
+			retval = execute_queues_cpsch(dqm,
+						      KFD_UNMAP_QUEUES_FILTER_DYNAMIC_QUEUES, 0);
+			if (retval == -ETIME)
+				qpd->reset_wavefronts = true;
+		} else {
+			retval = remove_queue_mes(dqm, q, qpd);
+		}
+
+		if (retval)
+			goto failed_unmap_queue;
+
+		decrement_queue_count(dqm, qpd, q);
+	}
+
 	mqd_mgr = dqm->mqd_mgrs[get_mqd_type_from_queue_type(
 			q->properties.type)];
 
@@ -1886,17 +1902,6 @@ static int destroy_queue_cpsch(struct device_queue_manager *dqm,
 
 	list_del(&q->list);
 	qpd->queue_count--;
-	if (q->properties.is_active) {
-		if (!dqm->dev->shared_resources.enable_mes) {
-			decrement_queue_count(dqm, qpd, q);
-			retval = execute_queues_cpsch(dqm,
-						      KFD_UNMAP_QUEUES_FILTER_DYNAMIC_QUEUES, 0);
-			if (retval == -ETIME)
-				qpd->reset_wavefronts = true;
-		} else {
-			retval = remove_queue_mes(dqm, q, qpd);
-		}
-	}
 
 	/*
 	 * Unconditionally decrement this counter, regardless of the queue's
@@ -1913,6 +1918,7 @@ static int destroy_queue_cpsch(struct device_queue_manager *dqm,
 
 	return retval;
 
+failed_unmap_queue:
 failed_try_destroy_debugged_queue:
 
 	dqm_unlock(dqm);
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
index dc00484ff484..99f2a6412201 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -419,7 +419,6 @@ int pqm_destroy_queue(struct process_queue_manager *pqm, unsigned int qid)
 	}
 
 	if (pqn->q) {
-		kfd_procfs_del_queue(pqn->q);
 		dqm = pqn->q->device->dqm;
 		retval = dqm->ops.destroy_queue(dqm, &pdd->qpd, pqn->q);
 		if (retval) {
@@ -439,6 +438,7 @@ int pqm_destroy_queue(struct process_queue_manager *pqm, unsigned int qid)
 		if (dev->shared_resources.enable_mes)
 			amdgpu_amdkfd_free_gtt_mem(dev->adev,
 						   pqn->q->gang_ctx_bo);
+		kfd_procfs_del_queue(pqn->q);
 		uninit_queue(pqn->q);
 	}
 
-- 
2.35.1

