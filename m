Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEB744327B4
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 21:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbhJRTdh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 15:33:37 -0400
Received: from mail.skyhub.de ([5.9.137.197]:38412 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233664AbhJRTdb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 15:33:31 -0400
Received: from zn.tnic (p200300ec2f085700af6a7a3215758573.dip0.t-ipconnect.de [IPv6:2003:ec:2f08:5700:af6a:7a32:1575:8573])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2B0B41EC04A9;
        Mon, 18 Oct 2021 21:31:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1634585479;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=+nsWWqmqSGVwOQE+JOrowpz/RZu30zxbCfysGoaRocY=;
        b=AEy/cLfrJofq6e20RF5dDlNHxet/AbvG36qGdU/gkziMRPWYRmUgWpWnip/LLdTtmpciPR
        PglnkOoc8OsryDpRzkUPM0NaMJVY2jId2RymJZw1YEnxCCo0xbARdhtgl8M8xJ+lm/9xpH
        MB12xABMXDNGjuYxsj9xYWJ3S6v9Wy8=
Date:   Mon, 18 Oct 2021 21:31:19 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     "H. Peter Anvin" <hpa@zytor.com>
Cc:     Jane Malalane <jane.malalane@citrix.com>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Pu Wen <puwen@hygon.cn>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Yazen Ghannam <Yazen.Ghannam@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Huang Rui <ray.huang@amd.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kim Phillips <kim.phillips@amd.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] x86/cpu: Fix migration safety with X86_BUG_NULL_SEL
Message-ID: <YW3Lhwzux0K1P72e@zn.tnic>
References: <20211013142230.10129-1-jane.malalane@citrix.com>
 <YW25x7AYiM1f1HQA@zn.tnic>
 <35CA4584-4CFD-4E47-9825-6438D9ED4ECC@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <35CA4584-4CFD-4E47-9825-6438D9ED4ECC@zytor.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 18, 2021 at 12:10:20PM -0700, H. Peter Anvin wrote:
> AFAIK no Intel CPU has ever had that behavior, and always cleared the
> segments; I don't Intel has any plans of supporting such a CPUID bit
> (although I'd certainly be willing to take such a request back to the
> CPU teams on request.)

No need - we can always set or clear a flag on Intel, depending on what
we do.

> That being said, this sounds like an ideal use for the hypervisor CPU
> feature flag.

Yap, it uses it.

> Maybe we should consider a migration hypervisor flag too to explicitly
> tell the kernel not to rely on hardware probing that breaks migration
> in general.

Meh, migration-specific flag calls for all kinds of nasty when each
HV would want different things to happen in the guest, for migration.
And then the patch flood will come. I mean, we already do a bunch of
X86_FEATURE_HYPERVISOR all over the place and apparently it is enough
here too...

> Now, with a CPUID but being introduced, the right thing would be to
> use the CPUID bit as a feature instead of using a bug flag, and add
> whitelisting in the vendor-specific code as applicable.

I guess we can flip all that logic checking X86_BUG_NULL_SEG... it
sounds like a lot of churn to me, though and I don't see a pressing need
for it unless someone is bored and wants to do some kernel patching
exercises but whatever...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
