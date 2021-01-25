Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EEFA304AC1
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730301AbhAZE7Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:59:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:37502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731075AbhAYSuX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:50:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07FF222D58;
        Mon, 25 Jan 2021 18:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600581;
        bh=e7w7eZhbT5BPMTB0jHTG4KuBkCW1+q0za1EKpTYM1Wo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1qWXx2RFrmRCcu4VGVEzcfCGWv1cRe+ggzFfN0t4cm9nuRVyNLc3ptA6TBcdDjq6H
         NwBlxJZoN3qsQ6ZxDfWV9wTI218lFvkbRe5WpPEeo4G0bNLY9UkdHvGVUBqwRzn+lf
         CCCsdH215wAHaI2KN3yitLIzxJxvzKqS7kQio9g4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Rogers <irogers@google.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 071/199] libperf tests: If a test fails return non-zero
Date:   Mon, 25 Jan 2021 19:38:13 +0100
Message-Id: <20210125183219.268292817@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Rogers <irogers@google.com>

[ Upstream commit bba2ea17ef553aea0df80cb64399fe2f70f225dd ]

If a test fails return -1 rather than 0. This is consistent with the
return value in test-cpumap.c

Signed-off-by: Ian Rogers <irogers@google.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lore.kernel.org/lkml/20210114180250.3853825-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/perf/tests/test-cpumap.c    | 2 +-
 tools/lib/perf/tests/test-evlist.c    | 2 +-
 tools/lib/perf/tests/test-evsel.c     | 2 +-
 tools/lib/perf/tests/test-threadmap.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/lib/perf/tests/test-cpumap.c b/tools/lib/perf/tests/test-cpumap.c
index c8d45091e7c26..c70e9e03af3e9 100644
--- a/tools/lib/perf/tests/test-cpumap.c
+++ b/tools/lib/perf/tests/test-cpumap.c
@@ -27,5 +27,5 @@ int main(int argc, char **argv)
 	perf_cpu_map__put(cpus);
 
 	__T_END;
-	return 0;
+	return tests_failed == 0 ? 0 : -1;
 }
diff --git a/tools/lib/perf/tests/test-evlist.c b/tools/lib/perf/tests/test-evlist.c
index 6d8ebe0c25042..d913241d41356 100644
--- a/tools/lib/perf/tests/test-evlist.c
+++ b/tools/lib/perf/tests/test-evlist.c
@@ -409,5 +409,5 @@ int main(int argc, char **argv)
 	test_mmap_cpus();
 
 	__T_END;
-	return 0;
+	return tests_failed == 0 ? 0 : -1;
 }
diff --git a/tools/lib/perf/tests/test-evsel.c b/tools/lib/perf/tests/test-evsel.c
index 135722ac965bf..0ad82d7a2a51b 100644
--- a/tools/lib/perf/tests/test-evsel.c
+++ b/tools/lib/perf/tests/test-evsel.c
@@ -131,5 +131,5 @@ int main(int argc, char **argv)
 	test_stat_thread_enable();
 
 	__T_END;
-	return 0;
+	return tests_failed == 0 ? 0 : -1;
 }
diff --git a/tools/lib/perf/tests/test-threadmap.c b/tools/lib/perf/tests/test-threadmap.c
index 7dc4d6fbeddee..384471441b484 100644
--- a/tools/lib/perf/tests/test-threadmap.c
+++ b/tools/lib/perf/tests/test-threadmap.c
@@ -27,5 +27,5 @@ int main(int argc, char **argv)
 	perf_thread_map__put(threads);
 
 	__T_END;
-	return 0;
+	return tests_failed == 0 ? 0 : -1;
 }
-- 
2.27.0



