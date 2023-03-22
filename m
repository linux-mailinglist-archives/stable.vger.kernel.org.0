Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA296C5674
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbjCVUG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbjCVUFq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 16:05:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE90733BB;
        Wed, 22 Mar 2023 13:01:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8DFFAB81DFA;
        Wed, 22 Mar 2023 20:00:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35812C433EF;
        Wed, 22 Mar 2023 20:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515244;
        bh=T+y02KqbdinWzs5BHyJ64yYI5IzZszI6qc+B2eCbKfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lo7oDI/m+EvdyxAbCfRCxEJjD/XixL4SBeTyY6oJHjNP/4qhRxpXyarF0zW90p0u9
         lPERHeKErsE2Th5i9eLCT5tuBVK9P65uvPKasq1Izexraqc5hda4CYOsJPmCls5TIR
         8KVXNeEYJDMLp5Q954WNlu5x4ZhKx+vaxFz5jfpqWfqJPa/60dtkLnpjIxkjbaItCY
         mLFr8xEpQDChuEPrgoacey7lQe8JA3H6ElyRFQ29tj/2kgpbIXnPSinyMuJCxoiXWm
         3oKeOGl0Q9riTtDVCckokIAjEV5jjxU60Vr1QYKvKCKwWZRyVmQ2qc5/FwlF9zgqPh
         zrIGR9QFItDDg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chia-I Wu <olvaffe@gmail.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@gmail.com, daniel@ffwll.ch,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.1 18/34] drm/amdkfd: fix potential kgd_mem UAFs
Date:   Wed, 22 Mar 2023 15:59:10 -0400
Message-Id: <20230322195926.1996699-18-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322195926.1996699-1-sashal@kernel.org>
References: <20230322195926.1996699-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chia-I Wu <olvaffe@gmail.com>

[ Upstream commit 9da050b0d9e04439d225a2ec3044af70cdfb3933 ]

kgd_mem pointers returned by kfd_process_device_translate_handle are
only guaranteed to be valid while p->mutex is held. As soon as the mutex
is unlocked, another thread can free the BO.

Signed-off-by: Chia-I Wu <olvaffe@gmail.com>
Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index f79b8e964140e..e191d38f3da62 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -1298,14 +1298,14 @@ static int kfd_ioctl_map_memory_to_gpu(struct file *filep,
 		args->n_success = i+1;
 	}
 
-	mutex_unlock(&p->mutex);
-
 	err = amdgpu_amdkfd_gpuvm_sync_memory(dev->adev, (struct kgd_mem *) mem, true);
 	if (err) {
 		pr_debug("Sync memory failed, wait interrupted by user signal\n");
 		goto sync_memory_failed;
 	}
 
+	mutex_unlock(&p->mutex);
+
 	/* Flush TLBs after waiting for the page table updates to complete */
 	for (i = 0; i < args->n_devices; i++) {
 		peer_pdd = kfd_process_device_data_by_id(p, devices_arr[i]);
@@ -1321,9 +1321,9 @@ static int kfd_ioctl_map_memory_to_gpu(struct file *filep,
 bind_process_to_device_failed:
 get_mem_obj_from_handle_failed:
 map_memory_to_gpu_failed:
+sync_memory_failed:
 	mutex_unlock(&p->mutex);
 copy_from_user_failed:
-sync_memory_failed:
 	kfree(devices_arr);
 
 	return err;
@@ -1337,6 +1337,7 @@ static int kfd_ioctl_unmap_memory_from_gpu(struct file *filep,
 	void *mem;
 	long err = 0;
 	uint32_t *devices_arr = NULL, i;
+	bool flush_tlb;
 
 	if (!args->n_devices) {
 		pr_debug("Device IDs array empty\n");
@@ -1389,16 +1390,19 @@ static int kfd_ioctl_unmap_memory_from_gpu(struct file *filep,
 		}
 		args->n_success = i+1;
 	}
-	mutex_unlock(&p->mutex);
 
-	if (kfd_flush_tlb_after_unmap(pdd->dev)) {
+	flush_tlb = kfd_flush_tlb_after_unmap(pdd->dev);
+	if (flush_tlb) {
 		err = amdgpu_amdkfd_gpuvm_sync_memory(pdd->dev->adev,
 				(struct kgd_mem *) mem, true);
 		if (err) {
 			pr_debug("Sync memory failed, wait interrupted by user signal\n");
 			goto sync_memory_failed;
 		}
+	}
+	mutex_unlock(&p->mutex);
 
+	if (flush_tlb) {
 		/* Flush TLBs after waiting for the page table updates to complete */
 		for (i = 0; i < args->n_devices; i++) {
 			peer_pdd = kfd_process_device_data_by_id(p, devices_arr[i]);
@@ -1414,9 +1418,9 @@ static int kfd_ioctl_unmap_memory_from_gpu(struct file *filep,
 bind_process_to_device_failed:
 get_mem_obj_from_handle_failed:
 unmap_memory_from_gpu_failed:
+sync_memory_failed:
 	mutex_unlock(&p->mutex);
 copy_from_user_failed:
-sync_memory_failed:
 	kfree(devices_arr);
 	return err;
 }
-- 
2.39.2

