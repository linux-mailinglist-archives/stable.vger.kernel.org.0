Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 361CA3286EF
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236826AbhCARRg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:17:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:35192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236461AbhCARIl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:08:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0A7F65010;
        Mon,  1 Mar 2021 16:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616917;
        bh=9cSHSHA18dLs053Qx+nwF8UhdPeBFiTR7EB7lHU5uew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GDkmOhNVpbIJ05rfpOu5hH7+o5tBB0JHLfXojK7hekttG/XGqQhGY6V5AVqL4jjLg
         iiG2WYfq0bURplqVjCYJKwHNmy/mkcAx5+qEgnSo9wApDpFdoYOENksn7DKIX71Tkv
         OufpJDuF7XCXUM+2uh16SesoddKzZsPq/qZAJ9i4=
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
Subject: [PATCH 4.19 140/247] perf tools: Fix DSO filtering when not finding a map for a sampled address
Date:   Mon,  1 Mar 2021 17:12:40 +0100
Message-Id: <20210301161038.525443998@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
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
index 9c22729e2ad60..538c935b40b8b 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -1660,6 +1660,8 @@ int machine__resolve(struct machine *machine, struct addr_location *al,
 		}
 
 		al->sym = map__find_symbol(al->map, al->addr);
+	} else if (symbol_conf.dso_list) {
+		al->filtered |= (1 << HIST_FILTER__DSO);
 	}
 
 	if (symbol_conf.sym_list &&
-- 
2.27.0



