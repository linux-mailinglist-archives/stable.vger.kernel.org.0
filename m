Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9569D73BCA
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391154AbfGXUDk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:03:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:54114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405868AbfGXUDh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 16:03:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8CFB2147A;
        Wed, 24 Jul 2019 20:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998616;
        bh=65BWGDIpap0BzGsgf1qyxTzlcwLR6BGBbWyre8uNvJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DmBiAPTRB8aIpcR03Y7qdqkz9Dd2LJ1kjzDGkWAozpG2qXgAuG0pwwK9I6dYSgC8F
         KRtB7dwGmHQtAaRHsdeqzeg3WvI+LlkVqxRQ6x97bSuJHsYKop1MBQKqprajO3Ne4w
         8uu7yu94Jd3fKC+GG+nj880STYMeMwVWLE679Ygc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Richter <tmricht@linux.ibm.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 056/271] perf report: Fix OOM error in TUI mode on s390
Date:   Wed, 24 Jul 2019 21:18:45 +0200
Message-Id: <20190724191659.940987995@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 8a07aa4e9b7b0222129c07afff81634a884b2866 ]

Debugging a OOM error using the TUI interface revealed this issue
on s390:

[tmricht@m83lp54 perf]$ cat /proc/kallsyms |sort
....
00000001119b7158 B radix_tree_node_cachep
00000001119b8000 B __bss_stop
00000001119b8000 B _end
000003ff80002850 t autofs_mount	[autofs4]
000003ff80002868 t autofs_show_options	[autofs4]
000003ff80002a98 t autofs_evict_inode	[autofs4]
....

There is a huge gap between the last kernel symbol
__bss_stop/_end and the first kernel module symbol
autofs_mount (from autofs4 module).

After reading the kernel symbol table via functions:

 dso__load()
 +--> dso__load_kernel_sym()
      +--> dso__load_kallsyms()
	   +--> __dso_load_kallsyms()
	        +--> symbols__fixup_end()

the symbol __bss_stop has a start address of 1119b8000 and
an end address of 3ff80002850, as can be seen by this debug statement:

  symbols__fixup_end __bss_stop start:0x1119b8000 end:0x3ff80002850

The size of symbol __bss_stop is 0x3fe6e64a850 bytes!
It is the last kernel symbol and fills up the space until
the first kernel module symbol.

This size kills the TUI interface when executing the following
code:

  process_sample_event()
    hist_entry_iter__add()
      hist_iter__report_callback()
        hist_entry__inc_addr_samples()
          symbol__inc_addr_samples(symbol = __bss_stop)
            symbol__cycles_hist()
               annotated_source__alloc_histograms(...,
				                symbol__size(sym),
		                                ...)

This function allocates memory to save sample histograms.
The symbol_size() marco is defined as sym->end - sym->start, which
results in above value of 0x3fe6e64a850 bytes and
the call to calloc() in annotated_source__alloc_histograms() fails.

The histgram memory allocation might fail, make this failure
no-fatal and continue processing.

Output before:
[tmricht@m83lp54 perf]$ ./perf --debug stderr=1 report -vvvvv \
					      -i ~/slow.data 2>/tmp/2
[tmricht@m83lp54 perf]$ tail -5 /tmp/2
  __symbol__inc_addr_samples(875): ENOMEM! sym->name=__bss_stop,
		start=0x1119b8000, addr=0x2aa0005eb08, end=0x3ff80002850,
		func: 0
problem adding hist entry, skipping event
0x938b8 [0x8]: failed to process type: 68 [Cannot allocate memory]
[tmricht@m83lp54 perf]$

Output after:
[tmricht@m83lp54 perf]$ ./perf --debug stderr=1 report -vvvvv \
					      -i ~/slow.data 2>/tmp/2
[tmricht@m83lp54 perf]$ tail -5 /tmp/2
   symbol__inc_addr_samples map:0x1597830 start:0x110730000 end:0x3ff80002850
   symbol__hists notes->src:0x2aa2a70 nr_hists:1
   symbol__inc_addr_samples sym:unlink_anon_vmas src:0x2aa2a70
   __symbol__inc_addr_samples: addr=0x11094c69e
   0x11094c670 unlink_anon_vmas: period++ [addr: 0x11094c69e, 0x2e, evidx=0]
   	=> nr_samples: 1, period: 526008
[tmricht@m83lp54 perf]$

There is no error about failed memory allocation and the TUI interface
shows all entries.

Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Reviewed-by: Hendrik Brueckner <brueckner@linux.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/90cb5607-3e12-5167-682d-978eba7dafa8@linux.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/annotate.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index dfee110b3a58..c357051dd2b6 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -911,9 +911,8 @@ static int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
 	if (sym == NULL)
 		return 0;
 	src = symbol__hists(sym, evsel->evlist->nr_entries);
-	if (src == NULL)
-		return -ENOMEM;
-	return __symbol__inc_addr_samples(sym, map, src, evsel->idx, addr, sample);
+	return (src) ?  __symbol__inc_addr_samples(sym, map, src, evsel->idx,
+						   addr, sample) : 0;
 }
 
 static int symbol__account_cycles(u64 addr, u64 start,
-- 
2.20.1



