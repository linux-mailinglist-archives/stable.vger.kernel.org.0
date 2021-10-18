Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F10432942
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 23:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232568AbhJRVss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 17:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231811AbhJRVss (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 17:48:48 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A61C9C06161C;
        Mon, 18 Oct 2021 14:46:36 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0857000d1633cd2c0a2bbf.dip0.t-ipconnect.de [IPv6:2003:ec:2f08:5700:d16:33cd:2c0a:2bbf])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 032061EC04A9;
        Mon, 18 Oct 2021 23:46:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1634593595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JA3ODn57yyFCTgqn4Db1tPCe0MaVdHR+I3o2KecHlZc=;
        b=QdrCDqKH2DzvbhR3ZX0meIyl4XOpPdGMdlhUgGc3EUm7j+vRJj02oDRD87lQBEA51PsQ7D
        1DqsAtDF2AsF5lmsii1kPitTZkdalDcLv3hgpBLfqKus1/aNp3C8d8tb+/OfGzbFvta6tq
        smusCk3wkotN+BGPDpSxgk8DGXit/HM=
Date:   Mon, 18 Oct 2021 23:46:34 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Andrew Cooper <andrew.cooper3@citrix.com>
Cc:     Jane Malalane <jane.malalane@citrix.com>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Pu Wen <puwen@hygon.cn>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Yazen Ghannam <Yazen.Ghannam@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Huang Rui <ray.huang@amd.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kim Phillips <kim.phillips@amd.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] x86/cpu: Fix migration safety with X86_BUG_NULL_SEL
Message-ID: <YW3rOv+60agyV2H6@zn.tnic>
References: <20211013142230.10129-1-jane.malalane@citrix.com>
 <YW25x7AYiM1f1HQA@zn.tnic>
 <bfa45053-1dbf-1cf6-4c6e-f6ec74a50422@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bfa45053-1dbf-1cf6-4c6e-f6ec74a50422@citrix.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 18, 2021 at 09:06:07PM +0100, Andrew Cooper wrote:
> ... this is 0x18 for Hygon, and ...

Sure, whatever :)

> >
> > 	/* All the remaining ones are affected */
> > 	set_cpu_bug(c, X86_BUG_NULL_SEG);
> 
> ... hypervisor && !ncsb still needs to set BUG_NULL_SEG, so you really
> can't exit early.

Yeah, we had a session on IRC, we came up with this rough version, more
polishing tomorrow:

static void early_probe_null_seg_clearing_base(struct cpuinfo_x86 *c)
{

        /* Zen3 CPUs advertise Null Selector Clears Base in CPUID. */
        if (c->extended_cpuid_level >= 0x80000021 && cpuid_eax(0x80000021) & BIT(6))
                return;

	/*
	 * CPUID bit above wasn't set. If this kernel is still running as a HV guest,
	 * then the HV has decided not to advertize that CPUID bit for whatever reason.
	 * For example, one member of the migration pool might be vulnerable.
	 * Which means, the bug is present: set the BUG flag and return.
	 */
        if (cpu_has(c, X86_FEATURE_HYPERVISOR)) {
		set_cpu_bug(c, X86_BUG_NULL_SEG);
                return;
	}

        /* Zen2 CPUs also have this behaviour, but no CPUID bit. 0x18 for Hygon. */
        if ((c->x86 == 0x17 || c->x86 == 0x18) && check_null_seg_clears_base(c))
                return;

        /* All the remaining ones are affected */
        set_cpu_bug(c, X86_BUG_NULL_SEG);
}

So I really want to have those comments explaining each step in the
complex check because we will forget why this crazy dance is being done
and as I said in a previous thread, we're not all virtualizers. :)

> No other CPU vendors are known to have this issue.

How do you know? Or should there be a comment along the lines of "Cooper
says that..."

:-)

> (And by "issue", even this is complicated.  Back in the 32bit
> days, it was a plausible perf improvement, but it backfired massively
> for AMD64 where there was a possibility/expectation to use NULL
> segments.)
> 
> Andy only put the check in unilaterally just in case, and even that was
> fine-ish until AMD went and fixed it silently in Zen2.

Yeah, there's the context switch overhead too but that's for another
thread.

> > Because if this null seg behavior detection should happen on all
> > CPUs - and I think it should, because, well, it has been that way
> > until now - then the vendor specific identification minus what
> > detect_null_seg_behavior() does should run first and then after
> > ->c_identify() is done, you should do something like:
> >
> >  if (!cpu_has_bug(c, X86_BUG_NULL_SEG)) { if
> >  (!check_null_seg_clears_base(c)) set_cpu_bug(c, X86_BUG_NULL_SEG);
> >  }
> >
> > so that it still takes place on all CPUs.
>
> This would only really work for boot cpu and setup_force_cap(),
> because no CPU is going to have X86_BUG_NULL_SEG set by
> default, but this still misses the point of the bugfix which
> is "check_null_seg_clears_base() must not be called when
> cpu_has_hypervisor".
>
> In practice, the BSP is good enough.  The behaviour predates the
> K8, which was the first CPU where it became observable without
> SMM/PUSHALL/etc, and quite possibly goes back to the dawn of time, and
> you can't mix a Zen1 and Zen2 in a 2-socket system.

Oh, I didn't express myself properly "should happen on all CPUs" was
supposed to mean, if this detection should happen on all vendors like it
does now. Not BSP vs AP.

> It is made unused by this patch, so can't be pulled out earlier, but
> should be adjusted.

Right.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
