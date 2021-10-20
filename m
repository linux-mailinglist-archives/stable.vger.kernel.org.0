Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1D2D4347FF
	for <lists+stable@lfdr.de>; Wed, 20 Oct 2021 11:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbhJTJhU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 05:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbhJTJhT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Oct 2021 05:37:19 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA92DC06161C;
        Wed, 20 Oct 2021 02:35:05 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id m14so2424185pfc.9;
        Wed, 20 Oct 2021 02:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=I0ZEoxf+qBRrE4EbV2DUTK2XydFaBZKQRHBZdtXWdAI=;
        b=ZuTXYVNiTIfLkbMl6G+ZXFJwDD8iEeOO9ZL4ZcQyMqRWdw3D7oXfxTqhZu/j2em3IB
         8XMj9jq6yg0zME0rR8hUAhM3GVP6qjMkBR/U0bWPyFxHPi4Bl3LjCwENvAE4tSlun/7s
         wAswkg2Fb758WbOyD/QGu+6mmtOMB0rUYBQrIchpHr/xBPfFtW+cgFCNpVlNDm0Pc0/D
         647q2HD2sssL8dBVZrR8mSrz7Ppp1aE2hvbseyVM1/CHzkcKI58Q+9MYdVfCXxlJF7tA
         YcWLsyttuR6cOiJNaBX/B9Y5SMfzDcRSs6QnscagOXbbCHGHR/zmQZbaf2E8wrlJy6ep
         jTGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=I0ZEoxf+qBRrE4EbV2DUTK2XydFaBZKQRHBZdtXWdAI=;
        b=GnrpCVQ3Siw5AGiEhG9IKp7/BAf/d2+hf0B9ogyofRNRRhYBjUHr0MCXpalqqz7tqn
         oodQW5Y2v5qwPyM9MDTogKqY0KJA/z65aBD5l47kNrSBNF9dx5yE8cl2OZVtwjT06kkR
         ooOGKvuSelurBAdurLfWYQXNLghkeMuUiRGfP8T8cTD8Pp4K5HwNbMbomJBQJ6H51jWR
         75t9Oqy4mD0+dj/GMjXpbKijb+z1HxWXzu8k1qRXS/IGyWqLSu1xxDatS08DpRJxMG5L
         rExNDKf8FlhKY3bGFo3LHMZVDY9XD8umubybgr7/x92ZTr6jRR/UxDcsaaTCxVlY88bs
         0qWA==
X-Gm-Message-State: AOAM532mVY3Fta73LtLhGh40d1BpM5J+w6GNj1DxBt6x+wJDth24swHS
        mLEVErC5rqNY+Eu7pcAhVuFd0iyc8HI=
X-Google-Smtp-Source: ABdhPJxNP0G5kSvi88Ytp53fs3hL1SswaI+tfU2GpY8sqcprGF19p7VNXQeDBZIyuq+qhdAciF8y4Q==
X-Received: by 2002:a05:6a00:9a2:b0:44c:b979:afe3 with SMTP id u34-20020a056a0009a200b0044cb979afe3mr5194704pfg.61.1634722505179;
        Wed, 20 Oct 2021 02:35:05 -0700 (PDT)
Received: from localhost (14-203-144-177.static.tpgi.com.au. [14.203.144.177])
        by smtp.gmail.com with ESMTPSA id oc8sm1978993pjb.15.2021.10.20.02.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 02:35:04 -0700 (PDT)
Date:   Wed, 20 Oct 2021 19:35:00 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v2] KVM: PPC: Defer vtime accounting 'til after IRQ
 handling
To:     kvm-ppc@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Greg Kurz <groug@kaod.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Paul Mackerras <paulus@ozlabs.org>,
        stable@vger.kernel.org
References: <20211007142856.41205-1-lvivier@redhat.com>
        <875yu17rxk.fsf@mpe.ellerman.id.au>
        <d7f59d0e-eac2-7978-4067-9258c8b1aefe@redhat.com>
        <1634263564.zfj0ajf8eh.astroid@bobo.none>
        <2a13119c-ccec-1dd5-8cf6-da07a9d8fe6f@redhat.com>
In-Reply-To: <2a13119c-ccec-1dd5-8cf6-da07a9d8fe6f@redhat.com>
MIME-Version: 1.0
Message-Id: <1634722472.k7vwa86otu.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Excerpts from Laurent Vivier's message of October 20, 2021 4:29 pm:
> On 15/10/2021 04:23, Nicholas Piggin wrote:
>> Excerpts from Laurent Vivier's message of October 13, 2021 7:30 pm:
>>> On 13/10/2021 01:18, Michael Ellerman wrote:
>>>> Laurent Vivier <lvivier@redhat.com> writes:
>>>>> Commit 112665286d08 moved guest_exit() in the interrupt protected
>>>>> area to avoid wrong context warning (or worse), but the tick counter
>>>>> cannot be updated and the guest time is accounted to the system time.
>>>>>
>>>>> To fix the problem port to POWER the x86 fix
>>>>> 160457140187 ("Defer vtime accounting 'til after IRQ handling"):
>>>>>
>>>>> "Defer the call to account guest time until after servicing any IRQ(s=
)
>>>>>    that happened in the guest or immediately after VM-Exit.  Tick-bas=
ed
>>>>>    accounting of vCPU time relies on PF_VCPU being set when the tick =
IRQ
>>>>>    handler runs, and IRQs are blocked throughout the main sequence of
>>>>>    vcpu_enter_guest(), including the call into vendor code to actuall=
y
>>>>>    enter and exit the guest."
>>>>>
>>>>> Fixes: 112665286d08 ("KVM: PPC: Book3S HV: Context tracking exit gues=
t context before enabling irqs")
>>>>> Cc: npiggin@gmail.com
>>>>> Cc: <stable@vger.kernel.org> # 5.12
>>>>> Signed-off-by: Laurent Vivier <lvivier@redhat.com>
>>>>> ---
>>>>>
>>>>> Notes:
>>>>>       v2: remove reference to commit 61bd0f66ff92
>>>>>           cc stable 5.12
>>>>>           add the same comment in the code as for x86
>>>>>
>>>>>    arch/powerpc/kvm/book3s_hv.c | 24 ++++++++++++++++++++----
>>>>>    1 file changed, 20 insertions(+), 4 deletions(-)
>>>>>
>>>>> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_h=
v.c
>>>>> index 2acb1c96cfaf..a694d1a8f6ce 100644
>>>>> --- a/arch/powerpc/kvm/book3s_hv.c
>>>>> +++ b/arch/powerpc/kvm/book3s_hv.c
>>>> ...
>>>>> @@ -4506,13 +4514,21 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vc=
pu, u64 time_limit,
>>>>>   =20
>>>>>    	srcu_read_unlock(&kvm->srcu, srcu_idx);
>>>>>   =20
>>>>> +	context_tracking_guest_exit();
>>>>> +
>>>>>    	set_irq_happened(trap);
>>>>>   =20
>>>>>    	kvmppc_set_host_core(pcpu);
>>>>>   =20
>>>>> -	guest_exit_irqoff();
>>>>> -
>>>>>    	local_irq_enable();
>>>>> +	/*
>>>>> +	 * Wait until after servicing IRQs to account guest time so that an=
y
>>>>> +	 * ticks that occurred while running the guest are properly account=
ed
>>>>> +	 * to the guest.  Waiting until IRQs are enabled degrades the accur=
acy
>>>>> +	 * of accounting via context tracking, but the loss of accuracy is
>>>>> +	 * acceptable for all known use cases.
>>>>> +	 */
>>>>> +	vtime_account_guest_exit();
>>>>
>>>> This pops a warning for me, running guest(s) on Power8:
>>>>   =20
>>>>     [  270.745303][T16661] ------------[ cut here ]------------
>>>>     [  270.745374][T16661] WARNING: CPU: 72 PID: 16661 at arch/powerpc=
/kernel/time.c:311 vtime_account_kernel+0xe0/0xf0
>>>
>>> Thank you, I missed that...
>>>
>>> My patch is wrong, I have to add vtime_account_guest_exit() before the =
local_irq_enable().
>>=20
>> I thought so because if we take an interrupt after exiting the guest tha=
t
>> should be accounted to kernel not guest.
>>=20
>>>
>>> arch/powerpc/kernel/time.c
>>>
>>>    305 static unsigned long vtime_delta(struct cpu_accounting_data *acc=
t,
>>>    306                                  unsigned long *stime_scaled,
>>>    307                                  unsigned long *steal_time)
>>>    308 {
>>>    309         unsigned long now, stime;
>>>    310
>>>    311         WARN_ON_ONCE(!irqs_disabled());
>>> ...
>>>
>>> But I don't understand how ticks can be accounted now if irqs are still=
 disabled.
>>>
>>> Not sure it is as simple as expected...
>>=20
>> I don't know all the timer stuff too well. The
>> !CONFIG_VIRT_CPU_ACCOUNTING case is relying on PF_VCPU to be set when
>> the host timer interrupt runs irqtime_account_process_tick runs so it
>> can accumulate that tick to the guest?
>>=20
>> That probably makes sense then, but it seems like we need that in a
>> different place. Timer interrupts are not guaranteed to be the first one
>> to occur when interrupts are enabled.
>>=20
>> Maybe a new tick_account_guest_exit() and move PF_VCPU clearing to that
>> for tick based accounting. Call it after local_irq_enable and call the
>> vtime accounting before it. Would that work?
>=20
> Hi Nick,
>=20
> I think I will not have the time to have a look to fix that?
>=20
> Could you try?

Hey Laurent, sure I can take a look at it.

Thanks,
Nick
