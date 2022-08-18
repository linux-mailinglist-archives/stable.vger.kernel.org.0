Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECC585986D5
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 17:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344008AbiHRPEH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 11:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344013AbiHRPEF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 11:04:05 -0400
X-Greylist: delayed 427 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 18 Aug 2022 08:04:03 PDT
Received: from rfvt.org.uk (rfvt.org.uk [37.187.119.221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A939F40BE7;
        Thu, 18 Aug 2022 08:04:03 -0700 (PDT)
Received: from wylie.me.uk (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by rfvt.org.uk (Postfix) with ESMTPS id 697A682429;
        Thu, 18 Aug 2022 15:56:52 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wylie.me.uk;
        s=mydkim005; t=1660834612;
        bh=2w2zcJmK/iAiFwIuyHBL4kajpnEz6z0D5iINur8oCq0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=Z74qpOCb/fvH7I3B031m8v/PyjVt5PvNX77vVY9B74FN1LxCtdHJFB+Koau3maS+w
         5uBNTIRValVGP242zJBOwUAU2qKscMTiXPrBmM6Edv35WK+BvQ6gEIG8NGvY8RRuy3
         BsN/siJsN3zzEXsNt3k7BOA9NdG3WNJmoFHSQKf4KUx9uGUuLc8pac91XEndrsIgo/
         Ve1OHVVqtWce1Hpwj91ZJp0d9D/UjWo8keIuZodRld55O4HAXmLTxA2EZE2LC1texi
         EBK4yk0j3pVYnxAvCJBM5IM5qOR4mYWEKm7CtFcSZ7FgOmdQnZfl9RgaozqpBICKvt
         SBLLTGOffGWNA==
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <25342.21300.105848.619006@wylie.me.uk>
Date:   Thu, 18 Aug 2022 15:56:52 +0100
From:   "Alan J. Wylie" <alan@wylie.me.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Regression in 5.19.0: USB errors during boot
In-Reply-To: <Yv5Q8gDvVTGOHd8k@kroah.com>
References: <25342.20092.262450.330346@wylie.me.uk>
        <Yv5Q8gDvVTGOHd8k@kroah.com>
X-Mailer: VM 8.2.0b under 27.2 (x86_64-pc-linux-gnu)
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

at 16:47 on Thu 18-Aug-2022 Greg Kroah-Hartman (gregkh@linuxfoundation.org) wrote:
> [Adding in linux-usb@vger]
> 
> 
> On Thu, Aug 18, 2022 at 03:36:44PM +0100, Alan J. Wylie wrote:
> > 
> > Apologies for the delay in reporting this: I messed up my first attempt at
> > bisecting, then I've spent a week going to, enjoying, returning from and
> > recovering from a music festival.
> > 
> > Up to and including 5.18.18 things are fine. With 5.19.0 (and .1 and .2)  I see
> > lots of errors and hangs on the USB2 chipset, e.g.
> > 
> > $ grep "usb 9-4" dmesg.5.19.2
> > [    6.669075] usb 9-4: new full-speed USB device number 2 using ohci-pci
> > [    6.829087] usb 9-4: device descriptor read/64, error -32
> > [    7.097094] usb 9-4: device descriptor read/64, error -32
> > [    7.361087] usb 9-4: new full-speed USB device number 3 using ohci-pci
> > [    7.521152] usb 9-4: device descriptor read/64, error -32
> > [    7.789066] usb 9-4: device descriptor read/64, error -32
> > [    8.081070] usb 9-4: new full-speed USB device number 4 using ohci-pci
> > [    8.497138] usb 9-4: device not accepting address 4, error -32
> > [    8.653140] usb 9-4: new full-speed USB device number 5 using ohci-pci
> > [    9.069141] usb 9-4: device not accepting address 5, error -32
> > $
> > 
> > $ grep "usb 1-2" dmesg.5.19.2
> > [    5.917102] usb 1-2: new high-speed USB device number 2 using ehci-pci
> > [    6.277076] usb 1-2: device descriptor read/64, error -71
> > [    6.513143] usb 1-2: device descriptor read/64, error -32
> > [    6.753146] usb 1-2: new high-speed USB device number 3 using ehci-pci
> > [    6.881143] usb 1-2: device descriptor read/64, error -32
> > [    7.117144] usb 1-2: device descriptor read/64, error -32
> > [    7.429141] usb 1-2: new high-speed USB device number 4 using ehci-pci
> > [    7.845134] usb 1-2: device not accepting address 4, error -32
> > [    7.977142] usb 1-2: new high-speed USB device number 5 using ehci-pci
> > [    8.393158] usb 1-2: device not accepting address 5, error -32
> > $
> > 
> > the USB port is then no longer usable
> > 
> > This is not reproducible on the other chipset (USB3) on this machine,
> > nor on two other systems. Swapping USB cables doesn't help.
> > 
> > I have bisected it to
> > 
> > $ git bisect bad
> > 78013eaadf696d2105982abb4018fbae394ca08f is the first bad commit
> > commit 78013eaadf696d2105982abb4018fbae394ca08f
> > Author: Christoph Hellwig <hch@lst.de>
> > Date:   Mon Feb 14 14:11:44 2022 +0100
> > 
> >     x86: remove the IOMMU table infrastructure
> > 
> > however it will not easily revert
> > 
> > I'll be more than happy to assist with any debugging/testing.
> > 
> > $ git revert 78013eaadf696d2105982abb4018fbae394ca08f
> > Auto-merging arch/x86/include/asm/dma-mapping.h
> > CONFLICT (content): Merge conflict in arch/x86/include/asm/dma-mapping.h
> > Auto-merging arch/x86/include/asm/iommu.h
> > Auto-merging arch/x86/include/asm/xen/swiotlb-xen.h
> > Auto-merging arch/x86/kernel/Makefile
> > Auto-merging arch/x86/kernel/pci-dma.c
> > CONFLICT (content): Merge conflict in arch/x86/kernel/pci-dma.c
> > Auto-merging arch/x86/kernel/vmlinux.lds.S
> > Auto-merging drivers/iommu/amd/init.c
> > Auto-merging drivers/iommu/amd/iommu.c
> > CONFLICT (content): Merge conflict in drivers/iommu/amd/iommu.c
> > Auto-merging drivers/iommu/intel/dmar.c
> > error: could not revert 78013eaadf69... x86: remove the IOMMU table infrastructure
> > 
> > # dmidecode  | grep -A2 "^Base Board"
> > Base Board Information
> >      Manufacturer: Gigabyte Technology Co., Ltd.
> >      Product Name: 970A-DS3P
> > #
> > 
> > # lspci -nn | grep -i usb
> > 00:12.0 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB OHCI0 Controller [1002:4397]
> > 00:12.2 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB EHCI Controller [1002:4396]
> > 00:13.0 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB OHCI0 Controller [1002:4397]
> > 00:13.2 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB EHCI Controller [1002:4396]
> > 00:14.5 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB OHCI2 Controller [1002:4399]
> > 00:16.0 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB OHCI0 Controller [1002:4397]
> > 00:16.2 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB EHCI Controller [1002:4396]
> > 02:00.0 USB controller [0c03]: VIA Technologies, Inc. VL805/806 xHCI USB 3.0 Controller [1106:3483] (rev 01)
> 
> So this only happens with the on-board USB 2 controller?

That is correct

> This is odd, I would not expect one PCI controller to work, but the
> other one not.
> 
> 
> > #
> > 
> > # lspci -v -s 00:12
> > 00:12.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB OHCI0 Controller (prog-if 10 [OHCI])
> > 	Subsystem: Gigabyte Technology Co., Ltd GA-880GMA-USB3
> > 	Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 18
> > 	Memory at fe50a000 (32-bit, non-prefetchable) [size=4K]
> > 	Kernel driver in use: ohci-pci
> > 				 	Kernel modules: ohci_pci
> > 00:12.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB EHCI Controller (prog-if 20 [EHCI])
> > 	Subsystem: Gigabyte Technology Co., Ltd GA-880GMA-USB3
> > 	Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 17
> > 	Memory at fe509000 (32-bit, non-prefetchable) [size=256]
> > 	Capabilities: [c0] Power Management version 2
> > 	Capabilities: [e4] Debug port: BAR=1 offset=00e0
> > 	Kernel driver in use: ehci-pci
> > 	Kernel modules: ehci_pci
> > #
> 
> What is the output of the lspci -v for the USB 3 controller?

# lspci -v -s 02:00
02:00.0 USB controller: VIA Technologies, Inc. VL805/806 xHCI USB 3.0 Controller (rev 01) (prog-if 30 [XHCI])
	Subsystem: Gigabyte Technology Co., Ltd VL805/806 xHCI USB 3.0 Controller
	Flags: bus master, fast devsel, latency 0, IRQ 36
	Memory at fe400000 (64-bit, non-prefetchable) [size=4K]
	Capabilities: [80] Power Management version 3
	Capabilities: [90] MSI: Enable+ Count=1/4 Maskable- 64bit+
	Capabilities: [c4] Express Endpoint, MSI 00
	Capabilities: [100] Advanced Error Reporting
	Kernel driver in use: xhci_hcd
	Kernel modules: xhci_pci

> 
> Christoph, any ideas?
> 
> thanks,
> 
> greg k-h

-- 
Alan J. Wylie                                          https://www.wylie.me.uk/

Dance like no-one's watching. / Encrypt like everyone is.
Security is inversely proportional to convenience
