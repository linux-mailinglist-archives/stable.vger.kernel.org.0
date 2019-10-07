Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7DBCE5BA
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 16:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728829AbfJGOtz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 10:49:55 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:44543 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728804AbfJGOty (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 10:49:54 -0400
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1iHUK8-0005yu-As; Mon, 07 Oct 2019 16:49:20 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 9AC7F1C0DCB;
        Mon,  7 Oct 2019 16:49:15 +0200 (CEST)
Date:   Mon, 07 Oct 2019 14:49:15 -0000
From:   "tip-bot2 for Steve MacLean" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/urgent] perf inject jit: Fix JIT_CODE_MOVE filename
Cc:     stable@vger.kernel.org, #@tip-bot2.tec.linutronix.de,
        v4.6+@tip-bot2.tec.linutronix.de,
        Steve MacLean <Steve.MacLean@Microsoft.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Brian Robbins <brianrob@microsoft.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        "Eric Saint-Etienne" <eric.saint.etienne@oracle.com>,
        John Keeping <john@metanate.com>,
        John Salem <josalem@microsoft.com>,
        Leo Yan <leo.yan@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Stephane Eranian <eranian@google.com>,
        Tom McDonald <thomas.mcdonald@microsoft.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: =?utf-8?q?=3CBN8PR21MB1362FF8F127B31DBF4121528F7800=40BN8PR21MB?=
 =?utf-8?q?1362=2Enamprd21=2Eprod=2Eoutlook=2Ecom=3E?=
References: =?utf-8?q?=3CBN8PR21MB1362FF8F127B31DBF4121528F7800=40BN8PR21M?=
 =?utf-8?q?B1362=2Enamprd21=2Eprod=2Eoutlook=2Ecom=3E?=
MIME-Version: 1.0
Message-ID: <157045975560.9978.11908955377927615460.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/urgent branch of tip:

Commit-ID:     b59711e9b0d22fd47abfa00602fd8c365cdd3ab7
Gitweb:        https://git.kernel.org/tip/b59711e9b0d22fd47abfa00602fd8c365cdd3ab7
Author:        Steve MacLean <Steve.MacLean@microsoft.com>
AuthorDate:    Sat, 28 Sep 2019 01:41:18 
Committer:     Arnaldo Carvalho de Melo <acme@redhat.com>
CommitterDate: Mon, 30 Sep 2019 17:29:49 -03:00

perf inject jit: Fix JIT_CODE_MOVE filename

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
index 1bdf4c6..e3ccb0c 100644
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
