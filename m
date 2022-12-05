Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5A8E643299
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234142AbiLET1T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:27:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234131AbiLET04 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:26:56 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55F2926571
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:24:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BF503CE13A5
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:23:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93CAAC433C1;
        Mon,  5 Dec 2022 19:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268238;
        bh=Ax7d55eGUBMhs5E2HtucnB2UTP0yrhboPeOMOga82GQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hWiJEV65E39VzXln9m2BzvR16/jj9RIJH8e8wUVxfYaxoed7cAfFVXHHkM7dE9ggb
         r/il3zZEhflJv1ihAiIC4++sJYXuTJCbCsmtbEB3II1as2mrswUnpgmSwPtlzLIhmQ
         0UoLLkK4kscKI8NdEz3PcBuTBuM7nivI4TzC6H4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 003/124] drm/amdgpu: cleanup error handling in amdgpu_cs_parser_bos
Date:   Mon,  5 Dec 2022 20:08:29 +0100
Message-Id: <20221205190808.532548278@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
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

From: Christian König <christian.koenig@amd.com>

[ Upstream commit 4953b6b22ab9d7f64706631a027b1ed1130ce4c8 ]

Return early on success and so remove all those "if (r)" in the error
path.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 4458da0bb09d ("drm/amdgpu: fix userptr HMM range handling v2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 37 +++++++++++++-------------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index aa3ce01cd538..fee99a40804e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -608,35 +608,34 @@ static int amdgpu_cs_parser_bos(struct amdgpu_cs_parser *p,
 	if (r)
 		goto error_validate;
 
-	amdgpu_cs_report_moved_bytes(p->adev, p->bytes_moved,
-				     p->bytes_moved_vis);
-
-	amdgpu_job_set_resources(p->job, p->bo_list->gds_obj,
-				 p->bo_list->gws_obj, p->bo_list->oa_obj);
-
-	if (!r && p->uf_entry.tv.bo) {
+	if (p->uf_entry.tv.bo) {
 		struct amdgpu_bo *uf = ttm_to_amdgpu_bo(p->uf_entry.tv.bo);
 
 		r = amdgpu_ttm_alloc_gart(&uf->tbo);
+		if (r)
+			goto error_validate;
+
 		p->job->uf_addr += amdgpu_bo_gpu_offset(uf);
 	}
 
+	amdgpu_cs_report_moved_bytes(p->adev, p->bytes_moved,
+				     p->bytes_moved_vis);
+	amdgpu_job_set_resources(p->job, p->bo_list->gds_obj,
+				 p->bo_list->gws_obj, p->bo_list->oa_obj);
+	return 0;
+
 error_validate:
-	if (r)
-		ttm_eu_backoff_reservation(&p->ticket, &p->validated);
+	ttm_eu_backoff_reservation(&p->ticket, &p->validated);
 
 out_free_user_pages:
-	if (r) {
-		amdgpu_bo_list_for_each_userptr_entry(e, p->bo_list) {
-			struct amdgpu_bo *bo = ttm_to_amdgpu_bo(e->tv.bo);
+	amdgpu_bo_list_for_each_userptr_entry(e, p->bo_list) {
+		struct amdgpu_bo *bo = ttm_to_amdgpu_bo(e->tv.bo);
 
-			if (!e->user_pages)
-				continue;
-			amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm);
-			kvfree(e->user_pages);
-			e->user_pages = NULL;
-		}
-		mutex_unlock(&p->bo_list->bo_list_mutex);
+		if (!e->user_pages)
+			continue;
+		amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm);
+		kvfree(e->user_pages);
+		e->user_pages = NULL;
 	}
 	return r;
 }
-- 
2.35.1



