Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C098200C74
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 16:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388781AbgFSOp7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:45:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388778AbgFSOp5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:45:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4091620A8B;
        Fri, 19 Jun 2020 14:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577956;
        bh=+QMo37ufAabq0igFYA6n7M8KW0mBfbxQ1kaR5smOkdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bEoiC21D+uQvWmGLF8ATsJ0lvA8t/MccDukiz4RKdk+9JtHfE8Ckh/N+yiFMeVAyH
         +n8Nojgry4b44VdKwmdx+IJ+oIPII02vwUgfpSEaOWRYIhIpRijkDAqq6/CpsDI/2R
         u1FQ5O9jtydnXIWuwoZzLYXulnhMxt1NtpcEOs00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matt Turner <mattst88@gmail.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miles Chen <miles.chen@mediatek.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.14 004/190] Fix acccess_ok() on alpha and SH
Date:   Fri, 19 Jun 2020 16:30:49 +0200
Message-Id: <20200619141633.684100017@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
References: <20200619141633.446429600@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 94bd8a05cd4de344a9a57e52ef7d99550251984f upstream.

Commit 594cc251fdd0 ("make 'user_access_begin()' do 'access_ok()'")
broke both alpha and SH booting in qemu, as noticed by Guenter Roeck.

It turns out that the bug wasn't actually in that commit itself (which
would have been surprising: it was mostly a no-op), but in how the
addition of access_ok() to the strncpy_from_user() and strnlen_user()
functions now triggered the case where those functions would test the
access of the very last byte of the user address space.

The string functions actually did that user range test before too, but
they did it manually by just comparing against user_addr_max().  But
with user_access_begin() doing the check (using "access_ok()"), it now
exposed problems in the architecture implementations of that function.

For example, on alpha, the access_ok() helper macro looked like this:

  #define __access_ok(addr, size) \
        ((get_fs().seg & (addr | size | (addr+size))) == 0)

and what it basically tests is of any of the high bits get set (the
USER_DS masking value is 0xfffffc0000000000).

And that's completely wrong for the "addr+size" check.  Because it's
off-by-one for the case where we check to the very end of the user
address space, which is exactly what the strn*_user() functions do.

Why? Because "addr+size" will be exactly the size of the address space,
so trying to access the last byte of the user address space will fail
the __access_ok() check, even though it shouldn't.  As a result, the
user string accessor functions failed consistently - because they
literally don't know how long the string is going to be, and the max
access is going to be that last byte of the user address space.

Side note: that alpha macro is buggy for another reason too - it re-uses
the arguments twice.

And SH has another version of almost the exact same bug:

  #define __addr_ok(addr) \
        ((unsigned long __force)(addr) < current_thread_info()->addr_limit.seg)

so far so good: yes, a user address must be below the limit.  But then:

  #define __access_ok(addr, size)         \
        (__addr_ok((addr) + (size)))

is wrong with the exact same off-by-one case: the case when "addr+size"
is exactly _equal_ to the limit is actually perfectly fine (think "one
byte access at the last address of the user address space")

The SH version is actually seriously buggy in another way: it doesn't
actually check for overflow, even though it did copy the _comment_ that
talks about overflow.

So it turns out that both SH and alpha actually have completely buggy
implementations of access_ok(), but they happened to work in practice
(although the SH overflow one is a serious serious security bug, not
that anybody likely cares about SH security).

This fixes the problems by using a similar macro on both alpha and SH.
It isn't trying to be clever, the end address is based on this logic:

        unsigned long __ao_end = __ao_a + __ao_b - !!__ao_b;

which basically says "add start and length, and then subtract one unless
the length was zero".  We can't subtract one for a zero length, or we'd
just hit an underflow instead.

For a lot of access_ok() users the length is a constant, so this isn't
actually as expensive as it initially looks.

Reported-and-tested-by: Guenter Roeck <linux@roeck-us.net>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Miles Chen <miles.chen@mediatek.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/alpha/include/asm/uaccess.h |    8 +++++---
 arch/sh/include/asm/uaccess.h    |    7 +++++--
 2 files changed, 10 insertions(+), 5 deletions(-)

--- a/arch/alpha/include/asm/uaccess.h
+++ b/arch/alpha/include/asm/uaccess.h
@@ -30,11 +30,13 @@
  * Address valid if:
  *  - "addr" doesn't have any high-bits set
  *  - AND "size" doesn't have any high-bits set
- *  - AND "addr+size" doesn't have any high-bits set
+ *  - AND "addr+size-(size != 0)" doesn't have any high-bits set
  *  - OR we are in kernel mode.
  */
-#define __access_ok(addr, size) \
-	((get_fs().seg & (addr | size | (addr+size))) == 0)
+#define __access_ok(addr, size) ({				\
+	unsigned long __ao_a = (addr), __ao_b = (size);		\
+	unsigned long __ao_end = __ao_a + __ao_b - !!__ao_b;	\
+	(get_fs().seg & (__ao_a | __ao_b | __ao_end)) == 0; })
 
 #define access_ok(type, addr, size)			\
 ({							\
--- a/arch/sh/include/asm/uaccess.h
+++ b/arch/sh/include/asm/uaccess.h
@@ -16,8 +16,11 @@
  * sum := addr + size;  carry? --> flag = true;
  * if (sum >= addr_limit) flag = true;
  */
-#define __access_ok(addr, size)		\
-	(__addr_ok((addr) + (size)))
+#define __access_ok(addr, size)	({				\
+	unsigned long __ao_a = (addr), __ao_b = (size);		\
+	unsigned long __ao_end = __ao_a + __ao_b - !!__ao_b;	\
+	__ao_end >= __ao_a && __addr_ok(__ao_end); })
+
 #define access_ok(type, addr, size)	\
 	(__chk_user_ptr(addr),		\
 	 __access_ok((unsigned long __force)(addr), (size)))


