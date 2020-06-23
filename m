Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 928C02061C1
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391832AbgFWUuE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:50:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:48476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404143AbgFWUtH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:49:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FF3C2098B;
        Tue, 23 Jun 2020 20:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592945346;
        bh=gMpAb/ZZpi5zacxHMyAQXaX3k0m9CwTdxfUeRQnHUrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sWgHAFWISuDhfFV5QB1uVNkVp5ijZO/Xrk0yw617Mtck80d1Y2/Ar/U5QYy2nb2W2
         9lK41IZTEtYl2L7n4qXTXYwUskzZI3WL7v0nEIVK8tE1DfYruxyw80ZsSihmI/wgQQ
         G2QSstOb+ZyEu46S6wyNOUSIb9teyVsw0I02B2TA=
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
Subject: [PATCH 4.14 106/136] perf report: Fix NULL pointer dereference in hists__fprintf_nr_sample_events()
Date:   Tue, 23 Jun 2020 21:59:22 +0200
Message-Id: <20200623195309.009008965@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195303.601828702@linuxfoundation.org>
References: <20200623195303.601828702@linuxfoundation.org>
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
index 429c3e140dc32..35a10b5985447 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -401,8 +401,7 @@ static size_t hists__fprintf_nr_sample_events(struct hists *hists, struct report
 	if (evname != NULL)
 		ret += fprintf(fp, " of event '%s'", evname);
 
-	if (symbol_conf.show_ref_callgraph &&
-	    strstr(evname, "call-graph=no")) {
+	if (symbol_conf.show_ref_callgraph && evname && strstr(evname, "call-graph=no")) {
 		ret += fprintf(fp, ", show reference callgraph");
 	}
 
-- 
2.25.1



