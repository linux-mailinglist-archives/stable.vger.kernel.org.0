Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77ECD20606F
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392448AbgFWUmv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:42:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:39476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390256AbgFWUmu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:42:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EF3B20767;
        Tue, 23 Jun 2020 20:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944969;
        bh=kORmj3Jqmaq1UgJjqWnJ6xS+gE+avf9nMSLRJyuvJwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kd/i6UmmFlEZ7nsZGBoIwiSlG5x2rra/WpWwyMA2p4X3xBsfoHhED+BIDfdQXpk6y
         IpKyILA3IGbwPItnXm5BQJgFXuLCQ2/dU9Y9osBhjjprqIUza5GCgX7NCk/7bZ54Pa
         vXzNKt12XuaYrvC9ohztkUR6VRufiZ4J8XqeWjRg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Kan Liang <kan.liang@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Gaurav Singh <gaurav1086@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 165/206] perf report: Fix NULL pointer dereference in hists__fprintf_nr_sample_events()
Date:   Tue, 23 Jun 2020 21:58:13 +0200
Message-Id: <20200623195325.114676312@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195316.864547658@linuxfoundation.org>
References: <20200623195316.864547658@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gaurav Singh <gaurav1086@gmail.com>

[ Upstream commit 11b6e5482e178055ec1f2444b55f2518713809d1 ]

The 'evname' variable can be NULL, as it is checked a few lines back,
check it before using.

Fixes: 9e207ddfa207 ("perf report: Show call graph from reference events")
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/
Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-report.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 5312c761a5dba..05eae94d09cb8 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -447,8 +447,7 @@ static size_t hists__fprintf_nr_sample_events(struct hists *hists, struct report
 	if (rep->time_str)
 		ret += fprintf(fp, " (time slices: %s)", rep->time_str);
 
-	if (symbol_conf.show_ref_callgraph &&
-	    strstr(evname, "call-graph=no")) {
+	if (symbol_conf.show_ref_callgraph && evname && strstr(evname, "call-graph=no")) {
 		ret += fprintf(fp, ", show reference callgraph");
 	}
 
-- 
2.25.1



