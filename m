Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCDF612C686
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731354AbfL2Rry (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:47:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:58750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731344AbfL2Rrv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:47:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E33E0208C4;
        Sun, 29 Dec 2019 17:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641670;
        bh=6qnczI6FHQazh9DmcWWErTsXpBXTUWcCdkBVEqjRnPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SwOXNhza+QKTpeL8liSepb9iJupWjpHtf8Nzsvl5MK/VoXGDSwRpip9RyspJrMIJY
         GGg61GEeq5l35pog6forZyRMXhljyfGn1Q5GqHZJPzITNVqz2T97EceW+8X/S3ABEz
         y4RMHLaNYvm7IS/kDIrlQGO1T9sIRqc6QiHSwUi8=
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
Subject: [PATCH 5.4 145/434] perf test: Report failure for mmap events
Date:   Sun, 29 Dec 2019 18:23:18 +0100
Message-Id: <20191229172711.376706225@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
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
index bce3a4cb4c89..ca0a6ca43b13 100644
--- a/tools/perf/tests/task-exit.c
+++ b/tools/perf/tests/task-exit.c
@@ -110,6 +110,7 @@ int test__task_exit(struct test *test __maybe_unused, int subtest __maybe_unused
 	if (evlist__mmap(evlist, 128) < 0) {
 		pr_debug("failed to mmap events: %d (%s)\n", errno,
 			 str_error_r(errno, sbuf, sizeof(sbuf)));
+		err = -1;
 		goto out_delete_evlist;
 	}
 
-- 
2.20.1



