Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD0AA2C9C44
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389835AbgLAJQp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:16:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:52950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390288AbgLAJOW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:14:22 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 430F721D7F;
        Tue,  1 Dec 2020 09:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606814022;
        bh=xarByCDFf+TGfIkBygtw5Np1/GtC+I+nThPwDZXnK2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dx9YAA8+Pfy/XIReZ4x/8WP7Ytbenb46eJX6vylbSi8HV2Jg98ti4uqsIltTL0lG6
         zI679KZrZU38pF3sRoCvho83Lv8KJfCMYYDViw13FLYNgDW582LG4ZMoDwdp8a4fwT
         /AgO2FsSXeC5jF4ereXWUhUZyAhXreqHwUJriy04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ian Rogers <irogers@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 138/152] perf record: Synthesize cgroup events only if needed
Date:   Tue,  1 Dec 2020 09:54:13 +0100
Message-Id: <20201201084729.892592993@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit aa50d953c169e876413bf237319e728dd41d9fdd ]

It didn't check the tool->cgroup_events bit which is set when the
--all-cgroups option is given.  Without it, samples will not have cgroup
info so no reason to synthesize.

We can check the PERF_RECORD_CGROUP records after running perf record
*WITHOUT* the --all-cgroups option:

Before:

  $ perf report -D | grep CGROUP
  0 0 0x8430 [0x38]: PERF_RECORD_CGROUP cgroup: 1 /
          CGROUP events:          1
          CGROUP events:          0
          CGROUP events:          0

After:

  $ perf report -D | grep CGROUP
          CGROUP events:          0
          CGROUP events:          0
          CGROUP events:          0

Committer testing:

Before:

  # perf record -a sleep 1
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 2.208 MB perf.data (10003 samples) ]
  # perf report -D | grep "CGROUP events"
            CGROUP events:        146
            CGROUP events:          0
            CGROUP events:          0
  #

After:

  # perf record -a sleep 1
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 2.208 MB perf.data (10448 samples) ]
  # perf report -D | grep "CGROUP events"
            CGROUP events:          0
            CGROUP events:          0
            CGROUP events:          0
  #

With all-cgroups:

  # perf record --all-cgroups -a sleep 1
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 2.374 MB perf.data (11526 samples) ]
  # perf report -D | grep "CGROUP events"
            CGROUP events:        146
            CGROUP events:          0
            CGROUP events:          0
  #

Fixes: 8fb4b67939e16 ("perf record: Add --all-cgroups option")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lore.kernel.org/lkml/20201127054356.405481-1-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/synthetic-events.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/synthetic-events.c b/tools/perf/util/synthetic-events.c
index 89b390623b63d..54ca751a2b3b3 100644
--- a/tools/perf/util/synthetic-events.c
+++ b/tools/perf/util/synthetic-events.c
@@ -563,6 +563,9 @@ int perf_event__synthesize_cgroups(struct perf_tool *tool,
 	char cgrp_root[PATH_MAX];
 	size_t mount_len;  /* length of mount point in the path */
 
+	if (!tool || !tool->cgroup_events)
+		return 0;
+
 	if (cgroupfs_find_mountpoint(cgrp_root, PATH_MAX, "perf_event") < 0) {
 		pr_debug("cannot find cgroup mount point\n");
 		return -1;
-- 
2.27.0



