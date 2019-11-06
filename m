Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFE3F1D46
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 19:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbfKFSPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 13:15:03 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:45013 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbfKFSPD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Nov 2019 13:15:03 -0500
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1iSPp1-00015o-7Q; Wed, 06 Nov 2019 19:14:23 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 3ACD41C0131;
        Wed,  6 Nov 2019 19:14:20 +0100 (CET)
Date:   Wed, 06 Nov 2019 18:14:19 -0000
From:   "tip-bot2 for Jiri Olsa" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/urgent] perf tools: Fix time sorting
Cc:     Jiri Olsa <jolsa@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Michael Petlan <mpetlan@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org,
        #@tip-bot2.tec.linutronix.de, v3.16+@tip-bot2.tec.linutronix.de,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20191104232711.16055-1-jolsa@kernel.org>
References: <20191104232711.16055-1-jolsa@kernel.org>
MIME-Version: 1.0
Message-ID: <157306405988.29376.15381480880213738913.tip-bot2@tip-bot2>
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

Commit-ID:     722ddfde366fd46205456a9c5ff9b3359dc9a75e
Gitweb:        https://git.kernel.org/tip/722ddfde366fd46205456a9c5ff9b3359dc9a75e
Author:        Jiri Olsa <jolsa@kernel.org>
AuthorDate:    Tue, 05 Nov 2019 00:27:11 +01:00
Committer:     Arnaldo Carvalho de Melo <acme@redhat.com>
CommitterDate: Tue, 05 Nov 2019 08:49:14 -03:00

perf tools: Fix time sorting

The final sort might get confused when the comparison is done over
bigger numbers than int like for -s time.

Check the following report for longer workloads:

  $ perf report -s time -F time,overhead --stdio

Fix hist_entry__sort() to properly return int64_t and not possible cut
int.

Fixes: 043ca389a318 ("perf tools: Use hpp formats to sort final output")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Michael Petlan <mpetlan@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org # v3.16+
Link: http://lore.kernel.org/lkml/20191104232711.16055-1-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 679a1d7..7b6eaf5 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -1625,7 +1625,7 @@ int hists__collapse_resort(struct hists *hists, struct ui_progress *prog)
 	return 0;
 }
 
-static int hist_entry__sort(struct hist_entry *a, struct hist_entry *b)
+static int64_t hist_entry__sort(struct hist_entry *a, struct hist_entry *b)
 {
 	struct hists *hists = a->hists;
 	struct perf_hpp_fmt *fmt;
