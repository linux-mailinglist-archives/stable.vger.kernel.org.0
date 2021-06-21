Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBCDB3AF02D
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232062AbhFUQrI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:47:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233646AbhFUQpH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:45:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0481761040;
        Mon, 21 Jun 2021 16:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293143;
        bh=TUDia6ZNuQqMxoADShp9wR3w1y43Dohd6yJsjfneYzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=htNY5KShJHGquRIYmc0kGPMlIOYfxGzaU45FJyBATiQO60tgicqPidk/IY9oTZvWM
         ZeXJ3efq0+kbi4QqMXYaKBYCqf7P3cTlsEvyfnimLXTfqapvfuqzV4Zrav2x5aSnGI
         cI3JgPc1cMPIDFZbc7DZpUmo+PqXG+B6FKOYLW68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Ian Rogers <irogers@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Kajol Jain <kjain@linux.ibm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 114/178] perf metricgroup: Return error code from metricgroup__add_metric_sys_event_iter()
Date:   Mon, 21 Jun 2021 18:15:28 +0200
Message-Id: <20210621154926.650552769@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Garry <john.garry@huawei.com>

[ Upstream commit fe7a98b9d9b36e5c8a22d76b67d29721f153f66e ]

The error code is not set at all in the sys event iter function.

This may lead to an uninitialized value of "ret" in
metricgroup__add_metric() when no CPU metric is added.

Fix by properly setting the error code.

It is not necessary to init "ret" to 0 in metricgroup__add_metric(), as
if we have no CPU or sys event metric matching, then "has_match" should
be 0 and "ret" is set to -EINVAL.

However gcc cannot detect that it may not have been set after the
map_for_each_metric() loop for CPU metrics, which is strange.

Fixes: be335ec28efa8 ("perf metricgroup: Support adding metrics for system PMUs")
Signed-off-by: John Garry <john.garry@huawei.com>
Acked-by: Ian Rogers <irogers@google.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Kajol Jain <kjain@linux.ibm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/1623335580-187317-3-git-send-email-john.garry@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/metricgroup.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/metricgroup.c b/tools/perf/util/metricgroup.c
index 1af71ac1cc68..939aed36e0c2 100644
--- a/tools/perf/util/metricgroup.c
+++ b/tools/perf/util/metricgroup.c
@@ -1072,16 +1072,18 @@ static int metricgroup__add_metric_sys_event_iter(struct pmu_event *pe,
 
 	ret = add_metric(d->metric_list, pe, d->metric_no_group, &m, NULL, d->ids);
 	if (ret)
-		return ret;
+		goto out;
 
 	ret = resolve_metric(d->metric_no_group,
 				     d->metric_list, NULL, d->ids);
 	if (ret)
-		return ret;
+		goto out;
 
 	*(d->has_match) = true;
 
-	return *d->ret;
+out:
+	*(d->ret) = ret;
+	return ret;
 }
 
 static int metricgroup__add_metric(const char *metric, bool metric_no_group,
-- 
2.30.2



