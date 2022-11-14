Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E241627C60
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 12:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236029AbiKNLc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 06:32:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236367AbiKNLcQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 06:32:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B021CFFF
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 03:32:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 637B361044
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 11:32:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B96C433C1;
        Mon, 14 Nov 2022 11:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668425534;
        bh=h93fxcEDX46VWYcsIErEIR3bE9MTNlz2PKa092PX5l4=;
        h=Subject:To:Cc:From:Date:From;
        b=2on1IEaDJI5PqC+iwqfAduQfI/3xpCPhtqwmxo7bufQOuZJ+IBJPxM+fcxm5oUUQe
         uwD4tfsp1gxeIsnAPiayO0T2V4Q7rvX4KiaglCeh/eoJoqtJJBCiyAuZw2k33VF1y8
         bxXETcMDG9nOZeubNBy1dTA766hhXRKkOD7CGemM=
Subject: FAILED: patch "[PATCH] drm/amdkfd: Migrate in CPU page fault use current mm" failed to apply to 5.15-stable tree
To:     Philip.Yang@amd.com, Felix.Kuehling@amd.com,
        alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Nov 2022 12:32:11 +0100
Message-ID: <1668425531237144@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

3a876060892b ("drm/amdkfd: Migrate in CPU page fault use current mm")
acac270d0982 ("drm/amdkfd: Add migration SMI event")
e0f1e65b836c ("drm/amdkfd: Add GPU recoverable fault SMI event")
9527b9caf82b ("drm/amdkfd: evict svm bo worker handle error")
7ad153db5859 ("drm/amdkfd: handle VMA remove race")
740a451b0797 ("drm/amdkfd: Handle incomplete migration to system memory")
33c6bd989d5e ("drm/amdkfd: debug message to count successfully migrated pages")
75fa98d6e458 ("drm/amdkfd: clarify the origin of cpages returned by migration functions")
ca432dcc27a1 ("drm/amdkfd: handle svm partial migration cpages 0")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3a876060892ba52dd67d197c78b955e62657d906 Mon Sep 17 00:00:00 2001
From: Philip Yang <Philip.Yang@amd.com>
Date: Thu, 8 Sep 2022 17:56:09 -0400
Subject: [PATCH] drm/amdkfd: Migrate in CPU page fault use current mm

migrate_vma_setup shows below warning because we don't hold another
process mm mmap_lock. We should use current vmf->vma->vm_mm instead, the
caller already hold current mmap lock inside CPU page fault handler.

 WARNING: CPU: 10 PID: 3054 at include/linux/mmap_lock.h:155 find_vma
 Call Trace:
  walk_page_range+0x76/0x150
  migrate_vma_setup+0x18a/0x640
  svm_migrate_vram_to_ram+0x245/0xa10 [amdgpu]
  svm_migrate_to_ram+0x36f/0x470 [amdgpu]
  do_swap_page+0xcfe/0xec0
  __handle_mm_fault+0x96b/0x15e0
  handle_mm_fault+0x13f/0x3e0
  do_user_addr_fault+0x1e7/0x690

Fixes: e1f84eef313f ("drm/amdkfd: handle CPU fault on COW mapping")
Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
index 929dec1da0e4..7522bf2d2f57 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -949,7 +949,8 @@ static vm_fault_t svm_migrate_to_ram(struct vm_fault *vmf)
 		goto out_unlock_prange;
 	}
 
-	r = svm_migrate_vram_to_ram(prange, mm, KFD_MIGRATE_TRIGGER_PAGEFAULT_CPU);
+	r = svm_migrate_vram_to_ram(prange, vmf->vma->vm_mm,
+				    KFD_MIGRATE_TRIGGER_PAGEFAULT_CPU);
 	if (r)
 		pr_debug("failed %d migrate svms 0x%p range 0x%p [0x%lx 0x%lx]\n",
 			 r, prange->svms, prange, prange->start, prange->last);

