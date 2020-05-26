Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9E11D8709
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729977AbgERS3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:29:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:39068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729389AbgERRmM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:42:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4880C207C4;
        Mon, 18 May 2020 17:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823731;
        bh=qDmmf1H14DQGq38TlSbF7UeqBoaq2BFhXg9rvJ9XgF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0fK8xP5eW+LHUZJCNnvBiJZmw/oeaBuzZetbWwEPMsoEWvnrnvV7OBb4GGb6U5Hko
         tp2f5Yhde72eChXDyEPTn5CXEfObaLFrF38gZVQQJR9iC2NQgAEwEleLlTI+3F9vpy
         PMqy7cEI6Eu+K6ajdrjfhhraNkxfTrjySjEF5/xs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Ali Saidi <alisaidi@amazon.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Michal Hocko <mhocko@suse.com>,
        Matthew Wilcox <willy@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jann Horn <jannh@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 14/90] binfmt_elf: move brk out of mmap when doing direct loader exec
Date:   Mon, 18 May 2020 19:35:52 +0200
Message-Id: <20200518173454.108423305@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.930655662@linuxfoundation.org>
References: <20200518173450.930655662@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit bbdc6076d2e5d07db44e74c11b01a3e27ab90b32 upstream.

Commmit eab09532d400 ("binfmt_elf: use ELF_ET_DYN_BASE only for PIE"),
made changes in the rare case when the ELF loader was directly invoked
(e.g to set a non-inheritable LD_LIBRARY_PATH, testing new versions of
the loader), by moving into the mmap region to avoid both ET_EXEC and
PIE binaries.  This had the effect of also moving the brk region into
mmap, which could lead to the stack and brk being arbitrarily close to
each other.  An unlucky process wouldn't get its requested stack size
and stack allocations could end up scribbling on the heap.

This is illustrated here.  In the case of using the loader directly, brk
(so helpfully identified as "[heap]") is allocated with the _loader_ not
the binary.  For example, with ASLR entirely disabled, you can see this
more clearly:

$ /bin/cat /proc/self/maps
555555554000-55555555c000 r-xp 00000000 ... /bin/cat
55555575b000-55555575c000 r--p 00007000 ... /bin/cat
55555575c000-55555575d000 rw-p 00008000 ... /bin/cat
55555575d000-55555577e000 rw-p 00000000 ... [heap]
...
7ffff7ff7000-7ffff7ffa000 r--p 00000000 ... [vvar]
7ffff7ffa000-7ffff7ffc000 r-xp 00000000 ... [vdso]
7ffff7ffc000-7ffff7ffd000 r--p 00027000 ... /lib/x86_64-linux-gnu/ld-2.27.so
7ffff7ffd000-7ffff7ffe000 rw-p 00028000 ... /lib/x86_64-linux-gnu/ld-2.27.so
7ffff7ffe000-7ffff7fff000 rw-p 00000000 ...
7ffffffde000-7ffffffff000 rw-p 00000000 ... [stack]

$ /lib/x86_64-linux-gnu/ld-2.27.so /bin/cat /proc/self/maps
...
7ffff7bcc000-7ffff7bd4000 r-xp 00000000 ... /bin/cat
7ffff7bd4000-7ffff7dd3000 ---p 00008000 ... /bin/cat
7ffff7dd3000-7ffff7dd4000 r--p 00007000 ... /bin/cat
7ffff7dd4000-7ffff7dd5000 rw-p 00008000 ... /bin/cat
7ffff7dd5000-7ffff7dfc000 r-xp 00000000 ... /lib/x86_64-linux-gnu/ld-2.27.so
7ffff7fb2000-7ffff7fd6000 rw-p 00000000 ...
7ffff7ff7000-7ffff7ffa000 r--p 00000000 ... [vvar]
7ffff7ffa000-7ffff7ffc000 r-xp 00000000 ... [vdso]
7ffff7ffc000-7ffff7ffd000 r--p 00027000 ... /lib/x86_64-linux-gnu/ld-2.27.so
7ffff7ffd000-7ffff7ffe000 rw-p 00028000 ... /lib/x86_64-linux-gnu/ld-2.27.so
7ffff7ffe000-7ffff8020000 rw-p 00000000 ... [heap]
7ffffffde000-7ffffffff000 rw-p 00000000 ... [stack]

The solution is to move brk out of mmap and into ELF_ET_DYN_BASE since
nothing is there in the direct loader case (and ET_EXEC is still far
away at 0x400000).  Anything that ran before should still work (i.e.
the ultimately-launched binary already had the brk very far from its
text, so this should be no different from a COMPAT_BRK standpoint).  The
only risk I see here is that if someone started to suddenly depend on
the entire memory space lower than the mmap region being available when
launching binaries via a direct loader execs which seems highly
unlikely, I'd hope: this would mean a binary would _not_ work when
exec()ed normally.

(Note that this is only done under CONFIG_ARCH_HAS_ELF_RANDOMIZATION
when randomization is turned on.)

Link: http://lkml.kernel.org/r/20190422225727.GA21011@beast
Link: https://lkml.kernel.org/r/CAGXu5jJ5sj3emOT2QPxQkNQk0qbU6zEfu9=Omfhx_p0nCKPSjA@mail.gmail.com
Fixes: eab09532d400 ("binfmt_elf: use ELF_ET_DYN_BASE only for PIE")
Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Ali Saidi <alisaidi@amazon.com>
Cc: Ali Saidi <alisaidi@amazon.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/binfmt_elf.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1100,6 +1100,17 @@ static int load_elf_binary(struct linux_
 	current->mm->start_stack = bprm->p;
 
 	if ((current->flags & PF_RANDOMIZE) && (randomize_va_space > 1)) {
+		/*
+		 * For architectures with ELF randomization, when executing
+		 * a loader directly (i.e. no interpreter listed in ELF
+		 * headers), move the brk area out of the mmap region
+		 * (since it grows up, and may collide early with the stack
+		 * growing down), and into the unused ELF_ET_DYN_BASE region.
+		 */
+		if (IS_ENABLED(CONFIG_ARCH_HAS_ELF_RANDOMIZE) && !interpreter)
+			current->mm->brk = current->mm->start_brk =
+				ELF_ET_DYN_BASE;
+
 		current->mm->brk = current->mm->start_brk =
 			arch_randomize_brk(current->mm);
 #ifdef compat_brk_randomized


