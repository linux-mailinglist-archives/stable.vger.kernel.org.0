Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5817F6280C9
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237876AbiKNNJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:09:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237896AbiKNNJH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:09:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B1826114
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:09:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5760B80EA6
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:09:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05AADC433C1;
        Mon, 14 Nov 2022 13:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431340;
        bh=jmQjxPvO7G0CUUHeMTbKq9Ujfj05n0/xTSvRz/9seu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o91NdVfZTp8cfYtFhgzBhFPe83O093L2R0JcmL7ztNDixZvXZ9VShy+HngzCTim8/
         f0QJfsVhLosKHyGT+GB76NaGjbBCylBXL0PCMQZVN5CPhgrbWkAEz4hGTrkvoSjJ88
         5FAzZ23rLC19Nh30pQ0Cs+6YQgO3ymOXYz1VjFDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Philip Yang <Philip.Yang@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 189/190] drm/amdkfd: Migrate in CPU page fault use current mm
Date:   Mon, 14 Nov 2022 13:46:53 +0100
Message-Id: <20221114124507.156841811@linuxfoundation.org>
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

commit 3a876060892ba52dd67d197c78b955e62657d906 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -951,7 +951,8 @@ static vm_fault_t svm_migrate_to_ram(str
 		goto out_unlock_prange;
 	}
 
-	r = svm_migrate_vram_to_ram(prange, mm, KFD_MIGRATE_TRIGGER_PAGEFAULT_CPU);
+	r = svm_migrate_vram_to_ram(prange, vmf->vma->vm_mm,
+				    KFD_MIGRATE_TRIGGER_PAGEFAULT_CPU);
 	if (r)
 		pr_debug("failed %d migrate svms 0x%p range 0x%p [0x%lx 0x%lx]\n",
 			 r, prange->svms, prange, prange->start, prange->last);


