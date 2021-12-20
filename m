Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 181C647AFB3
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238566AbhLTPR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:17:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239045AbhLTPQD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:16:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5841DC110F35;
        Mon, 20 Dec 2021 06:58:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7D576119C;
        Mon, 20 Dec 2021 14:57:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C4FC36AE8;
        Mon, 20 Dec 2021 14:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012279;
        bh=IuuTPBxZkgqvm54s/lsg7dRAuQILdH8j0YSojMVnBLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2bhhmGdzOTBZDayAM57K6rRi7zoGZEHA/BJM7yTZc7deUleMCqO040IJDZrRf2A7g
         mb2uW5/GbvyMC99UF67cuFWNEOX4MxQ0BsIz7KWp3s5ZPU3doPSIcLK6Dwhtu4fPu3
         3XvHe+Oxvzcsq3ljow6NJqZbUaWWZJQb28C8BXzk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Riccardo Mancini <rickyman7@gmail.com>
Subject: [PATCH 5.15 145/177] perf inject: Fix segfault due to perf_data__fd() without open
Date:   Mon, 20 Dec 2021 15:34:55 +0100
Message-Id: <20211220143044.961497941@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit c271a55b0c6029fed0cac909fa57999a11467132 upstream.

The fixed commit attempts to get the output file descriptor even if the
file was never opened e.g.

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
  __GI___fileno (fp=0x0) at fileno.c:35
  35      fileno.c: No such file or directory.
  (gdb) bt
  #0  __GI___fileno (fp=0x0) at fileno.c:35
  #1  0x00005621e48dd987 in perf_data__fd (data=0x7fff4c68bd08) at util/data.h:72
  #2  perf_data__fd (data=0x7fff4c68bd08) at util/data.h:69
  #3  cmd_inject (argc=<optimized out>, argv=0x7fff4c69c1f0) at builtin-inject.c:1017
  #4  0x00005621e4936783 in run_builtin (p=0x5621e4ee6878 <commands+600>, argc=4, argv=0x7fff4c69c1f0) at perf.c:313
  #5  0x00005621e4897d5c in handle_internal_command (argv=<optimized out>, argc=<optimized out>) at perf.c:365
  #6  run_argv (argcp=<optimized out>, argv=<optimized out>) at perf.c:409
  #7  main (argc=4, argv=0x7fff4c69c1f0) at perf.c:539
  (gdb)

Fixes: 0ae03893623dd1dd ("perf tools: Pass a fd to perf_file_header__read_pipe()")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Riccardo Mancini <rickyman7@gmail.com>
Cc: stable@vger.kernel.org
Link: http://lore.kernel.org/lkml/20211213084829.114772-3-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/builtin-inject.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -755,12 +755,16 @@ static int parse_vm_time_correlation(con
 	return inject->itrace_synth_opts.vm_tm_corr_args ? 0 : -ENOMEM;
 }
 
+static int output_fd(struct perf_inject *inject)
+{
+	return inject->in_place_update ? -1 : perf_data__fd(&inject->output);
+}
+
 static int __cmd_inject(struct perf_inject *inject)
 {
 	int ret = -EINVAL;
 	struct perf_session *session = inject->session;
-	struct perf_data *data_out = &inject->output;
-	int fd = inject->in_place_update ? -1 : perf_data__fd(data_out);
+	int fd = output_fd(inject);
 	u64 output_data_offset;
 
 	signal(SIGINT, sig_handler);
@@ -1006,7 +1010,7 @@ int cmd_inject(int argc, const char **ar
 	}
 
 	inject.session = __perf_session__new(&data, repipe,
-					     perf_data__fd(&inject.output),
+					     output_fd(&inject),
 					     &inject.tool);
 	if (IS_ERR(inject.session)) {
 		ret = PTR_ERR(inject.session);


