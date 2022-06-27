Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8AF155D25A
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237789AbiF0LtE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238400AbiF0LsY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:48:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C61E8BA3;
        Mon, 27 Jun 2022 04:41:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80FE0B81126;
        Mon, 27 Jun 2022 11:41:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41E2C3411D;
        Mon, 27 Jun 2022 11:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330066;
        bh=ISJvGI472kGimxCXpbo+gRj92Mt7djO20oMihAyYXU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WXCkav960fr7k0kiPL3GBXU3GBH4hdYXK2aQorQau9D7yakld4bdlxmXd75NACeHe
         hXo1m8UjpCciGSBr7xuk9pEJ23mZaJ4Ng0rpM9/XDr94KPSMvWN40RhdXAqpXovSnU
         /pRLacakyUTM3YNdicpjL9MtrTF0e/3qFc3B5nv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ali Saidi <alisaidi@amazon.com>,
        German Gomez <german.gomez@arm.com>,
        Leo Yan <leo.yan@linaro.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andrew Kilroy <andrew.kilroy@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        James Clark <james.clark@arm.com>,
        Jiri Olsa <jolsa@kernel.org>,
        John Garry <john.garry@huawei.com>,
        Kajol Jain <kjain@linux.ibm.com>,
        Li Huafei <lihuafei1@huawei.com>,
        linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Nick Forrington <nick.forrington@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 072/181] perf arm-spe: Dont set data source if its not a memory operation
Date:   Mon, 27 Jun 2022 13:20:45 +0200
Message-Id: <20220627111946.651930333@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leo Yan <leo.yan@linaro.org>

[ Upstream commit 51ba539f5bdb5a8cc7b1dedd5e73ac54564a7602 ]

Except for memory load and store operations, ARM SPE records also can
support other operation types, bug when set the data source field the
current code assumes a record is a either load operation or store
operation, this leads to wrongly synthesize memory samples.

This patch strictly checks the record operation type, it only sets data
source only for the operation types ARM_SPE_LD and ARM_SPE_ST,
otherwise, returns zero for data source.  Therefore, we can synthesize
memory samples only when data source is a non-zero value, the function
arm_spe__is_memory_event() is useless and removed.

Fixes: e55ed3423c1bb29f ("perf arm-spe: Synthesize memory event")
Reviewed-by: Ali Saidi <alisaidi@amazon.com>
Reviewed-by: German Gomez <german.gomez@arm.com>
Signed-off-by: Leo Yan <leo.yan@linaro.org>
Tested-by: Ali Saidi <alisaidi@amazon.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: alisaidi@amazon.com
Cc: Andrew Kilroy <andrew.kilroy@arm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: James Clark <james.clark@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Garry <john.garry@huawei.com>
Cc: Kajol Jain <kjain@linux.ibm.com>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Li Huafei <lihuafei1@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Nick Forrington <nick.forrington@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Link: http://lore.kernel.org/lkml/20220517020326.18580-5-alisaidi@amazon.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/arm-spe.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/tools/perf/util/arm-spe.c b/tools/perf/util/arm-spe.c
index 1a80151baed9..d040406f3314 100644
--- a/tools/perf/util/arm-spe.c
+++ b/tools/perf/util/arm-spe.c
@@ -387,26 +387,16 @@ static int arm_spe__synth_instruction_sample(struct arm_spe_queue *speq,
 	return arm_spe_deliver_synth_event(spe, speq, event, &sample);
 }
 
-#define SPE_MEM_TYPE	(ARM_SPE_L1D_ACCESS | ARM_SPE_L1D_MISS | \
-			 ARM_SPE_LLC_ACCESS | ARM_SPE_LLC_MISS | \
-			 ARM_SPE_REMOTE_ACCESS)
-
-static bool arm_spe__is_memory_event(enum arm_spe_sample_type type)
-{
-	if (type & SPE_MEM_TYPE)
-		return true;
-
-	return false;
-}
-
 static u64 arm_spe__synth_data_source(const struct arm_spe_record *record)
 {
 	union perf_mem_data_src	data_src = { 0 };
 
 	if (record->op == ARM_SPE_LD)
 		data_src.mem_op = PERF_MEM_OP_LOAD;
-	else
+	else if (record->op == ARM_SPE_ST)
 		data_src.mem_op = PERF_MEM_OP_STORE;
+	else
+		return 0;
 
 	if (record->type & (ARM_SPE_LLC_ACCESS | ARM_SPE_LLC_MISS)) {
 		data_src.mem_lvl = PERF_MEM_LVL_L3;
@@ -510,7 +500,11 @@ static int arm_spe_sample(struct arm_spe_queue *speq)
 			return err;
 	}
 
-	if (spe->sample_memory && arm_spe__is_memory_event(record->type)) {
+	/*
+	 * When data_src is zero it means the record is not a memory operation,
+	 * skip to synthesize memory sample for this case.
+	 */
+	if (spe->sample_memory && data_src) {
 		err = arm_spe__synth_mem_sample(speq, spe->memory_id, data_src);
 		if (err)
 			return err;
-- 
2.35.1



