Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB96522CBC4
	for <lists+stable@lfdr.de>; Fri, 24 Jul 2020 19:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgGXRRP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jul 2020 13:17:15 -0400
Received: from gecko.sbs.de ([194.138.37.40]:46960 "EHLO gecko.sbs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726397AbgGXRRP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jul 2020 13:17:15 -0400
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Jul 2020 13:17:14 EDT
Received: from mail2.sbs.de (mail2.sbs.de [192.129.41.66])
        by gecko.sbs.de (8.15.2/8.15.2) with ESMTPS id 06OH7AVU029510
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jul 2020 19:07:10 +0200
Received: from [139.22.112.247] ([139.22.112.247])
        by mail2.sbs.de (8.15.2/8.15.2) with ESMTP id 06OH76bs007058;
        Fri, 24 Jul 2020 19:07:07 +0200
Subject: Re: [PATCH 4.9 18/22] x86/fpu: Disable bottom halves while loading
 FPU registers
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        kvm ML <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Rik van Riel <riel@surriel.com>, x86-ml <x86@kernel.org>,
        cip-dev <cip-dev@lists.cip-project.org>
References: <20181228113126.144310132@linuxfoundation.org>
 <20181228113127.414176417@linuxfoundation.org>
From:   Jan Kiszka <jan.kiszka@siemens.com>
Message-ID: <01857944-ce1a-c6cd-3666-1e9b6ca8cccc@siemens.com>
Date:   Fri, 24 Jul 2020 19:07:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20181228113127.414176417@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 28.12.18 12:52, Greg Kroah-Hartman wrote:
> 4.9-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> 
> commit 68239654acafe6aad5a3c1dc7237e60accfebc03 upstream.
> 
> The sequence
> 
>    fpu->initialized = 1;		/* step A */
>    preempt_disable();		/* step B */
>    fpu__restore(fpu);
>    preempt_enable();
> 
> in __fpu__restore_sig() is racy in regard to a context switch.
> 
> For 32bit frames, __fpu__restore_sig() prepares the FPU state within
> fpu->state. To ensure that a context switch (switch_fpu_prepare() in
> particular) does not modify fpu->state it uses fpu__drop() which sets
> fpu->initialized to 0.
> 
> After fpu->initialized is cleared, the CPU's FPU state is not saved
> to fpu->state during a context switch. The new state is loaded via
> fpu__restore(). It gets loaded into fpu->state from userland and
> ensured it is sane. fpu->initialized is then set to 1 in order to avoid
> fpu__initialize() doing anything (overwrite the new state) which is part
> of fpu__restore().
> 
> A context switch between step A and B above would save CPU's current FPU
> registers to fpu->state and overwrite the newly prepared state. This
> looks like a tiny race window but the Kernel Test Robot reported this
> back in 2016 while we had lazy FPU support. Borislav Petkov made the
> link between that report and another patch that has been posted. Since
> the removal of the lazy FPU support, this race goes unnoticed because
> the warning has been removed.
> 
> Disable bottom halves around the restore sequence to avoid the race. BH
> need to be disabled because BH is allowed to run (even with preemption
> disabled) and might invoke kernel_fpu_begin() by doing IPsec.
> 
>   [ bp: massage commit message a bit. ]
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Acked-by: Ingo Molnar <mingo@kernel.org>
> Acked-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
> Cc: kvm ML <kvm@vger.kernel.org>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Cc: Rik van Riel <riel@surriel.com>
> Cc: stable@vger.kernel.org
> Cc: x86-ml <x86@kernel.org>
> Link: http://lkml.kernel.org/r/20181120102635.ddv3fvavxajjlfqk@linutronix.de
> Link: https://lkml.kernel.org/r/20160226074940.GA28911@pd.tnic
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   arch/x86/kernel/fpu/signal.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/arch/x86/kernel/fpu/signal.c
> +++ b/arch/x86/kernel/fpu/signal.c
> @@ -342,10 +342,10 @@ static int __fpu__restore_sig(void __use
>   			sanitize_restored_xstate(tsk, &env, xfeatures, fx_only);
>   		}
>   
> +		local_bh_disable();
>   		fpu->fpstate_active = 1;
> -		preempt_disable();
>   		fpu__restore(fpu);
> -		preempt_enable();
> +		local_bh_enable();
>   
>   		return err;
>   	} else {
> 
> 

Any reason why the backport stopped back than at 4.9? I just debugged 
this out of a 4.4 kernel, and it is needed there as well. I'm happy to 
propose a backport, would just appreciate a hint if the BH protection is 
needed also there (my case was without BH).

Thanks,
Jan

-- 
Siemens AG, Corporate Technology, CT RDA IOT SES-DE
Corporate Competence Center Embedded Linux
