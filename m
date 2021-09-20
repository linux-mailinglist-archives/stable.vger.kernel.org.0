Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71CB241207E
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347245AbhITRzt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:55:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:54630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349458AbhITRwu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:52:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A7546140A;
        Mon, 20 Sep 2021 17:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157985;
        bh=rSes+fkgNcdnRhQdFfMj5NVACGIdVJzrMcuJwL51u4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GEX98TFzjvXfrQZXe4AdZoR090FIilbElwIMjk2AK/phShRSe9uIN3SjO6t1/O9cX
         15xJlXoqQxLeNHXq15uPj/ZX12UWttAiu7eZ7eqrmHZVYGQP95feI96jT6+lo2L+EF
         kzRSnuQfxu4AEWBMgCK3yiN9lmuxgvz5jj3JpDMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 4.19 241/293] parisc: fix crash with signals and alloca
Date:   Mon, 20 Sep 2021 18:43:23 +0200
Message-Id: <20210920163941.644286313@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 030f653078316a9cc9ca6bd1b0234dcf858be35d upstream.

I was debugging some crashes on parisc and I found out that there is a
crash possibility if a function using alloca is interrupted by a signal.
The reason for the crash is that the gcc alloca implementation leaves
garbage in the upper 32 bits of the sp register. This normally doesn't
matter (the upper bits are ignored because the PSW W-bit is clear),
however the signal delivery routine in the kernel uses full 64 bits of sp
and it fails with -EFAULT if the upper 32 bits are not zero.

I created this program that demonstrates the problem:

#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <alloca.h>

static __attribute__((noinline,noclone)) void aa(int *size)
{
	void * volatile p = alloca(-*size);
	while (1) ;
}

static void handler(int sig)
{
	write(1, "signal delivered\n", 17);
	_exit(0);
}

int main(void)
{
	int size = -0x100;
	signal(SIGALRM, handler);
	alarm(1);
	aa(&size);
}

If you compile it with optimizations, it will crash.
The "aa" function has this disassembly:

000106a0 <aa>:
   106a0:       08 03 02 41     copy r3,r1
   106a4:       08 1e 02 43     copy sp,r3
   106a8:       6f c1 00 80     stw,ma r1,40(sp)
   106ac:       37 dc 3f c1     ldo -20(sp),ret0
   106b0:       0c 7c 12 90     stw ret0,8(r3)
   106b4:       0f 40 10 9c     ldw 0(r26),ret0		; ret0 = 0x00000000FFFFFF00
   106b8:       97 9c 00 7e     subi 3f,ret0,ret0	; ret0 = 0xFFFFFFFF0000013F
   106bc:       d7 80 1c 1a     depwi 0,31,6,ret0	; ret0 = 0xFFFFFFFF00000100
   106c0:       0b 9e 0a 1e     add,l sp,ret0,sp	;   sp = 0xFFFFFFFFxxxxxxxx
   106c4:       e8 1f 1f f7     b,l,n 106c4 <aa+0x24>,r0

This patch fixes the bug by truncating the "usp" variable to 32 bits.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/signal.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/parisc/kernel/signal.c
+++ b/arch/parisc/kernel/signal.c
@@ -239,6 +239,12 @@ setup_rt_frame(struct ksignal *ksig, sig
 #endif
 	
 	usp = (regs->gr[30] & ~(0x01UL));
+#ifdef CONFIG_64BIT
+	if (is_compat_task()) {
+		/* The gcc alloca implementation leaves garbage in the upper 32 bits of sp */
+		usp = (compat_uint_t)usp;
+	}
+#endif
 	/*FIXME: frame_size parameter is unused, remove it. */
 	frame = get_sigframe(&ksig->ka, usp, sizeof(*frame));
 


