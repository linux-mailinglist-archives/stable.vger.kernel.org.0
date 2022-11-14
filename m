Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E72A4627EF9
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237484AbiKNMyI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:54:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237490AbiKNMyH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:54:07 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF70D201B9
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:54:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 44EF3CE1009
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:54:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9D1C433C1;
        Mon, 14 Nov 2022 12:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430442;
        bh=hVSLI9utGzg9XNunX4tR3kC53T4/BrSa33Jpo/7dQ7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rGBB+W51dPSrClK4Pw6qVGyV4dGJ4o7t1uDOZrNY3HF6MJyDKULtdyFkYxC6MQavS
         RfAr1dAJ5BHmIfzI3W9EbHm+IIILuCA2P0xCvdn/NFZYTRuPHSHWFdueYX22ImrAwN
         6lrOSEpvjBkCuA0bshNiEAHINtpSVrPao5XCEMio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alex Sierra <alex.sierra@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 004/131] drm/amdkfd: avoid recursive lock in migrations back to RAM
Date:   Mon, 14 Nov 2022 13:44:33 +0100
Message-Id: <20221114124448.931468421@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
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

From: Alex Sierra <alex.sierra@amd.com>

[ Upstream commit a6283010e2907a5576f96b839e1a1c82659f137c ]

[Why]:
When we call hmm_range_fault to map memory after a migration, we don't
expect memory to be migrated again as a result of hmm_range_fault. The
driver ensures that all memory is in GPU-accessible locations so that
no migration should be needed. However, there is one corner case where
hmm_range_fault can unexpectedly cause a migration from DEVICE_PRIVATE
back to system memory due to a write-fault when a system memory page in
the same range was mapped read-only (e.g. COW). Ranges with individual
pages in different locations are usually the result of failed page
migrations (e.g. page lock contention). The unexpected migration back
to system memory causes a deadlock from recursive locking in our
driver.

[How]:
Creating a task reference new member under svm_range_list struct.
Setting this with "current" reference, right before the hmm_range_fault
is called. This member is checked against "current" reference at
svm_migrate_to_ram callback function. If equal, the migration will be
ignored.

Signed-off-by: Alex Sierra <alex.sierra@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 5b994354af3c ("drm/amdkfd: Fix NULL pointer dereference in svm_migrate_to_ram()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c | 5 +++++
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h    | 1 +
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c     | 2 ++
 3 files changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
index 4a16e3c257b9..a458c19b371a 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -796,6 +796,11 @@ static vm_fault_t svm_migrate_to_ram(struct vm_fault *vmf)
 		pr_debug("failed find process at fault address 0x%lx\n", addr);
 		return VM_FAULT_SIGBUS;
 	}
+	if (READ_ONCE(p->svms.faulting_task) == current) {
+		pr_debug("skipping ram migration\n");
+		kfd_unref_process(p);
+		return 0;
+	}
 	addr >>= PAGE_SHIFT;
 	pr_debug("CPU page fault svms 0x%p address 0x%lx\n", &p->svms, addr);
 
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
index 6d8f9bb2d905..47ec820cae72 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@ -755,6 +755,7 @@ struct svm_range_list {
 	atomic_t			evicted_ranges;
 	struct delayed_work		restore_work;
 	DECLARE_BITMAP(bitmap_supported, MAX_GPU_INSTANCE);
+	struct task_struct 		*faulting_task;
 };
 
 /* Process data */
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index 74e6f613be02..22a70aaccf13 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -1489,9 +1489,11 @@ static int svm_range_validate_and_map(struct mm_struct *mm,
 
 		next = min(vma->vm_end, end);
 		npages = (next - addr) >> PAGE_SHIFT;
+		WRITE_ONCE(p->svms.faulting_task, current);
 		r = amdgpu_hmm_range_get_pages(&prange->notifier, mm, NULL,
 					       addr, npages, &hmm_range,
 					       readonly, true, owner);
+		WRITE_ONCE(p->svms.faulting_task, NULL);
 		if (r) {
 			pr_debug("failed %d to get svm range pages\n", r);
 			goto unreserve_out;
-- 
2.35.1



