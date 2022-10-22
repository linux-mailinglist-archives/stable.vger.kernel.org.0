Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA355608A97
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 11:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbiJVJCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 05:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbiJVJCf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 05:02:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD6B2DB954;
        Sat, 22 Oct 2022 01:17:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D5C7B82E37;
        Sat, 22 Oct 2022 08:05:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC2F9C433C1;
        Sat, 22 Oct 2022 08:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425922;
        bh=Syyww4aE/A9q2YbgecUDjN7WhpYEeXohYESQpJiSY+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VQD4egYxjrwz4wIDEG+zjcgDgf8bsJBrGQVGu4h8lXQf/uTkYPqoDZqDZX/ur21Yc
         qACnaHHXgzbRlYOfhPga4l3zXfRQ05Dgid+Vr+0SbSy7wo8zJRCy8C9GM8923g+/VK
         KOnTCjgAbSI4pmSYsXLnFMwRtAfhqAS4mhCACSo4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philip Yang <Philip.Yang@amd.com>,
        Felix Kuehling <felix.kuehling@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 619/717] drm/amdgpu: SDMA update use unlocked iterator
Date:   Sat, 22 Oct 2022 09:28:18 +0200
Message-Id: <20221022072525.839645654@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit 3913f0179ba366f7d7d160c506ce00de1602bbc4 ]

SDMA update page table may be called from unlocked context, this
generate below warning. Use unlocked iterator to handle this case.

WARNING: CPU: 0 PID: 1475 at
drivers/dma-buf/dma-resv.c:483 dma_resv_iter_next
Call Trace:
 dma_resv_iter_first+0x43/0xa0
 amdgpu_vm_sdma_update+0x69/0x2d0 [amdgpu]
 amdgpu_vm_ptes_update+0x29c/0x870 [amdgpu]
 amdgpu_vm_update_range+0x2f6/0x6c0 [amdgpu]
 svm_range_unmap_from_gpus+0x115/0x300 [amdgpu]
 svm_range_cpu_invalidate_pagetables+0x510/0x5e0 [amdgpu]
 __mmu_notifier_invalidate_range_start+0x1d3/0x230
 unmap_vmas+0x140/0x150
 unmap_region+0xa8/0x110

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Suggested-by: Felix Kuehling <felix.kuehling@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c
index 1fd3cbca20a2..718db7d98e5a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c
@@ -211,12 +211,15 @@ static int amdgpu_vm_sdma_update(struct amdgpu_vm_update_params *p,
 	int r;
 
 	/* Wait for PD/PT moves to be completed */
-	dma_resv_for_each_fence(&cursor, bo->tbo.base.resv,
-				DMA_RESV_USAGE_KERNEL, fence) {
+	dma_resv_iter_begin(&cursor, bo->tbo.base.resv, DMA_RESV_USAGE_KERNEL);
+	dma_resv_for_each_fence_unlocked(&cursor, fence) {
 		r = amdgpu_sync_fence(&p->job->sync, fence);
-		if (r)
+		if (r) {
+			dma_resv_iter_end(&cursor);
 			return r;
+		}
 	}
+	dma_resv_iter_end(&cursor);
 
 	do {
 		ndw = p->num_dw_left;
-- 
2.35.1



