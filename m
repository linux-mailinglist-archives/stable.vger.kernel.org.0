Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8ABE31F7E6
	for <lists+stable@lfdr.de>; Fri, 19 Feb 2021 12:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbhBSLGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Feb 2021 06:06:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbhBSLGh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Feb 2021 06:06:37 -0500
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5589CC061574;
        Fri, 19 Feb 2021 03:05:57 -0800 (PST)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id AAE9A295; Fri, 19 Feb 2021 12:05:54 +0100 (CET)
Date:   Fri, 19 Feb 2021 12:05:49 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Joerg Roedel <jroedel@suse.de>, X86 ML <x86@kernel.org>,
        stable <stable@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 2/3] x86/sev-es: Check if regs->sp is trusted before
 adjusting #VC IST stack
Message-ID: <20210219110549.GI7302@8bytes.org>
References: <20210217120143.6106-1-joro@8bytes.org>
 <20210217120143.6106-3-joro@8bytes.org>
 <CALCETrWw-we3O4_upDoXJ4NzZHsBqNO69ht6nBp3y+QFhwPgKw@mail.gmail.com>
 <20210218112500.GH7302@8bytes.org>
 <CALCETrUohqQPVTBJZZKh-pj=4aZrwDAu5UFSetj3k5pGLDPbkA@mail.gmail.com>
 <20210218192117.GL12716@suse.de>
 <CALCETrUaOLwO51Js+OGNY03aep8BHoncZKTMr8sG1guUhLk40A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUaOLwO51Js+OGNY03aep8BHoncZKTMr8sG1guUhLk40A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 18, 2021 at 04:28:36PM -0800, Andy Lutomirski wrote:
> On Thu, Feb 18, 2021 at 11:21 AM Joerg Roedel <jroedel@suse.de> wrote:
> Can you give me an example, even artificial, in which the linked-list
> logic is useful?

So here we go, its of course artificial, but still:

	1. #VC happens, not important where
	2. NMI in the #VC prologue before it moved off its IST stack
	   - first VC IST adjustment happening here
	3. #VC in the NMI handler
	4. #HV in the #VC prologue again
	   - second VC IST adjustment happening here, so the #HV handler
	     can cause its own #VC exceptions.

Can only happen if the #HV handler is allowed to cause #VC exceptions.
But even if its not allowed, it can happen with SNP and a malicious
Hypervisor. But in this case the only option is to reliably panic.

> Can you explain your reasoning in considering the entry stack unsafe?
> It's 4k bytes these days.

I wasn't aware that it is 4k in size now. I still thought it was just
these 64 words large and one can not simply execute C code on it.

> You forgot about entry_SYSCALL_compat.

Right, thanks for pointing this out.

> Your 8-byte alignment is confusing to me.  In valid kernel code, SP
> should be 8-byte-aligned already, and, if you're trying to match
> architectural behavior, the CPU aligns to 16 bytes.

Yeah, I was just being cautious. The explicit alignment can be removed,
Boris also pointed this out.

> We're not robust against #VC, NMI in the #VC prologue before the magic
> stack switch, and a new #VC in the NMI prologue.  Nor do we appear to
> have any detection of the case where #VC nests directly inside its own
> prologue.  Or did I miss something else here?

No, you don't miss anything here. At the moment #VC can't happen at
those places, so this is not handled yet. With SNP it can happen and
needs to be handled in a way to at least allow a reliable panic (because
if it really happens the Hypervisor is messing with us).

> If we get NMI and get #VC in the NMI *asm*, the #VC magic stack switch
> looks like it will merrily run itself in the NMI special-stack-layout
> section, and that sounds really quite bad.

Yes, I havn't looked at the details yet, but if a #VC happens there it
probably better not returns.


> I mean that, IIRC, a malicious hypervisor can inject inappropriate
> vectors at inappropriate times if the #HV mechanism isn't enabled.
> For example, it could inject a page fault or an interrupt in a context
> in which we have the wrong GSBASE loaded.

Yes, a malicious Hypervisor can do that, and without #HV there is no
real protection against this besides turning all vectors (even IRQs)
into paranoid entries. Maybe even more care is needed, but I think its
not worth to care about this. 

> But the #DB issue makes this moot.  We have to use IST unless we turn
> off SCE.  But I admit I'm leaning toward turning off SCE until we have
> a solution that seems convincingly robust.

Turning off SCE might be tempting, but I guess doing so would break a
quite some user-space code, no?

Regards,

	Joerg
