Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03F441579CB
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729142AbgBJNSE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:18:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:60658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728961AbgBJMh5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:57 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAB322168B;
        Mon, 10 Feb 2020 12:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338276;
        bh=dbT2HJ03wcRgkccWrDwHhvTc/3UAs06v8MHzqQvBWis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=geJWpBs0uL/Uq+X5Yehi0p6xw6o6oABa8mr1VogUGpQN+NLRfLqssSCKYx+1+LS4Z
         LFb7BwtIMu0yn7ZMiwNq+xtx9hfTsLBQ+E+/FB5dJ7JMEf9XkTMaicIigCEM+CP/+z
         KOPx25VjgrklujrbykbRKVx9jmnIw7TPvNMv0JjE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e808452bad7c375cbee6@syzkaller-ppc64.appspotmail.com,
        Michael Ellerman <mpe@ellerman.id.au>,
        Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH 5.4 163/309] powerpc/futex: Fix incorrect user access blocking
Date:   Mon, 10 Feb 2020 04:31:59 -0800
Message-Id: <20200210122421.891045626@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 9dc086f1e9ef39dd823bd27954b884b2062f9e70 upstream.

The early versions of our kernel user access prevention (KUAP) were
written by Russell and Christophe, and didn't have separate
read/write access.

At some point I picked up the series and added the read/write access,
but I failed to update the usages in futex.h to correctly allow read
and write.

However we didn't notice because of another bug which was causing the
low-level code to always enable read and write. That bug was fixed
recently in commit 1d8f739b07bd ("powerpc/kuap: Fix set direction in
allow/prevent_user_access()").

futex_atomic_cmpxchg_inatomic() is passed the user address as %3 and
does:

  1:     lwarx   %1,  0, %3
         cmpw    0,  %1, %4
         bne-    3f
  2:     stwcx.  %5,  0, %3

Which clearly loads and stores from/to %3. The logic in
arch_futex_atomic_op_inuser() is similar, so fix both of them to use
allow_read_write_user().

Without this fix, and with PPC_KUAP_DEBUG=y, we see eg:

  Bug: Read fault blocked by AMR!
  WARNING: CPU: 94 PID: 149215 at arch/powerpc/include/asm/book3s/64/kup-radix.h:126 __do_page_fault+0x600/0xf30
  CPU: 94 PID: 149215 Comm: futex_requeue_p Tainted: G        W         5.5.0-rc7-gcc9x-g4c25df5640ae #1
  ...
  NIP [c000000000070680] __do_page_fault+0x600/0xf30
  LR [c00000000007067c] __do_page_fault+0x5fc/0xf30
  Call Trace:
  [c00020138e5637e0] [c00000000007067c] __do_page_fault+0x5fc/0xf30 (unreliable)
  [c00020138e5638c0] [c00000000000ada8] handle_page_fault+0x10/0x30
  --- interrupt: 301 at cmpxchg_futex_value_locked+0x68/0xd0
      LR = futex_lock_pi_atomic+0xe0/0x1f0
  [c00020138e563bc0] [c000000000217b50] futex_lock_pi_atomic+0x80/0x1f0 (unreliable)
  [c00020138e563c30] [c00000000021b668] futex_requeue+0x438/0xb60
  [c00020138e563d60] [c00000000021c6cc] do_futex+0x1ec/0x2b0
  [c00020138e563d90] [c00000000021c8b8] sys_futex+0x128/0x200
  [c00020138e563e20] [c00000000000b7ac] system_call+0x5c/0x68

Fixes: de78a9c42a79 ("powerpc: Add a framework for Kernel Userspace Access Protection")
Cc: stable@vger.kernel.org # v5.2+
Reported-by: syzbot+e808452bad7c375cbee6@syzkaller-ppc64.appspotmail.com
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Christophe Leroy <christophe.leroy@c-s.fr>
Link: https://lore.kernel.org/r/20200207122145.11928-1-mpe@ellerman.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/futex.h |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/arch/powerpc/include/asm/futex.h
+++ b/arch/powerpc/include/asm/futex.h
@@ -35,7 +35,7 @@ static inline int arch_futex_atomic_op_i
 {
 	int oldval = 0, ret;
 
-	allow_write_to_user(uaddr, sizeof(*uaddr));
+	allow_read_write_user(uaddr, uaddr, sizeof(*uaddr));
 	pagefault_disable();
 
 	switch (op) {
@@ -62,7 +62,7 @@ static inline int arch_futex_atomic_op_i
 
 	*oval = oldval;
 
-	prevent_write_to_user(uaddr, sizeof(*uaddr));
+	prevent_read_write_user(uaddr, uaddr, sizeof(*uaddr));
 	return ret;
 }
 
@@ -76,7 +76,8 @@ futex_atomic_cmpxchg_inatomic(u32 *uval,
 	if (!access_ok(uaddr, sizeof(u32)))
 		return -EFAULT;
 
-	allow_write_to_user(uaddr, sizeof(*uaddr));
+	allow_read_write_user(uaddr, uaddr, sizeof(*uaddr));
+
         __asm__ __volatile__ (
         PPC_ATOMIC_ENTRY_BARRIER
 "1:     lwarx   %1,0,%3         # futex_atomic_cmpxchg_inatomic\n\
@@ -97,7 +98,8 @@ futex_atomic_cmpxchg_inatomic(u32 *uval,
         : "cc", "memory");
 
 	*uval = prev;
-	prevent_write_to_user(uaddr, sizeof(*uaddr));
+	prevent_read_write_user(uaddr, uaddr, sizeof(*uaddr));
+
         return ret;
 }
 


