Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1B826F334
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgIRDFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 23:05:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:52048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727330AbgIRCEd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:04:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24E0A235F8;
        Fri, 18 Sep 2020 02:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394672;
        bh=BiouPKCrG2nElZXDM6x8aHBIiaJckJhpU6dfa35QRNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=03/H2OTfzhyMN9ykgT9fuhbphW4WWtb48HXyeEzCdzhTc+8jZMPt2tclQJ7CMHjAy
         JtqzlRZJlg3H8sIqqRtmITzJhlaVOMEHIsx/P9YZJmtQJL4rDrLfGaDazoanadsJ9I
         s0JWUVCjwMMTLKq9Uv62qYez8ZxYHdlIpNbMc6cg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Leo Yan <leo.yan@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Mike Leach <mike.leach@linaro.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Walker <robert.walker@arm.com>,
        Suzuki Poulouse <suzuki.poulose@arm.com>,
        coresight ml <coresight@lists.linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 164/330] perf cs-etm: Swap packets for instruction samples
Date:   Thu, 17 Sep 2020 21:58:24 -0400
Message-Id: <20200918020110.2063155-164-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leo Yan <leo.yan@linaro.org>

[ Upstream commit d01751563caf0dec7be36f81de77cc0197b77e59 ]

If use option '--itrace=iNNN' with Arm CoreSight trace data, perf tool
fails inject instruction samples; the root cause is the packets are only
swapped for branch samples and last branches but not for instruction
samples, so the new coming packets cannot be properly handled for only
synthesizing instruction samples.

To fix this issue, this patch refactors the code with a new function
cs_etm__packet_swap() which is used to swap packets and adds the
condition for instruction samples.

Signed-off-by: Leo Yan <leo.yan@linaro.org>
Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Mike Leach <mike.leach@linaro.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Walker <robert.walker@arm.com>
Cc: Suzuki Poulouse <suzuki.poulose@arm.com>
Cc: coresight ml <coresight@lists.linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Link: http://lore.kernel.org/lkml/20200219021811.20067-2-leo.yan@linaro.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/cs-etm.c | 39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/tools/perf/util/cs-etm.c b/tools/perf/util/cs-etm.c
index f5f855fff412e..38298cbb07524 100644
--- a/tools/perf/util/cs-etm.c
+++ b/tools/perf/util/cs-etm.c
@@ -363,6 +363,23 @@ struct cs_etm_packet_queue
 	return NULL;
 }
 
+static void cs_etm__packet_swap(struct cs_etm_auxtrace *etm,
+				struct cs_etm_traceid_queue *tidq)
+{
+	struct cs_etm_packet *tmp;
+
+	if (etm->sample_branches || etm->synth_opts.last_branch ||
+	    etm->sample_instructions) {
+		/*
+		 * Swap PACKET with PREV_PACKET: PACKET becomes PREV_PACKET for
+		 * the next incoming packet.
+		 */
+		tmp = tidq->packet;
+		tidq->packet = tidq->prev_packet;
+		tidq->prev_packet = tmp;
+	}
+}
+
 static void cs_etm__packet_dump(const char *pkt_string)
 {
 	const char *color = PERF_COLOR_BLUE;
@@ -1340,7 +1357,6 @@ static int cs_etm__sample(struct cs_etm_queue *etmq,
 			  struct cs_etm_traceid_queue *tidq)
 {
 	struct cs_etm_auxtrace *etm = etmq->etm;
-	struct cs_etm_packet *tmp;
 	int ret;
 	u8 trace_chan_id = tidq->trace_chan_id;
 	u64 instrs_executed = tidq->packet->instr_count;
@@ -1404,15 +1420,7 @@ static int cs_etm__sample(struct cs_etm_queue *etmq,
 		}
 	}
 
-	if (etm->sample_branches || etm->synth_opts.last_branch) {
-		/*
-		 * Swap PACKET with PREV_PACKET: PACKET becomes PREV_PACKET for
-		 * the next incoming packet.
-		 */
-		tmp = tidq->packet;
-		tidq->packet = tidq->prev_packet;
-		tidq->prev_packet = tmp;
-	}
+	cs_etm__packet_swap(etm, tidq);
 
 	return 0;
 }
@@ -1441,7 +1449,6 @@ static int cs_etm__flush(struct cs_etm_queue *etmq,
 {
 	int err = 0;
 	struct cs_etm_auxtrace *etm = etmq->etm;
-	struct cs_etm_packet *tmp;
 
 	/* Handle start tracing packet */
 	if (tidq->prev_packet->sample_type == CS_ETM_EMPTY)
@@ -1476,15 +1483,7 @@ static int cs_etm__flush(struct cs_etm_queue *etmq,
 	}
 
 swap_packet:
-	if (etm->sample_branches || etm->synth_opts.last_branch) {
-		/*
-		 * Swap PACKET with PREV_PACKET: PACKET becomes PREV_PACKET for
-		 * the next incoming packet.
-		 */
-		tmp = tidq->packet;
-		tidq->packet = tidq->prev_packet;
-		tidq->prev_packet = tmp;
-	}
+	cs_etm__packet_swap(etm, tidq);
 
 	return err;
 }
-- 
2.25.1

