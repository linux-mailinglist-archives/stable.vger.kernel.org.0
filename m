Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB04272F0E
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbgIUQqU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:46:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727838AbgIUQqS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:46:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89A1423888;
        Mon, 21 Sep 2020 16:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706778;
        bh=OQezxXUbYJ6jSeu0GCWveY6tXoG4TZbVPRRZEvs0g3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I0ilcwsrgBjqBgljtpCtcDefMV5x3LvNEhL/LfJ5xeruqQ2jmoYSV+LoxCygqQbBq
         R6tJuyClqhB61sMVoR7/QVSm0kTFCc9C/BJqzPfOe6B4mnMcFtF1itKDdnVLxsii5P
         Zt5eesCDdvjyEe99edcP1PB0G7C8YXVF4fjDxXSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Ian Rogers <irogers@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 061/118] perf evlist: Fix cpu/thread map leak
Date:   Mon, 21 Sep 2020 18:27:53 +0200
Message-Id: <20200921162039.192261076@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit bfd1b83d75e44a9f65de30accb3dd3b5940bd3ac ]

Asan reported leak of cpu and thread maps as they have one more refcount
than released.  I found that after setting evlist maps it should release
it's refcount.

It seems to be broken from the beginning so I chose the original commit
as the culprit.  But not sure how it's applied to stable trees since
there are many changes in the code after that.

Fixes: 7e2ed097538c5 ("perf evlist: Store pointer to the cpu and thread maps")
Fixes: 4112eb1899c0e ("perf evlist: Default to syswide target when no thread/cpu maps set")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lore.kernel.org/lkml/20200915031819.386559-4-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/evlist.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index ab48be4cf2584..b279888bb1aab 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -946,6 +946,10 @@ int perf_evlist__create_maps(struct evlist *evlist, struct target *target)
 
 	perf_evlist__set_maps(&evlist->core, cpus, threads);
 
+	/* as evlist now has references, put count here */
+	perf_cpu_map__put(cpus);
+	perf_thread_map__put(threads);
+
 	return 0;
 
 out_delete_threads:
@@ -1273,11 +1277,12 @@ static int perf_evlist__create_syswide_maps(struct evlist *evlist)
 		goto out_put;
 
 	perf_evlist__set_maps(&evlist->core, cpus, threads);
-out:
-	return err;
+
+	perf_thread_map__put(threads);
 out_put:
 	perf_cpu_map__put(cpus);
-	goto out;
+out:
+	return err;
 }
 
 int evlist__open(struct evlist *evlist)
-- 
2.25.1



