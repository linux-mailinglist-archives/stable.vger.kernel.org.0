Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD2120631A
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389482AbgFWUQ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:16:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:60800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388879AbgFWUQz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:16:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D9522064B;
        Tue, 23 Jun 2020 20:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943414;
        bh=GUTD5yk7Qpbx+rnv/WXVP0Uer1021qxyNmVETtm6AxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zTpa4VO2WkqS4l7b1jwe79buLks+/+M0/XPji44tnzOOhXTOPjT7R7ioKsFlWAdiR
         JN8qVbm/iQmtxKszrUYLokTrg4+kRy0VLmWSHBtFMgxP6ZDGJTuD6Yu/IojD75YZqM
         0NW+KR0CNUpmsFCWkyYDvCkqg5sOxHfam7qLVtRY=
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
Subject: [PATCH 5.7 383/477] perf report: Fix NULL pointer dereference in hists__fprintf_nr_sample_events()
Date:   Tue, 23 Jun 2020 21:56:20 +0200
Message-Id: <20200623195425.631083056@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
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
index 26d8fc27e427e..fc7855262162d 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -476,8 +476,7 @@ static size_t hists__fprintf_nr_sample_events(struct hists *hists, struct report
 	if (rep->time_str)
 		ret += fprintf(fp, " (time slices: %s)", rep->time_str);
 
-	if (symbol_conf.show_ref_callgraph &&
-	    strstr(evname, "call-graph=no")) {
+	if (symbol_conf.show_ref_callgraph && evname && strstr(evname, "call-graph=no")) {
 		ret += fprintf(fp, ", show reference callgraph");
 	}
 
-- 
2.25.1



