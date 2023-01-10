Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92A2866496E
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239265AbjAJSV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:21:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239264AbjAJSU7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:20:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1518B4D48C
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:18:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67E18B818FF
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:18:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B846AC433EF;
        Tue, 10 Jan 2023 18:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374728;
        bh=2au/8bzdU54fuOLPavMaj3vnB5+dwzQQIVuc7L2p3uk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vgbAPTQEAlt5Pic6fcxFIw/Q4Dfz9C1hwSNbVyhF9+wM4MGGPatH7icTgEwbxbuKS
         ab99mBYBjTeC0ns7I4Tm9KNY8gzizJLL5BiWM4HCzf8V4RrQZJKk6z/yEMcWY8mRkQ
         O079/+0lwlSLM/9LL8DOmPmlSS3qVQLdIOr895yY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Philip Yang <Philip.Yang@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 114/159] drm/amdkfd: Fix kfd_process_device_init_vm error handling
Date:   Tue, 10 Jan 2023 19:04:22 +0100
Message-Id: <20230110180021.930227054@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit 29d48b87db64b6697ddad007548e51d032081c59 ]

Should only destroy the ib_mem and let process cleanup worker to free
the outstanding BOs. Reset the pointer in pdd->qpd structure, to avoid
NULL pointer access in process destroy worker.

 BUG: kernel NULL pointer dereference, address: 0000000000000010
 Call Trace:
  amdgpu_amdkfd_gpuvm_unmap_gtt_bo_from_kernel+0x46/0xb0 [amdgpu]
  kfd_process_device_destroy_cwsr_dgpu+0x40/0x70 [amdgpu]
  kfd_process_destroy_pdds+0x71/0x190 [amdgpu]
  kfd_process_wq_release+0x2a2/0x3b0 [amdgpu]
  process_one_work+0x2a1/0x600
  worker_thread+0x39/0x3d0

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_process.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process.c b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
index 951b63677248..9821fa9268d3 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -689,13 +689,13 @@ void kfd_process_destroy_wq(void)
 }
 
 static void kfd_process_free_gpuvm(struct kgd_mem *mem,
-			struct kfd_process_device *pdd, void *kptr)
+			struct kfd_process_device *pdd, void **kptr)
 {
 	struct kfd_dev *dev = pdd->dev;
 
-	if (kptr) {
+	if (kptr && *kptr) {
 		amdgpu_amdkfd_gpuvm_unmap_gtt_bo_from_kernel(mem);
-		kptr = NULL;
+		*kptr = NULL;
 	}
 
 	amdgpu_amdkfd_gpuvm_unmap_memory_from_gpu(dev->adev, mem, pdd->drm_priv);
@@ -795,7 +795,7 @@ static void kfd_process_device_destroy_ib_mem(struct kfd_process_device *pdd)
 	if (!qpd->ib_kaddr || !qpd->ib_base)
 		return;
 
-	kfd_process_free_gpuvm(qpd->ib_mem, pdd, qpd->ib_kaddr);
+	kfd_process_free_gpuvm(qpd->ib_mem, pdd, &qpd->ib_kaddr);
 }
 
 struct kfd_process *kfd_create_process(struct file *filep)
@@ -1277,7 +1277,7 @@ static void kfd_process_device_destroy_cwsr_dgpu(struct kfd_process_device *pdd)
 	if (!dev->cwsr_enabled || !qpd->cwsr_kaddr || !qpd->cwsr_base)
 		return;
 
-	kfd_process_free_gpuvm(qpd->cwsr_mem, pdd, qpd->cwsr_kaddr);
+	kfd_process_free_gpuvm(qpd->cwsr_mem, pdd, &qpd->cwsr_kaddr);
 }
 
 void kfd_process_set_trap_handler(struct qcm_process_device *qpd,
@@ -1598,8 +1598,8 @@ int kfd_process_device_init_vm(struct kfd_process_device *pdd,
 	return 0;
 
 err_init_cwsr:
+	kfd_process_device_destroy_ib_mem(pdd);
 err_reserve_ib_mem:
-	kfd_process_device_free_bos(pdd);
 	pdd->drm_priv = NULL;
 
 	return ret;
-- 
2.35.1



