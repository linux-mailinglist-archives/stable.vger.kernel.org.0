Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF1E749A40E
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2371210AbiAYAHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:07:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2364552AbiAXXsc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:48:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 532DDC07E326;
        Mon, 24 Jan 2022 13:43:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A95CB8121C;
        Mon, 24 Jan 2022 21:43:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 296D2C340E4;
        Mon, 24 Jan 2022 21:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060612;
        bh=mfblvG5kbnlq85+nsOP4KlAoMqaul5WTuSLJfi8bZrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gB1VINutbeE6D++QOK0uQDfdN9+j3h0xYDCwvA5cBlWszvPhNbAX3P1JEsQjk3l+t
         l8ThK7MhrD0QILl0z8qV+JeZIBd9e0hXxGhKuoX9to6Nw4pbt/FYWwoyt30NCT8TcJ
         Nb04sQiPz6MN047TtBvvIofvdozt8j3YUnRM5K0M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Rogers <irogers@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>,
        John Garry <john.garry@huawei.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.16 1005/1039] perf metric: Fix metric_leader
Date:   Mon, 24 Jan 2022 19:46:34 +0100
Message-Id: <20220124184159.078107727@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Rogers <irogers@google.com>

commit d3e2bb4359f70c8b1d09a6f8e2f57240aab0da3f upstream.

Multiple events may have a metric_leader to aggregate into.

This happens for uncore events where, for example, uncore_imc is
expanded into uncore_imc_0, uncore_imc_1, etc.

Such events all have the same metric_id and should aggregate into the
first event.

The change introducing metric_ids had a bug where the metric_id was
compared to itself, creating an always true condition.

Correct this by comparing the event in the metric_evlist and the
metric_leader.

Fixes: ec5c5b3d2c21b3f3 ("perf metric: Encode and use metric-id as qualifier")
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: John Garry <john.garry@huawei.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lore.kernel.org/lkml/20220115062852.1959424-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/metricgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/util/metricgroup.c
+++ b/tools/perf/util/metricgroup.c
@@ -314,7 +314,7 @@ static int setup_metric_events(struct ha
 		 */
 		metric_id = evsel__metric_id(ev);
 		evlist__for_each_entry_continue(metric_evlist, ev) {
-			if (!strcmp(evsel__metric_id(metric_events[i]), metric_id))
+			if (!strcmp(evsel__metric_id(ev), metric_id))
 				ev->metric_leader = metric_events[i];
 		}
 	}


