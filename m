Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59B20387CBA
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 17:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350322AbhERPrs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 11:47:48 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:60996 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350273AbhERPrN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 11:47:13 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1621352753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tFBvPxPe54aPh5rteQfHOQUMzHXgN7KlH4xTqINWqUI=;
        b=vF3VwIKZ7BHMfvP7h9vdl91nh8NCm5AtXy+Cj9Rgh4ra0zvTety+D/HYzf4uIjXdgPLFh+
        d2/cspOgr2+p0oEpTVrarIpmvtHycyomeP1vaD+vvRPC9OXQ9QTC23WxUCggChR4AiCkdH
        AeHUcevehH9IctctK+Vg54ruWjcrTJxEbWj0UQk1u3GYB1KYIv9Pe2M22e7YxKuCnrWTVh
        slZj5oCGIqeeJytCLLAVZ+juPtL6R1kVg2q4ocjmedtGCWlsUwpZGO+wHaiuKlyT1GBJGK
        KPhBfMYtXWB1mbcRFThO81CrE0I8MRyuw3LL5VIGPqu62IuI27iQziYr3ELCwg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1621352753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tFBvPxPe54aPh5rteQfHOQUMzHXgN7KlH4xTqINWqUI=;
        b=vfQQExnlom63bLm3j2PsGUaANheJvookMkPzzYMK0X5MG96y7VK3tRd2QmSwfI9MuwXUJY
        rSXSM+7ZMucP9EDQ==
To:     Sachi King <nakato@nakato.io>,
        Maximilian Luz <luzmaximilian@gmail.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        David Laight <David.Laight@aculab.com>,
        "x86\@kernel.org" <x86@kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH] x86/i8259: Work around buggy legacy PIC
In-Reply-To: <1952705.8WFvOeMrJb@yuki>
References: <87a6otfblh.ffs@nanos.tec.linutronix.de> <b509418f-9fff-ab27-b460-ecbe6fdea09a@gmail.com> <87lf8ddjqx.ffs@nanos.tec.linutronix.de> <1952705.8WFvOeMrJb@yuki>
Date:   Tue, 18 May 2021 17:45:52 +0200
Message-ID: <87a6osdozz.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sachi,

On Wed, May 19 2021 at 05:58, Sachi King wrote:
> On Tuesday, May 18, 2021 9:27:02 AM AEST Thomas Gleixner wrote:
>> On Mon, May 17 2021 at 21:25, Maximilian Luz wrote:
>> > On 5/17/21 8:40 PM, Thomas Gleixner wrote:
>> >> Can you please add "apic=verbose" to the kernel command line and provide
>> >> full dmesg output for a kernel w/o your patch and one with your patch
>> >> applied?
>
> I've linked to a dmesg with "apic=verbose" below with the irq 7 override hack 
> applied.  Would you still like a copy without either of these patches
> applied?

No, that's pretty conclusive.

> What's the convention for including a dmesg on the mailing list?  I've 
> included the copy via gist as pasting it into email seems incorrect, but 
> that's also probably not the correct convention.

That's fine.

>> Sachi, can you please try the hack below to confirm the above?
>>
>> It's not meant to be a solution, but it's the most trivial way to
>> validate this.
>
> I've applied that patch and the GPIO driver loads and functions.

It's exactly what I expected. So now for a proper solution. After
talking to Raphael it seems something like that quirk is the best option
we have. I'll try to come up with something less horrible. There is some
other minor issue I noticed, which I need to look at as well.

Thanks for digging into this and for testing!

       tglx

