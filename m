Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05A6273A9E
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404063AbfGXTwG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:52:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:33630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404071AbfGXTwF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:52:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B7AB217D4;
        Wed, 24 Jul 2019 19:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997924;
        bh=4U7enLsMx7aiLoJftz6+zxOwBGkWBnmhB54K2IpPGQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PL0dzoNOHpUPoFRqGK38MvT8CKudfL/Dg15dyN6xTGK0bBRP5MDIWJaw9IMxgVdIN
         O0T0vJoJ+fpLuFXN+9PpmyHTds3M/NNMBKjPJ02STce0g1QgglTfg3UcLlluFHDFWn
         wUgIsCKbZAWCXGyC9bLQE4lcXscxZ7ln/oAt8bAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 190/371] perf stat: Dont merge events in the same PMU
Date:   Wed, 24 Jul 2019 21:19:02 +0200
Message-Id: <20190724191739.260674892@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6c5f4e5cb35b4694dc035d91092d23f596ecd06a ]

Event merging is mainly to collapse similar events in lots of different
duplicated PMUs.

It can break metric displaying. It's possible for two metrics to have
the same event, and when the two events happen in a row the second
wouldn't be displayed.  This would also not show the second metric.

To avoid this don't merge events in the same PMU. This makes sense, if
we have multiple events in the same PMU there is likely some reason for
it (e.g. using multiple groups) and we better not merge them.

While in theory it would be possible to construct metrics that have
events with the same name in different PMU no current metrics have this
problem.

This is the fix for perf stat -M UPI,IPC (needs also another bug fix to
completely work)

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Fixes: 430daf2dc7af ("perf stat: Collapse identically named events")
Link: http://lkml.kernel.org/r/20190624193711.35241-3-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/stat-display.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/stat-display.c b/tools/perf/util/stat-display.c
index 6d043c78f3c2..9c940242dcbe 100644
--- a/tools/perf/util/stat-display.c
+++ b/tools/perf/util/stat-display.c
@@ -539,7 +539,8 @@ static void collect_all_aliases(struct perf_stat_config *config, struct perf_evs
 		    alias->scale != counter->scale ||
 		    alias->cgrp != counter->cgrp ||
 		    strcmp(alias->unit, counter->unit) ||
-		    perf_evsel__is_clock(alias) != perf_evsel__is_clock(counter))
+		    perf_evsel__is_clock(alias) != perf_evsel__is_clock(counter) ||
+		    !strcmp(alias->pmu_name, counter->pmu_name))
 			break;
 		alias->merged_stat = true;
 		cb(config, alias, data, false);
-- 
2.20.1



