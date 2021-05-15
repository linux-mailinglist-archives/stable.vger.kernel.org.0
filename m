Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02F6638191F
	for <lists+stable@lfdr.de>; Sat, 15 May 2021 15:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbhEONkV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 May 2021 09:40:21 -0400
Received: from coleridge.oriole.systems ([89.238.76.34]:60266 "EHLO
        coleridge.oriole.systems" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbhEONkT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 May 2021 09:40:19 -0400
X-Greylist: delayed 593 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 May 2021 09:40:18 EDT
Date:   Sat, 15 May 2021 15:28:55 +0200
From:   Wolfgang =?utf-8?Q?M=C3=BCller?= <wolf@oriole.systems>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ashok Raj <ashok.raj@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 392/530] iommu/vt-d: Preset Access/Dirty bits for
 IOVA over FL
Message-ID: <20210515132855.4bn7ve2ozvdhpnj4@nabokov.fritz.box>
References: <20210512144819.664462530@linuxfoundation.org>
 <20210512144832.660153884@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210512144832.660153884@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi!

First of all, apologies if this is the wrong place to post a problem
report. I figured since I was going to reference a particular commit
anyway I might as well reply to the patch series that (seemed to have)
introduced the problem.

> From: Lu Baolu <baolu.lu@linux.intel.com>
> 
> [ Upstream commit a8ce9ebbecdfda3322bbcece6b3b25888217f8e3 ]
> 
> The Access/Dirty bits in the first level page table entry will be set
> whenever a page table entry was used for address translation or write
> permission was successfully translated. This is always true when using
> the first-level page table for kernel IOVA. Instead of wasting hardware
> cycles to update the certain bits, it's better to set them up at the
> beginning.

This commit seems to trigger a kernel panic very early in boot for me in
5.10.37 (36 is fine):


Call Trace:
 domain_mapping+0x16/0x90
 __iommu_map+0xcd/0x120
 iommu_create_device_direct_mappins.isra.0+0x175/0x210
 bus_iommu_probe+0x15a/0x290
 bus_set_iommu+0x7e/0xd0
 intel_iommu_init+0xf84/0x112b
 ? e820__memblock_setup+0x76/0x76
 pci_iommu_init+0x11/0x3a
 do_one_initcall+0x5a/0x190
 kernel_init_freeable+0x140/0x185
 ? rest_init+0xa4/0xa4
 kernel_init+0x5/0xfc
 ret_from_fork+0x22/0x30
Modules linked in:
CR2: 0000000000000000
---[ end trace 0904a2a0169baf8a ]--
RIP: 0010:__domain_mapping+0xa1/0x3a0
Code: 02 4d 63 ff 0f 85 1b 02 00 00 4c 89 d3 48 c1 e3 0c 4c 09 fb 4d 85 c0 0f 84
 2e 01 00 00 45 31 e4 31 ed 45 31 c9 4d 85 e4 75 58 <49> 8b 5d 00 41 8b 45 08 41
 8b 4d 0c 48 83 e3 fc 48 2b 1d 28 8f b8
RSP: 0000:ffffafc54002bc00 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 00000000dd7e4003 RCX: 000000000000002d
RDX: 0000000000000000 RSI: 00000000000dd7e4 RDI: ffff8b260108ac00
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
R10: 00000000000dd7e4 R11: ffff8b260108ac00 R12: 0000000000000000
R13: 0000000000000000 R14: 00000000000dd7e4 R15: 0000000000000003
FS:  0000000000000000(0000) GS:ffff8b290ec80000(0000) knlGS: 000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 00000000080050033
CR2: 000000000000000 CR3: 0000000009700c001 CR4: 00000000001706e0
Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009


I managed to build the kernel with debug info, and could trace the
problem to drivers/iommu/intel/iommu.c:

(gdb) l *__domain_mapping+0xa1
0xffffffff8146b171 is in __domain_mapping (drivers/iommu/intel/iommu.c:2381).

I then had a look at the commits for v5.10.36..v5.10.37 that touched
that file, and on a complete hunch reverted this one (there were only 4,
and this one looked the most suspect to my eyes). I could successfully
boot into the system again after that.

I'm unsure what other information about my system to include, please
advise. Something to note is that I am compiling the 5.10 series with
GCC 11 for which I'm manually pulling in the following commits:

1e860048c53ee77ee9870dcce94847a28544b753
67a5a68013056cbcf0a647e36cb6f4622fb6a470

I have not yet tried building 5.10.37 with GCC 10 because I already
cleaned the old compiler from my system. I don't think the compiler is
to blame here, however.

Thanks a lot,

-- 
Wolfgang
