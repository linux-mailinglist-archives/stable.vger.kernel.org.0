Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4202021FBC2
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730415AbgGNTEM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 15:04:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:54114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730546AbgGNS4P (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:56:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84F6922282;
        Tue, 14 Jul 2020 18:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752975;
        bh=Y3gmnZ14UNbPHkqjjTj7iYbabG72aVSl4P4Rk3VvwZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kqLIqZF4WXWkJNPLnCawZ2pYZC5sH3RTcxFQQPhI9EFwjxkecFvKTUzzideF0krq9
         Ude0BlrbtQGSCU3S8zDkA278AdxV7/lJQZXEpcYNy3wnl1vtVMujmH+IdNTxTfkI3D
         bdzJ+1EzYotn9URt/Z9N60B83jHHvhDuAE8guDes=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Li <liwei391@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 072/166] perf report TUI: Fix segmentation fault in perf_evsel__hists_browse()
Date:   Tue, 14 Jul 2020 20:43:57 +0200
Message-Id: <20200714184119.305256839@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Li <liwei391@huawei.com>

[ Upstream commit d61cbb859b45fdb6b4997f2d51834fae41af0e94 ]

The segmentation fault can be reproduced as following steps:

1) Executing perf report in tui.

2) Typing '/xxxxx' to filter the symbol to get nothing matched.

3) Pressing enter with no entry selected.

Then it will report a segmentation fault.

It is caused by the lack of check of browser->he_selection when
accessing it's member res_samples in perf_evsel__hists_browse().

These processes are meaningful for specified samples, so we can skip
these when nothing is selected.

Fixes: 4968ac8fb7c3 ("perf report: Implement browsing of individual samples")
Signed-off-by: Wei Li <liwei391@huawei.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Jin Yao <yao.jin@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Link: http://lore.kernel.org/lkml/20200612094322.39565-1-liwei391@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 487e54ef56a98..2101b6b770d81 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -2288,6 +2288,11 @@ static struct thread *hist_browser__selected_thread(struct hist_browser *browser
 	return browser->he_selection->thread;
 }
 
+static struct res_sample *hist_browser__selected_res_sample(struct hist_browser *browser)
+{
+	return browser->he_selection ? browser->he_selection->res_samples : NULL;
+}
+
 /* Check whether the browser is for 'top' or 'report' */
 static inline bool is_report_browser(void *timer)
 {
@@ -3357,16 +3362,16 @@ static int perf_evsel__hists_browse(struct evsel *evsel, int nr_events,
 					     &options[nr_options], NULL, NULL, evsel);
 		nr_options += add_res_sample_opt(browser, &actions[nr_options],
 						 &options[nr_options],
-				 hist_browser__selected_entry(browser)->res_samples,
-				 evsel, A_NORMAL);
+						 hist_browser__selected_res_sample(browser),
+						 evsel, A_NORMAL);
 		nr_options += add_res_sample_opt(browser, &actions[nr_options],
 						 &options[nr_options],
-				 hist_browser__selected_entry(browser)->res_samples,
-				 evsel, A_ASM);
+						 hist_browser__selected_res_sample(browser),
+						 evsel, A_ASM);
 		nr_options += add_res_sample_opt(browser, &actions[nr_options],
 						 &options[nr_options],
-				 hist_browser__selected_entry(browser)->res_samples,
-				 evsel, A_SOURCE);
+						 hist_browser__selected_res_sample(browser),
+						 evsel, A_SOURCE);
 		nr_options += add_switch_opt(browser, &actions[nr_options],
 					     &options[nr_options]);
 skip_scripting:
-- 
2.25.1



