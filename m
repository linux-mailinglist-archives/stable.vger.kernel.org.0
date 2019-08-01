Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07C9C7D4C0
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 07:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726152AbfHAFJq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 01:09:46 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35856 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbfHAFJp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 01:09:45 -0400
Received: by mail-pf1-f195.google.com with SMTP id r7so33284935pfl.3
        for <stable@vger.kernel.org>; Wed, 31 Jul 2019 22:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aLdgdj1EfeMVZ7XgY351LcWiVocr39+rpYFuoMHIDzQ=;
        b=J6WKPdKG6lEuXUsEYdwSy+xXv0V2TB0Z8XnXVWGAfSI03/7hdQibTWHOxe716G5xhM
         lVw4xNWem6Fu7CuOsEUUqxP0oofy0T9E7pdyW78vVRYVb6M3DltijB08Tx8l3WTIGWU3
         vEU/pgi59ZsJ1Y+LtclQ0nplNgRIgqpAFQjN3JN3ZtHZOv5JeBuzprH5oyt0vsWZXj8U
         QEi/vGMjIUIkXMo8G7x9XQ4ea6SVxYCDp9WTv98D7rhlPEE3YMqmufiwwuQ4hXj+EiCV
         yqQynWBPfF/aWGk3pQ2loi+B0jcSZy67pmd9Gp9LwPx29htlwRJH9ez/MdeiVc8KCXnC
         U5nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=aLdgdj1EfeMVZ7XgY351LcWiVocr39+rpYFuoMHIDzQ=;
        b=oDzj/7L58tuj2Mz2wPKCVov2p2HlKAcM0rQzVF3oneOLuybRoo7ZtHjxed1G24yd5y
         TKGaBIhjc9qoWKp6xcRmbyVlS3OKn4e3psyZIkgJfQr1OpUQJzsBwz/FY8BLtkqbNB+g
         sWRl976l44YfPbnmmXXbGLik5Mkc3HzS+uzUOQYcP8MOWylrNevkjI6IWa1z2UGesiOx
         xj4Bfo/CCSnCfuGcrNaU2Vg0qnTJAgxC58qDT+yx9VTiXae0kT0gtpr+yQfHX8tiZTqT
         q74uh9Y82jFZHpRGQsHsE6ult04fiyBXVL5HslYY6mf3Xsnuz601PBvX3OJBuUON1Yfq
         UeTA==
X-Gm-Message-State: APjAAAXs2jAwAEainyUBGc3XyvnQItAR+X7fhvjZKZt+xGQ6eMeOg7C6
        BgO7bjcBhuWY9QeeM69pfe4F7g==
X-Google-Smtp-Source: APXvYqyqM+VVslQdFWG491bGgkdXzFwyEniKtN5NsnBUBiF85SJ7Qanfs0z+9szSSwZNTIBayOyBaw==
X-Received: by 2002:a17:90a:4806:: with SMTP id a6mr6543128pjh.38.1564636185001;
        Wed, 31 Jul 2019 22:09:45 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id t96sm3320891pjb.1.2019.07.31.22.09.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 22:09:43 -0700 (PDT)
Date:   Thu, 1 Aug 2019 10:39:40 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Julien Thierry <julien.thierry@arm.com>
Cc:     stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com, julien.thierry.kdev@gmail.com
Subject: Re: [PATCH v4.4 V2 25/43] arm64: Move BP hardening to
 check_and_switch_context
Message-ID: <20190801050940.h65crfawrdifsrgg@vireshk-i7>
References: <cover.1562908074.git.viresh.kumar@linaro.org>
 <f655aaa158af070d45a2bd4965852b0c97a08838.1562908075.git.viresh.kumar@linaro.org>
 <59b252cf-9cb7-128b-4887-c21a8b9b92a9@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59b252cf-9cb7-128b-4887-c21a8b9b92a9@arm.com>
User-Agent: NeoMutt/20180716-391-311a52
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 31-07-19, 14:09, Julien Thierry wrote:
> 
> 
> On 12/07/2019 06:28, Viresh Kumar wrote:
> > From: Marc Zyngier <marc.zyngier@arm.com>
> > 
> > commit a8e4c0a919ae310944ed2c9ace11cf3ccd8a609b upstream.
> > 
> > We call arm64_apply_bp_hardening() from post_ttbr_update_workaround,
> > which has the unexpected consequence of being triggered on every
> > exception return to userspace when ARM64_SW_TTBR0_PAN is selected,
> > even if no context switch actually occured.
> > 
> > This is a bit suboptimal, and it would be more logical to only
> > invalidate the branch predictor when we actually switch to
> > a different mm.
> > 
> > In order to solve this, move the call to arm64_apply_bp_hardening()
> > into check_and_switch_context(), where we're guaranteed to pick
> > a different mm context.
> > 
> > Acked-by: Will Deacon <will.deacon@arm.com>
> > Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> > ---
> >  arch/arm64/mm/context.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm64/mm/context.c b/arch/arm64/mm/context.c
> > index be42bd3dca5c..de5afc27b4e6 100644
> > --- a/arch/arm64/mm/context.c
> > +++ b/arch/arm64/mm/context.c
> > @@ -183,6 +183,8 @@ void check_and_switch_context(struct mm_struct *mm, unsigned int cpu)
> >  	raw_spin_unlock_irqrestore(&cpu_asid_lock, flags);
> >  
> >  switch_mm_fastpath:
> > +	arm64_apply_bp_hardening();
> > +
> >  	cpu_switch_mm(mm->pgd, mm);
> >  }
> >  
> > @@ -193,8 +195,6 @@ asmlinkage void post_ttbr_update_workaround(void)
> >  			"ic iallu; dsb nsh; isb",
> >  			ARM64_WORKAROUND_CAVIUM_27456,
> >  			CONFIG_CAVIUM_ERRATUM_27456));
> > -
> > -	arm64_apply_bp_hardening();
> 
> Patches 22 and 23 factorize the post_ttbr_update_workaround() and move
> it to C code just so we would and a call to arm64_apply_bp_hardening()
> in patch 24 that now gets moved elsewhere?
> 
> Is it really worth backporting patches 22 and 23?

If I can merge patch 24 and 25 into a single patch while backporting,
then patch 22 and 23 won't be required. I am not sure how should the
commit log look like in that case though :)

Is mentioning both the upstream commit ids along with log of the first
patch (which was more important) enough, like this ?

Author: Will Deacon <will.deacon@arm.com>
Date:   Wed Jan 3 11:17:58 2018 +0000

    arm64: Add skeleton to harden the branch predictor against aliasing attacks
    
    commit 0f15adbb2861ce6f75ccfc5a92b19eae0ef327d0 upstream.
    commit a8e4c0a919ae310944ed2c9ace11cf3ccd8a609b upstream.
    
    Aliasing attacks against CPU branch predictors can allow an attacker to
    redirect speculative control flow on some CPUs and potentially divulge
    information from one context to another.
    
    This patch adds initial skeleton code behind a new Kconfig option to
    enable implementation-specific mitigations against these attacks for
    CPUs that are affected.
    
    Co-developed-by: Marc Zyngier <marc.zyngier@arm.com>
    Signed-off-by: Will Deacon <will.deacon@arm.com>
    Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
    [ v4.4: Changes made according to 4.4 codebase ]
    Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

-- 
viresh
