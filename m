Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D413978C6
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 19:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234581AbhFARKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 13:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234336AbhFARKw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 13:10:52 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D1FFC061756
        for <stable@vger.kernel.org>; Tue,  1 Jun 2021 10:09:09 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id t21so7237391plo.2
        for <stable@vger.kernel.org>; Tue, 01 Jun 2021 10:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=402d1vT6kafYaa9OYO/pPQP5D7goCvQWXQjnoTnBYFQ=;
        b=nvD1x9UnnGp3hae8WGb9Lu3uwOLha5HnwrxcS+3j/a6aVYtpRG3lQRNKHRXn9MZsRo
         cNHa5eqm6imtzc1nHTEQSRxeQdANEiUh5XwzWfjTcPfnBmIaFkkVijToJHe4NCFliK26
         fKer1rpr36RWINI+Df+gLfUl/5a0QT+3O6/XxilFO9yyoVnPfBLtbTIGbobVWZHcHEg4
         /5DB0DmTugmIZAdvxkisovnHLX0zwBq7lE9Od9xAisuJeqdsIYybWuRmHib6Fz2rJBtC
         ZBcmcDNbyflRDUhDnexP1Tk+7wL85JusaA39AOX+dygv3qWsAOEYG7SaqDHXN9sEZNof
         MkKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=402d1vT6kafYaa9OYO/pPQP5D7goCvQWXQjnoTnBYFQ=;
        b=LjxKEJdgiE7ADq9CB65WG+IxOtEQyp8kMld5fM09QKYPCS8bjBEcHRXHebASVL2fKX
         rVE3MOMqO+roU3AKI30lV/xiwZCgkH9bsLiQd9Uah3ttMdZPrWekJqsENf5TsqElW219
         VqS5vWKL16yejgbQNf2BzyUL5bFqsmoCioejAQNz0y9CTB9eOfCdw8oE7GTHz527HEld
         7H3i7e6vaEL2i0mBnwaFkqG50KM7MPJTBwQWhS/itYTJz6H6WEzBNNsaCh19jqKmq9Vw
         b1tk/fHfF/eDA/hK5DPe0X2RvzVpTYNRLpliMxsqNYjY+V66Qpb5OeGCQeAgVkpkLjyd
         5RnQ==
X-Gm-Message-State: AOAM530zQxOKR2HQu528zJHG5fXRijmEzAV49yP8lMz9CCDJMkOaB1np
        F1JSadkj262r6xxhqj4oMHLDYg==
X-Google-Smtp-Source: ABdhPJzdKyTOillNzs0rsuVx1le6bvyhxJP5iSe1FXNQm6CSoJOIo4hsR6+K15AV3rAQNWrH7caPQg==
X-Received: by 2002:a17:902:6b42:b029:107:a6d5:fc8a with SMTP id g2-20020a1709026b42b0290107a6d5fc8amr5375144plt.76.1622567348693;
        Tue, 01 Jun 2021 10:09:08 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id z12sm14331891pfk.45.2021.06.01.10.09.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 10:09:07 -0700 (PDT)
Date:   Tue, 1 Jun 2021 17:09:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Borislav Petkov <bp@alien8.de>, Pu Wen <puwen@hygon.cn>,
        Joerg Roedel <jroedel@suse.de>, x86@kernel.org,
        joro@8bytes.org, dave.hansen@linux.intel.com, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        sashal@kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/sev: Check whether SEV or SME is supported first
Message-ID: <YLZpsPli0ALRISvV@google.com>
References: <20210526072424.22453-1-puwen@hygon.cn>
 <YK6E5NnmRpYYDMTA@google.com>
 <905ecd90-54d2-35f1-c8ab-c123d8a3d9a0@hygon.cn>
 <YLSuRBzM6piigP8t@suse.de>
 <e1ad087e-a951-4128-923e-867a8b38ecec@hygon.cn>
 <YLZGuTYXDin2K9wx@zn.tnic>
 <YLZc3sFKSjpd2yPS@google.com>
 <dbc4e48f-187a-4b2d-2625-b62d334f60b2@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dbc4e48f-187a-4b2d-2625-b62d334f60b2@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 01, 2021, Tom Lendacky wrote:
> 
> On 6/1/21 11:14 AM, Sean Christopherson wrote:
> > On Tue, Jun 01, 2021, Borislav Petkov wrote:
> >> On Mon, May 31, 2021 at 10:56:50PM +0800, Pu Wen wrote:
> >>> Thanks for your suggestion, I'll try to set up early #GP handler to fix
> >>> the problem.
> >>
> >> Why? AFAICT, you only need to return early in sme_enable() if CPUID is
> >> not "AuthenticAMD". Just do that please.
> > 
> > I don't think that would suffice, presumably MSR_AMD64_SEV doesn't exist on older
> > AMD CPUs either.  E.g. there's no mention of MSR 0xC001_0131 in the dev's guide
> > from 2015[*].
> 
> That is the reason for checking the maximum supported leaf being at least
> 0x8000001f. If that leaf is supported, we expect the SEV status MSR to be
> valid. The problem is that the Hygon ucode does not support the MSR in
> question. I'm not sure what it would take for that to be added to their
> ucode and just always return 0.

Ah.  But it's also legal/possible for the max extended leaf to be greater than
0x8000001f, e.g. 0x80000020, without 0x8000001f itself being supported.  Even
if AMD can guarantee no such processor will exist, I don't think it would be
illegal for a hypervisor to emulate a feature (on an "AuthenticAMD" virtual CPU)
enumerated by a higher leaf on an older physical AMD CPU (or non-AMD CPU!) that
doesn't support MSR_AMD64_SEV.

> > I also don't see the point in checking the vendor string.  A malicious hypervisor
> > can lie about CPUID.0x0 just as easily as it can lie about CPUID.0x8000001f, so
> > for SEV the options are to either trust the hypervisor or eat #GPs on RDMSR for
> > non-SEV CPUs.  If we go with "trust the hypervisor", then the original patch of
> > hoisting the CPUID.0x8000001f check up is simpler than checking the vendor string.
> 
> Because a hypervisor can put anything it wants in the CPUID 0x0 /
> 0x80000000 fields, I don't think we can just check for "AuthenticAMD".
> 
> If we want the read of CPUID 0x8000001f done before reading the SEV status
> MSR, then the original patch is close, but slightly flawed, e.g. only SME
> can be indicated but then MSR_AMD64_SEV can say SEV active.

I didn't follow this.  Bare metal CPUs should never report only SME in CPUID and
then report SEV as being active in the MSR.

In the SEV case, relying on CPUID in any way, shape, or form requires trusting
the hypervisor.  The code could assert that CPUID and the MSR are consistent, but
I don't see any value in doing so as a much more effective attack would be to
report neither SME nor SEV as supported.
