Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 244A268DAA
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732965AbfGOOAd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:00:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:42212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387522AbfGOOAc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:00:32 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A806C2083D;
        Mon, 15 Jul 2019 14:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199231;
        bh=uXABNZOUoQaDXqF6BBmVMpHKEtCDQTObD2J1O1cN7Yc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YvbZ4P7n/W8NvgyU0txzvWULJCfE72UylyUp/t93WOi/lF+lyZONUSn9lSMtqb86E
         Ctl5qQT8HOJQMnc82lYGhTBRzWalyPp4SyqTnY+dHejfkKJxaMXMhTdZLWdsOxIpvS
         RKpqh1HkLGx8h+S28nnWTgi45skpNIPYi9lDb7vc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 218/249] perf stat: Don't merge events in the same PMU
Date:   Mon, 15 Jul 2019 09:46:23 -0400
Message-Id: <20190715134655.4076-218-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

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
index 4c53bae5644b..94bed4031def 100644
--- a/tools/perf/util/stat-display.c
+++ b/tools/perf/util/stat-display.c
@@ -542,7 +542,8 @@ static void collect_all_aliases(struct perf_stat_config *config, struct perf_evs
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

