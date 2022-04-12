Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55C1C4FD388
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 11:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352343AbiDLHgT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355510AbiDLH1j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:27:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44BB74EA2A;
        Tue, 12 Apr 2022 00:07:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E780B81B51;
        Tue, 12 Apr 2022 07:07:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05B0EC385A6;
        Tue, 12 Apr 2022 07:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747261;
        bh=89MrKhqbU4iUBu1mBVmX/Pf+qMpToYtQOMbN23scytw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X0ZmSGPE7Zv0/nt/N2gSgcEQGBJbK9dlpbdDaIiMBXsC9c55hwZnd4epHNUEXstB7
         5mPGkulCAiQdbbnJwTTHddlyxHyjIv6qCdjf3Y8eSeUbWHK1HoBlaEgeaWwTCzxtHm
         kvIZWxGCQ17fUnVuKgGYglFNzr/Iz7lR9lIzdLB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Huang <jinhuieric.huang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 016/343] drm/amdkfd: enable heavy-weight TLB flush on Arcturus
Date:   Tue, 12 Apr 2022 08:27:14 +0200
Message-Id: <20220412062951.573763904@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Eric Huang <jinhuieric.huang@amd.com>

[ Upstream commit f61c40c0757a79bcf744314df606c2bc8ae6a729 ]

SDMA FW fixes the hang issue for adding heavy-weight TLB
flush on Arcturus, so we can enable it.

Signed-off-by: Eric Huang <jinhuieric.huang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c |  6 ------
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c         | 10 ++++++++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index f9bab963a948..5df387c4d7fb 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1813,12 +1813,6 @@ int amdgpu_amdkfd_gpuvm_map_memory_to_gpu(
 				true);
 	ret = unreserve_bo_and_vms(&ctx, false, false);
 
-	/* Only apply no TLB flush on Aldebaran to
-	 * workaround regressions on other Asics.
-	 */
-	if (table_freed && (adev->asic_type != CHIP_ALDEBARAN))
-		*table_freed = true;
-
 	goto out;
 
 out_unreserve:
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index 4bfc0c8ab764..337953af7c2f 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -1416,6 +1416,12 @@ static int kfd_ioctl_free_memory_of_gpu(struct file *filep,
 	return ret;
 }
 
+static bool kfd_flush_tlb_after_unmap(struct kfd_dev *dev) {
+	return KFD_GC_VERSION(dev) == IP_VERSION(9, 4, 2) ||
+	       (KFD_GC_VERSION(dev) == IP_VERSION(9, 4, 1) &&
+	        dev->adev->sdma.instance[0].fw_version >= 18);
+}
+
 static int kfd_ioctl_map_memory_to_gpu(struct file *filep,
 					struct kfd_process *p, void *data)
 {
@@ -1503,7 +1509,7 @@ static int kfd_ioctl_map_memory_to_gpu(struct file *filep,
 	}
 
 	/* Flush TLBs after waiting for the page table updates to complete */
-	if (table_freed) {
+	if (table_freed || !kfd_flush_tlb_after_unmap(dev)) {
 		for (i = 0; i < args->n_devices; i++) {
 			peer = kfd_device_by_id(devices_arr[i]);
 			if (WARN_ON_ONCE(!peer))
@@ -1603,7 +1609,7 @@ static int kfd_ioctl_unmap_memory_from_gpu(struct file *filep,
 	}
 	mutex_unlock(&p->mutex);
 
-	if (KFD_GC_VERSION(dev) == IP_VERSION(9, 4, 2)) {
+	if (kfd_flush_tlb_after_unmap(dev)) {
 		err = amdgpu_amdkfd_gpuvm_sync_memory(dev->adev,
 				(struct kgd_mem *) mem, true);
 		if (err) {
-- 
2.35.1



