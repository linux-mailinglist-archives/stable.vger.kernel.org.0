Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2F3329BBF3
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802664AbgJ0Pup (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:50:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801692AbgJ0PnO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:43:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 548F320657;
        Tue, 27 Oct 2020 15:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813393;
        bh=Uzk/TUmlZJiCLu5r5B4dEaxnTlOtrlR/Y1j9vKrg1Ww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uk0UoMefd3wVGv57sNCNSom2iX+bV8uSIAla/8HA328nEwGG37kEmjlOAvoYdh0Ey
         pvXPrafp1J3SYFBhY6bgzjW0V0KYAS7qvJkgYB5vmPKZFjtFvDXwWikPUmXP7gQMpd
         Yw3FcEFtwpFpKm9hek7p22PS3pQvWXxMe0GJy/pA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rafael Aquini <aquini@redhat.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 509/757] mm: fix a race during THP splitting
Date:   Tue, 27 Oct 2020 14:52:39 +0100
Message-Id: <20201027135514.344867770@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huang Ying <ying.huang@intel.com>

[ Upstream commit c4f9c701f9b44299e6adbc58d1a4bb2c40383494 ]

It is reported that the following bug is triggered if the HDD is used as
swap device,

[ 5758.157556] BUG: kernel NULL pointer dereference, address: 0000000000000007
[ 5758.165331] #PF: supervisor write access in kernel mode
[ 5758.171161] #PF: error_code(0x0002) - not-present page
[ 5758.176894] PGD 0 P4D 0
[ 5758.179721] Oops: 0002 [#1] SMP PTI
[ 5758.183614] CPU: 10 PID: 316 Comm: kswapd1 Kdump: loaded Tainted: G S               --------- ---  5.9.0-0.rc3.1.tst.el8.x86_64 #1
[ 5758.196717] Hardware name: Intel Corporation S2600CP/S2600CP, BIOS SE5C600.86B.02.01.0002.082220131453 08/22/2013
[ 5758.208176] RIP: 0010:split_swap_cluster+0x47/0x60
[ 5758.213522] Code: c1 e3 06 48 c1 eb 0f 48 8d 1c d8 48 89 df e8 d0 20 6a 00 80 63 07 fb 48 85 db 74 16 48 89 df c6 07 00 66 66 66 90 31 c0 5b c3 <80> 24 25 07 00 00 00 fb 31 c0 5b c3 b8 f0 ff ff ff 5b c3 66 0f 1f
[ 5758.234478] RSP: 0018:ffffb147442d7af0 EFLAGS: 00010246
[ 5758.240309] RAX: 0000000000000000 RBX: 000000000014b217 RCX: ffffb14779fd9000
[ 5758.248281] RDX: 000000000014b217 RSI: ffff9c52f2ab1400 RDI: 000000000014b217
[ 5758.256246] RBP: ffffe00c51168080 R08: ffffe00c5116fe08 R09: ffff9c52fffd3000
[ 5758.264208] R10: ffffe00c511537c8 R11: ffff9c52fffd3c90 R12: 0000000000000000
[ 5758.272172] R13: ffffe00c51170000 R14: ffffe00c51170000 R15: ffffe00c51168040
[ 5758.280134] FS:  0000000000000000(0000) GS:ffff9c52f2a80000(0000) knlGS:0000000000000000
[ 5758.289163] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5758.295575] CR2: 0000000000000007 CR3: 0000000022a0e003 CR4: 00000000000606e0
[ 5758.303538] Call Trace:
[ 5758.306273]  split_huge_page_to_list+0x88b/0x950
[ 5758.311433]  deferred_split_scan+0x1ca/0x310
[ 5758.316202]  do_shrink_slab+0x12c/0x2a0
[ 5758.320491]  shrink_slab+0x20f/0x2c0
[ 5758.324482]  shrink_node+0x240/0x6c0
[ 5758.328469]  balance_pgdat+0x2d1/0x550
[ 5758.332652]  kswapd+0x201/0x3c0
[ 5758.336157]  ? finish_wait+0x80/0x80
[ 5758.340147]  ? balance_pgdat+0x550/0x550
[ 5758.344525]  kthread+0x114/0x130
[ 5758.348126]  ? kthread_park+0x80/0x80
[ 5758.352214]  ret_from_fork+0x22/0x30
[ 5758.356203] Modules linked in: fuse zram rfkill sunrpc intel_rapl_msr intel_rapl_common sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp mgag200 iTCO_wdt crct10dif_pclmul iTCO_vendor_support drm_kms_helper crc32_pclmul ghash_clmulni_intel syscopyarea sysfillrect sysimgblt fb_sys_fops cec rapl joydev intel_cstate ipmi_si ipmi_devintf drm intel_uncore i2c_i801 ipmi_msghandler pcspkr lpc_ich mei_me i2c_smbus mei ioatdma ip_tables xfs libcrc32c sr_mod sd_mod cdrom t10_pi sg igb ahci libahci i2c_algo_bit crc32c_intel libata dca wmi dm_mirror dm_region_hash dm_log dm_mod
[ 5758.412673] CR2: 0000000000000007
[    0.000000] Linux version 5.9.0-0.rc3.1.tst.el8.x86_64 (mockbuild@x86-vm-15.build.eng.bos.redhat.com) (gcc (GCC) 8.3.1 20191121 (Red Hat 8.3.1-5), GNU ld version 2.30-79.el8) #1 SMP Wed Sep 9 16:03:34 EDT 2020

After further digging it's found that the following race condition exists in the
original implementation,

CPU1                                                             CPU2
----                                                             ----
deferred_split_scan()
  split_huge_page(page) /* page isn't compound head */
    split_huge_page_to_list(page, NULL)
      __split_huge_page(page, )
        ClearPageCompound(head)
        /* unlock all subpages except page (not head) */
                                                                 add_to_swap(head)  /* not THP */
                                                                   get_swap_page(head)
                                                                   add_to_swap_cache(head, )
                                                                     SetPageSwapCache(head)
     if PageSwapCache(head)
       split_swap_cluster(/* swap entry of head */)
         /* Deref sis->cluster_info: NULL accessing! */

So, in split_huge_page_to_list(), PageSwapCache() is called for the already
split and unlocked "head", which may be added to swap cache in another CPU.  So
split_swap_cluster() may be called wrongly.

To fix the race, the call to split_swap_cluster() is moved to
__split_huge_page() before all subpages are unlocked.  So that the
PageSwapCache() is stable.

Fixes: 59807685a7e77 ("mm, THP, swap: support splitting THP for THP swap out")
Reported-by: Rafael Aquini <aquini@redhat.com>
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Rafael Aquini <aquini@redhat.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Link: https://lkml.kernel.org/r/20201009073647.1531083-1-ying.huang@intel.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/huge_memory.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d37e205d3eae7..18a6f8c8b2844 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2473,6 +2473,12 @@ static void __split_huge_page(struct page *page, struct list_head *list,
 
 	remap_page(head, nr);
 
+	if (PageSwapCache(head)) {
+		swp_entry_t entry = { .val = page_private(head) };
+
+		split_swap_cluster(entry);
+	}
+
 	for (i = 0; i < nr; i++) {
 		struct page *subpage = head + i;
 		if (subpage == page)
@@ -2707,12 +2713,7 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 		}
 
 		__split_huge_page(page, list, end, flags);
-		if (PageSwapCache(head)) {
-			swp_entry_t entry = { .val = page_private(head) };
-
-			ret = split_swap_cluster(entry);
-		} else
-			ret = 0;
+		ret = 0;
 	} else {
 		if (IS_ENABLED(CONFIG_DEBUG_VM) && mapcount) {
 			pr_alert("total_mapcount: %u, page_count(): %u\n",
-- 
2.25.1



