Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 397BA79805
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389308AbfG2TmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:42:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:57956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389290AbfG2TmQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:42:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7700220C01;
        Mon, 29 Jul 2019 19:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429336;
        bh=Mt3rxP5j/KBt/R08xubLFerAOhYk7oa71VRYwJkBrrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SDYcaVcflHmtbD+tu5eEbYZ7RdeY2IHUqaYsrpOSN4XPeGsP1bRdYGTvHnXnjJE3y
         lmZQ5ZRQAOmExpsW/Ym3I1SGFm72UPrh+/F85Vty48+Frq0Cn9h2bn92ZGNDAS2I+P
         sbf/ZqEbUFE9cf9yPz6vybRfLjGHiARnJ6xKHWLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Gorbik <gor@linux.ibm.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 064/113] kallsyms: exclude kasan local symbols on s390
Date:   Mon, 29 Jul 2019 21:22:31 +0200
Message-Id: <20190729190710.822245021@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190655.455345569@linuxfoundation.org>
References: <20190729190655.455345569@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 33177f01ca3fe550146bb9001bec2fd806b2f40c ]

gcc asan instrumentation emits the following sequence to store frame pc
when the kernel is built with CONFIG_RELOCATABLE:
debug/vsprintf.s:
        .section        .data.rel.ro.local,"aw"
        .align  8
.LC3:
        .quad   .LASANPC4826@GOTOFF
.text
        .align  8
        .type   number, @function
number:
.LASANPC4826:

and in case reloc is issued for LASANPC label it also gets into .symtab
with the same address as actual function symbol:
$ nm -n vmlinux | grep 0000000001397150
0000000001397150 t .LASANPC4826
0000000001397150 t number

In the end kernel backtraces are almost unreadable:
[  143.748476] Call Trace:
[  143.748484] ([<000000002da3e62c>] .LASANPC2671+0x114/0x190)
[  143.748492]  [<000000002eca1a58>] .LASANPC2612+0x110/0x160
[  143.748502]  [<000000002de9d830>] print_address_description+0x80/0x3b0
[  143.748511]  [<000000002de9dd64>] __kasan_report+0x15c/0x1c8
[  143.748521]  [<000000002ecb56d4>] strrchr+0x34/0x60
[  143.748534]  [<000003ff800a9a40>] kasan_strings+0xb0/0x148 [test_kasan]
[  143.748547]  [<000003ff800a9bba>] kmalloc_tests_init+0xe2/0x528 [test_kasan]
[  143.748555]  [<000000002da2117c>] .LASANPC4069+0x354/0x748
[  143.748563]  [<000000002dbfbb16>] do_init_module+0x136/0x3b0
[  143.748571]  [<000000002dbff3f4>] .LASANPC3191+0x2164/0x25d0
[  143.748580]  [<000000002dbffc4c>] .LASANPC3196+0x184/0x1b8
[  143.748587]  [<000000002ecdf2ec>] system_call+0xd8/0x2d8

Since LASANPC labels are not even unique and get into .symtab only due
to relocs filter them out in kallsyms.

Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kallsyms.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 0c9c54b57515..31ed7f3f0e15 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -152,6 +152,9 @@ static int read_symbol(FILE *in, struct sym_entry *s)
 	/* exclude debugging symbols */
 	else if (stype == 'N' || stype == 'n')
 		return -1;
+	/* exclude s390 kasan local symbols */
+	else if (!strncmp(sym, ".LASANPC", 8))
+		return -1;
 
 	/* include the type field in the symbol name, so that it gets
 	 * compressed together */
-- 
2.20.1



