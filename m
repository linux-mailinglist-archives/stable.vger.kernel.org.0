Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13EB3349AD7
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 21:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbhCYUKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 16:10:07 -0400
Received: from mail.skyhub.de ([5.9.137.197]:59234 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230258AbhCYUJk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 16:09:40 -0400
Received: from zn.tnic (p200300ec2f0d5d0094e6cb0f12bb7e2a.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:5d00:94e6:cb0f:12bb:7e2a])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 683AF1EC0249;
        Thu, 25 Mar 2021 21:09:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1616702978;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=mlAyvCnXo3hHmcqDcLa0T0+zPXCZVaDSlZjjwBtnDCY=;
        b=lkUeFKqn1wgy3MlXzWs7hStJOpvfYU/tTSZ8zOYUwS80eXwWt0+AaAq/qbqRDdR2dOttQd
        qDNk+HsALrwZvtX6EmcdW2Za2ZTKQEsCyb3Mt3PHOVCOECvGRx+9zhFJMJcbCU35iY/y2o
        W7f4GxpgqWzgUzEAKvw/RJPN4HHJMLs=
Date:   Thu, 25 Mar 2021 21:09:42 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     stable <stable@vger.kernel.org>
Cc:     Hugh Dickins <hughd@google.com>, Babu Moger <babu.moger@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Makarand Sonare <makarandsonare@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH] x86/tlb: Flush global mappings when KAISER is disabled
Message-ID: <20210325200942.GJ31322@zn.tnic>
References: <20210311214013.GH5829@zn.tnic>
 <d3e9e091-0fc8-1e11-ab99-9c8be086f1dc@amd.com>
 <4a72f780-3797-229e-a938-6dc5b14bec8d@amd.com>
 <20210311235215.GI5829@zn.tnic>
 <ed590709-65c8-ca2f-013f-d2c63d5ee0b7@amd.com>
 <20210324212139.GN5010@zn.tnic>
 <alpine.LSU.2.11.2103241651280.9593@eggly.anvils>
 <alpine.LSU.2.11.2103241913190.10112@eggly.anvils>
 <20210325095619.GC31322@zn.tnic>
 <20210325102959.GD31322@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210325102959.GD31322@zn.tnic>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi stable folks,

the patch below fixes kernels 4.4 and 4.9 booting on AMD platforms with
PCID support. It doesn't have an upstream counterpart because it patches
the KAISER code which didn't go upstream. It applies fine to both of the
aforementioned kernels - please pick it up.

Thx.

---
From: Borislav Petkov <bp@suse.de>
Date: Thu, 25 Mar 2021 11:02:31 +0100
Subject: [PATCH] x86/tlb: Flush global mappings when KAISER is disabled

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
2.29.2


-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
