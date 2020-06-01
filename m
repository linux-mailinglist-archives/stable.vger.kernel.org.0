Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 461111EA8E8
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 19:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728817AbgFAR5D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 13:57:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728807AbgFAR5B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 13:57:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A9A92085B;
        Mon,  1 Jun 2020 17:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034220;
        bh=GpWa1GaeAr8n5dw6/FOWbgmhDIEAfSTzn9TttsI97NU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M4cjncXs7tfJHLzJ/TLpwFjiJKY23roo9u355OhhIo+mO4yzD8Kh0EBk/aoo6nam2
         58vK105ts6o8xpyCJQ/0s12BgJ2d5sznSrv4bFOOkQXohEtoNSRwgl170N5G2ML3K9
         Q7XC4pZQAf2rNuFx/Jiu+iku2kUJqUCI56qbBRLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Borowski <kilobyte@angband.pl>,
        Michal Marek <mmarek@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH 4.4 46/48] asm-prototypes: Clear any CPP defines before declaring the functions
Date:   Mon,  1 Jun 2020 19:53:56 +0200
Message-Id: <20200601174005.209348116@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601173952.175939894@linuxfoundation.org>
References: <20200601173952.175939894@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Marek <mmarek@suse.com>

commit c7858bf16c0b2cc62f475f31e6df28c3a68da1d6 upstream.

The asm-prototypes.h file is used to provide dummy function declarations
for genksyms, when processing asm files with EXPORT_SYMBOL. Make sure
that any architecture defines get out of our way. x86 currently has an
issue with memcpy on 64bit with CONFIG_KMEMCHECK=y and with
memset/__memset on 32bit:

	$ cat init/test.c
	#include <asm/asm-prototypes.h>
	$ make -s init/test.o
	In file included from ./arch/x86/include/asm/string.h:4:0,
			 from ./include/linux/string.h:18,
			 from ./include/linux/bitmap.h:8,
			 from ./include/linux/cpumask.h:11,
			 from ./arch/x86/include/asm/cpumask.h:4,
			 from ./arch/x86/include/asm/msr.h:10,
			 from ./arch/x86/include/asm/processor.h:20,
			 from ./arch/x86/include/asm/cpufeature.h:4,
			 from ./arch/x86/include/asm/thread_info.h:52,
			 from ./include/linux/thread_info.h:25,
			 from ./arch/x86/include/asm/preempt.h:6,
			 from ./include/linux/preempt.h:59,
			 from ./include/linux/spinlock.h:50,
			 from ./include/linux/seqlock.h:35,
			 from ./include/linux/time.h:5,
			 from ./include/uapi/linux/timex.h:56,
			 from ./include/linux/timex.h:56,
			 from ./include/linux/sched.h:19,
			 from ./include/linux/uaccess.h:4,
			 from ./arch/x86/include/asm/asm-prototypes.h:2,
			 from init/test.c:1:
	./arch/x86/include/asm/string_64.h:52:47: error: expected declaration specifiers or ‘...’ before ‘(’ token
	 #define memcpy(dst, src, len) __inline_memcpy((dst), (src), (len))
	 ./include/asm-generic/asm-prototypes.h:6:14: note: in expansion of macro ‘memcpy’
	  extern void *memcpy(void *, const void *, __kernel_size_t);

						       ^
	...

During real build, this manifests itself by genksyms segfaulting.

Fixes: 334bb7738764 ("x86/kbuild: enable modversions for symbols exported from asm")
Reported-and-tested-by: Borislav Petkov <bp@alien8.de>
Cc: Adam Borowski <kilobyte@angband.pl>
Signed-off-by: Michal Marek <mmarek@suse.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/asm-generic/asm-prototypes.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/include/asm-generic/asm-prototypes.h
+++ b/include/asm-generic/asm-prototypes.h
@@ -1,7 +1,13 @@
 #include <linux/bitops.h>
+#undef __memset
 extern void *__memset(void *, int, __kernel_size_t);
+#undef __memcpy
 extern void *__memcpy(void *, const void *, __kernel_size_t);
+#undef __memmove
 extern void *__memmove(void *, const void *, __kernel_size_t);
+#undef memset
 extern void *memset(void *, int, __kernel_size_t);
+#undef memcpy
 extern void *memcpy(void *, const void *, __kernel_size_t);
+#undef memmove
 extern void *memmove(void *, const void *, __kernel_size_t);


