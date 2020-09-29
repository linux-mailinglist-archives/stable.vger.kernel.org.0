Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8954F27C89F
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731176AbgI2MD2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:03:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:60296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729821AbgI2Lie (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:38:34 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DCEF21D41;
        Tue, 29 Sep 2020 11:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379494;
        bh=nuwv9HNk0vrLOhegVxtxqW2sufYsdyF+G6bC4SxSkfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K3xgsY14Uy5IITsmNiULj5YVisJjONF+u0tSWrGUUDmuZL/tnt48APIKLHcyNvwNx
         2E3kyjYYn1Sx9MiETnx121N07O+kw3w4fV3Zm3wT6us0cJ6ywlPZSCglzUCsZwO0HH
         FLkUylo3gWOCKLOd89+2kjZrInj3A2qdlr4qOgHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Leach <mike.leach@linaro.org>,
        Leo Yan <leo.yan@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
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
Subject: [PATCH 5.4 159/388] perf cs-etm: Correct synthesizing instruction samples
Date:   Tue, 29 Sep 2020 12:58:10 +0200
Message-Id: <20200929110018.173746864@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leo Yan <leo.yan@linaro.org>

[ Upstream commit c9f5baa136777b2c982f6f7a90c9da69a88be148 ]

When 'etm->instructions_sample_period' is less than
'tidq->period_instructions', the function cs_etm__sample() cannot handle
this case properly with its logic.

Let's see below flow as an example:

- If we set itrace option '--itrace=i4', then function cs_etm__sample()
  has variables with initialized values:

  tidq->period_instructions = 0
  etm->instructions_sample_period = 4

- When the first packet is coming:

  packet->instr_count = 10; the number of instructions executed in this
  packet is 10, thus update period_instructions as below:

  tidq->period_instructions = 0 + 10 = 10
  instrs_over = 10 - 4 = 6
  offset = 10 - 6 - 1 = 3
  tidq->period_instructions = instrs_over = 6

- When the second packet is coming:

  packet->instr_count = 10; in the second pass, assume 10 instructions
  in the trace sample again:

  tidq->period_instructions = 6 + 10 = 16
  instrs_over = 16 - 4 = 12
  offset = 10 - 12 - 1 = -3  -> the negative value
  tidq->period_instructions = instrs_over = 12

So after handle these two packets, there have below issues:

The first issue is that cs_etm__instr_addr() returns the address within
the current trace sample of the instruction related to offset, so the
offset is supposed to be always unsigned value.  But in fact, function
cs_etm__sample() might calculate a negative offset value (in handling
the second packet, the offset is -3) and pass to cs_etm__instr_addr()
with u64 type with a big positive integer.

The second issue is it only synthesizes 2 samples for sample period = 4.
In theory, every packet has 10 instructions so the two packets have
total 20 instructions, 20 instructions should generate 5 samples
(4 x 5 = 20).  This is because cs_etm__sample() only calls once
cs_etm__synth_instruction_sample() to generate instruction sample per
range packet.

This patch fixes the logic in function cs_etm__sample(); the basic
idea for handling coming packet is:

- To synthesize the first instruction sample, it combines the left
  instructions from the previous packet and the head of the new
  packet; then generate continuous samples with sample period;
- At the tail of the new packet, if it has the rest instructions,
  these instructions will be left for the sequential sample.

Suggested-by: Mike Leach <mike.leach@linaro.org>
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
Link: http://lore.kernel.org/lkml/20200219021811.20067-4-leo.yan@linaro.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/cs-etm.c | 87 ++++++++++++++++++++++++++++++++--------
 1 file changed, 70 insertions(+), 17 deletions(-)

diff --git a/tools/perf/util/cs-etm.c b/tools/perf/util/cs-etm.c
index 38298cbb07524..451eee24165ee 100644
--- a/tools/perf/util/cs-etm.c
+++ b/tools/perf/util/cs-etm.c
@@ -1359,9 +1359,12 @@ static int cs_etm__sample(struct cs_etm_queue *etmq,
 	struct cs_etm_auxtrace *etm = etmq->etm;
 	int ret;
 	u8 trace_chan_id = tidq->trace_chan_id;
-	u64 instrs_executed = tidq->packet->instr_count;
+	u64 instrs_prev;
 
-	tidq->period_instructions += instrs_executed;
+	/* Get instructions remainder from previous packet */
+	instrs_prev = tidq->period_instructions;
+
+	tidq->period_instructions += tidq->packet->instr_count;
 
 	/*
 	 * Record a branch when the last instruction in
@@ -1379,26 +1382,76 @@ static int cs_etm__sample(struct cs_etm_queue *etmq,
 		 * TODO: allow period to be defined in cycles and clock time
 		 */
 
-		/* Get number of instructions executed after the sample point */
-		u64 instrs_over = tidq->period_instructions -
-			etm->instructions_sample_period;
+		/*
+		 * Below diagram demonstrates the instruction samples
+		 * generation flows:
+		 *
+		 *    Instrs     Instrs       Instrs       Instrs
+		 *   Sample(n)  Sample(n+1)  Sample(n+2)  Sample(n+3)
+		 *    |            |            |            |
+		 *    V            V            V            V
+		 *   --------------------------------------------------
+		 *            ^                                  ^
+		 *            |                                  |
+		 *         Period                             Period
+		 *    instructions(Pi)                   instructions(Pi')
+		 *
+		 *            |                                  |
+		 *            \---------------- -----------------/
+		 *                             V
+		 *                 tidq->packet->instr_count
+		 *
+		 * Instrs Sample(n...) are the synthesised samples occurring
+		 * every etm->instructions_sample_period instructions - as
+		 * defined on the perf command line.  Sample(n) is being the
+		 * last sample before the current etm packet, n+1 to n+3
+		 * samples are generated from the current etm packet.
+		 *
+		 * tidq->packet->instr_count represents the number of
+		 * instructions in the current etm packet.
+		 *
+		 * Period instructions (Pi) contains the the number of
+		 * instructions executed after the sample point(n) from the
+		 * previous etm packet.  This will always be less than
+		 * etm->instructions_sample_period.
+		 *
+		 * When generate new samples, it combines with two parts
+		 * instructions, one is the tail of the old packet and another
+		 * is the head of the new coming packet, to generate
+		 * sample(n+1); sample(n+2) and sample(n+3) consume the
+		 * instructions with sample period.  After sample(n+3), the rest
+		 * instructions will be used by later packet and it is assigned
+		 * to tidq->period_instructions for next round calculation.
+		 */
 
 		/*
-		 * Calculate the address of the sampled instruction (-1 as
-		 * sample is reported as though instruction has just been
-		 * executed, but PC has not advanced to next instruction)
+		 * Get the initial offset into the current packet instructions;
+		 * entry conditions ensure that instrs_prev is less than
+		 * etm->instructions_sample_period.
 		 */
-		u64 offset = (instrs_executed - instrs_over - 1);
-		u64 addr = cs_etm__instr_addr(etmq, trace_chan_id,
-					      tidq->packet, offset);
+		u64 offset = etm->instructions_sample_period - instrs_prev;
+		u64 addr;
 
-		ret = cs_etm__synth_instruction_sample(
-			etmq, tidq, addr, etm->instructions_sample_period);
-		if (ret)
-			return ret;
+		while (tidq->period_instructions >=
+				etm->instructions_sample_period) {
+			/*
+			 * Calculate the address of the sampled instruction (-1
+			 * as sample is reported as though instruction has just
+			 * been executed, but PC has not advanced to next
+			 * instruction)
+			 */
+			addr = cs_etm__instr_addr(etmq, trace_chan_id,
+						  tidq->packet, offset - 1);
+			ret = cs_etm__synth_instruction_sample(
+				etmq, tidq, addr,
+				etm->instructions_sample_period);
+			if (ret)
+				return ret;
 
-		/* Carry remaining instructions into next sample period */
-		tidq->period_instructions = instrs_over;
+			offset += etm->instructions_sample_period;
+			tidq->period_instructions -=
+				etm->instructions_sample_period;
+		}
 	}
 
 	if (etm->sample_branches) {
-- 
2.25.1



