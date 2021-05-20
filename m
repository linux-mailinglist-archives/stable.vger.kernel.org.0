Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6430038A5E8
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234049AbhETKVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:21:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:51994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236304AbhETKT3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:19:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E05AF619B3;
        Thu, 20 May 2021 09:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504027;
        bh=AxwVTSf5DngS8L2lA+nW56nje2oa08i1MY9gDI/Oxf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EqhnhtpT81ZKHjEfCj22nOTMrBHZ9zWtSEdXEiKpu8O8+Q4+i1NNeu4YR8MesDqA4
         wurtBO64EE69X6+1rK31YGhYDChC4N4euJ3q51xN5GteKXxjfxZCoN1cwzPZCCNi9X
         +R8bZVRm5ugN6UyyvviXjMWtWxSFfUeNECfeXKj4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 4.14 017/323] s390/disassembler: increase ebpf disasm buffer size
Date:   Thu, 20 May 2021 11:18:29 +0200
Message-Id: <20210520092120.707299699@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

commit 6f3353c2d2b3eb4de52e9704cb962712033db181 upstream.

Current ebpf disassembly buffer size of 64 is too small. E.g. this line
takes 65 bytes:
01fffff8005822e: ec8100ed8065\tclgrj\t%r8,%r1,8,001fffff80058408\n\0

Double the buffer size like it is done for the kernel disassembly buffer.

Fixes the following KASAN finding:

UG: KASAN: stack-out-of-bounds in print_fn_code+0x34c/0x380
Write of size 1 at addr 001fff800ad5f970 by task test_progs/853

CPU: 53 PID: 853 Comm: test_progs Not tainted
5.12.0-rc7-23786-g23457d86b1f0-dirty #19
Hardware name: IBM 3906 M04 704 (LPAR)
Call Trace:
 [<0000000cd8e0538a>] show_stack+0x17a/0x1668
 [<0000000cd8e2a5d8>] dump_stack+0x140/0x1b8
 [<0000000cd8e16e74>] print_address_description.constprop.0+0x54/0x260
 [<0000000cd75a8698>] kasan_report+0xc8/0x130
 [<0000000cd6e26da4>] print_fn_code+0x34c/0x380
 [<0000000cd6ea0f4e>] bpf_int_jit_compile+0xe3e/0xe58
 [<0000000cd72c4c88>] bpf_prog_select_runtime+0x5b8/0x9c0
 [<0000000cd72d1bf8>] bpf_prog_load+0xa78/0x19c0
 [<0000000cd72d7ad6>] __do_sys_bpf.part.0+0x18e/0x768
 [<0000000cd6e0f392>] do_syscall+0x12a/0x220
 [<0000000cd8e333f8>] __do_syscall+0x98/0xc8
 [<0000000cd8e54834>] system_call+0x6c/0x94
1 lock held by test_progs/853:
 #0: 0000000cd9bf7460 (report_lock){....}-{2:2}, at:
     kasan_report+0x96/0x130

addr 001fff800ad5f970 is located in stack of task test_progs/853 at
offset 96 in frame:
 print_fn_code+0x0/0x380
this frame has 1 object:
 [32, 96) 'buffer'

Memory state around the buggy address:
 001fff800ad5f800: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 001fff800ad5f880: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>001fff800ad5f900: 00 00 f1 f1 f1 f1 00 00 00 00 00 00 00 00 f3 f3
                                                             ^
 001fff800ad5f980: f3 f3 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 001fff800ad5fa00: 00 00 00 00 00 00 00 f1 f1 f1 f1 00 00 00 00 00

Cc: <stable@vger.kernel.org>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/dis.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/kernel/dis.c
+++ b/arch/s390/kernel/dis.c
@@ -2026,7 +2026,7 @@ void show_code(struct pt_regs *regs)
 
 void print_fn_code(unsigned char *code, unsigned long len)
 {
-	char buffer[64], *ptr;
+	char buffer[128], *ptr;
 	int opsize, i;
 
 	while (len) {


