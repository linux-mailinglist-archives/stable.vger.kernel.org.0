Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B197E45E596
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 04:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358285AbhKZCnh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 21:43:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:50264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358270AbhKZClX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 21:41:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE8F6611C4;
        Fri, 26 Nov 2021 02:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637894081;
        bh=j8zPzeBGu6tZK5oETIajOgAH9cu9LpR8C/YOzFvXoJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Br9aUWZy68Tgy6b8P2fYJP9f708Nxyv85SCMli8rLDNjEV1C6ghmDCpNvnJmsazhj
         +vOtSRXIld3WRwpA05eTNLyVx8IgYGOfE6GAXNIc9GobK1ecb+u1+ca9RLMfeKt9IK
         Ww7tjc/C1hG9RT7L5puoLBvBrgSFiwrjHOfmRKtHNcGyFRnTqd87gzFCRBOkaoB3Z7
         bAIQTNLx6BQjkn7yk/pKbUXGAzk/HBgtTJl/cSYdToDVIrXLGbBU40kPvvKGcwE0bM
         xUKHraTlaAg9N37LDhY3HDTfXPYY0QDKmUe1Cc6qSHxWUtjiDb5UUk1T0cap1ZK4KG
         cN1W3vfRObQrA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ian Rogers <irogers@google.com>, Kajol Jain <kjain@linux.ibm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        acme@kernel.org, kan.liang@linux.intel.com, ak@linux.intel.com,
        atrajeev@linux.vnet.ibm.com, linux-perf-users@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 27/28] perf hist: Fix memory leak of a perf_hpp_fmt
Date:   Thu, 25 Nov 2021 21:33:42 -0500
Message-Id: <20211126023343.442045-27-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023343.442045-1-sashal@kernel.org>
References: <20211126023343.442045-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

