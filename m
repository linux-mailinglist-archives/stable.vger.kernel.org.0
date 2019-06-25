Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F394F553AB
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 17:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbfFYPpF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 11:45:05 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36566 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727572AbfFYPpE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jun 2019 11:45:04 -0400
Received: by mail-wm1-f67.google.com with SMTP id u8so3477342wmm.1
        for <stable@vger.kernel.org>; Tue, 25 Jun 2019 08:45:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aRO1W46ROJMS0ZRgbEt/JW4/hpRyhoBHX+I5SlHhkhE=;
        b=L4NP5HZuY7gpem+oC1aA61zsXYbGEKjKOKjMHgqWCn1IP4F2kKbdQX7TaiwUaaQlt6
         EHa2IMsi8WiA/f+sf6feyV1Y3HGban8r+BVnhEbQk1RBfo4N/5vEhFmggZQqXJLVmETj
         rTfA8fot2z80DZ/ZMyBFMBtCNyvaEc0nYFZQImFnUy5VqG8k47A1yRymiMO/oAms/X21
         xJ5JsgbgykEyPbGMA2+57kDyx7kFXX7o4F2iPJjgJQcyeD3/EAczkUYRaWMIIXqqIvNT
         dbkjJbflKu2oojfh4LvaL20EcY1/kkHB4OuPESTJthp3ivDoLgj1Nu1K8tsiJ2tUylK1
         Gocw==
X-Gm-Message-State: APjAAAWegbFemmD2Gh5kAt8S2gRpUlQpNImIxOgUk3xTs2FbF21RDCC/
        Pn7Pcq8aXDYqnp/aOlDEbmJeGxe4M+U=
X-Google-Smtp-Source: APXvYqwjFb3HsTti/fYEh6c7y9Iz08eehzg5jSc6TfpUL1Ogvgk4N8X4MsCMgdQ5WK/vamie/w36WQ==
X-Received: by 2002:a7b:cd9a:: with SMTP id y26mr21292947wmj.44.1561477502524;
        Tue, 25 Jun 2019 08:45:02 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:61c1:6d8f:e2c4:2d5c? ([2001:b07:6468:f312:61c1:6d8f:e2c4:2d5c])
        by smtp.gmail.com with ESMTPSA id h84sm3332070wmf.43.2019.06.25.08.45.01
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 08:45:02 -0700 (PDT)
Subject: Re: [PATCH 1/1] kvm/speculation: Allow KVM guests to use SSBD even if
 host does not
To:     Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        rkrcmar@redhat.com
Cc:     x86@kernel.org, kvm@vger.kernel.org,
        stable <stable@vger.kernel.org>
References: <1560187210-11054-1-git-send-email-alejandro.j.jimenez@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1c9d4047-e54c-8d4b-13b1-020864f2f5bf@redhat.com>
Date:   Tue, 25 Jun 2019 17:45:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1560187210-11054-1-git-send-email-alejandro.j.jimenez@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/06/19 19:20, Alejandro Jimenez wrote:
> The bits set in x86_spec_ctrl_mask are used to calculate the
> guest's value of SPEC_CTRL that is written to the MSR before
> VMENTRY, and control which mitigations the guest can enable.
> In the case of SSBD, unless the host has enabled SSBD always
> on mode (by passing "spec_store_bypass_disable=on" in the
> kernel parameters), the SSBD bit is not set in the mask and
> the guest can not properly enable the SSBD always on
> mitigation mode.
> 
> This is confirmed by running the SSBD PoC on a guest using
> the SSBD always on mitigation mode (booted with kernel
> parameter "spec_store_bypass_disable=on"), and verifying
> that the guest is vulnerable unless the host is also using
> SSBD always on mode. In addition, the guest OS incorrectly
> reports the SSB vulnerability as mitigated.
> 
> Always set the SSBD bit in x86_spec_ctrl_mask when the host
> CPU supports it, allowing the guest to use SSBD whether or
> not the host has chosen to enable the mitigation in any of
> its modes.
> 
> Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
> Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

> ---
>  arch/x86/kernel/cpu/bugs.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> index 03b4cc0..66ca906 100644
> --- a/arch/x86/kernel/cpu/bugs.c
> +++ b/arch/x86/kernel/cpu/bugs.c
> @@ -836,6 +836,16 @@ static enum ssb_mitigation __init __ssb_select_mitigation(void)
>  	}
>  
>  	/*
> +	 * If SSBD is controlled by the SPEC_CTRL MSR, then set the proper
> +	 * bit in the mask to allow guests to use the mitigation even in the
> +	 * case where the host does not enable it.
> +	 */
> +	if (static_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD) ||
> +	    static_cpu_has(X86_FEATURE_AMD_SSBD)) {
> +		x86_spec_ctrl_mask |= SPEC_CTRL_SSBD;
> +	}
> +
> +	/*
>  	 * We have three CPU feature flags that are in play here:
>  	 *  - X86_BUG_SPEC_STORE_BYPASS - CPU is susceptible.
>  	 *  - X86_FEATURE_SSBD - CPU is able to turn off speculative store bypass
> @@ -852,7 +862,6 @@ static enum ssb_mitigation __init __ssb_select_mitigation(void)
>  			x86_amd_ssb_disable();
>  		} else {
>  			x86_spec_ctrl_base |= SPEC_CTRL_SSBD;
> -			x86_spec_ctrl_mask |= SPEC_CTRL_SSBD;
>  			wrmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
>  		}
>  	}
> 

