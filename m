Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2CA3615937
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiKBDGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbiKBDG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:06:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1DD823BE1
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:06:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51389B82072
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:06:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34CE2C433D6;
        Wed,  2 Nov 2022 03:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358386;
        bh=iUVwllhcJdFa9Xp3KiSFWTgOEM9p6nX6NNGsC73aJX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NWGn9Audt0DGvKoz5igVE8GenqtjHqDdHhC72icL/QTaxDfmlzPYiEIiqiVCKBwK3
         CuJHnuOxKQ7VvaWriG5aCESyScqxhnbFN+idbVego2eXK/9WaEGq27iZb64PSB0Ug1
         YH+zGfhYYiJ81topizK4iyZZKZIxq0EIRa329AQM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rafael Mendonca <rafaelmendsr@gmail.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 089/132] drm/amdkfd: Fix memory leak in kfd_mem_dmamap_userptr()
Date:   Wed,  2 Nov 2022 03:33:15 +0100
Message-Id: <20221102022101.964562534@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael Mendonca <rafaelmendsr@gmail.com>

[ Upstream commit 90bfee142af0f0e9d3bec80e7acd5f49b230acf7 ]

If the number of pages from the userptr BO differs from the SG BO then the
allocated memory for the SG table doesn't get freed before returning
-EINVAL, which may lead to a memory leak in some error paths. Fix this by
checking the number of pages before allocating memory for the SG table.

Fixes: 264fb4d332f5 ("drm/amdgpu: Add multi-GPU DMA mapping helpers")
Signed-off-by: Rafael Mendonca <rafaelmendsr@gmail.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index c904269b3e14..477ab3551177 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -476,13 +476,13 @@ kfd_mem_dmamap_userptr(struct kgd_mem *mem,
 	struct ttm_tt *ttm = bo->tbo.ttm;
 	int ret;
 
+	if (WARN_ON(ttm->num_pages != src_ttm->num_pages))
+		return -EINVAL;
+
 	ttm->sg = kmalloc(sizeof(*ttm->sg), GFP_KERNEL);
 	if (unlikely(!ttm->sg))
 		return -ENOMEM;
 
-	if (WARN_ON(ttm->num_pages != src_ttm->num_pages))
-		return -EINVAL;
-
 	/* Same sequence as in amdgpu_ttm_tt_pin_userptr */
 	ret = sg_alloc_table_from_pages(ttm->sg, src_ttm->pages,
 					ttm->num_pages, 0,
-- 
2.35.1



