Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B23164D765
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 08:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiLOHpm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 02:45:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiLOHpl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 02:45:41 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B63315
        for <stable@vger.kernel.org>; Wed, 14 Dec 2022 23:45:37 -0800 (PST)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 34234851B0;
        Thu, 15 Dec 2022 08:45:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1671090335;
        bh=c1kZ0IbvQWkU6EvA2f0rhew7jMkIcEBmnHz7wImnxTo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Ww0gImvaH8rj4WY+h/HiPUN5D2/lU5imqDRRAeR32VuLyIWTzflVwxIk+96SW4Rxe
         ly3ThubtLCZcI8ma8qZX7yVk3ZzSczMG4Nk/G9L+tJwMa2/xarEIcSyQcR7j363nL3
         cga06cfjoGqkmVHiOf6iSkcxZ296Tz7/lB6bVJ6SLmCxTgnYTQ0rhAelLfDyE0zhng
         Aam9hQ/Q/0FrIhbp1O1CpObiG2tV/QpN1YMxYpei1k5mooKBAdEdWxJ5tKlkeepz7q
         v23SfM8U5L6PDnNoJiVk7VlUbQ310bpkAriFqiJCEdnXnW3z/Snzz5dsMvBXO/p5nz
         yn0wKpeDtkEnQ==
Message-ID: <ac50a1ee-4312-48f6-af78-7b95a77e6fda@denx.de>
Date:   Thu, 15 Dec 2022 08:45:33 +0100
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
From:   Marek Vasut <marex@denx.de>
In-Reply-To: <20221215081604.5385fa56@xps-13>
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

On 12/15/22 08:16, Miquel Raynal wrote:
> Hi Marek & Francesco,

Hi,

> marex@denx.de wrote on Mon, 5 Dec 2022 17:25:11 +0100:
> 
>> On 12/5/22 14:49, Miquel Raynal wrote:
>>> Hi Francesco,
>>
>> Hi,
>>
>>> francesco@dolcini.it wrote on Mon, 5 Dec 2022 12:26:44 +0100:
>>>    
>>>> On Fri, Dec 02, 2022 at 06:08:22PM +0100, Marek Vasut wrote:
>>>>> But here I would say this is a firmware bug and it might have to be handled
>>>>> like a firmware bug, i.e. with fixup in the partition parser. I seem to be
>>>>> changing my opinion here again.
>>>>
>>>> I was thinking at this over the weekend, and I came to the following
>>>> ideas:
>>>>
>>>>    - we need some improvement on the fixup we already have in the
>>>>      partition parser. We cannot ignore the fdt produced by U-Boot - as
>>>>      bad as it is.
>>>>    - the proposed fixup is fine for the immediate need, but it is
>>>>      not going to be enough to cover the general issue with the U-Boot
>>>>      generated partitions. U-Boot might keep generating partitions as direct
>>>>      child of the nand controller even when a partitions{} node is
>>>>      available. In this case the current parser just fails since it looks
>>>>      only into it and it will find it empty.
>>>>    - the current U-Boot only handle partitions{} as a direct child of the
>>>>      nand-controller, the nand-chip is ignored. This is not the way it is
>>>>      supposed to work. U-Boot code would need to be improved.
>>>
>>> I've been thinking about it this weekend as well and the current fix
>>> which "just set" s_cell to 1 seems risky for me, it is typically the
>>> type of quick & dirty fix that might even break other board (nobody
>>> knew that U-Boot current logic expected #size-cells to be set in the
>>> DT, what if another "broken" DT expects the opposite...)
>>
>> Then with the current configuration, such broken DT would not work, since current DT does set #size-cells=<1> (wrongly).
>>
>>> , not
>>> mentioning potential issues with big storages (> 4GiB).
>>>
>>> All in all, I really think we should revert the DT change now, reverting
>>> as little to no drawbacks besides a dt_binding_check warning and gives
>>> us time to deal with it properly (both in U-Boot and Linux).
>>
>> I am really not happy with this, but if that's marked as intermediate fix, go for it.
>>
>> How do we deal with this in the long run however? Parser-side fix like this one, maybe with better heuristics ?
> 
> Yesterday while talking about an ACPI mis-description which needed
> fixing, I realized fixing up what the firmware provides to Linux should
> preferably be handled as early as possible. So my first first idea was
> to avoid using the broken "fixup mtdparts" function in U-Boot and I am
> still convinced this is what we should do in priority. However, as
> rightly pointed in this thread, we need to take care about the case
> where someone would use a newer DT (let's say, with the reverted changed
> reverted again) with an old U-Boot. I am still against piggy hacks in
> the generic ofpart.c driver, but what we could do however is a DT
> fixup in the init_machine (or the dt_fixup) hook for imx7 Colibri, very
> much like this:
> https://elixir.bootlin.com/linux/latest/source/arch/arm/mach-mvebu/board-v7.c#L111
> Plus a warning there saying "your dt is broken, update your firmware".

This does not work, because the old U-Boot fixup_mtdparts() may be 
applied on any machine, it is not colibri mx7 specific. Also, new 
arch-side workaround are really not welcome by the architecture 
maintainers as far as I can tell.

> So next time someone stumbles upon this issue, we can tell them "fix
> your bootloader", and apply the same hack in their board family (there
> are three or four IIRC which might be concerned some day).

There are also those machines we do not even know about which might be 
generating bogus DT using old U-Boot and fixup_mtdparts(), so, unless 
there is some all-arch fixup implementation, we wouldn't be able to fix 
them all on arch side. I think the all-arch fixup implementation would 
be the driver one, i.e. this patch as it is (or maybe with some 
improvement).

> That would fix all cases and only have an impact on the affected boards.

Sadly, it does only fix the known cases, not the unknown cases like 
downstream forks which never get any bootloader updates ever, and which 
you can't find in upstream U-Boot, and which you therefore cannot easily 
catch in the arch side fixup.

[...]
