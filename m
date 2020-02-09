Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A546F156CC6
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 22:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgBIVhW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 16:37:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:39404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726626AbgBIVhV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Feb 2020 16:37:21 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFA0B20733;
        Sun,  9 Feb 2020 21:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581284241;
        bh=If/7dcowv/24yHFAT1r4i2Hs0TLVclmJSanHZVLUfYE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Kj8eG+xwm84l5uJq/09Tr08xq5Y3rckvpFoiDfBGll07fTWi44bWUvnVLq85DtAoF
         txQdwm+8amVA7qVGy9W2+GtQrVHjJx12ifOUDxflgoKueEER8hEWHLTAH7iJQU0cKB
         Ztbgj+iuB74B3M2mw38ko+XF0WYMtvxmKTif0/Ug=
Date:   Sun, 9 Feb 2020 16:37:19 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     david@redhat.com, adobriyan@gmail.com, akpm@linux-foundation.org,
        bob.picco@oracle.com, dan.j.williams@intel.com,
        daniel.m.jordan@oracle.com, mhocko@kernel.org, mhocko@suse.com,
        n-horiguchi@ah.jp.nec.com, osalvador@suse.de,
        pasha.tatashin@oracle.com, sfr@canb.auug.org.au,
        stable@vger.kernel.org, steven.sistare@oracle.com,
        torvalds@linux-foundation.org
Subject: Re: FAILED: patch "[PATCH] mm/page_alloc.c: fix uninitialized
 memmaps on a partially" failed to apply to 4.19-stable tree
Message-ID: <20200209213719.GG3584@sasha-vm>
References: <158125202315212@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <158125202315212@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 09, 2020 at 01:40:23PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From e822969cab48b786b64246aad1a3ba2a774f5d23 Mon Sep 17 00:00:00 2001
>From: David Hildenbrand <david@redhat.com>
>Date: Mon, 3 Feb 2020 17:33:48 -0800
>Subject: [PATCH] mm/page_alloc.c: fix uninitialized memmaps on a partially
> populated last section
>
>Patch series "mm: fix max_pfn not falling on section boundary", v2.
>
>Playing with different memory sizes for a x86-64 guest, I discovered that
>some memmaps (highest section if max_mem does not fall on the section
>boundary) are marked as being valid and online, but contain garbage.  We
>have to properly initialize these memmaps.
>
>Looking at /proc/kpageflags and friends, I found some more issues,
>partially related to this.
>
>This patch (of 3):
>
>If max_pfn is not aligned to a section boundary, we can easily run into
>BUGs.  This can e.g., be triggered on x86-64 under QEMU by specifying a
>memory size that is not a multiple of 128MB (e.g., 4097MB, but also
>4160MB).  I was told that on real HW, we can easily have this scenario
>(esp., one of the main reasons sub-section hotadd of devmem was added).
>
>The issue is, that we have a valid memmap (pfn_valid()) for the whole
>section, and the whole section will be marked "online".
>pfn_to_online_page() will succeed, but the memmap contains garbage.
>
>E.g., doing a "./page-types -r -a 0x144001" when QEMU was started with "-m
>4160M" - (see tools/vm/page-types.c):
>
>[  200.476376] BUG: unable to handle page fault for address: fffffffffffffffe
>[  200.477500] #PF: supervisor read access in kernel mode
>[  200.478334] #PF: error_code(0x0000) - not-present page
>[  200.479076] PGD 59614067 P4D 59614067 PUD 59616067 PMD 0
>[  200.479557] Oops: 0000 [#4] SMP NOPTI
>[  200.479875] CPU: 0 PID: 603 Comm: page-types Tainted: G      D W         5.5.0-rc1-next-20191209 #93
>[  200.480646] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu4
>[  200.481648] RIP: 0010:stable_page_flags+0x4d/0x410
>[  200.482061] Code: f3 ff 41 89 c0 48 b8 00 00 00 00 01 00 00 00 45 84 c0 0f 85 cd 02 00 00 48 8b 53 08 48 8b 2b 48f
>[  200.483644] RSP: 0018:ffffb139401cbe60 EFLAGS: 00010202
>[  200.484091] RAX: fffffffffffffffe RBX: fffffbeec5100040 RCX: 0000000000000000
>[  200.484697] RDX: 0000000000000001 RSI: ffffffff9535c7cd RDI: 0000000000000246
>[  200.485313] RBP: ffffffffffffffff R08: 0000000000000000 R09: 0000000000000000
>[  200.485917] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000144001
>[  200.486523] R13: 00007ffd6ba55f48 R14: 00007ffd6ba55f40 R15: ffffb139401cbf08
>[  200.487130] FS:  00007f68df717580(0000) GS:ffff9ec77fa00000(0000) knlGS:0000000000000000
>[  200.487804] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>[  200.488295] CR2: fffffffffffffffe CR3: 0000000135d48000 CR4: 00000000000006f0
>[  200.488897] Call Trace:
>[  200.489115]  kpageflags_read+0xe9/0x140
>[  200.489447]  proc_reg_read+0x3c/0x60
>[  200.489755]  vfs_read+0xc2/0x170
>[  200.490037]  ksys_pread64+0x65/0xa0
>[  200.490352]  do_syscall_64+0x5c/0xa0
>[  200.490665]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
>But it can be triggered much easier via "cat /proc/kpageflags > /dev/null"
>after cold/hot plugging a DIMM to such a system:
>
>[root@localhost ~]# cat /proc/kpageflags > /dev/null
>[  111.517275] BUG: unable to handle page fault for address: fffffffffffffffe
>[  111.517907] #PF: supervisor read access in kernel mode
>[  111.518333] #PF: error_code(0x0000) - not-present page
>[  111.518771] PGD a240e067 P4D a240e067 PUD a2410067 PMD 0
>
>This patch fixes that by at least zero-ing out that memmap (so e.g.,
>page_to_pfn() will not crash).  Commit 907ec5fca3dc ("mm: zero remaining
>unavailable struct pages") tried to fix a similar issue, but forgot to
>consider this special case.
>
>After this patch, there are still problems to solve.  E.g., not all of
>these pages falling into a memory hole will actually get initialized later
>and set PageReserved - they are only zeroed out - but at least the
>immediate crashes are gone.  A follow-up patch will take care of this.
>
>Link: http://lkml.kernel.org/r/20191211163201.17179-2-david@redhat.com
>Fixes: f7f99100d8d9 ("mm: stop zeroing memory during allocation in vmemmap")
>Signed-off-by: David Hildenbrand <david@redhat.com>
>Tested-by: Daniel Jordan <daniel.m.jordan@oracle.com>
>Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
>Cc: Pavel Tatashin <pasha.tatashin@oracle.com>
>Cc: Andrew Morton <akpm@linux-foundation.org>
>Cc: Steven Sistare <steven.sistare@oracle.com>
>Cc: Michal Hocko <mhocko@suse.com>
>Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
>Cc: Bob Picco <bob.picco@oracle.com>
>Cc: Oscar Salvador <osalvador@suse.de>
>Cc: Alexey Dobriyan <adobriyan@gmail.com>
>Cc: Dan Williams <dan.j.williams@intel.com>
>Cc: Michal Hocko <mhocko@kernel.org>
>Cc: Stephen Rothwell <sfr@canb.auug.org.au>
>Cc: <stable@vger.kernel.org>	[4.15+]
>Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

I took these two additional patches for 4.19:

ec393a0f014e ("mm: return zero_resv_unavail optimization")
907ec5fca3dc ("mm: zero remaining unavailable struct pages")

-- 
Thanks,
Sasha
