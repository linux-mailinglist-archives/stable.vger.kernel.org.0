Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F154A6042C9
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 13:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbiJSLJ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 07:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233181AbiJSLIy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 07:08:54 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C97D14EC77;
        Wed, 19 Oct 2022 03:37:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 59455CE21B0;
        Wed, 19 Oct 2022 09:11:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EE53C433D7;
        Wed, 19 Oct 2022 09:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170698;
        bh=Syyww4aE/A9q2YbgecUDjN7WhpYEeXohYESQpJiSY+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gDGk9bT+1mK4aCae/7WPEbGv2qy33SKbiMCdGlJGuNSxv9MEURoYEjRskOKs8OWn6
         0e7ZCidLaqKTK92/Wf/NxjsVUJwdrdsQ0zJs8k1RtVuvfatAnqoizBjkSmiCGyi8or
         6qsGSrJzVuX/RQ+h6nQKb8HzpurXNqkcAo+Q1Ljk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philip Yang <Philip.Yang@amd.com>,
        Felix Kuehling <felix.kuehling@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 754/862] drm/amdgpu: SDMA update use unlocked iterator
Date:   Wed, 19 Oct 2022 10:34:01 +0200
Message-Id: <20221019083323.217463591@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



