Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1807F47AFDC
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238600AbhLTPUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:20:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239440AbhLTPSh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:18:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E7DFC019D88;
        Mon, 20 Dec 2021 06:59:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B95EB80EF1;
        Mon, 20 Dec 2021 14:59:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B6BEC36AE8;
        Mon, 20 Dec 2021 14:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012370;
        bh=ZKCYJTj7WpYxSyjM+4FjMwqAHTU8YUcXxs1z89j/YeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Txjf+2XgrzSLQpov9X2oCgfIewfMmqx3wKOBYSBu4l8zRAuqSDJ006YM4f1sPNMQ1
         kbfuyFsDwz0F1OVpSLg8vGyFhd8Ic7X3ht6XBanTEpopXVX7qum49RsR/OVu6g1IqD
         4LL279zca7SZxVoeQ0zYv02LVZqZTaYcjilDmbcY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Riccardo Mancini <rickyman7@gmail.com>
Subject: [PATCH 5.15 144/177] perf inject: Fix segfault due to close without open
Date:   Mon, 20 Dec 2021 15:34:54 +0100
Message-Id: <20211220143044.929790600@linuxfoundation.org>
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

commit 0c8e32fe48f549eef27c8c6b0a63530f83c3a643 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/builtin-inject.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -1069,7 +1069,8 @@ out_delete:
 	zstd_fini(&(inject.session->zstd_data));
 	perf_session__delete(inject.session);
 out_close_output:
-	perf_data__close(&inject.output);
+	if (!inject.in_place_update)
+		perf_data__close(&inject.output);
 	free(inject.itrace_synth_opts.vm_tm_corr_args);
 	return ret;
 }


