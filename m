Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3E9473EE3
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389973AbfGXU2I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:28:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:57950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388328AbfGXTe5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:34:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0131422AED;
        Wed, 24 Jul 2019 19:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996897;
        bh=Vv7PMWwrHlb6sDO2fUuMs105uz3gcvWzktxHE1gGFdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0b5wYl2WGAMfT22fGP48lpu7amr6779eE10aT1n9klPh8DyrkPsncpdw8uoeY2muF
         HR11451yniEYKh6bMBaXC2t/mnD//nsdcFg/E3K//O3t2TbVAoqF/IaLj+m3aI4CM9
         Z0EdhNcFA4IPaTMVgwbTm/AbibVCKp1eQiq9YKTc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 212/413] perf stat: Dont merge events in the same PMU
Date:   Wed, 24 Jul 2019 21:18:23 +0200
Message-Id: <20190724191749.688567692@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
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



