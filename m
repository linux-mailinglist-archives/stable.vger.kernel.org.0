Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 009812FC6C3
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 02:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730167AbhATB2q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 20:28:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:47354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730076AbhATB2h (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:28:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF1A4233EA;
        Wed, 20 Jan 2021 01:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611106020;
        bh=bStMQc+CCIpGLgNfT14m1MOG0H9KZDmQ8bWKvUCAhRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IHdwOOK+mMmz2PyaaoVoHaZ3e9DyUqoFGLekh0jfVHycNNJlVf09MtASe2D0s94Oh
         3qF8limtiukM0+kOJzJjFxN7TaP0zEa0acC66WvVsxWBRGnPTorN9TGAlsoJkpx8kg
         6W1OhzQfAJ+HJlhw3UrtIwcn6cA2OC4SKiH9JUzszzQf3v/TZCFmgqwyf+aruedMcT
         EsLsYZY+WQ6tQ0TwHpAimmaOBZAqA0kLtrGaBCdKHRUwEFmxRhoOofTKH3GKvoYBMo
         UhcDb/sPUmbd4b6Vw4C090tHOjbvfii3j7QBVO7k2gNbS1lKub3qYvZHN21+BdjvVo
         x5/xEIK4r6r2A==
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
Subject: [PATCH AUTOSEL 5.10 43/45] libperf tests: Fail when failing to get a tracepoint id
Date:   Tue, 19 Jan 2021 20:26:00 -0500
Message-Id: <20210120012602.769683-43-sashal@kernel.org>
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

[ Upstream commit 66dd86b2a2bee129c70f7ff054d3a6a2e5f8eb20 ]

Permissions are necessary to get a tracepoint id. Fail the test when the
read fails.

Signed-off-by: Ian Rogers <irogers@google.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lore.kernel.org/lkml/20210114180250.3853825-2-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/perf/tests/test-evlist.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/perf/tests/test-evlist.c b/tools/lib/perf/tests/test-evlist.c
index d913241d41356..bd19cabddaf62 100644
--- a/tools/lib/perf/tests/test-evlist.c
+++ b/tools/lib/perf/tests/test-evlist.c
@@ -215,6 +215,7 @@ static int test_mmap_thread(void)
 		 sysfs__mountpoint());
 
 	if (filename__read_int(path, &id)) {
+		tests_failed++;
 		fprintf(stderr, "error: failed to get tracepoint id: %s\n", path);
 		return -1;
 	}
-- 
2.27.0

