Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8110851971B
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 07:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344771AbiEDGDN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 02:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344788AbiEDGDM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 02:03:12 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB5AF2AE12;
        Tue,  3 May 2022 22:59:36 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KtR433QQ5z4xXS;
        Wed,  4 May 2022 15:59:31 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1651643971;
        bh=C8XFNo0MACWuzzd3GeNsre8CYszj5XfLhRDPTpa0WTs=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=odIvWeIo7sy+7E938rOqDN4nNheG/V9tcPuj5+9aZeDCrqs4lBdqW90f3DZ4ygj33
         fpNG17LjwHCdAf5yhIgbY+W0xg1LyDy8uFe3x2H07adoJikyiKiCv+wP2cokE0mY3Z
         byt94S3010u4Tb+68MPxaG44Rs5IrNHuR0x2U/Pj2r6ffil2jRl5zPOehqBe4xWigQ
         H+GcrF8y1ffJQUj+FUGBoO4b3xxXqhS+8p/4Da5U5jXmbLjni7Dj4DjwkuCjBWg3Lk
         cOPOa5PtbIQQNisaEDy93H1ABL8cGgtUtPJqakI6OJUl6z19edrlKIckmN+dE0yoRe
         EOrYRG8c/Nz2w==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Laurent Dufour <ldufour@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v2] powerpc/rtas: Keep MSR[RI] set when calling RTAS
In-Reply-To: <c33a2be3-d4b7-9b3b-c980-552f5de081be@linux.ibm.com>
References: <20220401140634.65726-1-ldufour@linux.ibm.com>
 <87r15aveny.fsf@mpe.ellerman.id.au>
 <c33a2be3-d4b7-9b3b-c980-552f5de081be@linux.ibm.com>
Date:   Wed, 04 May 2022 15:59:29 +1000
Message-ID: <87ee19vnwe.fsf@mpe.ellerman.id.au>
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
> On 03/05/2022, 17:06:41, Michael Ellerman wrote:
>> Laurent Dufour <ldufour@linux.ibm.com> writes:
...
>>> diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
>>> index 1f42aabbbab3..d7775b8c8853 100644
>>> --- a/arch/powerpc/kernel/rtas.c
>>> +++ b/arch/powerpc/kernel/rtas.c
>>> @@ -49,6 +49,11 @@ void enter_rtas(unsigned long);
>>>  
>>>  static inline void do_enter_rtas(unsigned long args)
>>>  {
>>> +	unsigned long msr;
>>> +
>>> +	msr = mfmsr();
>>> +	BUG_ON(!(msr & MSR_RI));
>> 
>> I'm not sure about this.
>> 
>> We call RTAS in some low-level places, so if we ever hit this BUG_ON
>> then it might cause us to crash badly, or recursively BUG.
>> 
>> A WARN_ON_ONCE() might be safer?
>
> I'm afraid a BUG_ON is required here. Since MSR[RI] is set on RTAS exit so
> if it was not set when calling RTAS, that's a real issue and should
> generate unexpected behaviour.
>
> Do you have places in mind where RTAS could be called with !MSR[RI]?

The main one I can think of is if someone is using
CONFIG_UDBG_RTAS_CONSOLE, then udbg_rtascon_putc() is wired up as
udbg_putc() and that might be called from anywhere, including xmon.

There's also RTAS calls in low-level xics interrupt code, that might get
called during panic/crash.

I don't expect any of those places to be called with MSR[RI] unset, but
I'm worried that if we're already crashing and for some reason MSR[RI]
is unset, then that BUG_ON will just make things worse.

eg. imagine taking a BUG_ON() for every character we try to print as
part of an oops.

Admittedly CONFIG_UDBG_RTAS_CONSOLE is old and probably not used much
anymore, but I'm still a bit paranoid :)

cheers
