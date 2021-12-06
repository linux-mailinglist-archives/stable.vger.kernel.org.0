Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA4A8469C34
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243809AbhLFPVT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:21:19 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52344 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358205AbhLFPTF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:19:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 213C2B810F1;
        Mon,  6 Dec 2021 15:15:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C5CC341C1;
        Mon,  6 Dec 2021 15:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803734;
        bh=j8zPzeBGu6tZK5oETIajOgAH9cu9LpR8C/YOzFvXoJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mWV4Gcs0iWdnE1bj7cne0P6YWjP15c6rrM7t3ITEPgE9EWeLdC/87Iy9H1UtS5UXZ
         7NNykxvwq4mBEIOnjl8Yl29fCqdHP2YhAhKdcSOPnsltjo7So5xwmP3UZaScfnQQ5X
         itGc7mXsivHNayBUukkCip+LMezvtqVro4385PMY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Rogers <irogers@google.com>,
        Kajol Jain <kjain@linux.ibm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 027/130] perf hist: Fix memory leak of a perf_hpp_fmt
Date:   Mon,  6 Dec 2021 15:55:44 +0100
Message-Id: <20211206145600.581782275@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Rogers <irogers@google.com>

[ Upstream commit 0ca1f534a776cc7d42f2c33da4732b74ec2790cd ]

perf_hpp__column_unregister() removes an entry from a list but doesn't
free the memory causing a memory leak spotted by leak sanitizer.

Add the free while at the same time reducing the scope of the function
to static.

Signed-off-by: Ian Rogers <irogers@google.com>
Reviewed-by: Kajol Jain <kjain@linux.ibm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lore.kernel.org/lkml/20211118071247.2140392-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/ui/hist.c   | 28 ++++++++++++++--------------
 tools/perf/util/hist.h |  1 -
 2 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index c1f24d0048527..5075ecead5f3d 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -535,6 +535,18 @@ struct perf_hpp_list perf_hpp_list = {
 #undef __HPP_SORT_ACC_FN
 #undef __HPP_SORT_RAW_FN
 
+static void fmt_free(struct perf_hpp_fmt *fmt)
+{
+	/*
+	 * At this point fmt should be completely
+	 * unhooked, if not it's a bug.
+	 */
+	BUG_ON(!list_empty(&fmt->list));
+	BUG_ON(!list_empty(&fmt->sort_list));
+
+	if (fmt->free)
+		fmt->free(fmt);
+}
 
 void perf_hpp__init(void)
 {
@@ -598,9 +610,10 @@ void perf_hpp_list__prepend_sort_field(struct perf_hpp_list *list,
 	list_add(&format->sort_list, &list->sorts);
 }
 
-void perf_hpp__column_unregister(struct perf_hpp_fmt *format)
+static void perf_hpp__column_unregister(struct perf_hpp_fmt *format)
 {
 	list_del_init(&format->list);
+	fmt_free(format);
 }
 
 void perf_hpp__cancel_cumulate(void)
@@ -672,19 +685,6 @@ void perf_hpp__append_sort_keys(struct perf_hpp_list *list)
 }
 
 
-static void fmt_free(struct perf_hpp_fmt *fmt)
-{
-	/*
-	 * At this point fmt should be completely
-	 * unhooked, if not it's a bug.
-	 */
-	BUG_ON(!list_empty(&fmt->list));
-	BUG_ON(!list_empty(&fmt->sort_list));
-
-	if (fmt->free)
-		fmt->free(fmt);
-}
-
 void perf_hpp__reset_output_field(struct perf_hpp_list *list)
 {
 	struct perf_hpp_fmt *fmt, *tmp;
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 96b1c13bbccc5..919f2c6c48142 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -362,7 +362,6 @@ enum {
 };
 
 void perf_hpp__init(void);
-void perf_hpp__column_unregister(struct perf_hpp_fmt *format);
 void perf_hpp__cancel_cumulate(void);
 void perf_hpp__setup_output_field(struct perf_hpp_list *list);
 void perf_hpp__reset_output_field(struct perf_hpp_list *list);
-- 
2.33.0



