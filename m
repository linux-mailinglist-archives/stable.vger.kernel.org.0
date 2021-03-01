Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0B532903A
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242763AbhCAUDn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:03:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:58878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242522AbhCATxv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:53:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49AEA65364;
        Mon,  1 Mar 2021 17:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621235;
        bh=/6DgLW5qA0JxQ2bSEwc6oQ+ExbQqEPZfOPn9vpkTUiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hFOa5s+ti9XhIjrYfuTorxMGWYjTTs3p0+iI+/q6PEjaIE14hHmMcsd+rkvgFLJ3P
         3fnqf6X1YDLudi90jQQ5z1Pz0GFwZkYKs4T6tGFC1HdhkPb47ulhA0ZM6zfFe0H4dN
         Ivv3/Cr9t+YnNHTi+2rgbvToPv8XOCx7DiKRqUyU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 443/775] powerpc/uaccess: Avoid might_fault() when user access is enabled
Date:   Mon,  1 Mar 2021 17:10:11 +0100
Message-Id: <20210301161223.444826869@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

[ Upstream commit 7d506ca97b665b95e698a53697dad99fae813c1a ]

The amount of code executed with enabled user space access (unlocked
KUAP) should be minimal. However with CONFIG_PROVE_LOCKING or
CONFIG_DEBUG_ATOMIC_SLEEP enabled, might_fault() calls into various
parts of the kernel, and may even end up replaying interrupts which in
turn may access user space and forget to restore the KUAP state.

The problem places are:
  1. strncpy_from_user (and similar) which unlock KUAP and call
     unsafe_get_user -> __get_user_allowed -> __get_user_nocheck()
     with do_allow=false to skip KUAP as the caller took care of it.
  2. __unsafe_put_user_goto() which is called with unlocked KUAP.

eg:
  WARNING: CPU: 30 PID: 1 at arch/powerpc/include/asm/book3s/64/kup.h:324 arch_local_irq_restore+0x160/0x190
  NIP arch_local_irq_restore+0x160/0x190
  LR  lock_is_held_type+0x140/0x200
  Call Trace:
    0xc00000007f392ff8 (unreliable)
    ___might_sleep+0x180/0x320
    __might_fault+0x50/0xe0
    filldir64+0x2d0/0x5d0
    call_filldir+0xc8/0x180
    ext4_readdir+0x948/0xb40
    iterate_dir+0x1ec/0x240
    sys_getdents64+0x80/0x290
    system_call_exception+0x160/0x280
    system_call_common+0xf0/0x27c

Change __get_user_nocheck() to look at `do_allow` to decide whether to
skip might_fault(). Since strncpy_from_user/etc call might_fault()
anyway before unlocking KUAP, there should be no visible change.

Drop might_fault() in __unsafe_put_user_goto() as it is only called
from unsafe_put_user(), which already has KUAP unlocked.

Since keeping might_fault() is still desirable for debugging, add
calls to it in user_[read|write]_access_begin(). That also allows us
to drop the is_kernel_addr() test, because there should be no code
using user_[read|write]_access_begin() in order to access a kernel
address.

Fixes: de78a9c42a79 ("powerpc: Add a framework for Kernel Userspace Access Protection")
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
[mpe: Combine with related patch from myself, merge change logs]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210204121612.32721-1-aik@ozlabs.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/uaccess.h | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/uaccess.h b/arch/powerpc/include/asm/uaccess.h
index 501c9a79038c0..f53bfefb4a577 100644
--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -216,8 +216,6 @@ do {								\
 #define __put_user_nocheck_goto(x, ptr, size, label)		\
 do {								\
 	__typeof__(*(ptr)) __user *__pu_addr = (ptr);		\
-	if (!is_kernel_addr((unsigned long)__pu_addr))		\
-		might_fault();					\
 	__chk_user_ptr(ptr);					\
 	__put_user_size_goto((x), __pu_addr, (size), label);	\
 } while (0)
@@ -313,7 +311,7 @@ do {								\
 	__typeof__(size) __gu_size = (size);			\
 								\
 	__chk_user_ptr(__gu_addr);				\
-	if (!is_kernel_addr((unsigned long)__gu_addr))		\
+	if (do_allow && !is_kernel_addr((unsigned long)__gu_addr)) \
 		might_fault();					\
 	barrier_nospec();					\
 	if (do_allow)								\
@@ -508,6 +506,9 @@ static __must_check inline bool user_access_begin(const void __user *ptr, size_t
 {
 	if (unlikely(!access_ok(ptr, len)))
 		return false;
+
+	might_fault();
+
 	allow_read_write_user((void __user *)ptr, ptr, len);
 	return true;
 }
@@ -521,6 +522,9 @@ user_read_access_begin(const void __user *ptr, size_t len)
 {
 	if (unlikely(!access_ok(ptr, len)))
 		return false;
+
+	might_fault();
+
 	allow_read_from_user(ptr, len);
 	return true;
 }
@@ -532,6 +536,9 @@ user_write_access_begin(const void __user *ptr, size_t len)
 {
 	if (unlikely(!access_ok(ptr, len)))
 		return false;
+
+	might_fault();
+
 	allow_write_to_user((void __user *)ptr, len);
 	return true;
 }
-- 
2.27.0



