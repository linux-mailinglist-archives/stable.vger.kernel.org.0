Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70AA042FFCD
	for <lists+stable@lfdr.de>; Sat, 16 Oct 2021 05:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239711AbhJPDFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 23:05:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:42194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239704AbhJPDFB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Oct 2021 23:05:01 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BE3861278;
        Sat, 16 Oct 2021 03:02:54 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@goodmis.org>)
        id 1mbZyH-006ZV1-8O; Fri, 15 Oct 2021 23:02:53 -0400
Message-ID: <20211016030253.098208133@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 15 Oct 2021 23:02:29 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Greentime Hu <green.hu@gmail.com>
Subject: [for-linus][PATCH 7/7] nds32/ftrace: Fix Error: invalid operands (*UND* and *UND* sections)
 for `^
References: <20211016030222.926060517@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

I received a build failure for a new patch I'm working on the nds32
architecture, and when I went to test it, I couldn't get to my build error,
because it failed to build with a bunch of:

  Error: invalid operands (*UND* and *UND* sections) for `^'

issues with various files. Those files were temporary asm files that looked
like:  kernel/.tmp_mc_fork.s

I decided to look deeper, and found that the "mc" portion of that name
stood for "mcount", and was created by the recordmcount.pl script. One that
I wrote over a decade ago. Once I knew the source of the problem, I was
able to investigate it further.

The way the recordmcount.pl script works (BTW, there's a C version that
simply modifies the ELF object) is by doing an "objdump" on the object
file. Looks for all the calls to "mcount", and creates an offset of those
locations from some global variable it can use (usually a global function
name, found with <.*>:). Creates a asm file that is a table of references
to these locations, using the found variable/function. Compiles it and
links it back into the original object file. This asm file is called
".tmp_mc_<object_base_name>.s".

The problem here is that the objdump produced by the nds32 object file,
contains things that look like:

 0000159a <.L3^B1>:
    159a:       c6 00           beqz38 $r6, 159a <.L3^B1>
                        159a: R_NDS32_9_PCREL_RELA      .text+0x159e
    159c:       84 d2           movi55 $r6, #-14
    159e:       80 06           mov55 $r0, $r6
    15a0:       ec 3c           addi10.sp #0x3c

Where ".L3^B1 is somehow selected as the "global" variable to index off of.

Then the assembly file that holds the mcount locations looks like this:

        .section __mcount_loc,"a",@progbits
        .align 2
        .long .L3^B1 + -5522
        .long .L3^B1 + -5384
        .long .L3^B1 + -5270
        .long .L3^B1 + -5098
        .long .L3^B1 + -4970
        .long .L3^B1 + -4758
        .long .L3^B1 + -4122
        [...]

And when it is compiled back to an object to link to the original object,
the compile fails on the "^" symbol.

Simple solution for now, is to have the perl script ignore using function
symbols that have an "^" in the name.

Link: https://lkml.kernel.org/r/20211014143507.4ad2c0f7@gandalf.local.home

Cc: stable@vger.kernel.org
Acked-by: Greentime Hu <green.hu@gmail.com>
Fixes: fbf58a52ac088 ("nds32/ftrace: Add RECORD_MCOUNT support")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 scripts/recordmcount.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 8f6b13ae46bf..7d631aaa0ae1 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -189,7 +189,7 @@ if ($arch =~ /(x86(_64)?)|(i386)/) {
 $local_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\S+)";
 $weak_regex = "^[0-9a-fA-F]+\\s+([wW])\\s+(\\S+)";
 $section_regex = "Disassembly of section\\s+(\\S+):";
-$function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
+$function_regex = "^([0-9a-fA-F]+)\\s+<([^^]*?)>:";
 $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s(mcount|__fentry__)\$";
 $section_type = '@progbits';
 $mcount_adjust = 0;
-- 
2.32.0
