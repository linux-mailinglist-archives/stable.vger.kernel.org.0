Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 365BC262B59
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 11:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729860AbgIIJJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 05:09:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:55136 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726489AbgIIJJ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Sep 2020 05:09:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 30825B03A;
        Wed,  9 Sep 2020 09:09:55 +0000 (UTC)
Date:   Wed, 9 Sep 2020 11:09:53 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Laurent Dufour <ldufour@linux.ibm.com>
Cc:     akpm@linux-foundation.org, David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>, rafael@kernel.org,
        nathanl@linux.ibm.com, cheloha@linux.ibm.com,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: don't rely on system state to detect hot-plug
 operations
Message-ID: <20200909090953.GE7348@dhcp22.suse.cz>
References: <5cbd92e1-c00a-4253-0119-c872bfa0f2bc@redhat.com>
 <20200908170835.85440-1-ldufour@linux.ibm.com>
 <20200909074011.GD7348@dhcp22.suse.cz>
 <9faac1ce-c02d-7dbc-f79a-4aaaa5a73d28@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9faac1ce-c02d-7dbc-f79a-4aaaa5a73d28@linux.ibm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 09-09-20 09:48:59, Laurent Dufour wrote:
> Le 09/09/2020 à 09:40, Michal Hocko a écrit :
> > [reposting because the malformed cc list confused my email client]
> > 
> > On Tue 08-09-20 19:08:35, Laurent Dufour wrote:
> > > In register_mem_sect_under_node() the system_state’s value is checked to
> > > detect whether the operation the call is made during boot time or during an
> > > hot-plug operation. Unfortunately, that check is wrong on some
> > > architecture, and may lead to sections being registered under multiple
> > > nodes if node's memory ranges are interleaved.
> > 
> > Why is this check arch specific?
> 
> I was wrong the check is not arch specific.
> 
> > > This can be seen on PowerPC LPAR after multiple memory hot-plug and
> > > hot-unplug operations are done. At the next reboot the node's memory ranges
> > > can be interleaved
> > 
> > What is the exact memory layout?
> 
> For instance:
> [    0.000000] Early memory node ranges
> [    0.000000]   node   1: [mem 0x0000000000000000-0x000000011fffffff]
> [    0.000000]   node   2: [mem 0x0000000120000000-0x000000014fffffff]
> [    0.000000]   node   1: [mem 0x0000000150000000-0x00000001ffffffff]
> [    0.000000]   node   0: [mem 0x0000000200000000-0x000000048fffffff]
> [    0.000000]   node   2: [mem 0x0000000490000000-0x00000007ffffffff]

Include this into the changelog.

> > > and since the call to link_mem_sections() is made in
> > > topology_init() while the system is in the SYSTEM_SCHEDULING state, the
> > > node's id is not checked, and the sections registered multiple times.
> > 
> > So a single memory section/memblock belongs to two numa nodes?
> 
> If the node id is not checked in register_mem_sect_under_node(), yes that the case.

I do not follow. register_mem_sect_under_node is about user interface.
This is independent on the low level memory representation - aka memory
section. I do not think we can handle a section in multiple zones/nodes.
Memblock in multiple zones/nodes is a different story and interleaving
physical memory layout can indeed lead to it. This is something that we
do not allow for runtime hotplug but have to somehow live with that - at
least not crash.
 
> > > In
> > > that case, the system is able to boot but later hot-plug operation may lead
> > > to this panic because the node's links are correctly broken:
> > 
> > Correctly broken? Could you provide more details on the inconsistency
> > please?
> 
> laurent@ltczep3-lp4:~$ ls -l /sys/devices/system/memory/memory21
> total 0
> lrwxrwxrwx 1 root root     0 Aug 24 05:27 node1 -> ../../node/node1
> lrwxrwxrwx 1 root root     0 Aug 24 05:27 node2 -> ../../node/node2
> -rw-r--r-- 1 root root 65536 Aug 24 05:27 online
> -r--r--r-- 1 root root 65536 Aug 24 05:27 phys_device
> -r--r--r-- 1 root root 65536 Aug 24 05:27 phys_index
> drwxr-xr-x 2 root root     0 Aug 24 05:27 power
> -r--r--r-- 1 root root 65536 Aug 24 05:27 removable
> -rw-r--r-- 1 root root 65536 Aug 24 05:27 state
> lrwxrwxrwx 1 root root     0 Aug 24 05:25 subsystem -> ../../../../bus/memory
> -rw-r--r-- 1 root root 65536 Aug 24 05:25 uevent
> -r--r--r-- 1 root root 65536 Aug 24 05:27 valid_zones

OK, so there are two nodes referenced here. Not terrible from the user
point of view. Such a memory block will refuse to offline or online
IIRC.
 
> > Which physical memory range you are trying to add here and what is the
> > node affinity?
> 
> None is added, the root cause of the issue is happening at boot time.

Let me clarify my question. The crash has clearly happened during the
hotplug add_memory_resource - which is clearly not a boot time path.
I was askin for more information about why this has failed. It is quite
clear that sysfs machinery has failed and that led to BUG_ON but we are
mising an information on why. What was the physical memory range to be
added and why sysfs failed?
 
> > > ------------[ cut here ]------------
> > > kernel BUG at /Users/laurent/src/linux-ppc/mm/memory_hotplug.c:1084!
> > > Oops: Exception in kernel mode, sig: 5 [#1]
> > > LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
> > > Modules linked in: rpadlpar_io rpaphp pseries_rng rng_core vmx_crypto gf128mul binfmt_misc ip_tables x_tables xfs libcrc32c crc32c_vpmsum autofs4
> > > CPU: 8 PID: 10256 Comm: drmgr Not tainted 5.9.0-rc1+ #25
> > > NIP:  c000000000403f34 LR: c000000000403f2c CTR: 0000000000000000
> > > REGS: c0000004876e3660 TRAP: 0700   Not tainted  (5.9.0-rc1+)
> > > MSR:  800000000282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 24000448  XER: 20040000
> > > CFAR: c000000000846d20 IRQMASK: 0
> > > GPR00: c000000000403f2c c0000004876e38f0 c0000000012f6f00 ffffffffffffffef
> > > GPR04: 0000000000000227 c0000004805ae680 0000000000000000 00000004886f0000
> > > GPR08: 0000000000000226 0000000000000003 0000000000000002 fffffffffffffffd
> > > GPR12: 0000000088000484 c00000001ec96280 0000000000000000 0000000000000000
> > > GPR16: 0000000000000000 0000000000000000 0000000000000004 0000000000000003
> > > GPR20: c00000047814ffe0 c0000007ffff7c08 0000000000000010 c0000000013332c8
> > > GPR24: 0000000000000000 c0000000011f6cc0 0000000000000000 0000000000000000
> > > GPR28: ffffffffffffffef 0000000000000001 0000000150000000 0000000010000000
> > > NIP [c000000000403f34] add_memory_resource+0x244/0x340
> > > LR [c000000000403f2c] add_memory_resource+0x23c/0x340
> > > Call Trace:
> > > [c0000004876e38f0] [c000000000403f2c] add_memory_resource+0x23c/0x340 (unreliable)
> > > [c0000004876e39c0] [c00000000040408c] __add_memory+0x5c/0xf0
> > > [c0000004876e39f0] [c0000000000e2b94] dlpar_add_lmb+0x1b4/0x500
> > > [c0000004876e3ad0] [c0000000000e3888] dlpar_memory+0x1f8/0xb80
> > > [c0000004876e3b60] [c0000000000dc0d0] handle_dlpar_errorlog+0xc0/0x190
> > > [c0000004876e3bd0] [c0000000000dc398] dlpar_store+0x198/0x4a0
> > > [c0000004876e3c90] [c00000000072e630] kobj_attr_store+0x30/0x50
> > > [c0000004876e3cb0] [c00000000051f954] sysfs_kf_write+0x64/0x90
> > > [c0000004876e3cd0] [c00000000051ee40] kernfs_fop_write+0x1b0/0x290
> > > [c0000004876e3d20] [c000000000438dd8] vfs_write+0xe8/0x290
> > > [c0000004876e3d70] [c0000000004391ac] ksys_write+0xdc/0x130
> > > [c0000004876e3dc0] [c000000000034e40] system_call_exception+0x160/0x270
> > > [c0000004876e3e20] [c00000000000d740] system_call_common+0xf0/0x27c
> > > Instruction dump:
> > > 48442e35 60000000 0b030000 3cbe0001 7fa3eb78 7bc48402 38a5fffe 7ca5fa14
> > > 78a58402 48442db1 60000000 7c7c1b78 <0b030000> 7f23cb78 4bda371d 60000000
> > > ---[ end trace 562fd6c109cd0fb2 ]---
> > 
> > The BUG_ON on failure is absolutely horrendous. There must be a better
> > way to handle a failure like that. The failure means that
> > sysfs_create_link_nowarn has failed. Please describe why that is the
> > case.
> > 
> > > This patch addresses the root cause by not relying on the system_state
> > > value to detect whether the call is due to a hot-plug operation or not. An
> > > additional parameter is added to link_mem_sections() to tell the context of
> > > the call and this parameter is propagated to register_mem_sect_under_node()
> > > throuugh the walk_memory_blocks()'s call.
> > 
> > This looks like a hack to me and it deserves a better explanation. The
> > existing code is a hack on its own and it is inconsistent with other
> > boot time detection. We are using (system_state < SYSTEM_RUNNING) at other
> > places IIRC. Would it help to use the same here as well? Maybe we want to
> > wrap that inside a helper (early_memory_init()) and use it at all
> > places.
> 
> I agree, this looks like a hack to check for the system_state value.
> I'll follow the David's proposal and introduce an enum detailing when the
> node id check has to be done or not.

I am not sure an enum is going to make the existing situation less
messy. Sure we somehow have to distinguish boot init and runtime hotplug
because they have different constrains. I am arguing that a) we should
have a consistent way to check for those and b) we shouldn't blow up
easily just because sysfs infrastructure has failed to initialize.
-- 
Michal Hocko
SUSE Labs
