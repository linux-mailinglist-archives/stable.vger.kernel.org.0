Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D43EF3DBAF1
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 16:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239142AbhG3OoU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 10:44:20 -0400
Received: from foss.arm.com ([217.140.110.172]:43018 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239095AbhG3OoU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Jul 2021 10:44:20 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 809526D;
        Fri, 30 Jul 2021 07:44:15 -0700 (PDT)
Received: from [10.57.36.146] (unknown [10.57.36.146])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AE9F33F70D;
        Fri, 30 Jul 2021 07:44:13 -0700 (PDT)
Subject: Re: [PATCH 2/2] arm64: dts: juno: Enable more SMMUs
To:     Anders Roxell <anders.roxell@linaro.org>
Cc:     sudeep.holla@arm.com, lorenzo.pieralisi@arm.com,
        liviu.dudau@arm.com, linux-arm-kernel@lists.infradead.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, sashal@kernel.org, arnd@arndb.de,
        lkft-triage@lists.linaro.org,
        Linux Kernel Functional Testing <lkft@linaro.org>
References: <720d0a9a42e33148fcac45cd39a727093a32bf32.1614965598.git.robin.murphy@arm.com>
 <a730070d718cb119f77c8ca1782a0d4189bfb3e7.1614965598.git.robin.murphy@arm.com>
 <0a1d437d-9ea0-de83-3c19-e07f560ad37c@arm.com>
 <20210730143431.GB1517404@mutt>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <8b358507-dbdf-b05b-c1da-2ec9903a2912@arm.com>
Date:   Fri, 30 Jul 2021 15:44:07 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210730143431.GB1517404@mutt>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-07-30 15:34, Anders Roxell wrote:
> On 2021-07-30 13:17, Robin Murphy wrote:
>> On 2021-07-30 12:35, Anders Roxell wrote:
>>> From: Robin Murphy <robin.murphy@arm.com>
>>>
>>>> Now that PCI inbound window restrictions are handled generically between
>>>> the of_pci resource parsing and the IOMMU layer, and described in the
>>>> Juno DT, we can finally enable the PCIe SMMU without the risk of DMA
>>>> mappings inadvertently allocating unusable addresses.
>>>>
>>>> Similarly, the relevant support for IOMMU mappings for peripheral
>>>> transfers has been hooked up in the pl330 driver for ages, so we can
>>>> happily enable the DMA SMMU without that breaking anything either.
>>>>
>>>> Signed-off-by: Robin Murphy <robin.murphy@arm.com>
>>>
>>> When we build a kernel with 64k page size and run the ltp syscalls we
>>> sporadically see a kernel crash while doing a mkfs on a connected SATA
>>> drive.  This is happening every third test run on any juno-r2 device in
>>> the lab with the same kernel image (stable-rc 5.13.y, mainline and next)
>>> with gcc-11.
>>
>> Hmm, I guess 64K pages might make a difference in that we'll chew through
>> IOVA space a lot faster with small mappings...
>>
>> I'll have to try to reproduce this locally, since the interesting thing
>> would be knowing what DMA address it was trying to use that went wrong, but
>> IOMMU tracepoints and/or dma-debug are going to generate an crazy amount of
>> data to sift through and try to correlate - having done it before it's not
>> something I'd readily ask someone else to do for me :)
>>
>> On a hunch, though, does it make any difference if you remove the first
>> entry from the PCIe "dma-ranges" (the 0x2c1c0000 one)?
> 
> I did this change, and run the job 7 times and could not reproduce the
> issue.

Thanks! And hold that thought; if it works then I suspect it probably is 
the best fix, but I'll double-check and write it up properly next week.

Cheers,
Robin.

> diff --git a/arch/arm64/boot/dts/arm/juno-base.dtsi b/arch/arm64/boot/dts/arm/juno-base.dtsi
> index 8e7a66943b01..d3148730e951 100644
> --- a/arch/arm64/boot/dts/arm/juno-base.dtsi
> +++ b/arch/arm64/boot/dts/arm/juno-base.dtsi
> @@ -545,8 +545,7 @@ pcie_ctlr: pcie@40000000 {
>                           <0x02000000 0x00 0x50000000 0x00 0x50000000 0x0 0x08000000>,
>                           <0x42000000 0x40 0x00000000 0x40 0x00000000 0x1 0x00000000>;
>                  /* Standard AXI Translation entries as programmed by EDK2 */
> -               dma-ranges = <0x02000000 0x0 0x2c1c0000 0x0 0x2c1c0000 0x0 0x00040000>,
> -                            <0x02000000 0x0 0x80000000 0x0 0x80000000 0x0 0x80000000>,
> +               dma-ranges = <0x02000000 0x0 0x80000000 0x0 0x80000000 0x0 0x80000000>,
>                               <0x43000000 0x8 0x00000000 0x8 0x00000000 0x2 0x00000000>;
>                  #interrupt-cells = <1>;
>                  interrupt-map-mask = <0 0 0 7>;
> 
> 
> Cheers,
> Anders
> 
