Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 206A2174886
	for <lists+stable@lfdr.de>; Sat, 29 Feb 2020 19:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727383AbgB2SAt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Feb 2020 13:00:49 -0500
Received: from mout.web.de ([212.227.15.14]:51241 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727255AbgB2SAs (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 29 Feb 2020 13:00:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1582999243;
        bh=7sBLw6YJEvp4YGnhVu8axUBel3768vmvW/3wio3Tvrs=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=qtAfRnJKKspS0RHfhCt1E4WknokrnCYugfF33HbDAP0DLHvUoETMDuBDK6Cb/zoRL
         wWfmVya3ho8O4nTwy0AaXNmuWRC2tTPd9eVA11G7176fnVgSMy9hE9oePrdluKOyd3
         6kAx+NjUxGca715D9QiSdN6NlcJ7+VfFmAsJues0=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.10] ([95.157.55.156]) by smtp.web.de (mrweb001
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0M6mgu-1jMLS32aM0-00wYrh; Sat, 29
 Feb 2020 19:00:43 +0100
Subject: Re: [FYI PATCH 1/3] KVM: nVMX: Don't emulate instructions in guest
 mode
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     oupton@google.com, stable@vger.kernel.org
References: <1582570596-45387-1-git-send-email-pbonzini@redhat.com>
 <1582570596-45387-2-git-send-email-pbonzini@redhat.com>
From:   Jan Kiszka <jan.kiszka@web.de>
Message-ID: <41d80479-7dbc-d912-ff0e-acd48746de0f@web.de>
Date:   Sat, 29 Feb 2020 19:00:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1582570596-45387-2-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:K/jHwtzw689mEoMzdHglVU2xe90FSO4aqZUuGdceM+yoNQP7fNF
 yed36k5DnywHOyrqBSxOfXIkztyjxTbL060SNBKrYNCOTTfde9p56s2j3sWdDwR2zS+dJSV
 W/WFaP1oIAMpmlisINKv80Id7lq5HLUHSqcZqlhmV2IpiyRGJLc1aJx/UV3jrUnP1tNNX8B
 SC6K3wbZYtFCtoyHGd0qw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:/hg5W+EoB70=:Dah3NSIkxbpBmnflbNMGTf
 wp7W+/OMFWZA0ez5TXiOBfnx8nyK1yJFV7n021lJAcCJuGqpYzL18ln/uf+T2PdZd0BihNfxh
 Mf0lxP1j1Gq0jAVy8/kNSALW9hw6iCIMGv133Ljf2AEtiQfb9Eo8nwLB6PLdlnYdqJ/CeiwCe
 dvwafZbCpWr9j9iEpERgfsztq1PGMQmFhLLz96zGREvZcixfZbwS9rz/MgtZOPCjeBEntukJo
 VvaMTfMk/dxiuFUYz71OykHxrLkIlny+Od1fC3A20WhuwpEn+PxyUhLxRPvU0HKKvTN/JcTbb
 uidQtjTVgx9VbyyqvFtrVninzRZi0/ftu9CfPPee18G3kwOzLTff4L01f6Bh0uhtv8gkPayK3
 hkKZ9GladgJbQCKgEj9iQ9nWRyve/LcvRXKu39ICV6AAKDRf4t5wcgmHD+sIoR5a7s8C13Kps
 b+yb1qfT4M3u8gpausB2H9le09mc1yaSwkxLbrvP3E8jdjrTrsdALF7YDW7ECLaR73+1hiY/O
 8s9Ww8NMie/q8WgS/XSSI/Ovc2P0WQMEznUXpAJ1qWPzd7nKkAOStcLeuTYz3crWtPBtsF8eD
 AEkPBfe0/ytsTAnxjq/YHw9sMTH/4GZ8Kj7nUgwVQoFpN9MsWCiIYj4zmbRa7SFDnVfaDtd5h
 2Wvbe5KQk2twmCqjIxu5S3etW7SwZDaZQzUkFAIi07Fy0OoS9ZLIZe+K+Blgqn5WPjkeQzQVV
 aEfQwzlJfWI0DO1UPKtAh3tMMLMkmpSwuPgdhT9hnDfKR/SsR37WIDaGZ+n1dhFti3omB5Vn3
 p5Dun7qD+j0I8ZQerWhl+GfraE193d9Qw4EMHyxn42maP52m344JreBoycDvdfy5RJf/x/VrC
 YZKi4TW0mNqJjytzTtxkB2xMtryWrShAmT3MhLoMWEuPWBh5qp256Vtvd/exYB1tSL3R4h1Cn
 uSsXUh4PHPgmYZtKFHAejoBUTJD/DMhlvG6Lo121gSD1xBSZ1GACZRt7H3mbQL8H4V2uMgJ4S
 +zmKQef40FDOP67VtD7mIGqO1DLaR9pC5YoAT1X8dZCGdawlrsVYzb1WRftQB2slS2+mh9g8z
 MLKVnbYgHy4o/cYhYrgKh2fXUgj5vet91ZbTBYN/SLwRw6MOn3hrmsikr+d+62WDVvE5oFg16
 J5yWnYOODK+CUds6xLrM4H9xR6CPPoSYNGRN6U/fyjk+dgL0D2XlTIb8amssKKzgfxjItXQfG
 szTfSpPOPeo3vTz7i
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 24.02.20 19:56, Paolo Bonzini wrote:
> vmx_check_intercept is not yet fully implemented. To avoid emulating
> instructions disallowed by the L1 hypervisor, refuse to emulate
> instructions by default.
>
> Cc: stable@vger.kernel.org
> [Made commit, added commit msg - Oliver]
> Signed-off-by: Oliver Upton <oupton@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index dcca514ffd42..5801a86f9c24 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7164,7 +7164,7 @@ static int vmx_check_intercept(struct kvm_vcpu *vc=
pu,
>   	}
>
>   	/* TODO: check more intercepts... */
> -	return X86EMUL_CONTINUE;
> +	return X86EMUL_UNHANDLEABLE;
>   }
>
>   #ifdef CONFIG_X86_64
>

Is this expected to cause regressions on less common workloads?
Jailhouse as L1 now fails when Linux as L2 tries to boot a CPU: L2-Linux
gets a triple fault on load_current_idt() in start_secondary(). Only
bisected so far, didn't debug further.

Jan
