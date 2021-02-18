Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3D6131E982
	for <lists+stable@lfdr.de>; Thu, 18 Feb 2021 13:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbhBRMEm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Feb 2021 07:04:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbhBRLjZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Feb 2021 06:39:25 -0500
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD2B7C061756;
        Thu, 18 Feb 2021 03:28:47 -0800 (PST)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 017B6247; Thu, 18 Feb 2021 12:25:03 +0100 (CET)
Date:   Thu, 18 Feb 2021 12:25:00 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     X86 ML <x86@kernel.org>, Joerg Roedel <jroedel@suse.de>,
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
Message-ID: <20210218112500.GH7302@8bytes.org>
References: <20210217120143.6106-1-joro@8bytes.org>
 <20210217120143.6106-3-joro@8bytes.org>
 <CALCETrWw-we3O4_upDoXJ4NzZHsBqNO69ht6nBp3y+QFhwPgKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWw-we3O4_upDoXJ4NzZHsBqNO69ht6nBp3y+QFhwPgKw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Andy,

On Wed, Feb 17, 2021 at 10:09:46AM -0800, Andy Lutomirski wrote:
> Can you get rid of the linked list hack while you're at it?  This code
> is unnecessarily convoluted right now, and it seems to be just asking
> for weird bugs.  Just stash the old value in a local variable, please.

Yeah, the linked list is not really necessary right now, because of the
way nested NMI handling works and given that these functions are only
used in the NMI handler right now.
The whole #VC handling code was written with future requirements in
mind, like what is needed when debugging registers get virtualized and
#HV gets enabled.
Until its clear whether __sev_es_ist_enter/exit() is needed in any of
these paths, I'd like to keep the linked list for now. It is more
complicated but allows nesting.

> Meanwhile, I'm pretty sure I can break this whole scheme if the
> hypervisor is messing with us.  As a trivial example, the sequence
> SYSCALL gap -> #VC -> NMI -> #VC will go quite poorly.

I don't see how this would break, can you elaborate?

What I think happens is:

SYSCALL gap (RSP is from userspace and untrusted)

	-> #VC - Handler on #VC IST stack detects that it interrupted
	   the SYSCALL gap and switches to the task stack.


	-> NMI - Now running on NMI IST stack. Depending on whether the
	   stack switch in the #VC handler already happened, the #VC IST
	   entry is adjusted so that a subsequent #VC will not overwrite
	   the interrupted handlers stack frame.

	-> #VC - Handler runs on the adjusted #VC IST stack and switches
	   itself back to the NMI IST stack. This is safe wrt. nested
	   NMIs as long as nested NMIs itself are safe.

As a rule of thumb, think of the #VC handler as trying to be a non-IST
handler by switching itself to the interrupted stack or the task stack.
If it detects that this is not possible (which can't happen right now,
but with SNP), it will kill the guest.

Also #VC is currently not safe against #MC, but this is the same as with
NMI and #MC. And more care is needed when SNP gets enabled and #VCs can
happen in the stack switching/stack adjustment code itself. I will
probably just add a check then to kill the guest if an SNP related #VC
comes from noinstr code.

> Is this really better than just turning IST off for #VC and
> documenting that we are not secure against a malicious hypervisor yet?

It needs to be IST, even without SNP, because #DB is IST too. When the
hypervisor intercepts #DB then any #DB exception will be turned into
#VC, so #VC needs to be handled anywhere a #DB can happen.

And with SNP we need to be able to at least detect a malicious HV so we
can reliably kill the guest. Otherwise the HV could potentially take
control over the guest's execution flow and make it reveal its secrets.

Regards,

	Joerg
