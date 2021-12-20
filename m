Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F87E47A753
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 10:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbhLTJkb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 04:40:31 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58468 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbhLTJka (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 04:40:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FB7FB80E28
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 09:40:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A37C36AE8;
        Mon, 20 Dec 2021 09:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639993228;
        bh=jaXc6tEqTHCkvsnx14mgEb6WZ7krKV8ZpNK0z3XsbrY=;
        h=Subject:To:Cc:From:Date:From;
        b=k8gvO2k1WdgLYjdgdS6YpA3VBjVqmUZHuMoKT+/YA1pM1w3D2W50CVSm8owgEB9zk
         VK1lcfd69Fs8VSJkRBxWQ/tV5XEsIBq/976bd5RxnATJPQdPtE+hcRzzzYvAQjqRgl
         QiyxcVsc9FBLiPeUDF5H9MAjR45aLTP/RnRGxE78=
Subject: FAILED: patch "[PATCH] perf inject: Fix segfault due to close without open" failed to apply to 5.4-stable tree
To:     adrian.hunter@intel.com, acme@redhat.com, jolsa@redhat.com,
        namhyung@kernel.org, rickyman7@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Dec 2021 10:40:25 +0100
Message-ID: <163999322518137@kroah.com>
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

From 0c8e32fe48f549eef27c8c6b0a63530f83c3a643 Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@intel.com>
Date: Mon, 13 Dec 2021 10:48:28 +0200
Subject: [PATCH] perf inject: Fix segfault due to close without open

The fixed commit attempts to close inject.output even if it was never
opened e.g.

  $ perf record uname
  Linux
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.002 MB perf.data (7 samples) ]
  $ perf inject -i perf.data --vm-time-correlation=dry-run
  Segmentation fault (core dumped)
  $ gdb --quiet perf
  Reading symbols from perf...
  (gdb) r inject -i perf.data --vm-time-correlation=dry-run
  Starting program: /home/ahunter/bin/perf inject -i perf.data --vm-time-correlation=dry-run
  [Thread debugging using libthread_db enabled]
  Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".

  Program received signal SIGSEGV, Segmentation fault.
  0x00007eff8afeef5b in _IO_new_fclose (fp=0x0) at iofclose.c:48
  48      iofclose.c: No such file or directory.
  (gdb) bt
  #0  0x00007eff8afeef5b in _IO_new_fclose (fp=0x0) at iofclose.c:48
  #1  0x0000557fc7b74f92 in perf_data__close (data=data@entry=0x7ffcdafa6578) at util/data.c:376
  #2  0x0000557fc7a6b807 in cmd_inject (argc=<optimized out>, argv=<optimized out>) at builtin-inject.c:1085
  #3  0x0000557fc7ac4783 in run_builtin (p=0x557fc8074878 <commands+600>, argc=4, argv=0x7ffcdafb6a60) at perf.c:313
  #4  0x0000557fc7a25d5c in handle_internal_command (argv=<optimized out>, argc=<optimized out>) at perf.c:365
  #5  run_argv (argcp=<optimized out>, argv=<optimized out>) at perf.c:409
  #6  main (argc=4, argv=0x7ffcdafb6a60) at perf.c:539
  (gdb)

Fixes: 02e6246f5364d526 ("perf inject: Close inject.output on exit")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Riccardo Mancini <rickyman7@gmail.com>
Cc: stable@vger.kernel.org
Link: http://lore.kernel.org/lkml/20211213084829.114772-2-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index b9d6306cc14e..af70f1c72052 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -1078,7 +1078,8 @@ int cmd_inject(int argc, const char **argv)
 	zstd_fini(&(inject.session->zstd_data));
 	perf_session__delete(inject.session);
 out_close_output:
-	perf_data__close(&inject.output);
+	if (!inject.in_place_update)
+		perf_data__close(&inject.output);
 	free(inject.itrace_synth_opts.vm_tm_corr_args);
 	return ret;
 }

