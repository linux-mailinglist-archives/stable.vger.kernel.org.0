Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20D294D84B
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbfFTSHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:07:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:34740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728384AbfFTSHw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:07:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B6372084E;
        Thu, 20 Jun 2019 18:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054071;
        bh=dDIlcOc0mj6TJSxSLEG7JNU0rapaycQ7btP3ssfYTcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1CwL8mGOLr4J4X1ID1a3sLTcOXMZaH9mfHNzvLp4yrQi8FqFqjDpzsTH8Wdjtc/fb
         hdlwT6lU/1l9KqnsO1WhE/4Zx8/ZhSdFzri1o9H5D6aV4H9GMxtp0eZghSMeYrvagU
         vhvCmesDY7+rgVJyi/zx2OpzhqIDzr8p7Jjt0Yzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andrei Vagin <avagin@openvz.org>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vasily Averin <vvs@virtuozzo.com>,
        Wang Nan <wangnan0@huawei.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Tommi Rantala <tommi.t.rantala@nokia.com>
Subject: [PATCH 4.14 01/45] perf machine: Guard against NULL in machine__exit()
Date:   Thu, 20 Jun 2019 19:57:03 +0200
Message-Id: <20190620174329.129654050@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174328.608036501@linuxfoundation.org>
References: <20190620174328.608036501@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

commit 4a2233b194c77ae1ea8304cb7c00b551de4313f0 upstream.

A recent fix for 'perf trace' introduced a bug where
machine__exit(trace->host) could be called while trace->host was still
NULL, so make this more robust by guarding against NULL, just like
free() does.

The problem happens, for instance, when !root users try to run 'perf
trace':

  [acme@jouet linux]$ trace
  Error:	No permissions to read /sys/kernel/debug/tracing/events/raw_syscalls/sys_(enter|exit)
  Hint:	Try 'sudo mount -o remount,mode=755 /sys/kernel/debug/tracing'

  perf: Segmentation fault
  Obtained 7 stack frames.
  [0x4f1b2e]
  /lib64/libc.so.6(+0x3671f) [0x7f43a1dd971f]
  [0x4f3fec]
  [0x47468b]
  [0x42a2db]
  /lib64/libc.so.6(__libc_start_main+0xe9) [0x7f43a1dc3509]
  [0x42a6c9]
  Segmentation fault (core dumped)
  [acme@jouet linux]$

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andrei Vagin <avagin@openvz.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vasily Averin <vvs@virtuozzo.com>
Cc: Wang Nan <wangnan0@huawei.com>
Fixes: 33974a414ce2 ("perf trace: Call machine__exit() at exit")
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Tommi Rantala <tommi.t.rantala@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/machine.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -156,6 +156,9 @@ void machine__delete_threads(struct mach
 
 void machine__exit(struct machine *machine)
 {
+	if (machine == NULL)
+		return;
+
 	machine__destroy_kernel_maps(machine);
 	map_groups__exit(&machine->kmaps);
 	dsos__exit(&machine->dsos);


