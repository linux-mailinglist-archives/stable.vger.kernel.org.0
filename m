Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D189D12C48B
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728716AbfL2Ram (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:30:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:57022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728740AbfL2Ral (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:30:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC7DC208E4;
        Sun, 29 Dec 2019 17:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640640;
        bh=F+RVtGEVmdod50DfTH1VyNi8CRxmTqjjFgd97kF6+zU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TzX9LG70BOjc+bcLzvQFQ+LU0OfSxHA/ahCXqiytZeYDR/H5o1iRjLmlzhxwHaLOf
         TD0RsPylpXwXuoqkxom5jQoxRgiu7fEctyHPlOks1tD+aVxl3YtrwC+2MAJTVSQMsz
         ga66bgOpuLKxkYXApWqR6rXV3peLt/ZeNsd1aGLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leo Yan <leo.yan@linaro.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 077/219] perf test: Report failure for mmap events
Date:   Sun, 29 Dec 2019 18:17:59 +0100
Message-Id: <20191229162517.555116819@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index e92fa6029ac7..788b0805d2f1 100644
--- a/tools/perf/tests/task-exit.c
+++ b/tools/perf/tests/task-exit.c
@@ -105,6 +105,7 @@ int test__task_exit(struct test *test __maybe_unused, int subtest __maybe_unused
 	if (perf_evlist__mmap(evlist, 128) < 0) {
 		pr_debug("failed to mmap events: %d (%s)\n", errno,
 			 str_error_r(errno, sbuf, sizeof(sbuf)));
+		err = -1;
 		goto out_delete_evlist;
 	}
 
-- 
2.20.1



