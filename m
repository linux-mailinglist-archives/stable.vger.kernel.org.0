Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9A07D876F
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 06:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729376AbfJPE3k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 00:29:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:38330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726078AbfJPE3k (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 00:29:40 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B28520663;
        Wed, 16 Oct 2019 04:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571200178;
        bh=O4HVQFJiYapsdHmtbuSgsOmS59EbQiDHC9sEWNuylck=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YETuhVdWQDMVOZ0Te7B1Zzy3goGNdM+ufKfn7Lds4W8oWsNSwGJzqFwDUp6bmjgg5
         l/nRkrP7RhX6B6R41j7CMwxIBJpIY8WoQ3UUos+NCYD5xOoX2mqSv6UBy7LieoVY2I
         6XnwaKP+jC5P4kE1GERSGc3AJStKAGwxjJbxVaMU=
Date:   Wed, 16 Oct 2019 05:29:33 +0100
From:   Will Deacon <will@kernel.org>
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     Andrey Konovalov <andreyknvl@google.com>,
        Jan Stancek <jstancek@redhat.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        CKI Project <cki-project@redhat.com>,
        LTP List <ltp@lists.linux.it>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>,
        Szabolcs Nagy <szabolcs.nagy@arm.com>,
        Dave P Martin <Dave.Martin@arm.com>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for kernel
 5.4.0-rc2-d6c2c23.cki (stable-next)
Message-ID: <20191016042933.bemrrurjbghuiw73@willie-the-truck>
References: <cki.B4A567748F.PFM8G4WKXI@redhat.com>
 <805988176.6044584.1571038139105.JavaMail.zimbra@redhat.com>
 <CAAeHK+zxFWvCOgTYrMuD-oHJAFMn5DVYmQ6-RvU8NrapSz01mQ@mail.gmail.com>
 <20191014162651.GF19200@arrakis.emea.arm.com>
 <20191014213332.mmq7narumxtkqumt@willie-the-truck>
 <20191015152651.GG13874@arrakis.emea.arm.com>
 <20191015161453.lllrp2gfwa5evd46@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191015161453.lllrp2gfwa5evd46@willie-the-truck>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 15, 2019 at 05:14:53PM +0100, Will Deacon wrote:
> On Tue, Oct 15, 2019 at 04:26:51PM +0100, Catalin Marinas wrote:
> > On Mon, Oct 14, 2019 at 10:33:32PM +0100, Will Deacon wrote:
> > > On Mon, Oct 14, 2019 at 05:26:51PM +0100, Catalin Marinas wrote:
> > > > The options I see:
> > > > 
> > > > 1. Revert commit 057d3389108e and try again to document that the memory
> > > >    syscalls do not support tagged pointers
> > > > 
> > > > 2. Change untagged_addr() to only 0-extend from bit 55 or leave the
> > > >    tag unchanged if bit 55 is 1. We could mask out the tag (0 rather
> > > >    than sign-extend) but if we had an mlock test passing ULONG_MASK,
> > > >    then we get -ENOMEM instead of -EINVAL
> > > > 
> > > > 3. Make untagged_addr() depend on the TIF_TAGGED_ADDR bit and we only
> > > >    break the ABI for applications opting in to this new ABI. We did look
> > > >    at this but the ptrace(PEEK/POKE_DATA) needs a bit more thinking on
> > > >    whether we check the ptrace'd process or the debugger flags
> > > > 
> > > > 4. Leave things as they are, consider the address space 56-bit and
> > > >    change the test to not use LONG_MAX on arm64. This needs to be passed
> > > >    by the sparc guys since they probably have a similar issue
> > > 
> > > I'm in favour of (2) or (4) as long as there's also an update to the docs.
> > 
> > With (4) we'd start differing from other architectures supported by
> > Linux. This works if we consider the test to be broken. However, reading
> > the mlock man page:
> > 
> >        EINVAL The result of the addition addr+len was less than addr
> >        (e.g., the addition may have resulted in an overflow).
> > 
> >        ENOMEM Some of the specified address range does not correspond to
> >        mapped pages in the address space of the process.
> > 
> > There is no mention of EINVAL outside the TASK_SIZE, seems to fall more
> > within the ENOMEM description above.
> 
> Sorry, I was being too vague in my wording. What I was trying to say is I'm
> ok with (2) or (4), but either way we need to update our ABI documentation
> under Documentation/arm64/.

Having looked at making that change, I actually think the text is ok as-is
if we go with option (2). We only make guarantees about "valid tagged
pointer", which are defined to "reference an address in the user process
address space" and therefore must have bit 55 == 0.

Untested patch below.

Will

--->8

From 517d979e84191ae9997c9513a88a5b798af6912f Mon Sep 17 00:00:00 2001
From: Will Deacon <will@kernel.org>
Date: Tue, 15 Oct 2019 21:04:18 -0700
Subject: [PATCH] arm64: tags: Preserve tags for addresses translated via TTBR1

Sign-extending TTBR1 addresses when converting to an untagged address
breaks the documented POSIX semantics for mlock() in some obscure error
cases where we end up returning -EINVAL instead of -ENOMEM as a direct
result of rewriting the upper address bits.

Rework the untagged_addr() macro to preserve the upper address bits for
TTBR1 addresses and only clear the tag bits for user addresses. This
matches the behaviour of the 'clear_address_tag' assembly macro, so
rename that and align the implementations at the same time so that they
use the same instruction sequences for the tag manipulation.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/stable/20191014162651.GF19200@arrakis.emea.arm.com/
Reported-by: Jan Stancek <jstancek@redhat.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/asm-uaccess.h |  7 +++----
 arch/arm64/include/asm/memory.h      | 10 ++++++++--
 arch/arm64/kernel/entry.S            |  4 ++--
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/asm-uaccess.h b/arch/arm64/include/asm/asm-uaccess.h
index f74909ba29bd..5bf963830b17 100644
--- a/arch/arm64/include/asm/asm-uaccess.h
+++ b/arch/arm64/include/asm/asm-uaccess.h
@@ -78,10 +78,9 @@ alternative_else_nop_endif
 /*
  * Remove the address tag from a virtual address, if present.
  */
-	.macro	clear_address_tag, dst, addr
-	tst	\addr, #(1 << 55)
-	bic	\dst, \addr, #(0xff << 56)
-	csel	\dst, \dst, \addr, eq
+	.macro	untagged_addr, dst, addr
+	sbfx	\dst, \addr, #0, #56
+	and	\dst, \dst, \addr
 	.endm
 
 #endif
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index b61b50bf68b1..c23c47360664 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -215,12 +215,18 @@ static inline unsigned long kaslr_offset(void)
  * up with a tagged userland pointer. Clear the tag to get a sane pointer to
  * pass on to access_ok(), for instance.
  */
-#define untagged_addr(addr)	\
+#define __untagged_addr(addr)	\
 	((__force __typeof__(addr))sign_extend64((__force u64)(addr), 55))
 
+#define untagged_addr(addr)	({					\
+	u64 __addr = (__force u64)addr;					\
+	__addr &= __untagged_addr(__addr);				\
+	(__force __typeof__(addr))__addr;				\
+})
+
 #ifdef CONFIG_KASAN_SW_TAGS
 #define __tag_shifted(tag)	((u64)(tag) << 56)
-#define __tag_reset(addr)	untagged_addr(addr)
+#define __tag_reset(addr)	__untagged_addr(addr)
 #define __tag_get(addr)		(__u8)((u64)(addr) >> 56)
 #else
 #define __tag_shifted(tag)	0UL
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index e304fe04b098..9ae336cc5833 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -604,7 +604,7 @@ el1_da:
 	 */
 	mrs	x3, far_el1
 	inherit_daif	pstate=x23, tmp=x2
-	clear_address_tag x0, x3
+	untagged_addr	x0, x3
 	mov	x2, sp				// struct pt_regs
 	bl	do_mem_abort
 
@@ -808,7 +808,7 @@ el0_da:
 	mrs	x26, far_el1
 	ct_user_exit_irqoff
 	enable_daif
-	clear_address_tag x0, x26
+	untagged_addr	x0, x26
 	mov	x1, x25
 	mov	x2, sp
 	bl	do_mem_abort
-- 
2.23.0.700.g56cf767bdb-goog

