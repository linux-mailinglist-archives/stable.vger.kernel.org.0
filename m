Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E28AE26163B
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 19:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732015AbgIHRGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 13:06:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:57568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731811AbgIHQTU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:19:20 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95A1323C43;
        Tue,  8 Sep 2020 15:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579377;
        bh=5lqjgR8g9+OBvNFISo9CIMaYPERA98kvgU95UhpC3E4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v7vXP07hk5zBazan5uzyjz822JVO3M2usN7+82Ml9DcOeDNka2ZeQzrVLl+vWY7n5
         JkB0aWObAq2VSWu6+kzjr5ry8q6ylexUiU2zTrfmAo56cN1at0JdDg5iQYMu8sroYw
         ymJ36H31f0NK9d9ivzBxvoeJC1RAfIWUPHJIuaKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tiezhu Yang <yangtiezhu@loongson.cn>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Xuefeng Li <lixuefeng@loongson.cn>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 053/186] perf top: Skip side-band event setup if HAVE_LIBBPF_SUPPORT is not set
Date:   Tue,  8 Sep 2020 17:23:15 +0200
Message-Id: <20200908152244.243347192@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 0c5f1acc2a14416bf30023f373558d369afdbfc8 ]

When I execute 'perf top' without HAVE_LIBBPF_SUPPORT, there exists the
following segmentation fault, skip the side-band event setup to fix it,
this is similar with commit 1101c872c8c7 ("perf record: Skip side-band
event setup if HAVE_LIBBPF_SUPPORT is not set").

  [yangtiezhu@linux perf]$ ./perf top
  <SNIP>
  perf: Segmentation fault
  Obtained 6 stack frames.
  ./perf(sighandler_dump_stack+0x5c) [0x12011b604]
  [0xffffffc010]
  ./perf(perf_mmap__read_init+0x3e) [0x1201feeae]
  ./perf() [0x1200d715c]
  /lib64/libpthread.so.0(+0xab9c) [0xffee10ab9c]
  /lib64/libc.so.6(+0x128f4c) [0xffedc08f4c]
  Segmentation fault
  [yangtiezhu@linux perf]$

I use git bisect to find commit b38d85ef49cf ("perf bpf: Decouple
creating the evlist from adding the SB event") is the first bad commit,
so also add the Fixes tag.

Committer testing:

First build perf explicitely disabling libbpf:

  $ make NO_LIBBPF=1 O=/tmp/build/perf -C tools/perf install-bin && perf test python

Now make sure it isn't linked:

  $ perf -vv | grep -w bpf
                   bpf: [ OFF ]  # HAVE_LIBBPF_SUPPORT
  $
  $ nm ~/bin/perf | grep libbpf
  $

And now try to run 'perf top':

  # perf top
  perf: Segmentation fault
  -------- backtrace --------
  perf[0x5bcd6d]
  /lib64/libc.so.6(+0x3ca6f)[0x7fd0f5a66a6f]
  perf(perf_mmap__read_init+0x1e)[0x5e1afe]
  perf[0x4cc468]
  /lib64/libpthread.so.0(+0x9431)[0x7fd0f645a431]
  /lib64/libc.so.6(clone+0x42)[0x7fd0f5b2b912]
  #

Applying this patch fixes the issue.

Fixes: b38d85ef49cf ("perf bpf: Decouple creating the evlist from adding the SB event")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Xuefeng Li <lixuefeng@loongson.cn>
Link: http://lore.kernel.org/lkml/1597753837-16222-1-git-send-email-yangtiezhu@loongson.cn
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-top.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 13889d73f8dd5..c665d69c0651d 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1746,6 +1746,7 @@ int cmd_top(int argc, const char **argv)
 		goto out_delete_evlist;
 	}
 
+#ifdef HAVE_LIBBPF_SUPPORT
 	if (!top.record_opts.no_bpf_event) {
 		top.sb_evlist = evlist__new();
 
@@ -1759,6 +1760,7 @@ int cmd_top(int argc, const char **argv)
 			goto out_delete_evlist;
 		}
 	}
+#endif
 
 	if (perf_evlist__start_sb_thread(top.sb_evlist, target)) {
 		pr_debug("Couldn't start the BPF side band thread:\nBPF programs starting from now on won't be annotatable\n");
-- 
2.25.1



