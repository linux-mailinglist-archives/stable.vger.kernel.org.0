Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E93B64E53A
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 01:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiLPAgP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 19:36:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbiLPAgG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 19:36:06 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 093455E08A
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 16:36:06 -0800 (PST)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id D1CA885353;
        Fri, 16 Dec 2022 01:36:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1671150964;
        bh=T+mP39cIMEHonu9/Zp55tlLxMp85cHAptl0xyYvMQsM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=AUDRlfoMeRq2pJ9H7ddvAVT3EcXuJJ5kdj5V4dRKnxh8iAwuvHg18ImxaWlOjgoSw
         MDf7E0qfLcX5ru3Sq7KknXCm6WWlkCqD9Wh0qNvEODNfWICtPS8mQxhuqy1GwKshtk
         ssAlrIb2uA9Dwlls8bZVFhvebI8FCnU+BVIKXFu8Uo2B0a5Blm0Zm899HdfNFyIMsW
         L170opc6OPwjeYScXDDOLPrf+b+VP4OEWr5JtvdxnjFzdoB9gOg2n24QbeBYcvP2a7
         CvMXYoGlcST04PIMR3qf4ma9tMDsst/Wg3c4h4/umc4g/w2so1Ppk71wp9PfQdUXMh
         qDmc35GRNKPRg==
Message-ID: <a54bf573-c14a-a546-10fc-e50274986ff5@denx.de>
Date:   Fri, 16 Dec 2022 01:36:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v1] mtd: parsers: ofpart: Fix parsing when size-cells is 0
Content-Language: en-US
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Francesco Dolcini <francesco@dolcini.it>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-mtd@lists.infradead.org,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        u-boot@lists.denx.de
References: <20221202150556.14c5ae43@xps-13>
 <2b6fc52d-60b9-d0f4-ab91-4cf7a8095999@denx.de>
 <20221202160030.1b8d0b8a@xps-13>
 <223b7a4e-3aff-8070-7387-c77d2ded1dd6@denx.de>
 <20221202164904.08d750df@xps-13>
 <0503c46d-c385-74f5-f762-51d87a5ebaff@denx.de>
 <20221202174255.2c1cb2ff@xps-13>
 <e80377c9-1542-d47d-6d35-2efdc15bcbf8@denx.de>
 <20221202175730.231d75d5@xps-13>
 <7afd364c-33b8-38a9-65a6-015b4360db6b@denx.de>
 <Y43VdPftDbq6cD2L@francesco-nb.int.toradex.com>
 <20221205144917.6514168a@xps-13>
 <ecca019d-b0b7-630c-4221-2684cb51634c@denx.de>
 <20221215081604.5385fa56@xps-13>
 <ac50a1ee-4312-48f6-af78-7b95a77e6fda@denx.de>
 <20221215090446.28363133@xps-13>
From:   Marek Vasut <marex@denx.de>
In-Reply-To: <20221215090446.28363133@xps-13>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.6 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/15/22 09:04, Miquel Raynal wrote:
> Hi Marek,

Hi,

[...]

>>> Yesterday while talking about an ACPI mis-description which needed
>>> fixing, I realized fixing up what the firmware provides to Linux should
>>> preferably be handled as early as possible. So my first first idea was
>>> to avoid using the broken "fixup mtdparts" function in U-Boot and I am
>>> still convinced this is what we should do in priority. However, as
>>> rightly pointed in this thread, we need to take care about the case
>>> where someone would use a newer DT (let's say, with the reverted changed
>>> reverted again) with an old U-Boot. I am still against piggy hacks in
>>> the generic ofpart.c driver, but what we could do however is a DT
>>> fixup in the init_machine (or the dt_fixup) hook for imx7 Colibri, very
>>> much like this:
>>> https://elixir.bootlin.com/linux/latest/source/arch/arm/mach-mvebu/board-v7.c#L111
>>> Plus a warning there saying "your dt is broken, update your firmware".
>>
>> This does not work, because the old U-Boot fixup_mtdparts() may be applied on any machine,
> 
> No: https://elixir.bootlin.com/u-boot/latest/A/ident/fdt_fixup_mtdparts

These are the boards from vendors who upstreamed their properly.

This does NOT take into account either boards which are using downstream 
U-Boot, or older U-Boot e.g. because they can not easily update.

> And we should make our best so its use does not proliferate.

I am not disputing that, but that's a separate U-Boot side fix which I 
hope Francesco would submit soon, AND, more importantly, the code is 
already in at least two U-Boot releases, so it's done, it's not going 
away any time soon.

> It's not like there is half a dozen of good ways to describe and forward
> partitions today.

That's really not what I am disputing here, the approach to describing 
partitions is crystal clear as far as I can tell.

>> it is not colibri mx7 specific. Also, new arch-side workaround are
>> really not welcome by the architecture maintainers as far as I can
>> tell.
> 
> So what? Let's propose the change and see what the maintainers have to
> say. I am open to discussion.

Why is there such strong opposition toward generic fix in the OF 
partition parser ?

> As I said, it is not colibri mx7 specific, there are a few boards which
> might be affected,

... that you know about ...

> they are all clearly identifiable with a compatible.
> It's not the entire planet either.

Neither of us can make this statement with certainty, because neither of 
us knows what hardware is running the affected version of U-Boot.

>>> So next time someone stumbles upon this issue, we can tell them "fix
>>> your bootloader", and apply the same hack in their board family (there
>>> are three or four IIRC which might be concerned some day).
>>
>> There are also those machines we do not even know about which might be generating bogus DT using old U-Boot and fixup_mtdparts(), so, unless there is some all-arch fixup implementation, we wouldn't be able to fix them all on arch side. I think the all-arch fixup implementation would be the driver one, i.e. this patch as it is (or maybe with some improvement).
> 
> If we don't know about them, as you say, I don't feel concerned.
> 
> If something is buggy, people will report it, we will point them in the
> right direction so they can fix their firmware and propose a similar
> fix in their case which will involve adding a new machine compatible to
> the list of boards that should tweak the #size-cell property.

Why is a potentially lengthy list of compatible strings in arch code, 
which every single user has to find _after_ their system completely 
fails to boot and forces them to perform potentially difficult recovery, 
potentially after an update to new linux-stable release no less -- over 
-- 4 liner generic fix in OF partition parser, which covers all the 
systems, does not cause systems to fail to boot completely, does not 
force users to suffer through recovery, does not require a list of 
compatibles in arch code, and rather only gracefully prints a warning ?

I very much prefer the second solution over the first.

And one more thing, the list of compatibles in arch code does not really 
work anyway, since once user updates their bootloader, the compatible 
won't change and the arch-side workaround would still be applied, which 
is not desired at that point anymore.

>>> That would fix all cases and only have an impact on the affected boards.
>>
>> Sadly, it does only fix the known cases, not the unknown cases like downstream forks which never get any bootloader updates ever, and which you can't find in upstream U-Boot, and which you therefore cannot easily catch in the arch side fixup.
> 
> And ?

I was under the impression Linux was supposed to deliver the best 
possible experience to its users even on not-perfect hardware, and if 
there are any quirks, the kernel should try to fix them up or work 
around them as best as it can, not dismiss them as broken hardware and 
fail to boot outright.
