Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98721F7B61
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbfKKSfm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:35:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:53616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727435AbfKKSfl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:35:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1D1D214E0;
        Mon, 11 Nov 2019 18:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497340;
        bh=s5h+oVp6iAHIinVU39+Bpvfa6kUNdNmBoQA7BY/ZAfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Demv49z6vwbEYfP/JPmY0EKN/uzLHk4CLI6qlfW2trtoKNcxhjr1J78ztgcRQm0HO
         UshWJbcDYQ79aL5Vbu+BobXsJHbwvrJaJJcalr7f1HKJX7SkTp9iNOCK6XteYHAALQ
         Mpiz03g+vq3YdLv/OaasEvq+CWUCNo2sYP0syzxo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Michael Petlan <mpetlan@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4.14 020/105] perf tools: Fix time sorting
Date:   Mon, 11 Nov 2019 19:27:50 +0100
Message-Id: <20191111181434.144368704@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181421.390326245@linuxfoundation.org>
References: <20191111181421.390326245@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

commit 722ddfde366fd46205456a9c5ff9b3359dc9a75e upstream.

The final sort might get confused when the comparison is done over
bigger numbers than int like for -s time.

Check the following report for longer workloads:

  $ perf report -s time -F time,overhead --stdio

Fix hist_entry__sort() to properly return int64_t and not possible cut
int.

Fixes: 043ca389a318 ("perf tools: Use hpp formats to sort final output")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Michael Petlan <mpetlan@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org # v3.16+
Link: http://lore.kernel.org/lkml/20191104232711.16055-1-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/hist.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -1504,7 +1504,7 @@ int hists__collapse_resort(struct hists
 	return 0;
 }
 
-static int hist_entry__sort(struct hist_entry *a, struct hist_entry *b)
+static int64_t hist_entry__sort(struct hist_entry *a, struct hist_entry *b)
 {
 	struct hists *hists = a->hists;
 	struct perf_hpp_fmt *fmt;


