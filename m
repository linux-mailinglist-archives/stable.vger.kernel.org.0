Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47038431B44
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232506AbhJRNb7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:31:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232509AbhJRNaS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:30:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20EB861352;
        Mon, 18 Oct 2021 13:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563687;
        bh=6Vp21lSexe6z120mdDelmfwJ35ap7XXTqN+VwLxH3y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oqV7SbQQicAeUhKIiDN7miXlzmyKfUYQ9iyjKsVsnQGWEQxF3NlMHTERQLRDRC38V
         HNLU+Ii8e47by44OaJecMyi8tUJxx9hnLGcDF2qKbS83u3gihsqSkXGyorSwarpwDf
         VzsjZnwI+DFPRUoF/l78jEqmgbOuqiMyC7wE9xVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Greentime Hu <green.hu@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.19 05/50] nds32/ftrace: Fix Error: invalid operands (*UND* and *UND* sections) for `^
Date:   Mon, 18 Oct 2021 15:24:12 +0200
Message-Id: <20211018132326.703373091@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132326.529486647@linuxfoundation.org>
References: <20211018132326.529486647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

commit be358af1191b1b2fedebd8f3421cafdc8edacc7d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/recordmcount.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -222,7 +222,7 @@ if ($arch =~ /(x86(_64)?)|(i386)/) {
 $local_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\S+)";
 $weak_regex = "^[0-9a-fA-F]+\\s+([wW])\\s+(\\S+)";
 $section_regex = "Disassembly of section\\s+(\\S+):";
-$function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
+$function_regex = "^([0-9a-fA-F]+)\\s+<([^^]*?)>:";
 $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s(mcount|__fentry__)\$";
 $section_type = '@progbits';
 $mcount_adjust = 0;


