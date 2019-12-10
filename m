Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14C87119735
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbfLJVbe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:31:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:57982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728164AbfLJVJ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:09:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68050246B1;
        Tue, 10 Dec 2019 21:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012167;
        bh=E1tJuxh6B/FdhYCbWIjwtof1EY/rbm/Cp4AzRV0SBi8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BC04pFOuUto13FtqjCEYl0KuHsdUDSQLxB3ySIRBqdEIj3lWuUYcYdsrzIXZHVMcY
         43oPXPYiR3UaK6sFFGlAIkIgyJnvL6Eu1PVIppaWf12gf64CnDmVScAtt8SXZ+MhkH
         COtcWOlZRCXNVUk4iyVKVe7347Y1EqxcDrH8+eVI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kevin Wang <kevin1.wang@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 127/350] drm/amdgpu: fix amdgpu trace event print string format error
Date:   Tue, 10 Dec 2019 16:03:52 -0500
Message-Id: <20191210210735.9077-88-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Wang <kevin1.wang@amd.com>

[ Upstream commit 2c2fdb8bca290c439e383cfb6857b0c65e528964 ]

the trace event print string format error.
(use integer type to handle string)

before:
amdgpu_test_kev-1556  [002]   138.508781: amdgpu_cs_ioctl:
sched_job=8, timeline=gfx_0.0.0, context=177, seqno=1,
ring_name=ffff94d01c207bf0, num_ibs=2

after:
amdgpu_test_kev-1506  [004]   370.703783: amdgpu_cs_ioctl:
sched_job=12, timeline=gfx_0.0.0, context=234, seqno=2,
ring_name=gfx_0.0.0, num_ibs=1

change trace event list:
1.amdgpu_cs_ioctl
2.amdgpu_sched_run_job
3.amdgpu_ib_pipe_sync

Signed-off-by: Kevin Wang <kevin1.wang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_trace.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_trace.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_trace.h
index 77674a7b96163..91899d28fa722 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_trace.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_trace.h
@@ -170,7 +170,7 @@ TRACE_EVENT(amdgpu_cs_ioctl,
 			     __field(unsigned int, context)
 			     __field(unsigned int, seqno)
 			     __field(struct dma_fence *, fence)
-			     __field(char *, ring_name)
+			     __string(ring, to_amdgpu_ring(job->base.sched)->name)
 			     __field(u32, num_ibs)
 			     ),
 
@@ -179,12 +179,12 @@ TRACE_EVENT(amdgpu_cs_ioctl,
 			   __assign_str(timeline, AMDGPU_JOB_GET_TIMELINE_NAME(job))
 			   __entry->context = job->base.s_fence->finished.context;
 			   __entry->seqno = job->base.s_fence->finished.seqno;
-			   __entry->ring_name = to_amdgpu_ring(job->base.sched)->name;
+			   __assign_str(ring, to_amdgpu_ring(job->base.sched)->name)
 			   __entry->num_ibs = job->num_ibs;
 			   ),
 	    TP_printk("sched_job=%llu, timeline=%s, context=%u, seqno=%u, ring_name=%s, num_ibs=%u",
 		      __entry->sched_job_id, __get_str(timeline), __entry->context,
-		      __entry->seqno, __entry->ring_name, __entry->num_ibs)
+		      __entry->seqno, __get_str(ring), __entry->num_ibs)
 );
 
 TRACE_EVENT(amdgpu_sched_run_job,
@@ -195,7 +195,7 @@ TRACE_EVENT(amdgpu_sched_run_job,
 			     __string(timeline, AMDGPU_JOB_GET_TIMELINE_NAME(job))
 			     __field(unsigned int, context)
 			     __field(unsigned int, seqno)
-			     __field(char *, ring_name)
+			     __string(ring, to_amdgpu_ring(job->base.sched)->name)
 			     __field(u32, num_ibs)
 			     ),
 
@@ -204,12 +204,12 @@ TRACE_EVENT(amdgpu_sched_run_job,
 			   __assign_str(timeline, AMDGPU_JOB_GET_TIMELINE_NAME(job))
 			   __entry->context = job->base.s_fence->finished.context;
 			   __entry->seqno = job->base.s_fence->finished.seqno;
-			   __entry->ring_name = to_amdgpu_ring(job->base.sched)->name;
+			   __assign_str(ring, to_amdgpu_ring(job->base.sched)->name)
 			   __entry->num_ibs = job->num_ibs;
 			   ),
 	    TP_printk("sched_job=%llu, timeline=%s, context=%u, seqno=%u, ring_name=%s, num_ibs=%u",
 		      __entry->sched_job_id, __get_str(timeline), __entry->context,
-		      __entry->seqno, __entry->ring_name, __entry->num_ibs)
+		      __entry->seqno, __get_str(ring), __entry->num_ibs)
 );
 
 
@@ -468,7 +468,7 @@ TRACE_EVENT(amdgpu_ib_pipe_sync,
 	    TP_PROTO(struct amdgpu_job *sched_job, struct dma_fence *fence),
 	    TP_ARGS(sched_job, fence),
 	    TP_STRUCT__entry(
-			     __field(const char *,name)
+			     __string(ring, sched_job->base.sched->name);
 			     __field(uint64_t, id)
 			     __field(struct dma_fence *, fence)
 			     __field(uint64_t, ctx)
@@ -476,14 +476,14 @@ TRACE_EVENT(amdgpu_ib_pipe_sync,
 			     ),
 
 	    TP_fast_assign(
-			   __entry->name = sched_job->base.sched->name;
+			   __assign_str(ring, sched_job->base.sched->name)
 			   __entry->id = sched_job->base.id;
 			   __entry->fence = fence;
 			   __entry->ctx = fence->context;
 			   __entry->seqno = fence->seqno;
 			   ),
 	    TP_printk("job ring=%s, id=%llu, need pipe sync to fence=%p, context=%llu, seq=%u",
-		      __entry->name, __entry->id,
+		      __get_str(ring), __entry->id,
 		      __entry->fence, __entry->ctx,
 		      __entry->seqno)
 );
-- 
2.20.1

