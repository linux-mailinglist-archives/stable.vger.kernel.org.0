Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3DEF4B471B
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244641AbiBNJmQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:42:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244983AbiBNJlC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:41:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A891ADA7;
        Mon, 14 Feb 2022 01:36:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F59C60F87;
        Mon, 14 Feb 2022 09:36:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3ADFC340E9;
        Mon, 14 Feb 2022 09:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831398;
        bh=DqHdHTwGY9ECVd1fMS2r5aNiB2rMUb0e+u093JFxsMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AR28315Os6kCn+pJKlfrmCum4wEky9MEhmxP+RVZE7SA3eRJ2kMCOCaYolk898sNu
         SSCLY283JOqJ75c+O1NnBcyLJNqmOZZ65pgFOtCgym/tzBUpvK9ROjtpFKWPoxE0pH
         Kp0mURiBmETBKNiekjGDj/WqomIgKUXY4PGPcg/8=
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
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 5.4 34/71] perf probe: Fix ppc64 perf probe add events failed case
Date:   Mon, 14 Feb 2022 10:26:02 +0100
Message-Id: <20220214092453.167162721@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092452.020713240@linuxfoundation.org>
References: <20220214092452.020713240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/probe-event.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -2954,6 +2954,9 @@ static int find_probe_trace_events_from_
 	for (j = 0; j < num_matched_functions; j++) {
 		sym = syms[j];
 
+		if (sym->type != STT_FUNC)
+			continue;
+
 		tev = (*tevs) + ret;
 		tp = &tev->point;
 		if (ret == num_matched_functions) {


