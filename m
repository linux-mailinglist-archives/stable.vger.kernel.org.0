Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 401F03DB875
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 14:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbhG3MRq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 08:17:46 -0400
Received: from foss.arm.com ([217.140.110.172]:41274 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230325AbhG3MRq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Jul 2021 08:17:46 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 393261FB;
        Fri, 30 Jul 2021 05:17:41 -0700 (PDT)
Received: from [10.57.36.146] (unknown [10.57.36.146])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 67CBD3F70D;
        Fri, 30 Jul 2021 05:17:39 -0700 (PDT)
Subject: Re: [PATCH 2/2] arm64: dts: juno: Enable more SMMUs
To:     Anders Roxell <anders.roxell@linaro.org>, sudeep.holla@arm.com,
        lorenzo.pieralisi@arm.com, liviu.dudau@arm.com
Cc:     linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        sashal@kernel.org, arnd@arndb.de, lkft-triage@lists.linaro.org,
        Linux Kernel Functional Testing <lkft@linaro.org>
References: <720d0a9a42e33148fcac45cd39a727093a32bf32.1614965598.git.robin.murphy@arm.com>
 <a730070d718cb119f77c8ca1782a0d4189bfb3e7.1614965598.git.robin.murphy@arm.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <0a1d437d-9ea0-de83-3c19-e07f560ad37c@arm.com>
Date:   Fri, 30 Jul 2021 13:17:33 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <a730070d718cb119f77c8ca1782a0d4189bfb3e7.1614965598.git.robin.murphy@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-07-30 12:35, Anders Roxell wrote:
> From: Robin Murphy <robin.murphy@arm.com>
> 
>> Now that PCI inbound window restrictions are handled generically between
>> the of_pci resource parsing and the IOMMU layer, and described in the
>> Juno DT, we can finally enable the PCIe SMMU without the risk of DMA
>> mappings inadvertently allocating unusable addresses.
>>
>> Similarly, the relevant support for IOMMU mappings for peripheral
>> transfers has been hooked up in the pl330 driver for ages, so we can
>> happily enable the DMA SMMU without that breaking anything either.
>>
>> Signed-off-by: Robin Murphy <robin.murphy@arm.com>
> 
> When we build a kernel with 64k page size and run the ltp syscalls we
> sporadically see a kernel crash while doing a mkfs on a connected SATA
> drive.  This is happening every third test run on any juno-r2 device in
> the lab with the same kernel image (stable-rc 5.13.y, mainline and next)
> with gcc-11.

Hmm, I guess 64K pages might make a difference in that we'll chew 
through IOVA space a lot faster with small mappings...

I'll have to try to reproduce this locally, since the interesting thing 
would be knowing what DMA address it was trying to use that went wrong, 
but IOMMU tracepoints and/or dma-debug are going to generate an crazy 
amount of data to sift through and try to correlate - having done it 
before it's not something I'd readily ask someone else to do for me :)

On a hunch, though, does it make any difference if you remove the first 
entry from the PCIe "dma-ranges" (the 0x2c1c0000 one)?

Robin.

> Here is a snippet of the boot log [1]:
> 
> + mkfs -t ext4 /dev/disk/by-id/ata-SanDisk_SDSSDA120G_165192443611
> mke2fs 1.43.8 (1-Jan-2018)
> Discarding device blocks:     4096/29305200
> [   55.344291] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
> frozen
> [   55.351423] ata1.00: irq_stat 0x00020002, failed to transmit command
> FIS
> [   55.358205] ata1.00: failed command: DATA SET MANAGEMENT
> [   55.363561] ata1.00: cmd 06/01:01:00:00:00/00:00:00:00:00/a0 tag 12
> dma 512 out
> [   55.363561]          res ec/ff:00:00:00:00/00:00:00:00:ec/00 Emask
> 0x12 (ATA bus error)
> [   55.378955] ata1.00: status: { Busy }
> [   55.382658] ata1.00: error: { ICRC UNC AMNF IDNF ABRT }
> [   55.387947] ata1: hard resetting link
> [   55.391653] ata1: controller in dubious state, performing PORT_RST
> [   57.588447] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   57.613471] ata1.00: configured for UDMA/100
> [   57.617866] ata1.00: device reported invalid CHS sector 0
> [   57.623397] ata1: EH complete
> 
> 
> When we revert this patch we don't see any issue.
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Cheers,
> Anders
> [1]
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.13.y/build/v5.13.5-225-g692072e7b7fa/testrun/5279599/suite/ltp-syscalls-tests/test/copy_file_range01/log
> 
