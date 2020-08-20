Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E87724BE4F
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730734AbgHTNXL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:23:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:46782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728444AbgHTJeL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:34:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79135207DE;
        Thu, 20 Aug 2020 09:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916040;
        bh=IiYFq2Urt7CVFWhnRx7Sf4p1sOBGWy+A0gkv82MJwEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R+BOCZgE/zNav6UOrPkEY+xgp3krx7x6gVbuYJaglHCmWiSMITI1SoJzdKCiQ6MQO
         /TxSefcLELRozIY/+McKC2HjWJffReFOVbivIpzrhYKzPIL75KpAdzcV1GvAOpMxtq
         6effkBDWSsluNXkbku0skZewKoLG+/rPsFzjLQm8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jin Yao <yao.jin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, Jin Yao <yao.jin@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 193/232] perf record: Skip side-band event setup if HAVE_LIBBPF_SUPPORT is not set
Date:   Thu, 20 Aug 2020 11:20:44 +0200
Message-Id: <20200820091622.140479237@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jin Yao <yao.jin@linux.intel.com>

[ Upstream commit 1101c872c8c7869c78dc106ae820040f36807eda ]

We received an error report that perf-record caused 'Segmentation fault'
on a newly system (e.g. on the new installed ubuntu).

  (gdb) backtrace
  #0  __read_once_size (size=4, res=<synthetic pointer>, p=0x14) at /root/0-jinyao/acme/tools/include/linux/compiler.h:139
  #1  atomic_read (v=0x14) at /root/0-jinyao/acme/tools/include/asm/../../arch/x86/include/asm/atomic.h:28
  #2  refcount_read (r=0x14) at /root/0-jinyao/acme/tools/include/linux/refcount.h:65
  #3  perf_mmap__read_init (map=map@entry=0x0) at mmap.c:177
  #4  0x0000561ce5c0de39 in perf_evlist__poll_thread (arg=0x561ce68584d0) at util/sideband_evlist.c:62
  #5  0x00007fad78491609 in start_thread (arg=<optimized out>) at pthread_create.c:477
  #6  0x00007fad7823c103 in clone () at ../sysdeps/unix/sysv/linux/x86_64/clone.S:95

The root cause is, evlist__add_bpf_sb_event() just returns 0 if
HAVE_LIBBPF_SUPPORT is not defined (inline function path). So it will
not create a valid evsel for side-band event.

But perf-record still creates BPF side band thread to process the
side-band event, then the error happpens.

We can reproduce this issue by removing the libelf-dev. e.g.
1. apt-get remove libelf-dev
2. perf record -a -- sleep 1

  root@test:~# ./perf record -a -- sleep 1
  perf: Segmentation fault
  Obtained 6 stack frames.
  ./perf(+0x28eee8) [0x5562d6ef6ee8]
  /lib/x86_64-linux-gnu/libc.so.6(+0x46210) [0x7fbfdc65f210]
  ./perf(+0x342e74) [0x5562d6faae74]
  ./perf(+0x257e39) [0x5562d6ebfe39]
  /lib/x86_64-linux-gnu/libpthread.so.0(+0x9609) [0x7fbfdc990609]
  /lib/x86_64-linux-gnu/libc.so.6(clone+0x43) [0x7fbfdc73b103]
  Segmentation fault (core dumped)

To fix this issue,

1. We either install the missing libraries to let HAVE_LIBBPF_SUPPORT
   be defined.
   e.g. apt-get install libelf-dev and install other related libraries.

2. Use this patch to skip the side-band event setup if HAVE_LIBBPF_SUPPORT
   is not set.

Committer notes:

The side band thread is not used just with BPF, it is also used with
--switch-output-event, so narrow the ifdef to the BPF specific part.

Fixes: 23cbb41c939a ("perf record: Move side band evlist setup to separate routine")
Signed-off-by: Jin Yao <yao.jin@linux.intel.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Jin Yao <yao.jin@intel.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/20200805022937.29184-1-yao.jin@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-record.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index a37e7910e9e90..23ea934f30b34 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -1489,7 +1489,7 @@ static int record__setup_sb_evlist(struct record *rec)
 		evlist__set_cb(rec->sb_evlist, record__process_signal_event, rec);
 		rec->thread_id = pthread_self();
 	}
-
+#ifdef HAVE_LIBBPF_SUPPORT
 	if (!opts->no_bpf_event) {
 		if (rec->sb_evlist == NULL) {
 			rec->sb_evlist = evlist__new();
@@ -1505,7 +1505,7 @@ static int record__setup_sb_evlist(struct record *rec)
 			return -1;
 		}
 	}
-
+#endif
 	if (perf_evlist__start_sb_thread(rec->sb_evlist, &rec->opts.target)) {
 		pr_debug("Couldn't start the BPF side band thread:\nBPF programs starting from now on won't be annotatable\n");
 		opts->no_bpf_event = true;
-- 
2.25.1



