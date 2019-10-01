Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 003B2C321D
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 13:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731777AbfJALN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 07:13:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:35376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731480AbfJALNZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 07:13:25 -0400
Received: from quaco.ghostprotocols.net (177.206.223.101.dynamic.adsl.gvt.net.br [177.206.223.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A8C221D82;
        Tue,  1 Oct 2019 11:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569928404;
        bh=6nepsOatIta3l4yHqYsACnbyfD9+FxxyFAEw23qEPu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0UH8llRtKycb73Ekxe4iC/BTw4M19Ru7BOy/gS8IiElgFJJpp19qMe4tJge09JLkS
         JfCvCKeTkuxA3w3A9CI30oHjf04jvFpfjmpAFLPGddMXkH72ioueMbhiJjy7E4OGX0
         ull4QVVMiiJ6W4qatCDCml7mxqe1WvMJD9+3jg+c=
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Clark Williams <williams@redhat.com>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Steve MacLean <Steve.MacLean@microsoft.com>,
        stable@vger.kernel.org,
        Steve MacLean <Steve.MacLean@Microsoft.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Brian Robbins <brianrob@microsoft.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Eric Saint-Etienne <eric.saint.etienne@oracle.com>,
        John Keeping <john@metanate.com>,
        John Salem <josalem@microsoft.com>,
        Leo Yan <leo.yan@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Stephane Eranian <eranian@google.com>,
        Tom McDonald <thomas.mcdonald@microsoft.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 13/24] perf inject jit: Fix JIT_CODE_MOVE filename
Date:   Tue,  1 Oct 2019 08:12:05 -0300
Message-Id: <20191001111216.7208-14-acme@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191001111216.7208-1-acme@kernel.org>
References: <20191001111216.7208-1-acme@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve MacLean <Steve.MacLean@microsoft.com>

During perf inject --jit, JIT_CODE_MOVE records were injecting MMAP records
with an incorrect filename. Specifically it was missing the ".so" suffix.

Further the JIT_CODE_LOAD record were silently truncating the
jr->load.code_index field to 32 bits before generating the filename.

Make both records emit the same filename based on the full 64 bit
code_index field.

Fixes: 9b07e27f88b9 ("perf inject: Add jitdump mmap injection support")
Cc: stable@vger.kernel.org # v4.6+
Signed-off-by: Steve MacLean <Steve.MacLean@Microsoft.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Brian Robbins <brianrob@microsoft.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Eric Saint-Etienne <eric.saint.etienne@oracle.com>
Cc: John Keeping <john@metanate.com>
Cc: John Salem <josalem@microsoft.com>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom McDonald <thomas.mcdonald@microsoft.com>
Link: http://lore.kernel.org/lkml/BN8PR21MB1362FF8F127B31DBF4121528F7800@BN8PR21MB1362.namprd21.prod.outlook.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/jitdump.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/jitdump.c b/tools/perf/util/jitdump.c
index 1bdf4c6ea3e5..e3ccb0ce1938 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -395,7 +395,7 @@ static int jit_repipe_code_load(struct jit_buf_desc *jd, union jr_entry *jr)
 	size_t size;
 	u16 idr_size;
 	const char *sym;
-	uint32_t count;
+	uint64_t count;
 	int ret, csize, usize;
 	pid_t pid, tid;
 	struct {
@@ -418,7 +418,7 @@ static int jit_repipe_code_load(struct jit_buf_desc *jd, union jr_entry *jr)
 		return -1;
 
 	filename = event->mmap2.filename;
-	size = snprintf(filename, PATH_MAX, "%s/jitted-%d-%u.so",
+	size = snprintf(filename, PATH_MAX, "%s/jitted-%d-%" PRIu64 ".so",
 			jd->dir,
 			pid,
 			count);
@@ -529,7 +529,7 @@ static int jit_repipe_code_move(struct jit_buf_desc *jd, union jr_entry *jr)
 		return -1;
 
 	filename = event->mmap2.filename;
-	size = snprintf(filename, PATH_MAX, "%s/jitted-%d-%"PRIu64,
+	size = snprintf(filename, PATH_MAX, "%s/jitted-%d-%" PRIu64 ".so",
 	         jd->dir,
 	         pid,
 		 jr->move.code_index);
-- 
2.21.0

