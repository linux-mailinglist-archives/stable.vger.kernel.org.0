Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAD78272F0F
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbgIUQqU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:46:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727431AbgIUQqQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:46:16 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53BA22223E;
        Mon, 21 Sep 2020 16:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706775;
        bh=WtErtWdQaKWcND03XTQEdTD2XtMNZkJt/CUV5bC/tRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pmTSuhR5WQ8mIET6yxuqzZC8QxS3PlyhA1jeOcHJ24BIPAy5IlBMR3LUJ8P4qrsCf
         uQQuJm4M46xbp/ErBE4UZwtP4xM8kaHxp5QbBJLhKWE5EXYtjumeA7J6FleHS+FGKP
         CqymGrsGTtynocFqqI2giQeib7bgKX0O3stiHWr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Ian Rogers <irogers@google.com>,
        John Garry <john.garry@huawei.com>,
        Kajol Jain <kjain@linux.ibm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 060/118] perf metric: Fix some memory leaks
Date:   Mon, 21 Sep 2020 18:27:52 +0200
Message-Id: <20200921162039.141888218@linuxfoundation.org>
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

[ Upstream commit 4f57a1ed749a81ec553d89233cab53db9365e193 ]

I found some memory leaks while reading the metric code.  Some are real
and others only occur in the error path.  When it failed during metric
or event parsing, it should release all resources properly.

Fixes: b18f3e365019d ("perf stat: Support JSON metrics in perf stat")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: John Garry <john.garry@huawei.com>
Cc: Kajol Jain <kjain@linux.ibm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lore.kernel.org/lkml/20200915031819.386559-2-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/metricgroup.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/metricgroup.c b/tools/perf/util/metricgroup.c
index 9e21aa767e417..344a75718afc3 100644
--- a/tools/perf/util/metricgroup.c
+++ b/tools/perf/util/metricgroup.c
@@ -443,6 +443,9 @@ void metricgroup__print(bool metrics, bool metricgroups, char *filter,
 						continue;
 					strlist__add(me->metrics, s);
 				}
+
+				if (!raw)
+					free(s);
 			}
 			free(omg);
 		}
@@ -726,7 +729,7 @@ int metricgroup__parse_groups(const struct option *opt,
 	ret = metricgroup__add_metric_list(str, metric_no_group,
 					   &extra_events, &group_list);
 	if (ret)
-		return ret;
+		goto out;
 	pr_debug("adding %s\n", extra_events.buf);
 	bzero(&parse_error, sizeof(parse_error));
 	ret = parse_events(perf_evlist, extra_events.buf, &parse_error);
@@ -734,11 +737,11 @@ int metricgroup__parse_groups(const struct option *opt,
 		parse_events_print_error(&parse_error, extra_events.buf);
 		goto out;
 	}
-	strbuf_release(&extra_events);
 	ret = metricgroup__setup_events(&group_list, metric_no_merge,
 					perf_evlist, metric_events);
 out:
 	metricgroup__free_egroups(&group_list);
+	strbuf_release(&extra_events);
 	return ret;
 }
 
-- 
2.25.1



