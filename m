Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1205251968F
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 06:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344553AbiEDEbc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 00:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344592AbiEDEbS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 00:31:18 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC972A273;
        Tue,  3 May 2022 21:27:43 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KtP232qptz4xXS;
        Wed,  4 May 2022 14:27:39 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1651638459;
        bh=4sM2j3BRcMpmeza4V5S7AVgFp6Yn9zTTV5iVujj+gyE=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=bC0SMIwFaxBOZjqcSS31sFWjfDNPG9ynZQ5VHo4uPLDNtKtMmH6TCjZ3IUkwKl2Re
         WgOWScAzufXX58ExM9BA3lbHAWTOVVCezwPJ3A6Ie9jwGQYZFHlj/jO8dCvLs5VScv
         Cxwo+BWhEr0pJpOWwM+xyo5QqONlqya+BD8bjcBP6PoByWECribrQDhMy1qOOrvQi+
         GtcZ17wyNaRxYD1j6iSJihqiEmROGGWQfRR8VbM/Kj0e9mkGaZdkA4Zzw7LbR0fbef
         3ONdkfptjbL9stkwmtIaRUQdyst4mgmwXGSCJYLKIH7jiRBncj4X8YLdckVcaXN/Us
         QMS4I05CCyDMA==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Laurent Dufour <ldufour@linux.ibm.com>,
        Fabiano Rosas <farosas@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v2] powerpc/rtas: Keep MSR[RI] set when calling RTAS
In-Reply-To: <60195753-93fc-ced7-c250-da65c05508af@linux.ibm.com>
References: <20220401140634.65726-1-ldufour@linux.ibm.com>
 <87r15aveny.fsf@mpe.ellerman.id.au> <87levia8wy.fsf@linux.ibm.com>
 <60195753-93fc-ced7-c250-da65c05508af@linux.ibm.com>
Date:   Wed, 04 May 2022 14:27:38 +1000
Message-ID: <87h765vs5h.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Laurent Dufour <ldufour@linux.ibm.com> writes:
> On 03/05/2022, 18:16:29, Fabiano Rosas wrote:
>> Michael Ellerman <mpe@ellerman.id.au> writes:
>> 
>>>> diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
>>>> index 9581906b5ee9..65cb14b56f8d 100644
>>>> --- a/arch/powerpc/kernel/entry_64.S
>>>> +++ b/arch/powerpc/kernel/entry_64.S
>>>> @@ -330,22 +330,18 @@ _GLOBAL(enter_rtas)
>>>>  	clrldi	r4,r4,2			/* convert to realmode address */
>>>>         	mtlr	r4
>>>>  
>>>> -	li	r0,0
>>>> -	ori	r0,r0,MSR_EE|MSR_SE|MSR_BE|MSR_RI
>>>> -	andc	r0,r6,r0
>>>> -	
>>>> -        li      r9,1
>>>> -        rldicr  r9,r9,MSR_SF_LG,(63-MSR_SF_LG)
>>>> -	ori	r9,r9,MSR_IR|MSR_DR|MSR_FE0|MSR_FE1|MSR_FP|MSR_RI|MSR_LE
>>>> -	andc	r6,r0,r9
>>>  
>>> One advantage of the old method is it can adapt to new MSR bits being
>>> set by the kernel.
>>>
>>> For example we used to use RTAS on powernv, and this code didn't need
>>> updating to cater to MSR_HV being set. We will probably never use RTAS
>>> on bare-metal again, so that's OK.
>>>
>>> But your change might break secure virtual machines, because it clears
>>> MSR_S whereas the old code didn't. I think SVMs did use RTAS, but I
>>> don't know whether it matters if it's called with MSR_S set or not?
>>>
>>> Not sure if anyone will remember, or has a working setup they can test.
>>> Maybe for now we just copy MSR_S from the kernel MSR the way the
>>> current code does.
>> 
>> Would the kernel even be able to change the bit? I think only urfid can
>> clear MSR_S.
>
> That's a good point, thanks Fabiano!
>
> The POWER ISA programming note about MSR[S] is explicit:
> "MSR[S] can be set to 1 only by the System Call instruction and some
> interrupts. It can be set to 0 only by urfid."
>
> Since RTAS is entered using rfid, MSR[S] should remain whatever is the
> value in SRR1.
>
> And that's what POWER ISA is saying about the rfid instruction, in the
> synopsis of the instruction the bit 41 of the resulting MSR (aka MSR[S]) is
> not impacted.
>
> So there is no need to take care of this MSR bit in our code, but for sure,
> this should be well commented.
>
> Michael, do you agree?

Yep.

Can you send a v3 with updated change log and comment mentioning MSR_S
and MSR_LE, thanks.

cheers
