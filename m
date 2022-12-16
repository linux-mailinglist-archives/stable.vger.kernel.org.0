Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6627A64E9B1
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 11:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbiLPKq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 05:46:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbiLPKqX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 05:46:23 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D58B44
        for <stable@vger.kernel.org>; Fri, 16 Dec 2022 02:46:21 -0800 (PST)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 5A3C48520E;
        Fri, 16 Dec 2022 11:46:19 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1671187580;
        bh=PIqUEziaW7aCKgN+qBabJu/0k2cDZ3tExytmC9OPj2A=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=KOh4hmtiuQW7opZtbe3v6jE9Vydd9/5Abxh7LW6ZxAg4CA4D05VtO+sLpNGZNcO8m
         bpRU8RIxmH67jls3FC7k7RicKM8xBxCMaFeXhYtPCU7cmFBrHjTM6HftzpfUB7E268
         mSFZ8MmZ0iBU4VNXhNP9CZnNxahpwYeiQ/q6Rc87JJIDeqGNcgrZ0fpKpdnx17xYQJ
         DeJiwDKc07jIoTdMQ8YR1VZ/iWgPNx+FNkZf038dtRAmQqmmSAE1kEMZdmeiprItGC
         SiPA4lSexHMe4YD6wmOoGwfxDve5Q0Ig0txUiaecALA7CpluyiVG3Ut8YCjZfRVwYX
         r5eDIkksdv8lw==
Message-ID: <6f5f5b32-d7fe-13cc-b52d-83a27bd9f53e@denx.de>
Date:   Fri, 16 Dec 2022 11:46:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v1] mtd: parsers: ofpart: Fix parsing when size-cells is 0
To:     Francesco Dolcini <francesco@dolcini.it>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-mtd@lists.infradead.org,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        u-boot@lists.denx.de
References: <Y5wiAPvPU+YY39oX@francesco-nb.int.toradex.com>
Content-Language: en-US
From:   Marek Vasut <marex@denx.de>
In-Reply-To: <Y5wiAPvPU+YY39oX@francesco-nb.int.toradex.com>
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

On 12/16/22 08:45, Francesco Dolcini wrote:
> Hello Marek and Miquel,

Hi,

> On Thu, Dec 15, 2022 at 08:16:04AM +0100, Miquel Raynal wrote:
>> So my first first idea was to avoid using the broken "fixup mtdparts"
>> function in U-Boot and I am still convinced this is what we should do
>> in priority.
> 
> This is something that was already discussed, but I was not really
> thinking much on it till now. Do you think that the whole idea of
> editing the MTD partitions from the firmware is wrong and we should just
> pass the partition on the command line OR that the current
> implementation is broken and can/should be fixed?

No, patching the partition layout into DT is fine. Firmwares of all 
kinds have been patching various parts of the DT before passing it to OS 
since forever, or more recently, merging multiple DT fragments and 
passing the composite DT to Linux.

As far as I recall, OF predates Linux and the OF tree has been usually 
assembled by the Forth firmware of that era from various chunks stored 
in different parts of the system. So this patching is fundamental part 
of the design since the beginning.

It is difficult to describe complex structure like the partition mapping 
on kernel command line, it should really be in DT or other such 
structure, so patching it into the DT is fine. The only detail here is, 
it should be patched into the DT correctly ... and ... if old firmwares 
do not do that, Linux should fix it up. You don't throw away your old PC 
just because it doesn't have perfect ACPI tables one would expect today, 
I don't see why we should do that with DT machines.

>> I am still against piggy hacks in the generic ofpart.c driver, but
>> what we could do however is a DT fixup in the init_machine (or the
>> dt_fixup) hook for imx7 Colibri, very much like this:
>> https://elixir.bootlin.com/linux/latest/source/arch/arm/mach-mvebu/board-v7.c#L111
>> Plus a warning there saying "your dt is broken, update your firmware".
> 
> I have a couple of concerns/question with this approach:
>   - do we have a single point to handle this? Different architectures are
>     affected by these issue. Duplicating the fixup code in multiple place
>     does not seems a great idea
>   - If we believe that the device tree is wrong, in the i.MX7 case
>     because of #size-cells should be set to 0 and not 1, we should not
>     alter the FDT. Other part of the code could rely on this being
>     correctly set to 0 moving forward.
> 
> If I understood you are proposing to have a fixup at the machine level
> that is converting a valid nand-controller node definition to a "broken"
> one. Unless I misunderstood you and you are thinking about rewriting the
> whole MTD partition from a broken definition to a proper one.
> 
> On Thu, Dec 15, 2022 at 09:04:46AM +0100, Miquel Raynal wrote:
>> marex@denx.de wrote on Thu, 15 Dec 2022 08:45:33 +0100:
>>> Sadly, it does only fix the known cases, not the unknown cases like
>>> downstream forks which never get any bootloader updates ever, and
>>> which you can't find in upstream U-Boot, and which you therefore
>>> cannot easily catch in the arch side fixup.
>>
>> And ?
> 
> I'm not personally and directly concerned, since the machine I care are
> all available upstream and known, however this is a general problem with
> U-Boot code being at the same time widely used on a range of embedded
> products and producing a broken MTD partition list.
> 
> I think we will just silently break boards and just creating a lot of
> issues to people. We would just introduce regression to the users, being
> aware of it and deliberately decide to not care and move the problem to
> someone else. I do not think this is a good way to go.

I agree.
