Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 281B8380A0E
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 15:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbhENNDC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 09:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhENNDC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 May 2021 09:03:02 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8277C061574;
        Fri, 14 May 2021 06:01:50 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1620997309;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6WK8Uhovat2rNpVT4rMlmAU7lk0bJSnslVIjRn8b7u4=;
        b=IcmpKQXJaMnRT46k0vQ3txAs2wcCeq3uORnWnm8KCb8hmh+8ed7TYEQ3xm0ANbrmY3+3NZ
        wWM1kfI+jFzKEAzQEjT7yzeejmIFgQ2BTuAFr8Ch71Td8kpqypN9hl7wqvwf/EiuMNTSkh
        bYxwTYaBMSWV5kGfWznx7gxS1+d8PrJFipF0Gem9UcOyNJIc/IK0DGi9nNwg18oI9Deyst
        MWoGJwu4yS/rJ9ZwoFY8dc1nG/aIn09jzKLocCr0wwvWGvRRZC9/BRcdDH9eSCYmoLS5YP
        db+M8l/SaoWBhwO1EUke/eJd7Mw0K9oDnG1O7LQQVwb1gnSGROS2+GGgtNPcHQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1620997309;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6WK8Uhovat2rNpVT4rMlmAU7lk0bJSnslVIjRn8b7u4=;
        b=YR6RH5dGO0YiPGI2tnLHb/sARh6P5vXUc1t0rrYQwhd+/fJhbrYrO0OmF+5xochIST9/7Y
        kA0SAZWUtHp+gFDQ==
To:     David Laight <David.Laight@ACULAB.COM>,
        'Maximilian Luz' <luzmaximilian@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, Sachi King <nakato@nakato.io>,
        "x86\@kernel.org" <x86@kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable\@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] x86/i8259: Work around buggy legacy PIC
In-Reply-To: <e43d9a823c9e44bab0cdbf32a000c373@AcuMS.aculab.com>
References: <20210512210459.1983026-1-luzmaximilian@gmail.com> <9b70d8113c084848b8d9293c4428d71b@AcuMS.aculab.com> <e7dbd4d1-f23f-42f0-e912-032ba32f9ec8@gmail.com> <e43d9a823c9e44bab0cdbf32a000c373@AcuMS.aculab.com>
Date:   Fri, 14 May 2021 15:01:48 +0200
Message-ID: <87tun54gg3.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

David,

On Thu, May 13 2021 at 10:36, David Laight wrote:

>> -----Original Message-----
>> From: Maximilian Luz <luzmaximilian@gmail.com>
>> Sent: 13 May 2021 11:12
>> To: David Laight <David.Laight@ACULAB.COM>; Thomas Gleixner <tglx@linutronix.de>; Ingo Molnar
>> <mingo@redhat.com>; Borislav Petkov <bp@alien8.de>
>> Cc: H. Peter Anvin <hpa@zytor.com>; Sachi King <nakato@nakato.io>; x86@kernel.org; linux-
>> kernel@vger.kernel.org; stable@vger.kernel.org
>> Subject: Re: [PATCH] x86/i8259: Work around buggy legacy PIC

can you please fix your mail client and spare us the useless header
duplication in the reply?

> It is also worth noting that the probe code is spectacularly crap.
> It writes 0xff and then checks that 0xff is read back.
> Almost anything (including a failed PCIe read to the ISA bridge)
> will return 0xff and make the test pass.

        unsigned char probe_val = ~(1 << PIC_CASCADE_IR);

	outb(probe_val, PIC_MASTER_IMR);
	new_val = inb(PIC_MASTER_IMR);

How is that writing 0xFF?

Thanks,

        tglx
