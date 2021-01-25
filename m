Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5453304AC2
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730324AbhAZE7c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:59:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:37544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731080AbhAYSuY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:50:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 776C42075B;
        Mon, 25 Jan 2021 18:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600584;
        bh=bStMQc+CCIpGLgNfT14m1MOG0H9KZDmQ8bWKvUCAhRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vIGTdGGRm+WUiJG10iI+00Szc6npd82ggTI6NoTxB1qDpVa7cQeX4u/SDrx/mBxcV
         iFl05j1i2HzqvBm1PIVgCKrtqsYBtH0p10HJCyRVNnTASRqlMJSb3BO9HVKW73tWca
         HZE7E4A/r7WXfXa2QepkNFnk87BlJ3YIrSlOPoMg=
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
Subject: [PATCH 5.10 072/199] libperf tests: Fail when failing to get a tracepoint id
Date:   Mon, 25 Jan 2021 19:38:14 +0100
Message-Id: <20210125183219.306708623@linuxfoundation.org>
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



