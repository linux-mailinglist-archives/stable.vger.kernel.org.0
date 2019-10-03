Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3304ECA8AF
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731180AbfJCQae (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:30:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:36732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391766AbfJCQae (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:30:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B6D920867;
        Thu,  3 Oct 2019 16:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120233;
        bh=EMm/DFERg7gGpc6ZK4Hzzr9d6eNec1wYcIFHfvS9e2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UwmNVxGak4fLBlv+tziudmwG3S7vbeQocy59dO4MkLpZDdLe68bThlCokU7XB8XGc
         +IIkJxhfPBJ8Gsf577dN3T1+lat3lusunP9/WcGnf8Sm9svyc3Y4hEat8cB55BTyjA
         MmWdgiGuTsXgY4DE47Si0TwobVj4vV+m1fSgbwNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 146/313] perf report: Fix --ns time sort key output
Date:   Thu,  3 Oct 2019 17:52:04 +0200
Message-Id: <20191003154547.292040072@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 7ace7a10054d8..966c248d6a3a1 100644
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



