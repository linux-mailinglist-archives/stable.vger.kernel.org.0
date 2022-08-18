Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9146598682
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 16:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343771AbiHROyG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 10:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343768AbiHROyF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 10:54:05 -0400
X-Greylist: delayed 596 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 18 Aug 2022 07:54:03 PDT
Received: from rfvt.org.uk (rfvt.org.uk [37.187.119.221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB0A51A31;
        Thu, 18 Aug 2022 07:54:02 -0700 (PDT)
Received: from wylie.me.uk (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by rfvt.org.uk (Postfix) with ESMTPS id BEC6282429;
        Thu, 18 Aug 2022 15:36:44 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wylie.me.uk;
        s=mydkim005; t=1660833404;
        bh=J/dd6iRcaMLMhF9nSV5GJIRzNBiCXO5bfnju6DcceSk=;
        h=Date:From:To:Cc:Subject;
        b=r546b75Oyf5q25xou88rrGy/63M/W7zceGRCdBz9oSTDju/5EiscOsZzZYEvAA4Ic
         Sw2n3bJVb5fgMEfCwy0xxvbTMxB/Xv3LgJExXGHyhNWPNATw9XJgkYJfFpT8QbT1jd
         37lHexyyAMAAUXVBfTDhy3Qd8OMqrBP9yITnQM7h2H+6LQf2/SeJ09NFhcYsz3eJW9
         AVdIqxAfHu+oPJ3ME0wAecgfu2nEVH+4g76T0SiST/Qc98glGgAiYWox9GbRncu3QJ
         76gr3nt31u2E16R5MV/GTlFfEry+Rq0zV0zMvLAS5JkwsMUZEsOIMz7wv8GH++rtbp
         0BOznopINnIhA==
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <25342.20092.262450.330346@wylie.me.uk>
Date:   Thu, 18 Aug 2022 15:36:44 +0100
From:   "Alan J. Wylie" <alan@wylie.me.uk>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Regression in 5.19.0: USB errors during boot
X-Mailer: VM 8.2.0b under 27.2 (x86_64-pc-linux-gnu)
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Apologies for the delay in reporting this: I messed up my first attempt at
bisecting, then I've spent a week going to, enjoying, returning from and
recovering from a music festival.

Up to and including 5.18.18 things are fine. With 5.19.0 (and .1 and .2)  I see
lots of errors and hangs on the USB2 chipset, e.g.

$ grep "usb 9-4" dmesg.5.19.2
[    6.669075] usb 9-4: new full-speed USB device number 2 using ohci-pci
[    6.829087] usb 9-4: device descriptor read/64, error -32
[    7.097094] usb 9-4: device descriptor read/64, error -32
[    7.361087] usb 9-4: new full-speed USB device number 3 using ohci-pci
[    7.521152] usb 9-4: device descriptor read/64, error -32
[    7.789066] usb 9-4: device descriptor read/64, error -32
[    8.081070] usb 9-4: new full-speed USB device number 4 using ohci-pci
[    8.497138] usb 9-4: device not accepting address 4, error -32
[    8.653140] usb 9-4: new full-speed USB device number 5 using ohci-pci
[    9.069141] usb 9-4: device not accepting address 5, error -32
$

$ grep "usb 1-2" dmesg.5.19.2
[    5.917102] usb 1-2: new high-speed USB device number 2 using ehci-pci
[    6.277076] usb 1-2: device descriptor read/64, error -71
[    6.513143] usb 1-2: device descriptor read/64, error -32
[    6.753146] usb 1-2: new high-speed USB device number 3 using ehci-pci
[    6.881143] usb 1-2: device descriptor read/64, error -32
[    7.117144] usb 1-2: device descriptor read/64, error -32
[    7.429141] usb 1-2: new high-speed USB device number 4 using ehci-pci
[    7.845134] usb 1-2: device not accepting address 4, error -32
[    7.977142] usb 1-2: new high-speed USB device number 5 using ehci-pci
[    8.393158] usb 1-2: device not accepting address 5, error -32
$

the USB port is then no longer usable

This is not reproducible on the other chipset (USB3) on this machine,
nor on two other systems. Swapping USB cables doesn't help.

I have bisected it to

$ git bisect bad
78013eaadf696d2105982abb4018fbae394ca08f is the first bad commit
commit 78013eaadf696d2105982abb4018fbae394ca08f
Author: Christoph Hellwig <hch@lst.de>
Date:   Mon Feb 14 14:11:44 2022 +0100

    x86: remove the IOMMU table infrastructure

however it will not easily revert

I'll be more than happy to assist with any debugging/testing.

$ git revert 78013eaadf696d2105982abb4018fbae394ca08f
Auto-merging arch/x86/include/asm/dma-mapping.h
CONFLICT (content): Merge conflict in arch/x86/include/asm/dma-mapping.h
Auto-merging arch/x86/include/asm/iommu.h
Auto-merging arch/x86/include/asm/xen/swiotlb-xen.h
Auto-merging arch/x86/kernel/Makefile
Auto-merging arch/x86/kernel/pci-dma.c
CONFLICT (content): Merge conflict in arch/x86/kernel/pci-dma.c
Auto-merging arch/x86/kernel/vmlinux.lds.S
Auto-merging drivers/iommu/amd/init.c
Auto-merging drivers/iommu/amd/iommu.c
CONFLICT (content): Merge conflict in drivers/iommu/amd/iommu.c
Auto-merging drivers/iommu/intel/dmar.c
error: could not revert 78013eaadf69... x86: remove the IOMMU table infrastructure

# dmidecode  | grep -A2 "^Base Board"
Base Board Information
     Manufacturer: Gigabyte Technology Co., Ltd.
     Product Name: 970A-DS3P
#

# lspci -nn | grep -i usb
00:12.0 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB OHCI0 Controller [1002:4397]
00:12.2 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB EHCI Controller [1002:4396]
00:13.0 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB OHCI0 Controller [1002:4397]
00:13.2 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB EHCI Controller [1002:4396]
00:14.5 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB OHCI2 Controller [1002:4399]
00:16.0 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB OHCI0 Controller [1002:4397]
00:16.2 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB EHCI Controller [1002:4396]
02:00.0 USB controller [0c03]: VIA Technologies, Inc. VL805/806 xHCI USB 3.0 Controller [1106:3483] (rev 01)
#

# lspci -v -s 00:12
00:12.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB OHCI0 Controller (prog-if 10 [OHCI])
	Subsystem: Gigabyte Technology Co., Ltd GA-880GMA-USB3
	Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 18
	Memory at fe50a000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci-pci
				 	Kernel modules: ohci_pci
00:12.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB EHCI Controller (prog-if 20 [EHCI])
	Subsystem: Gigabyte Technology Co., Ltd GA-880GMA-USB3
	Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 17
	Memory at fe509000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [c0] Power Management version 2
	Capabilities: [e4] Debug port: BAR=1 offset=00e0
	Kernel driver in use: ehci-pci
	Kernel modules: ehci_pci
#

# lsusb
Bus 005 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 009 Device 002: ID 067b:2303 Prolific Technology, Inc. PL2303 Serial Port / Mobile Action MA-8910P
Bus 009 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 008 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 007 Device 002: ID 03f0:0317 HP, Inc LaserJet 1200
Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 002: ID 04e8:6860 Samsung Electronics Co., Ltd Galaxy A5 (MTP)
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 002 Device 002: ID 2109:3431 VIA Labs, Inc. Hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
#

$ git bisect log
git bisect start
# good: [4b0986a3613c92f4ec1bdc7f60ec66fea135991f] Linux 5.18
git bisect good 4b0986a3613c92f4ec1bdc7f60ec66fea135991f
# good: [07e0b709cab7dc987b5071443789865e20481119] Linux 5.18.18
git bisect good 07e0b709cab7dc987b5071443789865e20481119
# bad: [3d7cb6b04c3f3115719235cc6866b10326de34cd] Linux 5.19
git bisect bad 3d7cb6b04c3f3115719235cc6866b10326de34cd
# bad: [c011dd537ffe47462051930413fed07dbdc80313] Merge tag 'arm-soc-5.19' of git://git.kernel.org/pub/scm/linux/kernel/git/soc/soc
git bisect bad c011dd537ffe47462051930413fed07dbdc80313
# good: [7e062cda7d90543ac8c7700fc7c5527d0c0f22ad] Merge tag 'net-next-5.19' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next
git bisect good 7e062cda7d90543ac8c7700fc7c5527d0c0f22ad
# good: [f8122500a039abeabfff41b0ad8b6a2c94c1107d] Merge branch 'etnaviv/next' of https://git.pengutronix.de/git/lst/linux into drm-next
git bisect good f8122500a039abeabfff41b0ad8b6a2c94c1107d
# good: [2518f226c60d8e04d18ba4295500a5b0b8ac7659] Merge tag 'drm-next-2022-05-25' of git://anongit.freedesktop.org/drm/drm
git bisect good 2518f226c60d8e04d18ba4295500a5b0b8ac7659
# good: [f7a344468105ef8c54086dfdc800e6f5a8417d3e] ASoC: max98090: Move check for invalid values before casting in max98090_put_enab_tlv()
git bisect good f7a344468105ef8c54086dfdc800e6f5a8417d3e
# good: [fbe86daca0ba878b04fa241b85e26e54d17d4229] Merge tag 'scsi-misc' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi
git bisect good fbe86daca0ba878b04fa241b85e26e54d17d4229
# good: [709c8632597c3276cd21324b0256628f1a7fd4df] xfs: rework deferred attribute operation setup
git bisect good 709c8632597c3276cd21324b0256628f1a7fd4df
# bad: [babf0bb978e3c9fce6c4eba6b744c8754fd43d8e] Merge tag 'xfs-5.19-for-linus' of git://git.kernel.org/pub/scm/fs/xfs/xfs-linux
git bisect bad babf0bb978e3c9fce6c4eba6b744c8754fd43d8e
# bad: [8b728edc5be161799434cc17e1279db2f8eabe29] Merge tag 'fs_for_v5.19-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs
git bisect bad 8b728edc5be161799434cc17e1279db2f8eabe29
# bad: [3f70356edf5611c28a68d8d5a9c2b442c9eb81e6] swiotlb: merge swiotlb-xen initialization into swiotlb
git bisect bad 3f70356edf5611c28a68d8d5a9c2b442c9eb81e6
# good: [f39f8d0eb081407e470396fd4cc376c526d13066] MIPS/octeon: use swiotlb_init instead of open coding it
git bisect good f39f8d0eb081407e470396fd4cc376c526d13066
# bad: [c6af2aa9ffc9763826607bc2664ef3ea4475ed18] swiotlb: make the swiotlb_init interface more useful
git bisect bad c6af2aa9ffc9763826607bc2664ef3ea4475ed18
# bad: [a3e230926708125205ffd06d3dc2175a8263ae7e] x86: centralize setting SWIOTLB_FORCE when guest memory encryption is enabled
git bisect bad a3e230926708125205ffd06d3dc2175a8263ae7e
# bad: [78013eaadf696d2105982abb4018fbae394ca08f] x86: remove the IOMMU table infrastructure
git bisect bad 78013eaadf696d2105982abb4018fbae394ca08f
# first bad commit: [78013eaadf696d2105982abb4018fbae394ca08f] x86: remove the IOMMU table infrastructure
$


-- 
Alan J. Wylie                                          https://www.wylie.me.uk/

Dance like no-one's watching. / Encrypt like everyone is.
Security is inversely proportional to convenience
