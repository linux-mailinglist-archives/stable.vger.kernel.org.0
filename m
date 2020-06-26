Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3BE20AAB9
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 05:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbgFZDax (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 23:30:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:48912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725900AbgFZDax (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jun 2020 23:30:53 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99ACD2089D;
        Fri, 26 Jun 2020 03:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593142252;
        bh=wY/slw8X5uR4JH7hoJhll75ZoEYqMJ/DKl6wxY8qtbE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=oFjqOWFWcH/Q758MuQJDJdoYZg6znHqjNUYj0GYTBf8olrFviQvZd9fCqUrmLY7wN
         FrGp9dwtCca7Se8r4itS45FF4OiUQ5LJDfTMEhFJxURV9+rfnlp6YPDzWLckCcer/G
         qDGE2cZmqkAiPuWwF8dNVSKCeXQLCnNl1qmzkT8c=
Date:   Thu, 25 Jun 2020 20:30:51 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ben.widawsky@intel.com,
        dan.j.williams@intel.com, david@redhat.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        steve.scargall@intel.com, torvalds@linux-foundation.org,
        vishal.l.verma@intel.com
Subject:  [patch 31/32] mm/memory_hotplug.c: fix false softlockup
 during pfn range removal
Message-ID: <20200626033051.73wfBW4YT%akpm@linux-foundation.org>
In-Reply-To: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

=46rom: Ben Widawsky <ben.widawsky@intel.com>
Subject: mm/memory_hotplug.c: fix false softlockup during pfn range removal

When working with very large nodes, poisoning the struct pages (for which
there will be very many) can take a very long time.  If the system is
using voluntary preemptions, the software watchdog will not be able to
detect forward progress.  This patch addresses this issue by offering to
give up time like __remove_pages() does.  This behavior was introduced in
v5.6 with: commit d33695b16a9f ("mm/memory_hotplug: poison memmap in
remove_pfn_range_from_zone()")

Alternately, init_page_poison could do this cond_resched(), but it seems
to me that the caller of init_page_poison() is what actually knows whether
or not it should relax its own priority.

Based on Dan's notes, I think this is perfectly safe: commit f931ab479dd2
("mm: fix devm_memremap_pages crash, use mem_hotplug_{begin, done}")

Aside from fixing the lockup, it is also a friendlier thing to do on lower
core systems that might wipe out large chunks of hotplug memory (probably
not a very common case).

Fixes this kind of splat:
[  352.142079] watchdog: BUG: soft lockup - CPU#46 stuck for 22s! [daxctl:9=
922]
[  352.150067] Modules linked in: nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nf=
t_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_c=
hain_nat nf_tables ebtable_nat ebtable_broute ip6table_nat ip6table_mangle =
ip6table_raw ip6table_security iptable_nat nf_nat nf_conntrack nf_defrag_ip=
v6 nf_defrag_ipv4 iptable_mangle iptable_raw iptable_security rfkill ip_set=
 nfnetlink ebtable_filter ebtables ip6table_filter ip6_tables iptable_filte=
r ib_isert iscsi_target_mod ib_srpt target_core_mod ib_srp scsi_transport_s=
rp ib_ipoib ib_umad vfat fat kmem intel_rapl_msr intel_rapl_common rpcrdma =
sunrpc rdma_ucm ib_iser isst_if_common rdma_cm skx_edac iw_cm ib_cm x86_pkg=
_temp_thermal libiscsi intel_powerclamp scsi_transport_iscsi coretemp kvm_i=
ntel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel i40iw =
intel_cstate iTCO_wdt ib_uverbs iTCO_vendor_support device_dax ib_core joyd=
ev intel_uncore i2c_i801 lpc_ich ipmi_ssif ioatdma dca wmi ipmi_si ipmi_dev=
intf ipmi_msghandler dax_pmem
[  352.150123]  dax_pmem_core acpi_pad acpi_power_meter drm ip_tables xfs l=
ibcrc32c nd_pmem nd_btt i40e e1000e crc32c_intel nfit
[  352.260774] irq event stamp: 138450
[  352.264692] hardirqs last  enabled at (138449): [<ffffffffa1001f26>] tra=
ce_hardirqs_on_thunk+0x1a/0x1c
[  352.275134] hardirqs last disabled at (138450): [<ffffffffa1001f42>] tra=
ce_hardirqs_off_thunk+0x1a/0x1c
[  352.285662] softirqs last  enabled at (138448): [<ffffffffa1e00347>] __d=
o_softirq+0x347/0x456
[  352.295233] softirqs last disabled at (138443): [<ffffffffa10c416d>] irq=
_exit+0x7d/0xb0
[  352.304210] CPU: 46 PID: 9922 Comm: daxctl Not tainted 5.7.0-BEN-14238-g=
373c6049b336 #30
[  352.313283] Hardware name: Intel Corporation PURLEY/PURLEY, BIOS PLYXCRB=
1.86B.0578.D07.1902280810 02/28/2019
[  352.324308] RIP: 0010:memset_erms+0x9/0x10
[  352.328905] Code: c1 e9 03 40 0f b6 f6 48 b8 01 01 01 01 01 01 01 01 48 =
0f af c6 f3 48 ab 89 d1 f3 aa 4c 89 c8 c3 90 49 89 f9 40 88 f0 48 89 d1 <f3=
> aa 4c 89 c8 c3 90 49 89 fa 40 0f b6 ce 48 b8 01 01 01 01 01 01
[  352.349953] RSP: 0018:ffffc90021b5fd50 EFLAGS: 00010202 ORIG_RAX: ffffff=
ffffffff13
[  352.358450] RAX: 00000000000000ff RBX: ffff88983ffd5000 RCX: 0000000065d=
f0e40
[  352.366457] RDX: 00000003a0000000 RSI: 00000000ffffffff RDI: ffffea039b2=
0f1c0
[  352.374465] RBP: ffff88983ffd6c00 R08: 0000000000000000 R09: ffffea00610=
00000
[  352.382473] R10: 0000000000000001 R11: 0000000000000000 R12: ffffea006f8=
08000
[  352.390480] R13: 0000000001840000 R14: 000000000e800000 R15: ffff8997d7b=
764e0
[  352.398487] FS:  00007f724ef81780(0000) GS:ffff8997df100000(0000) knlGS:=
0000000000000000
[  352.407562] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  352.414011] CR2: 00007ffcd4070768 CR3: 000001178c722002 CR4: 00000000003=
606e0
[  352.422056] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  352.430092] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[  352.438115] Call Trace:
[  352.440865]  remove_pfn_range_from_zone+0x3a/0x380
[  352.446244]  ? cpumask_next+0x17/0x20
[  352.450361]  memunmap_pages+0x17f/0x280
[  352.454670]  release_nodes+0x22a/0x260
[  352.458888]  __device_release_driver+0x172/0x220
[  352.464070]  device_driver_detach+0x3e/0xa0
[  352.468753]  unbind_store+0x113/0x130
[  352.472868]  kernfs_fop_write+0xdc/0x1c0
[  352.477273]  vfs_write+0xde/0x1d0
[  352.482218]  ksys_write+0x58/0xd0
[  352.487207]  do_syscall_64+0x5a/0x120
[  352.492529]  entry_SYSCALL_64_after_hwframe+0x49/0xb3
[  352.499446] RIP: 0033:0x7f724f40b5e7
[  352.504673] Code: Bad RIP value.
[  352.509484] RSP: 002b:00007ffcd40738f8 EFLAGS: 00000246 ORIG_RAX: 000000=
0000000001
[  352.519213] RAX: ffffffffffffffda RBX: 00007f724ef816a8 RCX: 00007f724f4=
0b5e7
[  352.528410] RDX: 0000000000000007 RSI: 00005617d7cd1277 RDI: 00000000000=
00003
[  352.537573] RBP: 0000000000000003 R08: 00000000ffffffff R09: 00007ffcd40=
737d0
[  352.546764] R10: 0000000000000000 R11: 0000000000000246 R12: 00005617d7c=
d1277
[  352.555929] R13: 0000000000000000 R14: 0000000000000007 R15: 00005617d7c=
d1230
[  370.353742] Built 2 zonelists, mobility grouping on.  Total pages: 49050=
381
[  370.373317] Policy zone: Normal
[  374.948164] Built 3 zonelists, mobility grouping on.  Total pages: 49312=
525
[  375.017496] Policy zone: Normal

David said: "It really only is an issue for devmem.  Ordinary
hotplugged system memory is not affected (onlined/offlined in memory
block granularity)."

Link: http://lkml.kernel.org/r/20200619231213.1160351-1-ben.widawsky@intel.=
com
Fixes: commit d33695b16a9f ("mm/memory_hotplug: poison memmap in remove_pfn=
_range_from_zone()")
Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
Reported-by: "Scargall, Steve" <steve.scargall@intel.com>
Reported-by: Ben Widawsky <ben.widawsky@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/mm/memory_hotplug.c~mm-fix-false-softlockup-during-pfn-range-removal
+++ a/mm/memory_hotplug.c
@@ -471,11 +471,20 @@ void __ref remove_pfn_range_from_zone(st
 				      unsigned long start_pfn,
 				      unsigned long nr_pages)
 {
+	const unsigned long end_pfn =3D start_pfn + nr_pages;
 	struct pglist_data *pgdat =3D zone->zone_pgdat;
-	unsigned long flags;
+	unsigned long pfn, cur_nr_pages, flags;
=20
 	/* Poison struct pages because they are now uninitialized again. */
-	page_init_poison(pfn_to_page(start_pfn), sizeof(struct page) * nr_pages);
+	for (pfn =3D start_pfn; pfn < end_pfn; pfn +=3D cur_nr_pages) {
+		cond_resched();
+
+		/* Select all remaining pages up to the next section boundary */
+		cur_nr_pages =3D
+			min(end_pfn - pfn, SECTION_ALIGN_UP(pfn + 1) - pfn);
+		page_init_poison(pfn_to_page(pfn),
+				 sizeof(struct page) * cur_nr_pages);
+	}
=20
 #ifdef CONFIG_ZONE_DEVICE
 	/*
_
