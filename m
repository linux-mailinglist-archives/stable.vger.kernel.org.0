Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAF89498133
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 14:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233011AbiAXNdY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 08:33:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44768 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239976AbiAXNdY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 08:33:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A663B80FBD
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 13:33:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C09C340E1;
        Mon, 24 Jan 2022 13:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643031201;
        bh=5RmOmHufsMaOsubdYRQPV526LCFy8W7s/KDCeuFhVe4=;
        h=Subject:To:Cc:From:Date:From;
        b=NrvPL432K6t3ni7LndpqSiYqvgbIVaMs3smmVRUppO1mVhuV4/+YVlBK+T1He9OWP
         hL8vHRDIgGQz6ifa4wmtqphgpgR6wUT+dMc4fUJh73BCvMVu0ZZBXF67yA7afenTxA
         yHzMGFViUo/Wev4oQbiqIUwgf+uDVG2hbC8yJ0M8=
Subject: FAILED: patch "[PATCH] perf probe: Fix ppc64 'perf probe add events failed' case" failed to apply to 5.4-stable tree
To:     chenzechuan1@huawei.com, Jianlin.Lv@arm.com, acme@redhat.com,
        alexander.shishkin@linux.intel.com, jolsa@redhat.com,
        mark.rutland@arm.com, mhiramat@kernel.org, mingo@redhat.com,
        mpe@ellerman.id.au, namhyung@kernel.org,
        naveen.n.rao@linux.vnet.ibm.com, peterz@infradead.org,
        ravi.bangoria@linux.ibm.com, yangjihong1@huawei.com,
        yao.jin@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 14:33:09 +0100
Message-ID: <1643031189224222@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4624f199327a704dd1069aca1c3cadb8f2a28c6f Mon Sep 17 00:00:00 2001
From: Zechuan Chen <chenzechuan1@huawei.com>
Date: Tue, 28 Dec 2021 19:13:38 +0800
Subject: [PATCH] perf probe: Fix ppc64 'perf probe add events failed' case

Because of commit bf794bf52a80c627 ("powerpc/kprobes: Fix kallsyms
lookup across powerpc ABIv1 and ABIv2"), in ppc64 ABIv1, our perf
command eliminates the need to use the prefix "." at the symbol name.

But when the command "perf probe -a schedule" is executed on ppc64
ABIv1, it obtains two symbol address information through /proc/kallsyms,
for example:

  cat /proc/kallsyms | grep -w schedule
  c000000000657020 T .schedule
  c000000000d4fdb8 D schedule

The symbol "D schedule" is not a function symbol, and perf will print:
"p:probe/schedule _text+13958584"Failed to write event: Invalid argument

Therefore, when searching symbols from map and adding probe point for
them, a symbol type check is added. If the type of symbol is not a
function, skip it.

Fixes: bf794bf52a80c627 ("powerpc/kprobes: Fix kallsyms lookup across powerpc ABIv1 and ABIv2")
Signed-off-by: Zechuan Chen <chenzechuan1@huawei.com>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jianlin Lv <Jianlin.Lv@arm.com>
Cc: Jin Yao <yao.jin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Cc: Yang Jihong <yangjihong1@huawei.com>
Link: https://lore.kernel.org/r/20211228111338.218602-1-chenzechuan1@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index b2a02c9ab8ea..a834918a0a0d 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -3083,6 +3083,9 @@ static int find_probe_trace_events_from_map(struct perf_probe_event *pev,
 	for (j = 0; j < num_matched_functions; j++) {
 		sym = syms[j];
 
+		if (sym->type != STT_FUNC)
+			continue;
+
 		/* There can be duplicated symbols in the map */
 		for (i = 0; i < j; i++)
 			if (sym->start == syms[i]->start) {

