Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A06F734C5C0
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbhC2ICu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:02:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:44420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231404AbhC2ICF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:02:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2B9561969;
        Mon, 29 Mar 2021 08:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617004924;
        bh=LCXC1wQiEl5fRnvuuHBtnBzqnyTewHr2MiBWlIOyARg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TLl+tnrGfma3neGlraiVdZyGlV0nt4ajcKtb+jyD9kwmj0TE167nQpWdxvzkdLpI7
         9XO0sEz0VXII005TEFjbk6TdOk3Fw3J9QKvvRyK2JYY82/TyGwe7cKQsae83y4W0nq
         CBV3rvd4VinzMjZq8EcJuPDV8oX/Y7KQIHP9MVh8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Borislav Petkov <bp@suse.de>, Hugh Dickins <hughd@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Babu Moger <babu.moger@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 17/53] x86/tlb: Flush global mappings when KAISER is disabled
Date:   Mon, 29 Mar 2021 09:57:52 +0200
Message-Id: <20210329075608.115652652@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075607.561619583@linuxfoundation.org>
References: <20210329075607.561619583@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Jim Mattson reported that Debian 9 guests using a 4.9-stable kernel
are exploding during alternatives patching:

  kernel BUG at /build/linux-dqnRSc/linux-4.9.228/arch/x86/kernel/alternative.c:709!
  invalid opcode: 0000 [#1] SMP
  Modules linked in:
  CPU: 1 PID: 1 Comm: swapper/0 Not tainted 4.9.0-13-amd64 #1 Debian 4.9.228-1
  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
  Call Trace:
   swap_entry_free
   swap_entry_free
   text_poke_bp
   swap_entry_free
   arch_jump_label_transform
   set_debug_rodata
   __jump_label_update
   static_key_slow_inc
   frontswap_register_ops
   init_zswap
   init_frontswap
   do_one_initcall
   set_debug_rodata
   kernel_init_freeable
   rest_init
   kernel_init
   ret_from_fork

triggering the BUG_ON in text_poke() which verifies whether patched
instruction bytes have actually landed at the destination.

Further debugging showed that the TLB flush before that check is
insufficient because there could be global mappings left in the TLB,
leading to a stale mapping getting used.

I say "global mappings" because the hardware configuration is a new one:
machine is an AMD, which means, KAISER/PTI doesn't need to be enabled
there, which also means there's no user/kernel pagetables split and
therefore the TLB can have global mappings.

And the configuration is new one for a second reason: because that AMD
machine supports PCID and INVPCID, which leads the CPU detection code to
set the synthetic X86_FEATURE_INVPCID_SINGLE flag.

Now, __native_flush_tlb_single() does invalidate global mappings when
X86_FEATURE_INVPCID_SINGLE is *not* set and returns.

When X86_FEATURE_INVPCID_SINGLE is set, however, it invalidates the
requested address from both PCIDs in the KAISER-enabled case. But if
KAISER is not enabled and the machine has global mappings in the TLB,
then those global mappings do not get invalidated, which would lead to
the above mismatch from using a stale TLB entry.

So make sure to flush those global mappings in the KAISER disabled case.

Co-debugged by Babu Moger <babu.moger@amd.com>.

Reported-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Tested-by: Babu Moger <babu.moger@amd.com>
Tested-by: Jim Mattson <jmattson@google.com>
Link: https://lkml.kernel.org/r/CALMp9eRDSW66%2BXvbHVF4ohL7XhThoPoT0BrB0TcS0cgk=dkcBg@mail.gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/tlbflush.h | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index f5ca15622dc9..2bfa4deb8cae 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -245,12 +245,15 @@ static inline void __native_flush_tlb_single(unsigned long addr)
 	 * ASID.  But, userspace flushes are probably much more
 	 * important performance-wise.
 	 *
-	 * Make sure to do only a single invpcid when KAISER is
-	 * disabled and we have only a single ASID.
+	 * In the KAISER disabled case, do an INVLPG to make sure
+	 * the mapping is flushed in case it is a global one.
 	 */
-	if (kaiser_enabled)
+	if (kaiser_enabled) {
 		invpcid_flush_one(X86_CR3_PCID_ASID_USER, addr);
-	invpcid_flush_one(X86_CR3_PCID_ASID_KERN, addr);
+		invpcid_flush_one(X86_CR3_PCID_ASID_KERN, addr);
+	} else {
+		asm volatile("invlpg (%0)" ::"r" (addr) : "memory");
+	}
 }
 
 static inline void __flush_tlb_all(void)
-- 
2.30.1



