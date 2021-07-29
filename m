Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4063DA5F0
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 16:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239111AbhG2OKJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 10:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238665AbhG2OHd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Jul 2021 10:07:33 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB00C0619EB
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 07:00:12 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id r2so7119561wrl.1
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 07:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=liO5wucVGjUgl66CCyk5eCr9ee7CWFbOuaagBW74+qs=;
        b=EJ2F3ITFwEJ9rcPEvHQ6lQ2DOZnQ5vBtGtiPUiaEaUYZAeiKbLrc61I8wPZVT0mmce
         oMnATeCgB3nMSCmOY6JYICgTkdxdCA6cizvZWmE5FXgzbr/++FZUo4NbEvGTfoaVyNo1
         0azpBzwCzgho7Xydbwqhu4X7ssL0HYuQtBhcVrHshYeuX/tgsNM/hwhRAfj6VPIYKcNn
         SRdE5PgOBshCvRabzbztBxFP+svsg33eT/iYXEhNAvgVqbLfjYJ27YSZ+f2oEjLm1yDO
         AhQLpqmc/tmy1CFjkjoE2k7ynXOGtOgA9wC8FJHeG8CjoVUhMUY8rhuJgR4gWWk4TaFx
         BLGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=liO5wucVGjUgl66CCyk5eCr9ee7CWFbOuaagBW74+qs=;
        b=qu+hId/BSn+F7gvKs9c5yEj9KqWTHL8Q03zNa4LOr1XQIIM+qwVC14UWNrMxtgLjyS
         myx4a/C7G0sieA9NokZHAewVqMpMy2vaYx63CvJdFlvBxb7VrZfdw08vSES0vaMvdW32
         h6OHzX2vrjuaRbH0d4Ehe2UyPf0fQB+C9emBarc6tC0AJsbsGGdY0nZlYWQMvEprbX64
         FU+Gtd6fFkWIhuiMyuMcrA98jPKbVTirCXUWbU0NpyS2zaQt0O1EmTX/f40aaIk9IY4s
         K9fvcB1M7xSrSptzWSfBYJSGBGDvZOgJ/DLpH1Qs22ksJpVFkRZhywRtku66Aaob68nc
         JeZw==
X-Gm-Message-State: AOAM533EcGlmPEf1T3C/uucx83IJSe/i1uvytIxDU6nARoQLkxnWXQfx
        cT6Jeu95uIzL9v5mcuuggfM1Iw==
X-Google-Smtp-Source: ABdhPJzb3jcmoJ3eeO2z7wKiK0sm764dKThMtyfcXT/S/xhsz1jMXke7rkEjfqjma4uFzTs051Dz9A==
X-Received: by 2002:a5d:64ac:: with SMTP id m12mr4942109wrp.89.1627567209287;
        Thu, 29 Jul 2021 07:00:09 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:293a:bc89:7514:5218])
        by smtp.gmail.com with ESMTPSA id l18sm9913097wmq.0.2021.07.29.07.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 07:00:09 -0700 (PDT)
Date:   Thu, 29 Jul 2021 15:00:05 +0100
From:   Quentin Perret <qperret@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Unregister HYP sections from kmemleak in
 protected mode
Message-ID: <YQK0ZeRZY/53tWEZ@google.com>
References: <20210729135016.3037277-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210729135016.3037277-1-maz@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thursday 29 Jul 2021 at 14:50:16 (+0100), Marc Zyngier wrote:
> Booting a KVM host in protected mode with kmemleak quickly results
> in a pretty bad crash, as kmemleak doesn't know that the HYP sections
> have been taken away.
> 
> Make the unregistration from kmemleak part of marking the sections
> as HYP-private. The rest of the HYP-specific data is obtained via
> the page allocator, which is not subjected to kmemleak.
> 
> Fixes: 90134ac9cabb ("KVM: arm64: Protect the .hyp sections from the host")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: Quentin Perret <qperret@google.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: stable@vger.kernel.org # 5.13
> ---
>  arch/arm64/kvm/arm.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index e9a2b8f27792..23f12e602878 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -15,6 +15,7 @@
>  #include <linux/fs.h>
>  #include <linux/mman.h>
>  #include <linux/sched.h>
> +#include <linux/kmemleak.h>
>  #include <linux/kvm.h>
>  #include <linux/kvm_irqfd.h>
>  #include <linux/irqbypass.h>
> @@ -1960,8 +1961,12 @@ static inline int pkvm_mark_hyp(phys_addr_t start, phys_addr_t end)
>  }
>  
>  #define pkvm_mark_hyp_section(__section)		\
> +({							\
> +	u64 sz = __section##_end - __section##_start;	\
> +	kmemleak_free_part(__section##_start, sz);	\
>  	pkvm_mark_hyp(__pa_symbol(__section##_start),	\
> -			__pa_symbol(__section##_end))
> +		      __pa_symbol(__section##_end));	\
> +})

At some point we should also look into unmapping these sections from
EL1 stage-1 as well, as that should lead to better error messages in
case the host accesses hyp-private memory some other way. But this
patch makes sense on its own, so:

Reviewed-by: Quentin Perret <qperret@google.com>

Thanks,
Quentin
