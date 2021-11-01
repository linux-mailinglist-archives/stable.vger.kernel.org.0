Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE6344174C
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233077AbhKAJfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:35:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:37040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232650AbhKAJcP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:32:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E90D611AD;
        Mon,  1 Nov 2021 09:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758670;
        bh=fPPyFN4wlEqeVkHFMiXw4QGG3iEQcdsgYbJ3w6dkcsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JqzhqaaU32fuV7I5QlDGD9p2crtUZwVczFI6g5xaNz+BczAcfDe3+k4qIyBwxLkan
         dWnmh5QEYZQzWRUVlEWJ+w3OSoiZhJ2qFNQp+wN3WbC9yjzVQUBpJDQvP0bSu6Ydux
         hp+S6GHJSipPApSsVHT3QuBOOQXWeOJmYa9zVAQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lexi Shao <shaolexi@huawei.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 5.10 01/77] ARM: 9132/1: Fix __get_user_check failure with ARM KASAN images
Date:   Mon,  1 Nov 2021 10:16:49 +0100
Message-Id: <20211101082511.523745713@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082511.254155853@linuxfoundation.org>
References: <20211101082511.254155853@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lexi Shao <shaolexi@huawei.com>

commit df909df0770779f1a5560c2bb641a2809655ef28 upstream.

ARM: kasan: Fix __get_user_check failure with kasan

In macro __get_user_check defined in arch/arm/include/asm/uaccess.h,
error code is store in register int __e(r0). When kasan is
enabled, assigning value to kernel address might trigger kasan check,
which unexpectedly overwrites r0 and causes undefined behavior on arm
kasan images.

One example is failure in do_futex and results in process soft lockup.
Log:
watchdog: BUG: soft lockup - CPU#0 stuck for 62946ms! [rs:main
Q:Reg:1151]
...
(__asan_store4) from (futex_wait_setup+0xf8/0x2b4)
(futex_wait_setup) from (futex_wait+0x138/0x394)
(futex_wait) from (do_futex+0x164/0xe40)
(do_futex) from (sys_futex_time32+0x178/0x230)
(sys_futex_time32) from (ret_fast_syscall+0x0/0x50)

The soft lockup happens in function futex_wait_setup. The reason is
function get_futex_value_locked always return EINVAL, thus pc jump
back to retry label and causes looping.

This line in function get_futex_value_locked
	ret = __get_user(*dest, from);
is expanded to
	*dest = (typeof(*(p))) __r2; ,
in macro __get_user_check. Writing to pointer dest triggers kasan check
and overwrites the return value of __get_user_x function.
The assembly code of get_futex_value_locked in kernel/futex.c:
...
c01f6dc8:       eb0b020e        bl      c04b7608 <__get_user_4>
// "x = (typeof(*(p))) __r2;" triggers kasan check and r0 is overwritten
c01f6dCc:       e1a00007        mov     r0, r7
c01f6dd0:       e1a05002        mov     r5, r2
c01f6dd4:       eb04f1e6        bl      c0333574 <__asan_store4>
c01f6dd8:       e5875000        str     r5, [r7]
// save ret value of __get_user(*dest, from), which is dest address now
c01f6ddc:       e1a05000        mov     r5, r0
...
// checking return value of __get_user failed
c01f6e00:       e3550000        cmp     r5, #0
...
c01f6e0c:       01a00005        moveq   r0, r5
// assign return value to EINVAL
c01f6e10:       13e0000d        mvnne   r0, #13

Return value is the destination address of get_user thus certainly
non-zero, so get_futex_value_locked always return EINVAL.

Fix it by using a tmp vairable to store the error code before the
assignment. This fix has no effects to non-kasan images thanks to compiler
optimization. It only affects cases that overwrite r0 due to kasan check.

This should fix bug discussed in Link:
[1] https://lore.kernel.org/linux-arm-kernel/0ef7c2a5-5d8b-c5e0-63fa-31693fd4495c@gmail.com/

Fixes: 421015713b30 ("ARM: 9017/2: Enable KASan for ARM")
Signed-off-by: Lexi Shao <shaolexi@huawei.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/uaccess.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/arm/include/asm/uaccess.h
+++ b/arch/arm/include/asm/uaccess.h
@@ -200,6 +200,7 @@ extern int __get_user_64t_4(void *);
 		register unsigned long __l asm("r1") = __limit;		\
 		register int __e asm("r0");				\
 		unsigned int __ua_flags = uaccess_save_and_enable();	\
+		int __tmp_e;						\
 		switch (sizeof(*(__p))) {				\
 		case 1:							\
 			if (sizeof((x)) >= 8)				\
@@ -227,9 +228,10 @@ extern int __get_user_64t_4(void *);
 			break;						\
 		default: __e = __get_user_bad(); break;			\
 		}							\
+		__tmp_e = __e;						\
 		uaccess_restore(__ua_flags);				\
 		x = (typeof(*(p))) __r2;				\
-		__e;							\
+		__tmp_e;						\
 	})
 
 #define get_user(x, p)							\


