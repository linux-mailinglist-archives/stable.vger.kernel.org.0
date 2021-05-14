Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B485380EEE
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 19:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbhENRaM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 13:30:12 -0400
Received: from terminus.zytor.com ([198.137.202.136]:55143 "EHLO
        mail.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229516AbhENRaM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 May 2021 13:30:12 -0400
Received: from tazenda.hos.anvin.org ([IPv6:2601:646:8602:8be0:7285:c2ff:fefb:fd4])
        (authenticated bits=0)
        by mail.zytor.com (8.16.1/8.15.2) with ESMTPSA id 14EHSaXc3149327
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Fri, 14 May 2021 10:28:36 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 14EHSaXc3149327
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2021042801; t=1621013318;
        bh=jSzPdXXc18oxGyRbNuujyb/chXDixgHnSADRJ1xFGAw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=ZgJnsaf9WvSYOIHTsfdIIHP1/Yhs8t/6zK6uHxzk//1cTlkiwLo8CUGJkRx+roSNj
         KspkzNOpGlHIKX4POtuFDtmRY/EsUe6IGSI8D25gizCAtst3Z6bmTW/1QcAyeiozB1
         /1WEI7OaP7Q/8/lFI163/CzIm+Lgwx1fpUO4dbRQycuSdZOO19PHjpMLVLG/sTpm09
         62DgYkR8TbVugGuO7gwMfSSqJmZoaXP++4iMAUAnrsPVbt2apA6PnVqUpB9uw2Sy8A
         xPVnO8J4VKsw//i9+VRclX+OlLAjDk8IhDtLRXug/ZwviZ5d8SBZvocEUJ5FPGe7GQ
         4gOnSv3hPZoGQ==
Subject: Re: [PATCH] x86/i8259: Work around buggy legacy PIC
To:     David Laight <David.Laight@ACULAB.COM>,
        "'Thomas Gleixner'" <tglx@linutronix.de>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
Cc:     Sachi King <nakato@nakato.io>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20210512210459.1983026-1-luzmaximilian@gmail.com>
 <9b70d8113c084848b8d9293c4428d71b@AcuMS.aculab.com>
 <e7dbd4d1-f23f-42f0-e912-032ba32f9ec8@gmail.com>
 <87r1i94eg6.ffs@nanos.tec.linutronix.de>
 <f0f52e319c06462ea0b5fbba827df9e0@AcuMS.aculab.com>
From:   "H. Peter Anvin" <hpa@zytor.com>
Message-ID: <b29b5c28-c36d-9c03-fc1a-055d8a089bcd@zytor.com>
Date:   Fri, 14 May 2021 10:28:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <f0f52e319c06462ea0b5fbba827df9e0@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/14/21 9:12 AM, David Laight wrote:
> 
> A more interesting probe would be:
> - Write some value to register 1 - the mask.
> - Write 9 to register zero (selects interrupt in service register).
> - Read register 0 - should be zero since we aren't in as ISR.
> - Read register 1 - should get the mask back.
> You can also write 8 to register 0, reads then return the pending interrupts.
> Their might be pending interrupts - so that value can't be checked.
> 
> But if reads start returning the last written value you might only
> have capacitors on the data bus.

What data bus? These things haven't been on a physical parallel bus for 
ages.

> The required initialisation registers are pretty fixed for the PC hardware.
> But finding the values requires a bit of work.
> 
> 	David

And you always risk activating new bugs.

Since this appears to be a specific platform advertising the wrong 
answer in firmware, this is better handled as a quirk.

	-hpa

