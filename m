Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C35312C7E0
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731319AbfL2Rro (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:47:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:58550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731314AbfL2Rro (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:47:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8ABCA20718;
        Sun, 29 Dec 2019 17:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641663;
        bh=uE0iH8WzY1QGwFgchLx48TMYteqPSRlGCxrJMQlyC7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gSEq/fgYHGhQZZobfO026f9iygFjTVGl6erSUNe2VfVIhAvvyDIpmKZsZDGvTBYLE
         e+if2HLWy+EReTrc/iQUfu389cB+ILE05LNBEK0KUN1Haaty2M3aJbKqhjYW+dA94s
         mhA8Xsnw9TgqtxGPe0lySJOql9LiQ+XEMLEym6tw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Wang <kevin1.wang@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 160/434] drm/amdgpu: fix amdgpu trace event print string format error
Date:   Sun, 29 Dec 2019 18:23:33 +0100
Message-Id: <20191229172712.399273265@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 77674a7b9616..91899d28fa72 100644
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



