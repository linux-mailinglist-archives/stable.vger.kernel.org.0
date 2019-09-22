Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D66ABA61B
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390806AbfIVSrb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:47:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:43940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390929AbfIVSrb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:47:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6AEA208C2;
        Sun, 22 Sep 2019 18:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178050;
        bh=m1xU3MN9oZtjKPTUZFaPksrFuGLR44/SZKFcE/8zU+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HD2Z6xg4Pcj7iicwsg1SaPl9dYWJ7LomsbpNlg4Kl/NYVwjdJc0qSuOuW140wVER3
         oJn4ZaI2a1P/ymyoEovo9WD+zBA8tbnDHZiCiB/9z157ByB+wadM1UNen4WxM2VXeP
         fRzMvO8yCynGFuYF8EIjKdWh4/M9LODDupTxw6zs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 128/203] perf report: Fix --ns time sort key output
Date:   Sun, 22 Sep 2019 14:42:34 -0400
Message-Id: <20190922184350.30563-128-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

[ Upstream commit 3dab6ac080dcd7f71cb9ceb84ad7dafecd6f7c07 ]

If the user specified --ns, the column to print the sort time stamp
wasn't wide enough to actually print the full nanoseconds.

Widen the time key column width when --ns is specified.

Before:

  % perf record -a sleep 1
  % perf report --sort time,overhead,symbol --stdio --ns
  ...
       2.39%  187851.10000  [k] smp_call_function_single   -      -
       1.53%  187851.10000  [k] intel_idle                 -      -
       0.59%  187851.10000  [.] __wcscmp_ifunc             -      -
       0.33%  187851.10000  [.] 0000000000000000           -      -
       0.28%  187851.10000  [k] cpuidle_enter_state        -      -

After:

  % perf report --sort time,overhead,symbol --stdio --ns
  ...
       2.39%  187851.100000000  [k] smp_call_function_single   -      -
       1.53%  187851.100000000  [k] intel_idle                 -      -
       0.59%  187851.100000000  [.] __wcscmp_ifunc             -      -
       0.33%  187851.100000000  [.] 0000000000000000           -      -
       0.28%  187851.100000000  [k] cpuidle_enter_state        -      -

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Link: http://lkml.kernel.org/r/20190823210338.12360-2-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/hist.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index f24fd1954f6c9..6bd270a1e93e0 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -193,7 +193,10 @@ void hists__calc_col_len(struct hists *hists, struct hist_entry *h)
 	hists__new_col_len(hists, HISTC_MEM_LVL, 21 + 3);
 	hists__new_col_len(hists, HISTC_LOCAL_WEIGHT, 12);
 	hists__new_col_len(hists, HISTC_GLOBAL_WEIGHT, 12);
-	hists__new_col_len(hists, HISTC_TIME, 12);
+	if (symbol_conf.nanosecs)
+		hists__new_col_len(hists, HISTC_TIME, 16);
+	else
+		hists__new_col_len(hists, HISTC_TIME, 12);
 
 	if (h->srcline) {
 		len = MAX(strlen(h->srcline), strlen(sort_srcline.se_header));
-- 
2.20.1

