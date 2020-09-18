Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA8A526F1F1
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729858AbgIRCzD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:55:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:57334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727889AbgIRCHN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:07:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99E0A238E6;
        Fri, 18 Sep 2020 02:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394832;
        bh=RuOcHj6Pq7vRFqIp9YPlvoYdwRZ5RcdJnj7QOiZtsFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EuUtszqAycdmRfxftOmObHVi5HYtx2B8nqiJ4FZWi6cdOyPmg82YJqyEtMt2l5N1k
         jQKFChHoCNaI6thLYKaFyizSGbdLDO5Eo02Yo2+8wVheD3wwd88RlnHyl24kYQ6MXL
         C/+tmPeZwWx5JhQGdZGBhCYt4z15O5FZD2b6e4AQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiri Olsa <jolsa@kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Michael Petlan <mpetlan@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 294/330] perf stat: Fix duration_time value for higher intervals
Date:   Thu, 17 Sep 2020 22:00:34 -0400
Message-Id: <20200918020110.2063155-294-sashal@kernel.org>
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

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit ea9eb1f456a08c18feb485894185f7a4e31cc8a4 ]

Joakim reported wrong duration_time value for interval bigger
than 4000 [1].

The problem is in the interval value we pass to update_stats
function, which is typed as 'unsigned int' and overflows when
we get over 2^32 (happens between intervals 4000 and 5000).

Retyping the passed value to unsigned long long.

[1] https://www.spinics.net/lists/linux-perf-users/msg11777.html

Fixes: b90f1333ef08 ("perf stat: Update walltime_nsecs_stats in interval mode")
Reported-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Michael Petlan <mpetlan@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/20200518131445.3745083-1-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-stat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 468fc49420ce1..ac2feddc75fdd 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -351,7 +351,7 @@ static void process_interval(void)
 	}
 
 	init_stats(&walltime_nsecs_stats);
-	update_stats(&walltime_nsecs_stats, stat_config.interval * 1000000);
+	update_stats(&walltime_nsecs_stats, stat_config.interval * 1000000ULL);
 	print_counters(&rs, 0, NULL);
 }
 
-- 
2.25.1

