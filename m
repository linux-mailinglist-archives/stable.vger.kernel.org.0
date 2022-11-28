Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1543063AD8A
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 17:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbiK1QVh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 11:21:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbiK1QVg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 11:21:36 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD01F1BEA7
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 08:21:34 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id d1so17710605wrs.12
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 08:21:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7l0e6+kEcQQFvkN7YhfAN0By446IdSPyELxeXFw9c5Y=;
        b=dYgxQuVbSlB1pV2Luhhmv/tOa7sVlvBxyaYIdTLqHrjCYR4H4k0xJ3B8QJ/mclaoOJ
         SPaDArBaJMHyAlQhWN7tKbeD2E5gjvR4uC64C7/Cs2rANEM+OhUWD2lK+btagovEfx9t
         vX9PmkKU+urUmCGwQG2JJ9oqzay++VbpBMMgltN1KnBiRGXoXl6FQvJn6bI5Ea1RSqKN
         Ecv4NyEXjK6PmSI5uhRPHruCKBpflXQi3S/agyIp+ywMca9rS/CpBRSMsSUcPyCZVsKj
         bEXY6YBLcMBhGcyktI0xP/fHpzLHnJMlk15rir8NkKcKoZ1jNX0L/uu4S/Zezv1hWt0g
         81oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7l0e6+kEcQQFvkN7YhfAN0By446IdSPyELxeXFw9c5Y=;
        b=3bG0qziBjg3v8FSimH+vSQA/LcbGUBtgbpr0dO+pwegtT9GTrWpV2qREjjN0tFBLBh
         +3NzhypLrNh8gf1neh7oGvpAwAxWEVCQT0F8yY8rLE2QRgMUTZLzH+BFJBJttqa+pjwE
         m7YJBgVwZ3E+sLmKsVZEybhvei557XGq+FW5qfV3hT7Qrf2fbkXpP9fVP4cUh3wihI8f
         d0H8op+4kFAkjRxxjT3H+ZWkAKv2ewGW2+CuoYCEcNMAxQM+xMYBQTciJlKdtQMWD79Q
         JnQpjuoDUT0tHBzAdIRGw4QGNSv6dzmdPxXetk7CMTGsLLbixeSx43hxp7jYqNilXHME
         1Rjw==
X-Gm-Message-State: ANoB5pnBpMF4tlGzABZzJIL1KwPVtqXNZwcrIExvfkdF8FrIzAGlt0/r
        6+jC1RKHvtuTyTDmkJtP2Fjjdg==
X-Google-Smtp-Source: AA0mqf6e0Jsh0yIuny8MI5bX3mJwVUqPcAsqVCrRTZTzeIS17P6MI2YkV/B2Fjr9RzT3QgnAbHFVPg==
X-Received: by 2002:adf:fbc2:0:b0:241:eca8:4746 with SMTP id d2-20020adffbc2000000b00241eca84746mr16921914wrs.256.1669652493182;
        Mon, 28 Nov 2022 08:21:33 -0800 (PST)
Received: from google.com (65.0.187.35.bc.googleusercontent.com. [35.187.0.65])
        by smtp.gmail.com with ESMTPSA id c12-20020adfed8c000000b00236b2804d79sm11303251wro.2.2022.11.28.08.21.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 08:21:32 -0800 (PST)
Date:   Mon, 28 Nov 2022 16:21:28 +0000
From:   Vincent Donnefort <vdonnefort@google.com>
To:     Marc Zyngier <maz@kernel.org>, stable@vger.kernel.org,
        gregkh@kernel.org
Cc:     kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: pkvm: Fixup boot mode to reflect that the
 kernel resumes from EL1
Message-ID: <Y4TgCOFgjMWuTTWe@google.com>
References: <20221108100138.3887862-1-vdonnefort@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108100138.3887862-1-vdonnefort@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 08, 2022 at 10:01:38AM +0000, Vincent Donnefort wrote:
> From: Marc Zyngier <maz@kernel.org>
> 
> The kernel has an awfully complicated boot sequence in order to cope
> with the various EL2 configurations, including those that "enhanced"
> the architecture. We go from EL2 to EL1, then back to EL2, staying
> at EL2 if VHE capable and otherwise go back to EL1.
> 
> Here's a paracetamol tablet for you.
> 
> The cpu_resume path follows the same logic, because coming up with
> two versions of a square wheel is hard.
> 
> However, things aren't this straightforward with pKVM, as the host
> resume path is always proxied by the hypervisor, which means that
> the kernel is always entered at EL1. Which contradicts what the
> __boot_cpu_mode[] array contains (it obviously says EL2).
> 
> This thus triggers a HVC call from EL1 to EL2 in a vain attempt
> to upgrade from EL1 to EL2 VHE, which we are, funnily enough,
> reluctant to grant to the host kernel. This is also completely
> unexpected, and puzzles your average EL2 hacker.
> 
> Address it by fixing up the boot mode at the point the host gets
> deprivileged. is_hyp_mode_available() and co already have a static
> branch to deal with this, making it pretty safe.
> 
> Cc: <stable@vger.kernel.org> # 5.15+
> Reported-by: Vincent Donnefort <vdonnefort@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Tested-by: Vincent Donnefort <vdonnefort@google.com>
> 
> --- 
> 
> This patch doesn't have an upstream version. It's been fixed by the side
> effect of another upstream patch. see conversation [1]
> 
> [1] https://lore.kernel.org/all/20221011165400.1241729-1-maz@kernel.org/
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 4cb265e15361..3fe816c244ce 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -2000,6 +2000,17 @@ static int pkvm_drop_host_privileges(void)
>  	 * once the host stage 2 is installed.
>  	 */
>  	static_branch_enable(&kvm_protected_mode_initialized);
> +
> +	/*
> +	 * Fixup the boot mode so that we don't take spurious round
> +	 * trips via EL2 on cpu_resume. Flush to the PoC for a good
> +	 * measure, so that it can be observed by a CPU coming out of
> +	 * suspend with the MMU off.
> +	 */
> +	__boot_cpu_mode[0] = __boot_cpu_mode[1] = BOOT_CPU_MODE_EL1;
> +	dcache_clean_poc((unsigned long)__boot_cpu_mode,
> +			 (unsigned long)(__boot_cpu_mode + 2));
> +
>  	on_each_cpu(_kvm_host_prot_finalize, &ret, 1);
>  	return ret;
>  }
> -- 
> 2.38.1.431.g37b22c650d-goog
>

Hi Greg,

Any chance to pick this fix for 5.15?

Thanks!

-- 
Vincent.
