Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFB1329018
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242586AbhCAUC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:02:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:58552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240388AbhCATwC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:52:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8398064FDB;
        Mon,  1 Mar 2021 17:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621156;
        bh=EYaIKS/YSWQDbbP3RAFEpfgEqPD9Rtac8OvjkDsmCLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QrAxR0NMjisLKDqAgc55o8Gx4ZqommHhkHxLKhRop1mxomPI+zXBGMgbJTwbMQvVU
         oWkzj+zyK60osE+IoIwP4LX0IQGUKjnTxUIGWmo6HTTLWaJ1P1YE2Vh4ldqi3xNm5B
         3jKP/i5M15tZEePl0re/GvOaPaHlTCFhu09iAzcE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>, Kan Liang <kan.liang@intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 414/775] perf tools: Fix DSO filtering when not finding a map for a sampled address
Date:   Mon,  1 Mar 2021 17:09:42 +0100
Message-Id: <20210301161222.040754234@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit c69bf11ad3d30b6bf01cfa538ddff1a59467c734 ]

When we lookup an address and don't find a map we should filter that
sample if the user specified a list of --dso entries to filter on, fix
it.

Before:

  $ perf script
             sleep 274800  2843.556162:          1 cycles:u:  ffffffffbb26bff4 [unknown] ([unknown])
             sleep 274800  2843.556168:          1 cycles:u:  ffffffffbb2b047d [unknown] ([unknown])
             sleep 274800  2843.556171:          1 cycles:u:  ffffffffbb2706b2 [unknown] ([unknown])
             sleep 274800  2843.556174:          6 cycles:u:  ffffffffbb2b0267 [unknown] ([unknown])
             sleep 274800  2843.556176:         59 cycles:u:  ffffffffbb2b03b1 [unknown] ([unknown])
             sleep 274800  2843.556180:        691 cycles:u:  ffffffffbb26bff4 [unknown] ([unknown])
             sleep 274800  2843.556189:       9160 cycles:u:      7fa9550eeaa3 __GI___tunables_init+0xf3 (/usr/lib64/ld-2.32.so)
             sleep 274800  2843.556312:      86937 cycles:u:      7fa9550e157b _dl_lookup_symbol_x+0x4b (/usr/lib64/ld-2.32.so)
  $

So we have some samples we somehow didn't find in a map for, if we now
do:

  $ perf report --stdio --dso /usr/lib64/ld-2.32.so
  # dso: /usr/lib64/ld-2.32.so
  #
  # Total Lost Samples: 0
  #
  # Samples: 8  of event 'cycles:u'
  # Event count (approx.): 96856
  #
  # Overhead  Command  Symbol
  # ........  .......  ........................
  #
      89.76%  sleep    [.] _dl_lookup_symbol_x
       9.46%  sleep    [.] __GI___tunables_init
       0.71%  sleep    [k] 0xffffffffbb26bff4
       0.06%  sleep    [k] 0xffffffffbb2b03b1
       0.01%  sleep    [k] 0xffffffffbb2b0267
       0.00%  sleep    [k] 0xffffffffbb2706b2
       0.00%  sleep    [k] 0xffffffffbb2b047d
  $

After this patch we get the right output with just entries for the DSOs
specified in --dso:

  $ perf report --stdio --dso /usr/lib64/ld-2.32.so
  # dso: /usr/lib64/ld-2.32.so
  #
  # Total Lost Samples: 0
  #
  # Samples: 8  of event 'cycles:u'
  # Event count (approx.): 96856
  #
  # Overhead  Command  Symbol
  # ........  .......  ........................
  #
      89.76%  sleep    [.] _dl_lookup_symbol_x
       9.46%  sleep    [.] __GI___tunables_init
  $
  #

Fixes: 96415e4d3f5fdf9c ("perf symbols: Avoid unnecessary symbol loading when dso list is specified")
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jin Yao <yao.jin@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/20210128131209.GD775562@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/event.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 05616d4138a96..7e440fa90c938 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -673,6 +673,8 @@ int machine__resolve(struct machine *machine, struct addr_location *al,
 		}
 
 		al->sym = map__find_symbol(al->map, al->addr);
+	} else if (symbol_conf.dso_list) {
+		al->filtered |= (1 << HIST_FILTER__DSO);
 	}
 
 	if (symbol_conf.sym_list) {
-- 
2.27.0



