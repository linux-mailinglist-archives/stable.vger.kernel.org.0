Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 075676E25E
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 10:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbfGSIRn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 04:17:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50546 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbfGSIRn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jul 2019 04:17:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=/N0fwQUf+LFvYWyDwHukfaEU87+mI1t965IcqrX5RhE=; b=v2decXNuCTpVdF6+CgRLhcO3L
        jHU+Qf9NVcoLiWtFL/ZtApdPGMJaG6QP8YBPEIVkRBL3qQxANVMrXF7vJ54m3hEXjatalIBx95WjK
        55KCOmUjp4QyLDFlm21HP1wLl8TTUI7xrYS9BLbRteSH7GBMV7uvjxFDeXSrRK1nehlP4HtepoZQB
        u+phEYp/CcpqadxUr7EiUVLmw8rIQVfKnYDe2shYNV89Yex3x+09WSI7QWHv3hbPO7fT74CJDx6kq
        coPMV/5T8E1VsRPJjrmDRCaCYUMXoDU8xd1LvSKjgQV2v7P93izlo4kHGjE9cTo0Vab+Ws2Swoq/M
        oJbjwiszQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hoO57-0004wo-JA; Fri, 19 Jul 2019 08:17:34 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 558B820BA5401; Fri, 19 Jul 2019 10:17:32 +0200 (CEST)
Date:   Fri, 19 Jul 2019 10:17:32 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Vaibhav Rustagi <vaibhavrustagi@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>,
        "# 3.4.x" <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86/purgatory: add -mno-sse, -mno-mmx, -mno-sse2 to
 Makefile
Message-ID: <20190719081732.GF3419@hirez.programming.kicks-ass.net>
References: <20190718000206.121392-1-vaibhavrustagi@google.com>
 <20190718000206.121392-2-vaibhavrustagi@google.com>
 <CAKwvOdkHHNR7utufOcDwAOgBEA9MnOLh713Gaq01R=n26EyjZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdkHHNR7utufOcDwAOgBEA9MnOLh713Gaq01R=n26EyjZw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 18, 2019 at 02:34:44PM -0700, Nick Desaulniers wrote:
> On Wed, Jul 17, 2019 at 5:02 PM Vaibhav Rustagi
> <vaibhavrustagi@google.com> wrote:
> >
> > Compiling the purgatory code with clang results in using of mmx
> > registers.
> >
> > $ objdump -d arch/x86/purgatory/purgatory.ro | grep xmm
> >
> >      112:       0f 28 00                movaps (%rax),%xmm0
> >      115:       0f 11 07                movups %xmm0,(%rdi)
> >      122:       0f 28 00                movaps (%rax),%xmm0
> >      125:       0f 11 47 10             movups %xmm0,0x10(%rdi)
> >
> > Add -mno-sse, -mno-mmx, -mno-sse2 to avoid generating SSE instructions.
> >
> > Signed-off-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
> > ---
> >  arch/x86/purgatory/Makefile | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
> > index 3cf302b26332..3589ec4a28c7 100644
> > --- a/arch/x86/purgatory/Makefile
> > +++ b/arch/x86/purgatory/Makefile
> > @@ -20,6 +20,7 @@ KCOV_INSTRUMENT := n
> >  # sure how to relocate those. Like kexec-tools, use custom flags.
> >
> >  KBUILD_CFLAGS := -fno-strict-aliasing -Wall -Wstrict-prototypes -fno-zero-initialized-in-bss -fno-builtin -ffreestanding -c -Os -mcmodel=large
> > +KBUILD_CFLAGS += -mno-mmx -mno-sse -mno-sse2
> 
> Yep, this is a commonly recurring bug in the kernel, observed again
> and again for Clang builds.  The top level Makefile carefully sets
> KBUILD_CFLAGS, then lower subdirs in the kernel wipe them away with
> `:=` assignment. Invariably important flags don't always get re-added.
> In this case, these flags are used in arch/x86/Makefile, but not here
> and should be IMO.  Thanks for the patch.

Should we then not fix/remove these := assignments?
