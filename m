Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68D81627FE0
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237672AbiKNNCX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:02:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237720AbiKNNCU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:02:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C1029344
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:02:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93E9761173
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:02:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E69EC433D7;
        Mon, 14 Nov 2022 13:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430938;
        bh=5JhirKHBL41cZqCTZRAYuUQBq1CyFsvlEgY08ZtfZmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AdR420dMj/W5vCQuRkQe8+xL4dEBVXBNi22HUZuCQo5tzSnJ0pKa62lp3vy5n5MKN
         IzP/DGFEp0mzQx5wxLaM0LCCg20Bf2Ch8YjgOUDy972JWbEdEqnKnyHbCjHkLchDT9
         l5HfIqpRU7KVeElVTJ4Cp4FzP2zA+jBjEcWiTSlA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Philip Yang <Philip.Yang@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 011/190] drm/amdkfd: handle CPU fault on COW mapping
Date:   Mon, 14 Nov 2022 13:43:55 +0100
Message-Id: <20221114124459.286320427@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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

[ Upstream commit e1f84eef313f4820cca068a238c645d0a38c6a9b ]

If CPU page fault in a page with zone_device_data svm_bo from another
process, that means it is COW mapping in the child process and the
range is migrated to VRAM by parent process. Migrate the parent
process range back to system memory to recover the CPU page fault.

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 5b994354af3c ("drm/amdkfd: Fix NULL pointer dereference in svm_migrate_to_ram()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c | 42 ++++++++++++++++--------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
index b059a77b6081..6555d775a532 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -886,7 +886,7 @@ svm_migrate_to_vram(struct svm_range *prange, uint32_t best_loc,
 static vm_fault_t svm_migrate_to_ram(struct vm_fault *vmf)
 {
 	unsigned long addr = vmf->address;
-	struct vm_area_struct *vma;
+	struct svm_range_bo *svm_bo;
 	enum svm_work_list_ops op;
 	struct svm_range *parent;
 	struct svm_range *prange;
@@ -894,29 +894,42 @@ static vm_fault_t svm_migrate_to_ram(struct vm_fault *vmf)
 	struct mm_struct *mm;
 	int r = 0;
 
-	vma = vmf->vma;
-	mm = vma->vm_mm;
+	svm_bo = vmf->page->zone_device_data;
+	if (!svm_bo) {
+		pr_debug("failed get device page at addr 0x%lx\n", addr);
+		return VM_FAULT_SIGBUS;
+	}
+	if (!mmget_not_zero(svm_bo->eviction_fence->mm)) {
+		pr_debug("addr 0x%lx of process mm is detroyed\n", addr);
+		return VM_FAULT_SIGBUS;
+	}
+
+	mm = svm_bo->eviction_fence->mm;
+	if (mm != vmf->vma->vm_mm)
+		pr_debug("addr 0x%lx is COW mapping in child process\n", addr);
 
-	p = kfd_lookup_process_by_mm(vma->vm_mm);
+	p = kfd_lookup_process_by_mm(mm);
 	if (!p) {
 		pr_debug("failed find process at fault address 0x%lx\n", addr);
-		return VM_FAULT_SIGBUS;
+		r = VM_FAULT_SIGBUS;
+		goto out_mmput;
 	}
 	if (READ_ONCE(p->svms.faulting_task) == current) {
 		pr_debug("skipping ram migration\n");
-		kfd_unref_process(p);
-		return 0;
+		r = 0;
+		goto out_unref_process;
 	}
-	addr >>= PAGE_SHIFT;
+
 	pr_debug("CPU page fault svms 0x%p address 0x%lx\n", &p->svms, addr);
+	addr >>= PAGE_SHIFT;
 
 	mutex_lock(&p->svms.lock);
 
 	prange = svm_range_from_addr(&p->svms, addr, &parent);
 	if (!prange) {
-		pr_debug("cannot find svm range at 0x%lx\n", addr);
+		pr_debug("failed get range svms 0x%p addr 0x%lx\n", &p->svms, addr);
 		r = -EFAULT;
-		goto out;
+		goto out_unlock_svms;
 	}
 
 	mutex_lock(&parent->migrate_mutex);
@@ -940,8 +953,8 @@ static vm_fault_t svm_migrate_to_ram(struct vm_fault *vmf)
 
 	r = svm_migrate_vram_to_ram(prange, mm, KFD_MIGRATE_TRIGGER_PAGEFAULT_CPU);
 	if (r)
-		pr_debug("failed %d migrate 0x%p [0x%lx 0x%lx] to ram\n", r,
-			 prange, prange->start, prange->last);
+		pr_debug("failed %d migrate svms 0x%p range 0x%p [0x%lx 0x%lx]\n",
+			 r, prange->svms, prange, prange->start, prange->last);
 
 	/* xnack on, update mapping on GPUs with ACCESS_IN_PLACE */
 	if (p->xnack_enabled && parent == prange)
@@ -955,9 +968,12 @@ static vm_fault_t svm_migrate_to_ram(struct vm_fault *vmf)
 	if (prange != parent)
 		mutex_unlock(&prange->migrate_mutex);
 	mutex_unlock(&parent->migrate_mutex);
-out:
+out_unlock_svms:
 	mutex_unlock(&p->svms.lock);
+out_unref_process:
 	kfd_unref_process(p);
+out_mmput:
+	mmput(mm);
 
 	pr_debug("CPU fault svms 0x%p address 0x%lx done\n", &p->svms, addr);
 
-- 
2.35.1



