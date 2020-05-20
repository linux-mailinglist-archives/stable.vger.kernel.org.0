Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ACF51DC1AC
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 23:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbgETV5Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 17:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728111AbgETV5P (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 17:57:15 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 887A4C061A0E
        for <stable@vger.kernel.org>; Wed, 20 May 2020 14:57:15 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id z5so6243823ejb.3
        for <stable@vger.kernel.org>; Wed, 20 May 2020 14:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IqzpEer//XK22yZ98UAKJ7MBv4zHdPVVNRSVLrhFals=;
        b=bVbiMveqZaJY6CN61D/3eT0a0iz5G1ujKdeEmUSKkRjV2bpnmoSyhakW3LkMb3d/wG
         rBCrI4FJVb+MTYbejV8E8DGHLXjuswp3fnUkO35cz048PT0R8KhQ31fVJttmcYjq1s6L
         yPm7e5J4AQRs/GM4B+6Ih4xAq3nQfXSp39/Rf2lYy7eHb4qMNOW0JGoHLrDoqiM50bUH
         TmPMK672nDpVm6Yv3ye3RC6w3VEn7Rxmktgoj5N6vyrMrQ0Ct4UJAumuf67tTJmQDLFi
         1+6yeAvIEVcSJMPt2aL/FYjwqElRcXBwYU/X5XwN/GwpFSLs05yEF7K2TA1ms4Kj+3xs
         Vj4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IqzpEer//XK22yZ98UAKJ7MBv4zHdPVVNRSVLrhFals=;
        b=Gm87EfZiOFwZ9il7eWr7Fory21juBI6hGfKamxyJW0E59YrnJcRL9SNedntLgLWhWR
         n818DV/WkB+rh84XukhVRa/HSIjsgilfOr1uv6KZHhpy0LS2Sc3iJXJAbS+9HJ5Mj61t
         EXAUK+Sq5ayaAkWl+BfXgwYGZqdngSg5TNY8qB2YfYbXaaR4ESz2BbmzSA88o+1yQGpc
         cq9DoGSW9rmHertGeUExbTHUiqkzBaleNMP3mKIPLU/6v0DkmMWIChNE5UoBdN4lMJ19
         sW9UCNVHZOdgxnSTBZYPsKJbN0O3RjnM7kQm11F/yjTu6szqVQa4xGheRogveq083IHz
         HyYQ==
X-Gm-Message-State: AOAM531QXTQGwONz8qJm1xCkxUIhdwyeJlN5spo2NwjWQYdn39Ajbozb
        weCfu8UdhGQF9d7iP6WUUHXBbyFECeaY22vVIrAEmA==
X-Google-Smtp-Source: ABdhPJyEtJIRy5zvU/Ue+wi49BTEkeLMMKxvFOmL5yCA0qbl0BCCkHFWunjp2ymm5wjf5KNjuojO1Gsyky3jk1f9Z3k=
X-Received: by 2002:a17:906:a8d:: with SMTP id y13mr963076ejf.455.1590011834056;
 Wed, 20 May 2020 14:57:14 -0700 (PDT)
MIME-Version: 1.0
References: <158992635164.403910.2616621400995359522.stgit@dwillia2-desk3.amr.corp.intel.com>
 <158992636214.403910.12184670538732959406.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20200520191320.GA3255@redhat.com>
In-Reply-To: <20200520191320.GA3255@redhat.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 20 May 2020 14:57:02 -0700
Message-ID: <CAPcyv4jPZny8uraVtO8gMfs8W9EJWfgSAo1zOnwqe2VBSLgaDQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] x86/copy_mc: Introduce copy_mc_generic()
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, X86 ML <x86@kernel.org>,
        stable <stable@vger.kernel.org>, Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Erwin Tsaur <erwin.tsaur@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 20, 2020 at 12:13 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Tue, May 19, 2020 at 03:12:42PM -0700, Dan Williams wrote:
> > The original copy_mc_fragile() implementation had negative performance
> > implications since it did not use the fast-string instruction sequence
> > to perform copies. For this reason copy_mc_to_kernel() fell back to
> > plain memcpy() to preserve performance on platform that did not indicate
> > the capability to recover from machine check exceptions. However, that
> > capability detection was not architectural and now that some platforms
> > can recover from fast-string consumption of memory errors the memcpy()
> > fallback now causes these more capable platforms to fail.
> >
> > Introduce copy_mc_generic() as the fast default implementation of
> > copy_mc_to_kernel() and finalize the transition of copy_mc_fragile() to
> > be a platform quirk to indicate 'fragility'. With this in place
> > copy_mc_to_kernel() is fast and recovery-ready by default regardless of
> > hardware capability.
> >
> > Thanks to Vivek for identifying that copy_user_generic() is not suitable
> > as the copy_mc_to_user() backend since the #MC handler explicitly checks
> > ex_has_fault_handler().
>
> /me is curious to know why #MC handler mandates use of _ASM_EXTABLE_FAULT().

Even though we could try to handle all faults / exceptions
generically, I think it makes sense to enforce type safety here if
only to support architectures that can only satisfy the minimum
contract of copy_mc_to_user(). For example, if there was some
destination exception other than #PF the contract implied by
copy_mc_to_user() is that exception is not intended to be permissible
in this path. See:

00c42373d397 x86-64: add warning for non-canonical user access address
dereferences
75045f77f7a7 x86/extable: Introduce _ASM_EXTABLE_UA for uaccess fixups

...for examples of other justification for being explicit in these paths.

>
> [..]
> > +/*
> > + * copy_mc_generic - memory copy with exception handling
> > + *
> > + * Fast string copy + fault / exception handling. If the CPU does
> > + * support machine check exception recovery, but does not support
> > + * recovering from fast-string exceptions then this CPU needs to be
> > + * added to the copy_mc_fragile_key set of quirks. Otherwise, absent any
> > + * machine check recovery support this version should be no slower than
> > + * standard memcpy.
> > + */
> > +SYM_FUNC_START(copy_mc_generic)
> > +     ALTERNATIVE "jmp copy_mc_fragile", "", X86_FEATURE_ERMS
> > +     movq %rdi, %rax
> > +     movq %rdx, %rcx
> > +.L_copy:
> > +     rep movsb
> > +     /* Copy successful. Return zero */
> > +     xorl %eax, %eax
> > +     ret
> > +SYM_FUNC_END(copy_mc_generic)
> > +EXPORT_SYMBOL_GPL(copy_mc_generic)
> > +
> > +     .section .fixup, "ax"
> > +.E_copy:
> > +     /*
> > +      * On fault %rcx is updated such that the copy instruction could
> > +      * optionally be restarted at the fault position, i.e. it
> > +      * contains 'bytes remaining'. A non-zero return indicates error
> > +      * to copy_safe() users, or indicate short transfers to
>
> copy_safe() is vestige of terminology of previous patches?

Thanks, yes, I missed this one.

>
> > +      * user-copy routines.
> > +      */
> > +     movq %rcx, %rax
> > +     ret
> > +
> > +     .previous
> > +
> > +     _ASM_EXTABLE_FAULT(.L_copy, .E_copy)
>
> A question for my education purposes.
>
> So copy_mc_generic() can handle MCE both on source and destination
> addresses? (Assuming some device can generate MCE on stores too).

There's no such thing as #MC on write. #MC is only signaled on consumed poison.

In this case what is specifically being handled is #MC with RIP
pointing at a movq instruction. The fault handler actually does not
know anything about source or destination, it just knows fault /
exception type and the register state.

> On the other hand copy_mc_fragile() handles MCE recovery only on
> source and non-MCE recovery on destination.

No, there's no difference in capability. #MC can only be raised on a
poison-read in both cases.
