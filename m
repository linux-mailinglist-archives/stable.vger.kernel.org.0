Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA67445067
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 09:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbhKDIhz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 04:37:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:52968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230410AbhKDIht (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 04:37:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5E7D611CB;
        Thu,  4 Nov 2021 08:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636014911;
        bh=+UAkRrFFch22X7642iIOQo7roal4lSmXVN1jw2B0LFA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nlKmrxIcvLo9iKreFITSTsmfNMw9MhZtS/doOEhrynLCh+2S37qiw+DIAvBohsiA+
         eWJypCbEbb1MKAJ062CqvAWWAw/SGjKjXif9Za0uKL+p+mAMraHDbqkH1tiHqTniG6
         Tcr4xm5h6661oLizgg1SS8L7eNRaE0rEvJUwERwE=
Date:   Thu, 4 Nov 2021 09:34:58 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Stefan Agner <stefan@agner.ch>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        Russell King <linux@armlinux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        "open list:SYNOPSYS ARC ARCHITECTURE" 
        <linux-snps-arc@lists.infradead.org>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        "open list:MIPS" <linux-mips@linux-mips.org>,
        "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" 
        <linuxppc-dev@lists.ozlabs.org>,
        "open list:RISC-V ARCHITECTURE" <linux-riscv@lists.infradead.org>,
        "open list:GENERIC INCLUDE/ASM HEADER FILES" 
        <linux-arch@vger.kernel.org>
Subject: Re: [PATCH stable 4.19 1/1] arch: pgtable: define
 MAX_POSSIBLE_PHYSMEM_BITS where needed
Message-ID: <YYObMlXLFi7pAJ83@kroah.com>
References: <20211103205656.374678-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211103205656.374678-1-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 03, 2021 at 01:56:56PM -0700, Florian Fainelli wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> [ Upstream commit cef397038167ac15d085914493d6c86385773709 ]
> 
> Stefan Agner reported a bug when using zsram on 32-bit Arm machines
> with RAM above the 4GB address boundary:
> 
>   Unable to handle kernel NULL pointer dereference at virtual address 00000000
>   pgd = a27bd01c
>   [00000000] *pgd=236a0003, *pmd=1ffa64003
>   Internal error: Oops: 207 [#1] SMP ARM
>   Modules linked in: mdio_bcm_unimac(+) brcmfmac cfg80211 brcmutil raspberrypi_hwmon hci_uart crc32_arm_ce bcm2711_thermal phy_generic genet
>   CPU: 0 PID: 123 Comm: mkfs.ext4 Not tainted 5.9.6 #1
>   Hardware name: BCM2711
>   PC is at zs_map_object+0x94/0x338
>   LR is at zram_bvec_rw.constprop.0+0x330/0xa64
>   pc : [<c0602b38>]    lr : [<c0bda6a0>]    psr: 60000013
>   sp : e376bbe0  ip : 00000000  fp : c1e2921c
>   r10: 00000002  r9 : c1dda730  r8 : 00000000
>   r7 : e8ff7a00  r6 : 00000000  r5 : 02f9ffa0  r4 : e3710000
>   r3 : 000fdffe  r2 : c1e0ce80  r1 : ebf979a0  r0 : 00000000
>   Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
>   Control: 30c5383d  Table: 235c2a80  DAC: fffffffd
>   Process mkfs.ext4 (pid: 123, stack limit = 0x495a22e6)
>   Stack: (0xe376bbe0 to 0xe376c000)
> 
> As it turns out, zsram needs to know the maximum memory size, which
> is defined in MAX_PHYSMEM_BITS when CONFIG_SPARSEMEM is set, or in
> MAX_POSSIBLE_PHYSMEM_BITS on the x86 architecture.
> 
> The same problem will be hit on all 32-bit architectures that have a
> physical address space larger than 4GB and happen to not enable sparsemem
> and include asm/sparsemem.h from asm/pgtable.h.
> 
> After the initial discussion, I suggested just always defining
> MAX_POSSIBLE_PHYSMEM_BITS whenever CONFIG_PHYS_ADDR_T_64BIT is
> set, or provoking a build error otherwise. This addresses all
> configurations that can currently have this runtime bug, but
> leaves all other configurations unchanged.
> 
> I looked up the possible number of bits in source code and
> datasheets, here is what I found:
> 
>  - on ARC, CONFIG_ARC_HAS_PAE40 controls whether 32 or 40 bits are used
>  - on ARM, CONFIG_LPAE enables 40 bit addressing, without it we never
>    support more than 32 bits, even though supersections in theory allow
>    up to 40 bits as well.
>  - on MIPS, some MIPS32r1 or later chips support 36 bits, and MIPS32r5
>    XPA supports up to 60 bits in theory, but 40 bits are more than
>    anyone will ever ship
>  - On PowerPC, there are three different implementations of 36 bit
>    addressing, but 32-bit is used without CONFIG_PTE_64BIT
>  - On RISC-V, the normal page table format can support 34 bit
>    addressing. There is no highmem support on RISC-V, so anything
>    above 2GB is unused, but it might be useful to eventually support
>    CONFIG_ZRAM for high pages.
> 
> Fixes: 61989a80fb3a ("staging: zsmalloc: zsmalloc memory allocation library")
> Fixes: 02390b87a945 ("mm/zsmalloc: Prepare to variable MAX_PHYSMEM_BITS")
> Acked-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Reviewed-by: Stefan Agner <stefan@agner.ch>
> Tested-by: Stefan Agner <stefan@agner.ch>
> Acked-by: Mike Rapoport <rppt@linux.ibm.com>
> Link: https://lore.kernel.org/linux-mm/bdfa44bf1c570b05d6c70898e2bbb0acf234ecdf.1604762181.git.stefan@agner.ch/
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> [florian: patch arch/powerpc/include/asm/pte-common.h for 4.19.y]
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

All now queued up, thanks.

greg k-h
