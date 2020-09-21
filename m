Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73760272FA5
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728321AbgIUQ6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:58:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:45370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728952AbgIUQll (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:41:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5CBE235F9;
        Mon, 21 Sep 2020 16:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706500;
        bh=Nz4n7y5tVBMacRjzpmWhoY0JWGL8SRcYrc+5EGfCeKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MazVnHz16uVARxH3Q2k79RaNklikQod80UYzG3lwEwSVh79RvmD2mCuwhC05R1TBc
         yimn9LqE7Qjmwbg8txDv8qjj3rwJT2ASB1R2Kvvgmt3NH3B9H40lCvdaB/MtVKie0/
         ZOhO43jeZxzD/X1rUIfs8dB4fO5oZdLUNicJ7yEg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Michael Petlan <mpetlan@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Wang Nan <wangnan0@huawei.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 30/49] perf test: Fix the "signal" test inline assembly
Date:   Mon, 21 Sep 2020 18:28:14 +0200
Message-Id: <20200921162035.985776275@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162034.660953761@linuxfoundation.org>
References: <20200921162034.660953761@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 8a39e8c4d9baf65d88f66d49ac684df381e30055 ]

When compiling with DEBUG=1 on Fedora 32 I'm getting crash for 'perf
test signal':

  Program received signal SIGSEGV, Segmentation fault.
  0x0000000000c68548 in __test_function ()
  (gdb) bt
  #0  0x0000000000c68548 in __test_function ()
  #1  0x00000000004d62e9 in test_function () at tests/bp_signal.c:61
  #2  0x00000000004d689a in test__bp_signal (test=0xa8e280 <generic_ ...
  #3  0x00000000004b7d49 in run_test (test=0xa8e280 <generic_tests+1 ...
  #4  0x00000000004b7e7f in test_and_print (t=0xa8e280 <generic_test ...
  #5  0x00000000004b8927 in __cmd_test (argc=1, argv=0x7fffffffdce0, ...
  ...

It's caused by the symbol __test_function being in the ".bss" section:

  $ readelf -a ./perf | less
    [Nr] Name              Type             Address           Offset
         Size              EntSize          Flags  Link  Info  Align
    ...
    [28] .bss              NOBITS           0000000000c356a0  008346a0
         00000000000511f8  0000000000000000  WA       0     0     32

  $ nm perf | grep __test_function
  0000000000c68548 B __test_function

I guess most of the time we're just lucky the inline asm ended up in the
".text" section, so making it specific explicit with push and pop
section clauses.

  $ readelf -a ./perf | less
    [Nr] Name              Type             Address           Offset
         Size              EntSize          Flags  Link  Info  Align
    ...
    [13] .text             PROGBITS         0000000000431240  00031240
         0000000000306faa  0000000000000000  AX       0     0     16

  $ nm perf | grep __test_function
  00000000004d62c8 T __test_function

Committer testing:

  $ readelf -wi ~/bin/perf | grep producer -m1
    <c>   DW_AT_producer    : (indirect string, offset: 0x254a): GNU C99 10.2.1 20200723 (Red Hat 10.2.1-1) -mtune=generic -march=x86-64 -ggdb3 -std=gnu99 -fno-omit-frame-pointer -funwind-tables -fstack-protector-all
                                                                                                                                         ^^^^^
                                                                                                                                         ^^^^^
                                                                                                                                         ^^^^^
  $

Before:

  $ perf test signal
  20: Breakpoint overflow signal handler                    : FAILED!
  $

After:

  $ perf test signal
  20: Breakpoint overflow signal handler                    : Ok
  $

Fixes: 8fd34e1cce18 ("perf test: Improve bp_signal")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Michael Petlan <mpetlan@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Wang Nan <wangnan0@huawei.com>
Link: http://lore.kernel.org/lkml/20200911130005.1842138-1-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/bp_signal.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/tests/bp_signal.c b/tools/perf/tests/bp_signal.c
index 6cf00650602ef..697423ce3bdfc 100644
--- a/tools/perf/tests/bp_signal.c
+++ b/tools/perf/tests/bp_signal.c
@@ -44,10 +44,13 @@ volatile long the_var;
 #if defined (__x86_64__)
 extern void __test_function(volatile long *ptr);
 asm (
+	".pushsection .text;"
 	".globl __test_function\n"
+	".type __test_function, @function;"
 	"__test_function:\n"
 	"incq (%rdi)\n"
-	"ret\n");
+	"ret\n"
+	".popsection\n");
 #else
 static void __test_function(volatile long *ptr)
 {
-- 
2.25.1



