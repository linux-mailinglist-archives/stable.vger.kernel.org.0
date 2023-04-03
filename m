Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 833A76D49FD
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233857AbjDCOnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233849AbjDCOnJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:43:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E2DD17AF2
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:42:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0629C60FBE
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:42:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E648C4339B;
        Mon,  3 Apr 2023 14:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532954;
        bh=dzmlU27bKsUNMFVwZr2fEjPlAseFp8Oh7zyPVBCzuiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ey/a5MJLbO4U1lUIF8UIGk6zYjV2A+N55AcQrqXoYuCHmNF68+0V+0apocj6eH7Sg
         kF8ZkaTkcenRNNCPkX/pMWrqgY5570UFdK4M2qMysnPjgd+RLxZXGOO7jf3qxjMdZv
         EBFTsjRsZEWmaPdw9fDeCFu+KGfCMdmG5d285uzU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiaogang Chen <Xiaogang.Chen@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 179/181] drm/amdkfd: Get prange->offset after svm_range_vram_node_new
Date:   Mon,  3 Apr 2023 16:10:14 +0200
Message-Id: <20230403140420.955580059@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaogang Chen <xiaogang.chen@amd.com>

commit 8eeddc0d4200762063e1c66b9cc63afa7b24ebf0 upstream.

During miration to vram prange->offset is valid after vram buffer is located,
either use old one or allocate a new one. Move svm_range_vram_node_new before
migrate for each vma to get valid prange->offset.

v2: squash in warning fix

Fixes: b4ee9606378b ("drm/amdkfd: Fix BO offset for multi-VMA page migration")
Signed-off-by: Xiaogang Chen <Xiaogang.Chen@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -311,12 +311,6 @@ svm_migrate_copy_to_vram(struct amdgpu_d
 	src = scratch;
 	dst = (uint64_t *)(scratch + npages);
 
-	r = svm_range_vram_node_new(adev, prange, true);
-	if (r) {
-		dev_dbg(adev->dev, "fail %d to alloc vram\n", r);
-		goto out;
-	}
-
 	amdgpu_res_first(prange->ttm_res, ttm_res_offset,
 			 npages << PAGE_SHIFT, &cursor);
 	for (i = j = 0; i < npages; i++) {
@@ -397,7 +391,7 @@ out_free_vram_pages:
 		migrate->dst[i + 3] = 0;
 	}
 #endif
-out:
+
 	return r;
 }
 
@@ -526,6 +520,12 @@ svm_migrate_ram_to_vram(struct svm_range
 
 	start = prange->start << PAGE_SHIFT;
 	end = (prange->last + 1) << PAGE_SHIFT;
+
+	r = svm_range_vram_node_new(adev, prange, true);
+	if (r) {
+		dev_dbg(adev->dev, "fail %ld to alloc vram\n", r);
+		return r;
+	}
 	ttm_res_offset = prange->offset << PAGE_SHIFT;
 
 	for (addr = start; addr < end;) {
@@ -549,6 +549,8 @@ svm_migrate_ram_to_vram(struct svm_range
 
 	if (cpages)
 		prange->actual_loc = best_loc;
+	else
+		svm_range_vram_node_free(prange);
 
 	return r < 0 ? r : 0;
 }


