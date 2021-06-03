Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCCE39AAF1
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 21:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbhFCTas (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 15:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbhFCTas (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Jun 2021 15:30:48 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DECDC06174A;
        Thu,  3 Jun 2021 12:29:03 -0700 (PDT)
Received: from zn.tnic (p200300ec2f13850043af4c4d530a3258.dip0.t-ipconnect.de [IPv6:2003:ec:2f13:8500:43af:4c4d:530a:3258])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A959D1EC0246;
        Thu,  3 Jun 2021 21:29:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1622748541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=6paDKQJHEjIdx6NGu5KmRam+YlvwZVZiDbV6ggOOvIc=;
        b=d8k6qjUhDgO7FqHQANt/hqbfXBXWj0sQ/K8HMPLp6zfg/ou9wrZESr2pctZcVbB5w2ruFd
        mwCXnAL0kR7Z7+rqToEaabhuzT+D8HoOP0ZLQRJtlzsEEnNOe/EYlRaau5EEwD7PXMT2Zr
        uj3pipgy3Z3Cy1VeK8uKPcW6dnItmuw=
Date:   Thu, 3 Jun 2021 21:28:56 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Yu-cheng Yu <yu-cheng.yu@intel.com>, stable@vger.kernel.org
Subject: Re: [patch 3/8] x86/fpu: Invalidate FPU state after a failed XRSTOR
 from a user buffer
Message-ID: <YLkteEfyD3mqcCnO@zn.tnic>
References: <20210602095543.149814064@linutronix.de>
 <20210602101618.627715436@linutronix.de>
 <YLeedfdsnsKqcbGx@zn.tnic>
 <6220f2da-1d5b-843c-fa82-58a28fbcdd6b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6220f2da-1d5b-843c-fa82-58a28fbcdd6b@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 03, 2021 at 10:30:05AM -0700, Andy Lutomirski wrote:
> Think "complex microarchitectural conditions".

Ah, the magic phrase.

> How about:
> 
> As far as I can tell, both Intel and AMD consider it to be
> architecturally valid for XRSTOR to fail with #PF but nonetheless change
> user state.  The actual conditions under which this might occur are
> unclear [1], but it seems plausible that this might be triggered if one
> sibling thread unmaps a page and invalidates the shared TLB while
> another sibling thread is executing XRSTOR on the page in question.
> 
> __fpu__restore_sig() can execute XRSTOR while the hardware registers are
> preserved on behalf of a different victim task (using the
> fpu_fpregs_owner_ctx mechanism), and, in theory, XRSTOR could fail but
> modify the registers.  If this happens, then there is a window in which
> __fpu__restore_sig() could schedule out and the victim task could
> schedule back in without reloading its own FPU registers.  This would
> result in part of the FPU state that __fpu__restore_sig() was attempting
> to load leaking into the victim task's user-visible state.
> 
> Invalidate preserved FPU registers on XRSTOR failure to prevent this
> situation from corrupting any state.
> 
> [1] Frequent readers of the errata lists might imagine "complex
> microarchitectural conditions".

Yap, very nice, thanks!

> > I'm wondering if that comment can simply be above the TIF_NEED_FPU_LOAD
> > testing, standalone, instead of having it in an empty else? And then get
> > rid of that else.
> 
> I'm fine either way.

Ok, then let's aim for common, no-surprise-there patterns as we're in a
mine field here anyway.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
