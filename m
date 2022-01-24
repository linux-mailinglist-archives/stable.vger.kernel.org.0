Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 566F2499B52
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1575105AbiAXVvC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:51:02 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52952 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445206AbiAXVng (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:43:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F4E3B8119E;
        Mon, 24 Jan 2022 21:43:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23521C340E4;
        Mon, 24 Jan 2022 21:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060609;
        bh=xi4KJIaJwSCkynoxCcarqiM8KPP5W/cAYIZDLYrFnBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O9krJI8xsM2S5QNE6Aw2IuCATZOgoMbs8wBe7VSujvoGSQ+DD7gJDVKP1wHauRJId
         WUN6Up3OIB6mFG1Wo21dSyGU+aCH2HGhMchR8vkYuvVa1L4vohi1mTd8d+fwY6+U/x
         KhGqXLo+KqHs0tts/WNorz0G32PJff+/rPf29Qd0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zechuan Chen <chenzechuan1@huawei.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jianlin Lv <Jianlin.Lv@arm.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Namhyung Kim <namhyung@kernel.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        Yang Jihong <yangjihong1@huawei.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.16 1004/1039] perf probe: Fix ppc64 perf probe add events failed case
Date:   Mon, 24 Jan 2022 19:46:33 +0100
Message-Id: <20220124184159.039062305@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zechuan Chen <chenzechuan1@huawei.com>

commit 4624f199327a704dd1069aca1c3cadb8f2a28c6f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/probe-event.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -3083,6 +3083,9 @@ static int find_probe_trace_events_from_
 	for (j = 0; j < num_matched_functions; j++) {
 		sym = syms[j];
 
+		if (sym->type != STT_FUNC)
+			continue;
+
 		/* There can be duplicated symbols in the map */
 		for (i = 0; i < j; i++)
 			if (sym->start == syms[i]->start) {


