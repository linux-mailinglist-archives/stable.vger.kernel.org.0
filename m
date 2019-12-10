Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82062119BCF
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 23:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbfLJWLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 17:11:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:34422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728264AbfLJWD4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 17:03:56 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5BF2214D8;
        Tue, 10 Dec 2019 22:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576015435;
        bh=8wh+p64T8rURgFickUOAnFGXBpIYAInJHAGKYcjtebI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zCqUaXp51m/sbwqaA1mh0kNdQch+Ax//VmPI4fLKVzuWPlOYXRgOrEc5dKUxsM/tQ
         fRBoORCy3sXrr4jpwuxLo+dBbL+bJruMSK50az0eXAqkng7uhMOvM1JuJH10OcZ+Gy
         fnA4FQG8eot2wyjiTg6ND0iQKB3qZ9mydgpdmYzQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Leo Yan <leo.yan@linaro.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 045/130] perf test: Report failure for mmap events
Date:   Tue, 10 Dec 2019 17:01:36 -0500
Message-Id: <20191210220301.13262-45-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210220301.13262-1-sashal@kernel.org>
References: <20191210220301.13262-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leo Yan <leo.yan@linaro.org>

[ Upstream commit 6add129c5d9210ada25217abc130df0b7096ee02 ]

When fail to mmap events in task exit case, it misses to set 'err' to
-1; thus the testing will not report failure for it.

This patch sets 'err' to -1 when fails to mmap events, thus Perf tool
can report correct result.

Fixes: d723a55096b8 ("perf test: Add test case for checking number of EXIT events")
Signed-off-by: Leo Yan <leo.yan@linaro.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lore.kernel.org/lkml/20191011091942.29841-1-leo.yan@linaro.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/task-exit.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/tests/task-exit.c b/tools/perf/tests/task-exit.c
index 89c8e1604ca73..94fe5464bc6f3 100644
--- a/tools/perf/tests/task-exit.c
+++ b/tools/perf/tests/task-exit.c
@@ -104,6 +104,7 @@ int test__task_exit(struct test *test __maybe_unused, int subtest __maybe_unused
 	if (perf_evlist__mmap(evlist, 128, true) < 0) {
 		pr_debug("failed to mmap events: %d (%s)\n", errno,
 			 str_error_r(errno, sbuf, sizeof(sbuf)));
+		err = -1;
 		goto out_delete_evlist;
 	}
 
-- 
2.20.1

