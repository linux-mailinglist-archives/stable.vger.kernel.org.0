Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6A974BDC90
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356757AbiBULv1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 06:51:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356882AbiBULvF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 06:51:05 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E401EEE9;
        Mon, 21 Feb 2022 03:50:41 -0800 (PST)
Received: from ip4d144895.dynamic.kabel-deutschland.de ([77.20.72.149] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nM7DA-0004w3-Ce; Mon, 21 Feb 2022 12:50:36 +0100
Message-ID: <72b499e9-4f23-bbf8-f026-4d4e074df268@leemhuis.info>
Date:   Mon, 21 Feb 2022 12:50:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
From:   Thorsten Leemhuis <regressions@leemhuis.info>
Subject: Re: [PATCH] PCI: xgene: Fix IB window setup
To:     dann frazier <dann.frazier@canonical.com>,
        Rob Herring <robh@kernel.org>
Cc:     Toan Le <toan@os.amperecomputing.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?Q?Krzysztof_Wilczy=c5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <amurray@thegoodpenguin.co.uk>,
        =?UTF-8?Q?St=c3=a9phane_Graber?= <stgraber@ubuntu.com>,
        stable <stable@vger.kernel.org>, PCI <linux-pci@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
References: <20211129173637.303201-1-robh@kernel.org>
 <Yf2wTLjmcRj+AbDv@xps13.dannf>
 <CAL_Jsq+4b4Yy8rJGJv9j9j_TCm6mTAkW5fzcDuuW-jOoiZ2GLg@mail.gmail.com>
 <CALdTtnuK+D7gNbEDgHbrc29pFFCR3XYAHqrK3=X_hQxUx-Seow@mail.gmail.com>
 <CAL_JsqJUmjG-SiuR9T7f=5nGcSjTLhuF_382EQDf74kcqdAq_w@mail.gmail.com>
 <YgHFFIRT6E0j9TlX@xps13.dannf>
 <CAL_JsqJLTkDm_ZbFWSKwKvVAh0KpxiS9y6LEwmhQ-kejTcLq7A@mail.gmail.com>
 <YgXG838iMrS1l8SC@xps13.dannf>
Content-Language: en-BS
In-Reply-To: <YgXG838iMrS1l8SC@xps13.dannf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1645444241;627a70cd;
X-HE-SMSGID: 1nM7DA-0004w3-Ce
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, this is your Linux kernel regression tracker speaking. Top-posting
for once, to make this easy accessible to everyone.

What's the status of this regression and getting it fixed? It looks like
there was quite some progress for a while, but then things seem to have
come to a halt ten days ago. Could anyone please provide a status
update, please?

Ciao, Thorsten (wearing his 'Linux kernel regression tracker' hat)

P.S.: As a Linux kernel regression tracker I'm getting a lot of reports
on my table. I can only look briefly into most of them. Unfortunately
therefore I sometimes will get things wrong or miss something important.
I hope that's not the case here; if you think it is, don't hesitate to
tell me about it in a public reply, that's in everyone's interest.

#regzbot poke


On 11.02.22 03:16, dann frazier wrote:
> On Tue, Feb 08, 2022 at 08:34:45AM -0600, Rob Herring wrote:
>> On Mon, Feb 7, 2022 at 7:19 PM dann frazier <dann.frazier@canonical.com> wrote:
>>>
>>> On Mon, Feb 07, 2022 at 10:09:31AM -0600, Rob Herring wrote:
>>>> On Sat, Feb 5, 2022 at 3:13 PM dann frazier <dann.frazier@canonical.com> wrote:
>>>>>
>>>>> On Sat, Feb 5, 2022 at 9:05 AM Rob Herring <robh@kernel.org> wrote:
>>>>>>
>>>>>> On Fri, Feb 4, 2022 at 5:01 PM dann frazier <dann.frazier@canonical.com> wrote:
>>>>>>>
>>>>>>> On Mon, Nov 29, 2021 at 11:36:37AM -0600, Rob Herring wrote:
>>>>>>>> Commit 6dce5aa59e0b ("PCI: xgene: Use inbound resources for setup")
>>>>>>>> broke PCI support on XGene. The cause is the IB resources are now sorted
>>>>>>>> in address order instead of being in DT dma-ranges order. The result is
>>>>>>>> which inbound registers are used for each region are swapped. I don't
>>>>>>>> know the details about this h/w, but it appears that IB region 0
>>>>>>>> registers can't handle a size greater than 4GB. In any case, limiting
>>>>>>>> the size for region 0 is enough to get back to the original assignment
>>>>>>>> of dma-ranges to regions.
>>>>>>>
>>>>>>> hey Rob!
>>>>>>>
>>>>>>> I've been seeing a panic on HP Moonshoot m400 cartridges (X-Gene1) -
>>>>>>> only during network installs - that I also bisected down to commit
>>>>>>> 6dce5aa59e0b ("PCI: xgene: Use inbound resources for setup"). I was
>>>>>>> hoping that this patch that fixed the issue on Stéphane's X-Gene2
>>>>>>> system would also fix my issue, but no luck. In fact, it seems to just
>>>>>>> makes it fail differently. Reverting both patches is required to get a
>>>>>>> v5.17-rc kernel to boot.
>>>>>>>
>>>>>>> I've collected the following logs - let me know if anything else would
>>>>>>> be useful.
>>>>>>>
>>>>>>> 1) v5.17-rc2+ (unmodified):
>>>>>>>    http://dannf.org/bugs/m400-no-reverts.log
>>>>>>>    Note that the mlx4 driver fails initialization.
>>>>>>>
>>>>>>> 2) v5.17-rc2+, w/o the commit that fixed Stéphane's system:
>>>>>>>    http://dannf.org/bugs/m400-xgene2-fix-reverted.log
>>>>>>>    Note the mlx4 MSI-X timeout, and later panic.
>>>>>>>
>>>>>>> 3) v5.17-rc2+, w/ both commits reverted (works)
>>>>>>>    http://dannf.org/bugs/m400-both-reverted.log
>>>>>>
>>>>>> The ranges and dma-ranges addresses don't appear to match up with any
>>>>>> upstream dts files. Can you send me the DT?
>>>>>
>>>>> Sure: http://dannf.org/bugs/fdt
>>>>
>>>> The first fix certainly is a problem. It's going to need something
>>>> besides size to key off of (originally it was dependent on order of
>>>> dma-ranges entries).
>>>>
>>>> The 2nd issue is the 'dma-ranges' has a second entry that is now ignored:
>>>>
>>>> dma-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00>, <0x00
>>>> 0x79000000 0x00 0x79000000 0x00 0x800000>;
>>>>
>>>> Based on the flags (3rd addr cell: 0x0), we have an inbound config
>>>> space which the kernel now ignores because inbound config space
>>>> accesses make no sense. But clearly some setup is needed. Upstream, in
>>>> contrast, sets up a memory range that includes this region, so the
>>>> setup does happen:
>>>>
>>>> <0x42000000 0x00 0x00000000 0x00 0x00000000 0x80 0x00000000>
>>>>
>>>> Minimally, I suspect it will work if you change dma-ranges 2nd entry to:
>>>>
>>>> <0x42000000 0x79000000 0x00 0x79000000 0x00 0x800000>
>>>
>>> Thanks for looking into this Rob. I tried to test that theory, but it
>>> didn't seem to work. This is what I tried:
>>>
>>> --- m400.dts    2022-02-07 20:16:44.840475323 +0000
>>> +++ m400.dts.dmaonly    2022-02-08 00:17:54.097132000 +0000
>>> @@ -446,7 +446,7 @@
>>>                         reg = <0x00 0x1f2b0000 0x00 0x10000 0xe0 0xd0000000 0x00 0x200000 0x00 0x79e00000 0x00 0x2000000 0x00 0x79000000 0x00 0x800000>;
>>>                         reg-names = "csr\0cfg\0msi_gen\0msi_term";
>>>                         ranges = <0x1000000 0x00 0x00 0xe0 0x10000000 0x00 0x10000 0x2000000 0x00 0x30000000 0xe1 0x30000000 0x00 0x80000000>;
>>> -                       dma-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x00 0x79000000 0x00 0x79000000 0x00 0x800000>;
>>> +                       dma-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x42000000 0x79000000 0x00 0x79000000 0x00 0x800000>;
>>>                         ib-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x00 0x79000000 0x00 0x79000000 0x00 0x800000>;
>>>                         ib-ranges-ep = <0x2000000 0x00 0x00 0x00 0x00 0x00 0x400000 0x2000000 0x00 0x00 0x00 0x00 0x00 0x400000 0x2000000 0x00 0x79000000 0x00 0x79000000 0x00 0x100000>;
>>>                         interrupts = <0x00 0x10 0x04>;
>>> @@ -471,7 +471,7 @@
>>>                         reg = <0x00 0x1f2c0000 0x00 0x10000 0xd0 0xd0000000 0x00 0x200000 0x00 0x79e00000 0x00 0x2000000 0x00 0x79000000 0x00 0x800000>;
>>>                         reg-names = "csr\0cfg\0msi_gen\0msi_term";
>>>                         ranges = <0x1000000 0x00 0x00 0xd0 0x10000000 0x00 0x10000 0x2000000 0x00 0x30000000 0xd1 0x30000000 0x00 0x80000000>;
>>> -                       dma-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x00 0x79000000 0x00 0x79000000 0x00 0x800000>;
>>> +                       dma-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x42000000 0x79000000 0x00 0x79000000 0x00 0x800000>;
>>>                         ib-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x00 0x79000000 0x00 0x79000000 0x00 0x800000>;
>>>                         ib-ranges-ep = <0x2000000 0x00 0x00 0x00 0x00 0x00 0x400000 0x2000000 0x00 0x00 0x00 0x00 0x00 0x400000 0x2000000 0x00 0x79000000 0x00 0x79000000 0x00 0x100000>;
>>>                         interrupts = <0x00 0x10 0x04>;
>>> @@ -496,7 +496,7 @@
>>>                         reg = <0x00 0x1f2d0000 0x00 0x10000 0x90 0xd0000000 0x00 0x200000 0x00 0x79e00000 0x00 0x2000000 0x00 0x79000000 0x00 0x800000>;
>>>                         reg-names = "csr\0cfg\0msi_gen\0msi_term";
>>>                         ranges = <0x1000000 0x00 0x00 0x90 0x10000000 0x00 0x10000 0x2000000 0x00 0x30000000 0x91 0x30000000 0x00 0x80000000>;
>>> -                       dma-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x00 0x79000000 0x00 0x79000000 0x00 0x800000>;
>>> +                       dma-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x42000000 0x79000000 0x00 0x79000000 0x00 0x800000>;
>>>                         ib-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x00 0x79000000 0x00 0x79000000 0x00 0x800000>;
>>>                         ib-ranges-ep = <0x2000000 0x00 0x00 0x00 0x00 0x00 0x400000 0x2000000 0x00 0x00 0x00 0x00 0x00 0x400000 0x2000000 0x00 0x79000000 0x00 0x79000000 0x00 0x100000>;
>>>                         interrupts = <0x00 0x10 0x04>;
>>> @@ -522,7 +522,7 @@
>>>                         reg = <0x00 0x1f500000 0x00 0x10000 0xa0 0xd0000000 0x00 0x200000 0x00 0x79e00000 0x00 0x2000000 0x00 0x79000000 0x00 0x800000>;
>>>                         reg-names = "csr\0cfg\0msi_gen\0msi_term";
>>>                         ranges = <0x2000000 0x00 0x30000000 0xa1 0x30000000 0x00 0x80000000>;
>>> -                       dma-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x00 0x79000000 0x00 0x79000000 0x00 0x800000>;
>>> +                       dma-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x42000000 0x79000000 0x00 0x79000000 0x00 0x800000>;
>>>                         ib-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x00 0x79000000 0x00 0x79000000 0x00 0x800000>;
>>>                         ib-ranges-ep = <0x2000000 0x00 0x00 0x00 0x00 0x00 0x400000 0x2000000 0x00 0x00 0x00 0x00 0x00 0x400000 0x2000000 0x00 0x79000000 0x00 0x79000000 0x00 0x100000>;
>>>                         interrupts = <0x00 0x10 0x04>;
>>> @@ -547,7 +547,7 @@
>>>                         reg = <0x00 0x1f510000 0x00 0x10000 0xc0 0xd0000000 0x00 0x200000 0x00 0x79e00000 0x00 0x2000000 0x00 0x79000000 0x00 0x800000>;
>>>                         reg-names = "csr\0cfg\0msi_gen\0msi_term";
>>>                         ranges = <0x1000000 0x00 0x00 0xc0 0x10000000 0x00 0x10000 0x2000000 0x00 0x30000000 0xc1 0x30000000 0x00 0x80000000>;
>>> -                       dma-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x00 0x79000000 0x00 0x79000000 0x00 0x800000>;
>>> +                       dma-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x42000000 0x79000000 0x00 0x79000000 0x00 0x800000>;
>>>                         ib-ranges = <0x42000000 0x40 0x00 0x40 0x00 0x40 0x00 0x00 0x00 0x79000000 0x00 0x79000000 0x00 0x800000>;
>>>                         ib-ranges-ep = <0x2000000 0x00 0x00 0x00 0x00 0x00 0x400000 0x2000000 0x00 0x00 0x00 0x00 0x00 0x400000 0x2000000 0x00 0x79000000 0x00 0x79000000 0x00 0x100000>;
>>>                         interrupts = <0x00 0x10 0x04>;
>>>
>>> And that failed to boot with a 5.17-rc3. Since dma-ranges was
>>> previously identical to ib-ranges, I also tried making the same change
>>> to ib-ranges, but with no success.
>>
>> Failed to boot at all or just PCIe still didn't work causing boot to
>> eventually fail?
> 
> Sorry, I mean PCIe still didn't work, here's the log:
>  http://dannf.org/bugs/m400-tweaked_dtb.log
> (unmodified kernel source w/ above dtb change)
> 
>> 'ib-ranges' is unknown to the kernel, so the firmware
>> is using it somehow?
>>
>> You also need to revert the first fix for PCIe to work.
> 
> Oh, OK. I misunderstood. I tried reverting commit 6dce5aa59e0b "PCI:
> xgene: Use inbound resources for setup" along with a dtb with the
> dma-ranges change in the diff above, but PCIe still didn't
> work. Here's the log:
> 
> http://dannf.org/bugs/m400-6dce5aa5_reverted+tweaked_dtb.log
> 
>   -dann
>   
>>
>>>> While we shouldn't break existing DTs, the moonshot DT doesn't use
>>>> what's documented upstream. There are multiple differences compared to
>>>> what's documented. Is upstream supposed to support upstream DTs,
>>>> downstream DTs, and ACPI for XGene which is an abandoned platform with
>>>> only a handful of users?
>>>
>>> That's a fair question, though it's one of a policy, and I feel I'd be
>>> overstepping by weighing in. I suppose one option I have is to try
>>> and create and upstream a dts for these systems and modify our
>>> boot.scr to always load that over the one provided by firmware. While
>>> we do have some of these systems in production, they are being retired
>>> and replaced with newer kit over time, and it's possible we'll never
>>> need to upgrade them to a modern kernel.
>>>
>>>   -dann

