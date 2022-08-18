Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3ED59864D
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 16:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244743AbiHROrU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 10:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233992AbiHROrT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 10:47:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0338ABB926;
        Thu, 18 Aug 2022 07:47:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9416260B3F;
        Thu, 18 Aug 2022 14:47:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B4DC433C1;
        Thu, 18 Aug 2022 14:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660834036;
        bh=vkra+54wSOIY+Y+8ajG7f72gPrM+M8yjbxSyC4XndDc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LNjBIGy2aDIQKn0/m/2vLz7gWbb+Mhtvi8/RiYREGS5rL0/rCC8RMXAJH1lcKRkgk
         1DpHRpQulWGffTzE7e0P22n32+4zkTU5YSNvxPqsYi4ACCI+IINgdQ8S/3YlXAHwCg
         0bhIipR3qJReZrwZn4JEXdShmonF/fexjAtdpBW4=
Date:   Thu, 18 Aug 2022 16:47:14 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Alan J. Wylie" <alan@wylie.me.uk>, linux-usb@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Regression in 5.19.0: USB errors during boot
Message-ID: <Yv5Q8gDvVTGOHd8k@kroah.com>
References: <25342.20092.262450.330346@wylie.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25342.20092.262450.330346@wylie.me.uk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Adding in linux-usb@vger]


On Thu, Aug 18, 2022 at 03:36:44PM +0100, Alan J. Wylie wrote:
> 
> Apologies for the delay in reporting this: I messed up my first attempt at
> bisecting, then I've spent a week going to, enjoying, returning from and
> recovering from a music festival.
> 
> Up to and including 5.18.18 things are fine. With 5.19.0 (and .1 and .2)  I see
> lots of errors and hangs on the USB2 chipset, e.g.
> 
> $ grep "usb 9-4" dmesg.5.19.2
> [    6.669075] usb 9-4: new full-speed USB device number 2 using ohci-pci
> [    6.829087] usb 9-4: device descriptor read/64, error -32
> [    7.097094] usb 9-4: device descriptor read/64, error -32
> [    7.361087] usb 9-4: new full-speed USB device number 3 using ohci-pci
> [    7.521152] usb 9-4: device descriptor read/64, error -32
> [    7.789066] usb 9-4: device descriptor read/64, error -32
> [    8.081070] usb 9-4: new full-speed USB device number 4 using ohci-pci
> [    8.497138] usb 9-4: device not accepting address 4, error -32
> [    8.653140] usb 9-4: new full-speed USB device number 5 using ohci-pci
> [    9.069141] usb 9-4: device not accepting address 5, error -32
> $
> 
> $ grep "usb 1-2" dmesg.5.19.2
> [    5.917102] usb 1-2: new high-speed USB device number 2 using ehci-pci
> [    6.277076] usb 1-2: device descriptor read/64, error -71
> [    6.513143] usb 1-2: device descriptor read/64, error -32
> [    6.753146] usb 1-2: new high-speed USB device number 3 using ehci-pci
> [    6.881143] usb 1-2: device descriptor read/64, error -32
> [    7.117144] usb 1-2: device descriptor read/64, error -32
> [    7.429141] usb 1-2: new high-speed USB device number 4 using ehci-pci
> [    7.845134] usb 1-2: device not accepting address 4, error -32
> [    7.977142] usb 1-2: new high-speed USB device number 5 using ehci-pci
> [    8.393158] usb 1-2: device not accepting address 5, error -32
> $
> 
> the USB port is then no longer usable
> 
> This is not reproducible on the other chipset (USB3) on this machine,
> nor on two other systems. Swapping USB cables doesn't help.
> 
> I have bisected it to
> 
> $ git bisect bad
> 78013eaadf696d2105982abb4018fbae394ca08f is the first bad commit
> commit 78013eaadf696d2105982abb4018fbae394ca08f
> Author: Christoph Hellwig <hch@lst.de>
> Date:   Mon Feb 14 14:11:44 2022 +0100
> 
>     x86: remove the IOMMU table infrastructure
> 
> however it will not easily revert
> 
> I'll be more than happy to assist with any debugging/testing.
> 
> $ git revert 78013eaadf696d2105982abb4018fbae394ca08f
> Auto-merging arch/x86/include/asm/dma-mapping.h
> CONFLICT (content): Merge conflict in arch/x86/include/asm/dma-mapping.h
> Auto-merging arch/x86/include/asm/iommu.h
> Auto-merging arch/x86/include/asm/xen/swiotlb-xen.h
> Auto-merging arch/x86/kernel/Makefile
> Auto-merging arch/x86/kernel/pci-dma.c
> CONFLICT (content): Merge conflict in arch/x86/kernel/pci-dma.c
> Auto-merging arch/x86/kernel/vmlinux.lds.S
> Auto-merging drivers/iommu/amd/init.c
> Auto-merging drivers/iommu/amd/iommu.c
> CONFLICT (content): Merge conflict in drivers/iommu/amd/iommu.c
> Auto-merging drivers/iommu/intel/dmar.c
> error: could not revert 78013eaadf69... x86: remove the IOMMU table infrastructure
> 
> # dmidecode  | grep -A2 "^Base Board"
> Base Board Information
>      Manufacturer: Gigabyte Technology Co., Ltd.
>      Product Name: 970A-DS3P
> #
> 
> # lspci -nn | grep -i usb
> 00:12.0 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB OHCI0 Controller [1002:4397]
> 00:12.2 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB EHCI Controller [1002:4396]
> 00:13.0 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB OHCI0 Controller [1002:4397]
> 00:13.2 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB EHCI Controller [1002:4396]
> 00:14.5 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB OHCI2 Controller [1002:4399]
> 00:16.0 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB OHCI0 Controller [1002:4397]
> 00:16.2 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB EHCI Controller [1002:4396]
> 02:00.0 USB controller [0c03]: VIA Technologies, Inc. VL805/806 xHCI USB 3.0 Controller [1106:3483] (rev 01)

So this only happens with the on-board USB 2 controller?

This is odd, I would not expect one PCI controller to work, but the
other one not.


> #
> 
> # lspci -v -s 00:12
> 00:12.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB OHCI0 Controller (prog-if 10 [OHCI])
> 	Subsystem: Gigabyte Technology Co., Ltd GA-880GMA-USB3
> 	Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 18
> 	Memory at fe50a000 (32-bit, non-prefetchable) [size=4K]
> 	Kernel driver in use: ohci-pci
> 				 	Kernel modules: ohci_pci
> 00:12.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB EHCI Controller (prog-if 20 [EHCI])
> 	Subsystem: Gigabyte Technology Co., Ltd GA-880GMA-USB3
> 	Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 17
> 	Memory at fe509000 (32-bit, non-prefetchable) [size=256]
> 	Capabilities: [c0] Power Management version 2
> 	Capabilities: [e4] Debug port: BAR=1 offset=00e0
> 	Kernel driver in use: ehci-pci
> 	Kernel modules: ehci_pci
> #

What is the output of the lspci -v for the USB 3 controller?

Christoph, any ideas?

thanks,

greg k-h
