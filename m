Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBF1F2FC7F9
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 03:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732064AbhATC3y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 21:29:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:47270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730092AbhATB2i (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:28:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0041923341;
        Wed, 20 Jan 2021 01:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611106018;
        bh=e7w7eZhbT5BPMTB0jHTG4KuBkCW1+q0za1EKpTYM1Wo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b40lTZu9JI6V3b0rilL+ihQBu0CEQk/TH1tQgDtPNnaUJ//HapnfWxWK1hr7gvygy
         1TQgJr/Ec7+lDF5sKh5uQ1lJsJK+EuoOk26pNz/dfyadwNSf454V4Y+xe8m3lkLqPl
         k8U+alV516vdk8ln5udGtlSNOkozjYU+Lbbt6o8zNhP+IwfWsUyNDz8Jb4gk8e3apk
         WbKZNJTQBkKmQzz9nmwVl0rMlg0Tf9edzfZ1MZ8BVouAzUDpI0lnje8xLAfLV9dbGe
         VQvKPPENA6NJTKB1kLWKB8s4qAfzMddpNkd7Jlfb2uB6FQw8GT2Dr+uIowXuJAWT59
         yXpw5QMnsW25g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 42/45] libperf tests: If a test fails return non-zero
Date:   Tue, 19 Jan 2021 20:25:59 -0500
Message-Id: <20210120012602.769683-42-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012602.769683-1-sashal@kernel.org>
References: <20210120012602.769683-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

