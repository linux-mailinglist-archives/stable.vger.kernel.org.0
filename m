Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 260443F1954
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 14:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239054AbhHSMbw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 08:31:52 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:8886 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232676AbhHSMbv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Aug 2021 08:31:51 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Gr3tP4jmYz8sWS;
        Thu, 19 Aug 2021 20:27:09 +0800 (CST)
Received: from dggpemm500002.china.huawei.com (7.185.36.229) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 19 Aug 2021 20:31:13 +0800
Received: from linux-ibm.site (10.175.102.37) by
 dggpemm500002.china.huawei.com (7.185.36.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 19 Aug 2021 20:31:13 +0800
From:   Hanjun Guo <guohanjun@huawei.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, <stable@vger.kernel.org>
CC:     =?UTF-8?q?Martin=20Li=C5=A1ka?= <mliska@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH 5.10.y 5/6] perf annotate: Fix jump parsing for C++ code.
Date:   Thu, 19 Aug 2021 20:19:11 +0800
Message-ID: <1629375552-51897-6-git-send-email-guohanjun@huawei.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1629375552-51897-1-git-send-email-guohanjun@huawei.com>
References: <1629375552-51897-1-git-send-email-guohanjun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.102.37]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500002.china.huawei.com (7.185.36.229)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Liška <mliska@suse.cz>

commit 1f0e6edcd968ff19211245f7da6039e983aa51e5 upstream.

Considering the following testcase:

  int
  foo(int a, int b)
  {
     for (unsigned i = 0; i < 1000000000; i++)
       a += b;
     return a;
  }

  int main()
  {
     foo (3, 4);
     return 0;
  }

'perf annotate' displays:

  86.52 │40055e: → ja   40056c <foo(int, int)+0x26>
  13.37 │400560:   mov  -0x18(%rbp),%eax
        │400563:   add  %eax,-0x14(%rbp)
        │400566:   addl $0x1,-0x4(%rbp)
   0.11 │40056a: → jmp  400557 <foo(int, int)+0x11>
        │40056c:   mov  -0x14(%rbp),%eax
        │40056f:   pop  %rbp

and the 'ja 40056c' does not link to the location in the function.  It's
caused by fact that comma is wrongly parsed, it's part of function
signature.

With my patch I see:

  86.52 │   ┌──ja   26
  13.37 │   │  mov  -0x18(%rbp),%eax
        │   │  add  %eax,-0x14(%rbp)
        │   │  addl $0x1,-0x4(%rbp)
   0.11 │   │↑ jmp  11
        │26:└─→mov  -0x14(%rbp),%eax

and 'o' output prints:

  86.52 │4005┌── ↓ ja   40056c <foo(int, int)+0x26>
  13.37 │4005│0:   mov  -0x18(%rbp),%eax
        │4005│3:   add  %eax,-0x14(%rbp)
        │4005│6:   addl $0x1,-0x4(%rbp)
   0.11 │4005│a: ↑ jmp  400557 <foo(int, int)+0x11>
        │4005└─→   mov  -0x14(%rbp),%eax

On the contrary, compiling the very same file with gcc -x c, the parsing
is fine because function arguments are not displayed:

  jmp  400543 <foo+0x1d>

Committer testing:

Before:

  $ cat cpp_args_annotate.c
  int
  foo(int a, int b)
  {
     for (unsigned i = 0; i < 1000000000; i++)
       a += b;
     return a;
  }

  int main()
  {
     foo (3, 4);
     return 0;
  }
  $ gcc --version |& head -1
  gcc (GCC) 10.2.1 20201125 (Red Hat 10.2.1-9)
  $ gcc -g cpp_args_annotate.c -o cpp_args_annotate
  $ perf record ./cpp_args_annotate
  [ perf record: Woken up 2 times to write data ]
  [ perf record: Captured and wrote 0.275 MB perf.data (7188 samples) ]
  $ perf annotate --stdio2 foo
  Samples: 7K of event 'cycles:u', 4000 Hz, Event count (approx.): 7468429289, [percent: local period]
  foo() /home/acme/c/cpp_args_annotate
  Percent
              0000000000401106 <foo>:
              foo():
              int
              foo(int a, int b)
              {
                push %rbp
                mov  %rsp,%rbp
                mov  %edi,-0x14(%rbp)
                mov  %esi,-0x18(%rbp)
              for (unsigned i = 0; i < 1000000000; i++)
                movl $0x0,-0x4(%rbp)
              ↓ jmp  1d
              a += b;
   13.45  13:   mov  -0x18(%rbp),%eax
                add  %eax,-0x14(%rbp)
              for (unsigned i = 0; i < 1000000000; i++)
                addl $0x1,-0x4(%rbp)
    0.09  1d:   cmpl $0x3b9ac9ff,-0x4(%rbp)
   86.46      ↑ jbe  13
              return a;
                mov  -0x14(%rbp),%eax
              }
                pop  %rbp
              ← retq
  $

I.e. works for C, now lets switch to C++:

  $ g++ -g cpp_args_annotate.c -o cpp_args_annotate
  $ perf record ./cpp_args_annotate
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.268 MB perf.data (6976 samples) ]
  $ perf annotate --stdio2 foo
  Samples: 6K of event 'cycles:u', 4000 Hz, Event count (approx.): 7380681761, [percent: local period]
  foo() /home/acme/c/cpp_args_annotate
  Percent
              0000000000401106 <foo(int, int)>:
              foo(int, int):
              int
              foo(int a, int b)
              {
                push %rbp
                mov  %rsp,%rbp
                mov  %edi,-0x14(%rbp)
                mov  %esi,-0x18(%rbp)
              for (unsigned i = 0; i < 1000000000; i++)
                movl $0x0,-0x4(%rbp)
                cmpl $0x3b9ac9ff,-0x4(%rbp)
   86.53      → ja   40112c <foo(int, int)+0x26>
              a += b;
   13.32        mov  -0x18(%rbp),%eax
    0.00        add  %eax,-0x14(%rbp)
              for (unsigned i = 0; i < 1000000000; i++)
                addl $0x1,-0x4(%rbp)
    0.15      → jmp  401117 <foo(int, int)+0x11>
              return a;
                mov  -0x14(%rbp),%eax
              }
                pop  %rbp
              ← retq
  $

Reproduced.

Now with this patch:

Reusing the C++ built binary, as we can see here:

  $ readelf -wi cpp_args_annotate | grep producer
    <c>   DW_AT_producer    : (indirect string, offset: 0x2e): GNU C++14 10.2.1 20201125 (Red Hat 10.2.1-9) -mtune=generic -march=x86-64 -g
  $

And furthermore:

  $ file cpp_args_annotate
  cpp_args_annotate: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, BuildID[sha1]=4fe3cab260204765605ec630d0dc7a7e93c361a9, for GNU/Linux 3.2.0, with debug_info, not stripped
  $ perf buildid-list -i cpp_args_annotate
  4fe3cab260204765605ec630d0dc7a7e93c361a9
  $ perf buildid-list | grep cpp_args_annotate
  4fe3cab260204765605ec630d0dc7a7e93c361a9 /home/acme/c/cpp_args_annotate
  $

It now works:

  $ perf annotate --stdio2 foo
  Samples: 6K of event 'cycles:u', 4000 Hz, Event count (approx.): 7380681761, [percent: local period]
  foo() /home/acme/c/cpp_args_annotate
  Percent
              0000000000401106 <foo(int, int)>:
              foo(int, int):
              int
              foo(int a, int b)
              {
                push %rbp
                mov  %rsp,%rbp
                mov  %edi,-0x14(%rbp)
                mov  %esi,-0x18(%rbp)
              for (unsigned i = 0; i < 1000000000; i++)
                movl $0x0,-0x4(%rbp)
          11:   cmpl $0x3b9ac9ff,-0x4(%rbp)
   86.53      ↓ ja   26
              a += b;
   13.32        mov  -0x18(%rbp),%eax
    0.00        add  %eax,-0x14(%rbp)
              for (unsigned i = 0; i < 1000000000; i++)
                addl $0x1,-0x4(%rbp)
    0.15      ↑ jmp  11
              return a;
          26:   mov  -0x14(%rbp),%eax
              }
                pop  %rbp
              ← retq
  $

Signed-off-by: Martin Liška <mliska@suse.cz>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Link: http://lore.kernel.org/lkml/13e1a405-edf9-e4c2-4327-a9b454353730@suse.cz
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
---
 tools/perf/util/annotate.c | 8 ++++++++
 tools/perf/util/annotate.h | 1 +
 2 files changed, 9 insertions(+)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 6c8575e..3081894 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -317,12 +317,18 @@ bool ins__is_call(const struct ins *ins)
 /*
  * Prevents from matching commas in the comment section, e.g.:
  * ffff200008446e70:       b.cs    ffff2000084470f4 <generic_exec_single+0x314>  // b.hs, b.nlast
+ *
+ * and skip comma as part of function arguments, e.g.:
+ * 1d8b4ac <linemap_lookup(line_maps const*, unsigned int)+0xcc>
  */
 static inline const char *validate_comma(const char *c, struct ins_operands *ops)
 {
 	if (ops->raw_comment && c > ops->raw_comment)
 		return NULL;
 
+	if (ops->raw_func_start && c > ops->raw_func_start)
+		return NULL;
+
 	return c;
 }
 
@@ -337,6 +343,8 @@ static int jump__parse(struct arch *arch, struct ins_operands *ops, struct map_s
 	u64 start, end;
 
 	ops->raw_comment = strchr(ops->raw, arch->objdump.comment_char);
+	ops->raw_func_start = strchr(ops->raw, '<');
+
 	c = validate_comma(c, ops);
 
 	/*
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 0a0cd4f..096cdaf 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -32,6 +32,7 @@ struct ins {
 struct ins_operands {
 	char	*raw;
 	char	*raw_comment;
+	char	*raw_func_start;
 	struct {
 		char	*raw;
 		char	*name;
-- 
1.7.12.4

