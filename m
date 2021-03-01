Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFFF328922
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238871AbhCARvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:51:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:37402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236726AbhCARoj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:44:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 145D164FD1;
        Mon,  1 Mar 2021 16:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617873;
        bh=2pkBy4foSvl7IE4vsbtW4EyIWnJW/EJXx0nNyz+L1mM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CDzlAp3yQ9+lk75+WZMXI9X//+DCMlbRUWvMKUIS8suXWqP8w59lLxESRKwhkw9m3
         MhHGESr1dxqlLHVTusRDJMDTpN25obzzo0a0uVRluBVuWSFt7w+uXyP/M+gqvh/nS2
         h9H3UU0z5yTKMkQmbTP5ukoFrJtMYxO2lEfui23o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 197/340] perf intel-pt: Fix premature IPC
Date:   Mon,  1 Mar 2021 17:12:21 +0100
Message-Id: <20210301161058.005567835@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 20aa39708a5999b7921b27482a756766272286ac ]

The code assumed a change in cycle count means accurate IPC. That is not
correct, for example when sampling both branches and instructions, or at
a FUP packet (which is not CYC-eligible) address. Fix by using an explicit
flag to indicate when IPC can be sampled.

Fixes: 5b1dc0fd1da06 ("perf intel-pt: Add support for samples to contain IPC ratio")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org
Link: https://lore.kernel.org/r/20210205175350.23817-3-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../util/intel-pt-decoder/intel-pt-decoder.c     | 11 ++++++++++-
 .../util/intel-pt-decoder/intel-pt-decoder.h     |  1 +
 tools/perf/util/intel-pt.c                       | 16 ++++++----------
 3 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
index a3fdea49ad663..7f53b63088b2c 100644
--- a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
@@ -2637,9 +2637,18 @@ const struct intel_pt_state *intel_pt_decode(struct intel_pt_decoder *decoder)
 		}
 		if (intel_pt_sample_time(decoder->pkt_state)) {
 			intel_pt_update_sample_time(decoder);
-			if (decoder->sample_cyc)
+			if (decoder->sample_cyc) {
 				decoder->sample_tot_cyc_cnt = decoder->tot_cyc_cnt;
+				decoder->state.flags |= INTEL_PT_SAMPLE_IPC;
+				decoder->sample_cyc = false;
+			}
 		}
+		/*
+		 * When using only TSC/MTC to compute cycles, IPC can be
+		 * sampled as soon as the cycle count changes.
+		 */
+		if (!decoder->have_cyc)
+			decoder->state.flags |= INTEL_PT_SAMPLE_IPC;
 	}
 
 	decoder->state.timestamp = decoder->sample_timestamp;
diff --git a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.h b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.h
index e289e463d635e..7396da0fa3a7c 100644
--- a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.h
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.h
@@ -17,6 +17,7 @@
 #define INTEL_PT_ABORT_TX	(1 << 1)
 #define INTEL_PT_ASYNC		(1 << 2)
 #define INTEL_PT_FUP_IP		(1 << 3)
+#define INTEL_PT_SAMPLE_IPC	(1 << 4)
 
 enum intel_pt_sample_type {
 	INTEL_PT_BRANCH		= 1 << 0,
diff --git a/tools/perf/util/intel-pt.c b/tools/perf/util/intel-pt.c
index 8aeaeba48a41f..d0e0ce11faf58 100644
--- a/tools/perf/util/intel-pt.c
+++ b/tools/perf/util/intel-pt.c
@@ -1304,7 +1304,8 @@ static int intel_pt_synth_branch_sample(struct intel_pt_queue *ptq)
 		sample.branch_stack = (struct branch_stack *)&dummy_bs;
 	}
 
-	sample.cyc_cnt = ptq->ipc_cyc_cnt - ptq->last_br_cyc_cnt;
+	if (ptq->state->flags & INTEL_PT_SAMPLE_IPC)
+		sample.cyc_cnt = ptq->ipc_cyc_cnt - ptq->last_br_cyc_cnt;
 	if (sample.cyc_cnt) {
 		sample.insn_cnt = ptq->ipc_insn_cnt - ptq->last_br_insn_cnt;
 		ptq->last_br_insn_cnt = ptq->ipc_insn_cnt;
@@ -1366,7 +1367,8 @@ static int intel_pt_synth_instruction_sample(struct intel_pt_queue *ptq)
 	sample.stream_id = ptq->pt->instructions_id;
 	sample.period = ptq->state->tot_insn_cnt - ptq->last_insn_cnt;
 
-	sample.cyc_cnt = ptq->ipc_cyc_cnt - ptq->last_in_cyc_cnt;
+	if (ptq->state->flags & INTEL_PT_SAMPLE_IPC)
+		sample.cyc_cnt = ptq->ipc_cyc_cnt - ptq->last_in_cyc_cnt;
 	if (sample.cyc_cnt) {
 		sample.insn_cnt = ptq->ipc_insn_cnt - ptq->last_in_insn_cnt;
 		ptq->last_in_insn_cnt = ptq->ipc_insn_cnt;
@@ -1901,14 +1903,8 @@ static int intel_pt_sample(struct intel_pt_queue *ptq)
 
 	ptq->have_sample = false;
 
-	if (ptq->state->tot_cyc_cnt > ptq->ipc_cyc_cnt) {
-		/*
-		 * Cycle count and instruction count only go together to create
-		 * a valid IPC ratio when the cycle count changes.
-		 */
-		ptq->ipc_insn_cnt = ptq->state->tot_insn_cnt;
-		ptq->ipc_cyc_cnt = ptq->state->tot_cyc_cnt;
-	}
+	ptq->ipc_insn_cnt = ptq->state->tot_insn_cnt;
+	ptq->ipc_cyc_cnt = ptq->state->tot_cyc_cnt;
 
 	/*
 	 * Do PEBS first to allow for the possibility that the PEBS timestamp
-- 
2.27.0



