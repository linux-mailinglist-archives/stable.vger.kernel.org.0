Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDF179B9ED
	for <lists+stable@lfdr.de>; Sat, 24 Aug 2019 02:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbfHXA7h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Aug 2019 20:59:37 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:37052 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbfHXA7h (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Aug 2019 20:59:37 -0400
Received: from p5de0b6c5.dip0.t-ipconnect.de ([93.224.182.197] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1i1KOw-0003M2-0x; Sat, 24 Aug 2019 02:59:30 +0200
Date:   Sat, 24 Aug 2019 02:59:28 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Song Liu <songliubraving@fb.com>
cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Joerg Roedel <jroedel@suse.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH v2] x86/mm/pti: in pti_clone_pgtable(), increase addr
 properly
In-Reply-To: <alpine.DEB.2.21.1908211210160.2223@nanos.tec.linutronix.de>
Message-ID: <alpine.DEB.2.21.1908240225320.1939@nanos.tec.linutronix.de>
References: <20190820202314.1083149-1-songliubraving@fb.com> <2CB1A3FD-33EF-4D8B-B74A-CF35F9722993@fb.com> <alpine.DEB.2.21.1908211210160.2223@nanos.tec.linutronix.de>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 21 Aug 2019, Thomas Gleixner wrote:
> On Wed, 21 Aug 2019, Song Liu wrote:
> > > On Aug 20, 2019, at 1:23 PM, Song Liu <songliubraving@fb.com> wrote:
> > > 
> > > Before 32-bit support, pti_clone_pmds() always adds PMD_SIZE to addr.
> > > This behavior changes after the 32-bit support:  pti_clone_pgtable()
> > > increases addr by PUD_SIZE for pud_none(*pud) case, and increases addr by
> > > PMD_SIZE for pmd_none(*pmd) case. However, this is not accurate because
> > > addr may not be PUD_SIZE/PMD_SIZE aligned.
> > > 
> > > Fix this issue by properly rounding up addr to next PUD_SIZE/PMD_SIZE
> > > in these two cases.
> > 
> > After poking around more, I found the following doesn't really make 
> > sense. 
> 
> I'm glad you figured that out yourself. Was about to write up something to
> that effect.
> 
> Still interesting questions remain:
> 
>   1) How did you end up feeding an unaligned address into that which points
>      to a 0 PUD?
> 
>   2) Is this related to Facebook specific changes and unlikely to affect any
>      regular kernel? I can't come up with a way to trigger that in mainline
> 
>   3) As this is a user page table and the missing mapping is related to
>      mappings required by PTI, how is the machine going in/out of user
>      space in the first place? Or did I just trip over what you called
>      nonsense?

And just because this ended in silence I looked at it myself after Peter
told me that this was on a kernel with PTI disabled. Aside of that my built
in distrust for debug war stories combined with fairy tale changelogs
triggered my curiousity anyway.

So that cannot be a kernel with PTI disabled compile time because in that
case the functions are not available, unless it's FB hackery which I do not
care about.

So the only way this can be reached is when PTI is configured but disabled
at boot time via pti=off or nopti.

For some silly reason and that goes back to before the 32bit support and
Joern did not notice either when he introduced pti_finalize() this results
in the following functions being called unconditionallY:

     pti_clone_entry_text()
     pti_clone_kernel_text()

pti_clone_kernel_text() was called unconditionally before the 32bit support
already and the only reason why it did not have any effect in that
situation is that it invokes pti_kernel_image_global_ok() and that returns
false when PTI is disabled on the kernel command line. Oh well. It
obviously never checked whether X86_FEATURE_PTI was disabled or enabled in
the first place.

Now 32bit moved that around into pti_finalize() and added the call to
pti_clone_entry_text() which just runs unconditionally.

Now there is still the interesting question why this matters. The to be
cloned page table entries are mapped and the start address even if
unaligned never points to something unmapped. The unmapped case only covers
holes and holes are obviously aligned at the upper levels even if the
address of the hole is unaligned.

So colour me still confused what's wrong there but the proper fix is the
trivial:

--- a/arch/x86/mm/pti.c
+++ b/arch/x86/mm/pti.c
@@ -666,6 +666,8 @@ void __init pti_init(void)
  */
 void pti_finalize(void)
 {
+	if (!boot_cpu_has(X86_FEATURE_PTI))
+		return;
 	/*
 	 * We need to clone everything (again) that maps parts of the
 	 * kernel image.

Hmm?

I'm going to look whether that makes any difference in the page tables
tomorrow with brain awake, but I wanted to share this before the .us
vanishes into the weekend :)

Thanks,

	tglx

