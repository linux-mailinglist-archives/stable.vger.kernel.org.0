Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 532B96246E
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389640AbfGHPmn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:42:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:43046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729789AbfGHPmn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:42:43 -0400
Received: from quaco.ghostprotocols.net (179-240-135-35.3g.claro.net.br [179.240.135.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EECB42175B;
        Mon,  8 Jul 2019 15:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562600562;
        bh=S9MveyUPoPJqyWBk6RkG+PIi4txbqqIJER1Z9E/hWqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pHBftSrSoiwG3GXjuEXHGxjHj+npFvOYz70topazH9n7VFCgWBv0VsW2mN+rvN9FJ
         7A0rhyn0KgTRvdBQaThFHIp93uDCHk79WeDwA9lNXxIZiN56wVmpccCo+lzJEUjHYl
         RtsVlbaxocp9BKcdUNk2ATJ2/CWybZSsZbr34R+0=
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Clark Williams <williams@redhat.com>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Song Liu <songliubraving@fb.com>,
        David Carrillo Cisneros <davidca@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        kernel-team@fb.com, stable@vger.kernel.org
Subject: [PATCH 2/8] perf header: Assign proper ff->ph in perf_event__synthesize_features()
Date:   Mon,  8 Jul 2019 12:42:01 -0300
Message-Id: <20190708154207.11403-3-acme@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190708154207.11403-1-acme@kernel.org>
References: <20190708154207.11403-1-acme@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Song Liu <songliubraving@fb.com>

bpf/btf write_* functions need ff->ph->env.

With this missing, pipe-mode (perf record -o -)  would crash like:

Program terminated with signal SIGSEGV, Segmentation fault.

This patch assign proper ph value to ff.

Committer testing:

  (gdb) run record -o -
  Starting program: /root/bin/perf record -o -
  PERFILE2
  <SNIP start of perf.data headers>
  Thread 1 "perf" received signal SIGSEGV, Segmentation fault.
  __do_write_buf (size=4, buf=0x160, ff=0x7fffffff8f80) at util/header.c:126
  126		memcpy(ff->buf + ff->offset, buf, size);
  (gdb) bt
  #0  __do_write_buf (size=4, buf=0x160, ff=0x7fffffff8f80) at util/header.c:126
  #1  do_write (ff=ff@entry=0x7fffffff8f80, buf=buf@entry=0x160, size=4) at util/header.c:137
  #2  0x00000000004eddba in write_bpf_prog_info (ff=0x7fffffff8f80, evlist=<optimized out>) at util/header.c:912
  #3  0x00000000004f69d7 in perf_event__synthesize_features (tool=tool@entry=0x97cc00 <record>, session=session@entry=0x7fffe9c6d010,
      evlist=0x7fffe9cae010, process=process@entry=0x4435d0 <process_synthesized_event>) at util/header.c:3695
  #4  0x0000000000443c79 in record__synthesize (tail=tail@entry=false, rec=0x97cc00 <record>) at builtin-record.c:1214
  #5  0x0000000000444ec9 in __cmd_record (rec=0x97cc00 <record>, argv=<optimized out>, argc=0) at builtin-record.c:1435
  #6  cmd_record (argc=0, argv=<optimized out>) at builtin-record.c:2450
  #7  0x00000000004ae3e9 in run_builtin (p=p@entry=0x98e058 <commands+216>, argc=argc@entry=3, argv=0x7fffffffd670) at perf.c:304
  #8  0x000000000042eded in handle_internal_command (argv=<optimized out>, argc=<optimized out>) at perf.c:356
  #9  run_argv (argcp=<optimized out>, argv=<optimized out>) at perf.c:400
  #10 main (argc=3, argv=<optimized out>) at perf.c:522
  (gdb)

After the patch the SEGSEGV is gone.

Reported-by: David Carrillo Cisneros <davidca@fb.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: kernel-team@fb.com
Cc: stable@vger.kernel.org # v5.1+
Fixes: 606f972b1361 ("perf bpf: Save bpf_prog_info information as headers to perf.data")
Link: http://lkml.kernel.org/r/20190620010453.4118689-1-songliubraving@fb.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 847ae51a524b..fb0aa661644b 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -3602,6 +3602,7 @@ int perf_event__synthesize_features(struct perf_tool *tool,
 		return -ENOMEM;
 
 	ff.size = sz - sz_hdr;
+	ff.ph = &session->header;
 
 	for_each_set_bit(feat, header->adds_features, HEADER_FEAT_BITS) {
 		if (!feat_ops[feat].synthesize) {
-- 
2.20.1

