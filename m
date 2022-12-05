Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9014F643290
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233929AbiLET1B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:27:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234075AbiLET0n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:26:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA22E264B8
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:23:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7330361313
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:23:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 892F9C433C1;
        Mon,  5 Dec 2022 19:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268207;
        bh=FCrinnjCUlC3PZ1fpNaYdKKk/Ur3JiDQofZaCyVop00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YMX2wk/lVFZ8cPu2At0g2SjBe9W0HFdSVIkOAHiFZiWzw/x8cLpSxVs4Lho73cR0t
         Uh3OPIJ46gjreR4NelGJe048yftxEaJWJm0oMtsxhIBflc8xvHVirpg+UL3pHhh7v/
         iVbjxEQi2GnI2mSx90v72WL0KjAj+b5M51jk8wOo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        Luben Tuikov <luben.tuikov@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 002/124] drm/amdgpu: move setting the job resources
Date:   Mon,  5 Dec 2022 20:08:28 +0100
Message-Id: <20221205190808.497491856@linuxfoundation.org>
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

[ Upstream commit 736ec9fadd7a1fde8480df7e5cfac465c07ff6f3 ]

Move setting the job resources into amdgpu_job.c

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Andrey Grodzovsky <andrey.grodzovsky@amd.com>
Reviewed-by: Luben Tuikov <luben.tuikov@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 4458da0bb09d ("drm/amdgpu: fix userptr HMM range handling v2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c  | 21 ++-------------------
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c | 17 +++++++++++++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.h |  2 ++
 3 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index b7bae833c804..aa3ce01cd538 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -495,9 +495,6 @@ static int amdgpu_cs_parser_bos(struct amdgpu_cs_parser *p,
 	struct amdgpu_vm *vm = &fpriv->vm;
 	struct amdgpu_bo_list_entry *e;
 	struct list_head duplicates;
-	struct amdgpu_bo *gds;
-	struct amdgpu_bo *gws;
-	struct amdgpu_bo *oa;
 	int r;
 
 	INIT_LIST_HEAD(&p->validated);
@@ -614,22 +611,8 @@ static int amdgpu_cs_parser_bos(struct amdgpu_cs_parser *p,
 	amdgpu_cs_report_moved_bytes(p->adev, p->bytes_moved,
 				     p->bytes_moved_vis);
 
-	gds = p->bo_list->gds_obj;
-	gws = p->bo_list->gws_obj;
-	oa = p->bo_list->oa_obj;
-
-	if (gds) {
-		p->job->gds_base = amdgpu_bo_gpu_offset(gds) >> PAGE_SHIFT;
-		p->job->gds_size = amdgpu_bo_size(gds) >> PAGE_SHIFT;
-	}
-	if (gws) {
-		p->job->gws_base = amdgpu_bo_gpu_offset(gws) >> PAGE_SHIFT;
-		p->job->gws_size = amdgpu_bo_size(gws) >> PAGE_SHIFT;
-	}
-	if (oa) {
-		p->job->oa_base = amdgpu_bo_gpu_offset(oa) >> PAGE_SHIFT;
-		p->job->oa_size = amdgpu_bo_size(oa) >> PAGE_SHIFT;
-	}
+	amdgpu_job_set_resources(p->job, p->bo_list->gds_obj,
+				 p->bo_list->gws_obj, p->bo_list->oa_obj);
 
 	if (!r && p->uf_entry.tv.bo) {
 		struct amdgpu_bo *uf = ttm_to_amdgpu_bo(p->uf_entry.tv.bo);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
index c2fd6f3076a6..3b025aace283 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
@@ -129,6 +129,23 @@ int amdgpu_job_alloc_with_ib(struct amdgpu_device *adev, unsigned size,
 	return r;
 }
 
+void amdgpu_job_set_resources(struct amdgpu_job *job, struct amdgpu_bo *gds,
+			      struct amdgpu_bo *gws, struct amdgpu_bo *oa)
+{
+	if (gds) {
+		job->gds_base = amdgpu_bo_gpu_offset(gds) >> PAGE_SHIFT;
+		job->gds_size = amdgpu_bo_size(gds) >> PAGE_SHIFT;
+	}
+	if (gws) {
+		job->gws_base = amdgpu_bo_gpu_offset(gws) >> PAGE_SHIFT;
+		job->gws_size = amdgpu_bo_size(gws) >> PAGE_SHIFT;
+	}
+	if (oa) {
+		job->oa_base = amdgpu_bo_gpu_offset(oa) >> PAGE_SHIFT;
+		job->oa_size = amdgpu_bo_size(oa) >> PAGE_SHIFT;
+	}
+}
+
 void amdgpu_job_free_resources(struct amdgpu_job *job)
 {
 	struct amdgpu_ring *ring = to_amdgpu_ring(job->base.sched);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.h
index babc0af751c2..2a1961bf1194 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.h
@@ -76,6 +76,8 @@ int amdgpu_job_alloc(struct amdgpu_device *adev, unsigned num_ibs,
 		     struct amdgpu_job **job, struct amdgpu_vm *vm);
 int amdgpu_job_alloc_with_ib(struct amdgpu_device *adev, unsigned size,
 		enum amdgpu_ib_pool_type pool, struct amdgpu_job **job);
+void amdgpu_job_set_resources(struct amdgpu_job *job, struct amdgpu_bo *gds,
+			      struct amdgpu_bo *gws, struct amdgpu_bo *oa);
 void amdgpu_job_free_resources(struct amdgpu_job *job);
 void amdgpu_job_free(struct amdgpu_job *job);
 int amdgpu_job_submit(struct amdgpu_job *job, struct drm_sched_entity *entity,
-- 
2.35.1



