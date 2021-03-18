Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1125734063F
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 14:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbhCRNDZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 09:03:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230169AbhCRNDG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Mar 2021 09:03:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C238564DFB;
        Thu, 18 Mar 2021 13:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616072586;
        bh=H6FwzdcR6qvs2S3lGFKitAunGXBMVAggNXohomzWTJs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bWfYlaL4e1wy5J/8tv/4LjIWO/K7eY8EjaTBE/nDluRODRc5fduBkAl7zzAetXb8U
         XK9eGBiz5utE1KB3LXXa/51FX6ZbMO+ul1HPVovxuLuWWDJ8HxSNlDhka7Xm3XQLmW
         NKw2oFRSGFqr+Q1KESoI/8kyj84TsDr9IyUq5fgLuBrYnbtxWVKV3ECuVaBkblubWr
         KP7q2pkPrTISrjGPvUt0Kt39ge5k42zQaRQ/P6bvA3t5P1nZqSHtEwT1dNk1wyYOnI
         tCGsiapEGLcXXCYA6yJpHZYo/DUsR+5Ux1cgvcHBmfXpKAtmAY7K3lmX6uEzuXhG8v
         fw8xrkkV7hljQ==
Date:   Thu, 18 Mar 2021 09:03:04 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Thomas Backlund <tmb@tmb.nu>, "# 3.4.x" <stable@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: stable request
Message-ID: <YFNPiHAvEwDpGLrv@sashalap>
References: <d5c825ba-cdcb-29eb-c434-83ef4db05ee0@tmb.nu>
 <CAMj1kXEM76Dejv1fTZ-1EmXpSsE-ZtKWf19dPNTSBRuPcAkreA@mail.gmail.com>
 <1e6eb02b-e699-d1ff-9cfb-4ef77255e244@tmb.nu>
 <9493dced-908e-a9bd-009a-6b20a8422ec1@tmb.nu>
 <CAMj1kXHzEEU2-mVxVD8g=P_Py_WJMOn0q8m+k-txUUioS+2ajQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAMj1kXHzEEU2-mVxVD8g=P_Py_WJMOn0q8m+k-txUUioS+2ajQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 16, 2021 at 01:35:40PM +0100, Ard Biesheuvel wrote:
>On Tue, 16 Mar 2021 at 13:28, Thomas Backlund <tmb@tmb.nu> wrote:
>>
>>
>> Den 16.3.2021 kl. 14:15, skrev Thomas Backlund:
>> >
>> > Den 16.3.2021 kl. 12:17, skrev Ard Biesheuvel:
>> >> On Tue, 16 Mar 2021 at 10:21, Thomas Backlund <tmb@tmb.nu> wrote:
>> >>> Den 16.3.2021 kl. 08:37, skrev Ard Biesheuvel:
>> >>>> Please consider backporting commit
>> >>>>
>> >>>> 86ad60a65f29dd862a11c22bb4b5be28d6c5cef1
>> >>>> crypto: x86/aes-ni-xts - use direct calls to and 4-way stride
>> >>>>
>> >>>> to stable. It addresses a rather substantial retpoline-related
>> >>>> performance regression in the AES-NI XTS code, which is a widely used
>> >>>> disk encryption algorithm on x86.
>> >>>>
>> >>> To get all the nice bits, we added the following in Mageia 5.10 / 5.11
>> >>> series kerenels (the 2 first is needed to get the third to apply/build
>> >>> nicely):
>> >>>
>> >> I will leave it up to the -stable maintainers to decide, but I will
>> >> point out that none of the additional patches fix any bugs, so this
>> >> may violate the stable kernel rules. In fact, I deliberately split the
>> >> XTS changes into two  patches so that the first one could be
>> >> backported individually.
>> >
>> > Yes, I understand that.
>> >
>> > but commit
>> >
>> > 86ad60a65f29dd862a11c22bb4b5be28d6c5cef1
>> > crypto: x86/aes-ni-xts - use direct calls to and 4-way stride
>> >
>> > only applies cleanly on 5.11.
>> >
>> >
>> > So if it's wanted in 5.10 you need the 2 others too... unless you intend to provide a tested backport...
>> > and IIRC GregKH prefers 1:1 matching of patches between -stable and linus tree unless they are too intrusive.
>> >
>> >
>> > As for the last one I seem to remember comments that it too was part of the "affects performance", but I might be remembering wrong... and since you are Author of them I assume you know better about the facts :)
>> >
>> >
>> > That's why I listed them as an extra "hopefully helfpful" info and datapoint that they work...
>> > We have been carrying them in 5.10 series since we rebased to 5.10.8 on January 17th, 2021
>> >
>> >
>> > but in the end it's up to the -stable maintainers as you point out...
>>
>>
>> and now  I re-checked...
>>
>> Only the first is needed to get your fix to apply cleanly on 5.10
>>
>>
>> the second came in as a pre-req for the fourth patch...
>>
>
>OK so that would be
>
>032d049ea0f45b45c21f3f02b542aa18bc6b6428
>Uros Bizjak <ubizjak@gmail.com>
>crypto: aesni - Use TEST %reg,%reg instead of CMP $0,%reg
>
>which is already in 5.11, but needs to be backported as well for the
>originally requested backport to apply cleanly to 5.10 and earlier.
>
>Thanks for digging that up.

Queued up for 5.10 and 5.11.

What about anything older than 5.10? Looks like it's needed there too?

-- 
Thanks,
Sasha
