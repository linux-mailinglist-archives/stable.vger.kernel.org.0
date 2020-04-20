Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E63221B09A3
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727848AbgDTMkt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:40:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:33222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727846AbgDTMks (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:40:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B750D20736;
        Mon, 20 Apr 2020 12:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386447;
        bh=SgjDXtDgQGdZHYXIuByUqint4a036yOfcRxQTWh8XgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gF93p11Pn2git7WrLZjcXf4Mj40zIBvLKGsryFROKdqjyJehrld2wIJAJFj5fxERQ
         eMU1z8kA6FYhm8krEq1PmKBe0lxi+8yN4nmxT9hKoV44L/vA3e1KR2g215KyNp5eSA
         yeR1jo84PmEMirSIjo8XkxbzH5H5PEBGrXzQ3f2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jin Yao <yao.jin@linux.intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.5 26/65] perf report: Fix no branch type statistics report issue
Date:   Mon, 20 Apr 2020 14:38:30 +0200
Message-Id: <20200420121511.919805031@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121505.909671922@linuxfoundation.org>
References: <20200420121505.909671922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jin Yao <yao.jin@linux.intel.com>

commit c3b10649a80e9da2892c1fd3038c53abd57588f6 upstream.

Previously we could get the report of branch type statistics.

For example:

  # perf record -j any,save_type ...
  # t perf report --stdio

  #
  # Branch Statistics:
  #
  COND_FWD:  40.6%
  COND_BWD:   4.1%
  CROSS_4K:  24.7%
  CROSS_2M:  12.3%
      COND:  44.7%
    UNCOND:   0.0%
       IND:   6.1%
      CALL:  24.5%
       RET:  24.7%

But now for the recent perf, it can't report the branch type statistics.

It's a regression issue caused by commit 40c39e304641 ("perf report: Fix
a no annotate browser displayed issue"), which only counts the branch
type statistics for browser mode.

This patch moves the branch_type_count() outside of ui__has_annotation()
checking, then branch type statistics can work for stdio mode.

Fixes: 40c39e304641 ("perf report: Fix a no annotate browser displayed issue")
Signed-off-by: Jin Yao <yao.jin@linux.intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/20200313134607.12873-1-yao.jin@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/builtin-report.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -185,24 +185,23 @@ static int hist_iter__branch_callback(st
 {
 	struct hist_entry *he = iter->he;
 	struct report *rep = arg;
-	struct branch_info *bi;
+	struct branch_info *bi = he->branch_info;
 	struct perf_sample *sample = iter->sample;
 	struct evsel *evsel = iter->evsel;
 	int err;
 
+	branch_type_count(&rep->brtype_stat, &bi->flags,
+			  bi->from.addr, bi->to.addr);
+
 	if (!ui__has_annotation() && !rep->symbol_ipc)
 		return 0;
 
-	bi = he->branch_info;
 	err = addr_map_symbol__inc_samples(&bi->from, sample, evsel);
 	if (err)
 		goto out;
 
 	err = addr_map_symbol__inc_samples(&bi->to, sample, evsel);
 
-	branch_type_count(&rep->brtype_stat, &bi->flags,
-			  bi->from.addr, bi->to.addr);
-
 out:
 	return err;
 }


