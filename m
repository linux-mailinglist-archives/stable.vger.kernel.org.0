Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A872D139E36
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 01:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728977AbgANA3e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 19:29:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:45786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728890AbgANA3e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Jan 2020 19:29:34 -0500
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FD1F21556;
        Tue, 14 Jan 2020 00:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578961773;
        bh=DcHqBL64cbNkVbSmxrP/j7rkitdcnTiPDWtLdYy4gmU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=g6vf8wLwX37XkzCTV60uaetfiDyZU8PV3/W/mv0mIgR7vd1B0AMvTZuEt+5mG9sbV
         izDaLs2RTWscjLS9XwJVXZtsuG8HzYTRnD8h8LjozYz3GmyNDcK1ZC2LE0mjchfvTh
         Aae3BHnhZe23bDs8T0e224EYWkScf7hfBYNTjHB0=
Date:   Mon, 13 Jan 2020 16:29:32 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     stable@vger.kernel.org, shakeelb@google.com, rientjes@google.com,
        penberg@kernel.org, mhocko@kernel.org, lixc17@lenovo.com,
        jroedel@suse.de, iamjoonsoo.kim@lge.com, hannes@cmpxchg.org,
        cl@linux.com, ahuang12@lenovo.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 10/11] mm: memcg/slab: call flush_memcg_workqueue()
 only if memcg workqueue is valid
Message-ID: <20200114002932.ZMvXk%akpm@linux-foundation.org>
In-Reply-To: <20200113162831.f7d69e11e9e673c40005c9b0@linux-foundation.org>
User-Agent: s-nail v14.9.15
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Huang <ahuang12@lenovo.com>
Subject: mm: memcg/slab: call flush_memcg_workqueue() only if memcg workqueue is valid

When booting with amd_iommu=off, the following WARNING message
appears:
  AMD-Vi: AMD IOMMU disabled on kernel command-line
  ------------[ cut here ]------------
  WARNING: CPU: 0 PID: 0 at kernel/workqueue.c:2772 flush_workqueue+0x42e/0x450
  Modules linked in:
  CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.5.0-rc3-amd-iommu #6
  Hardware name: Lenovo ThinkSystem SR655-2S/7D2WRCZ000, BIOS D8E101L-1.00 12/05/2019
  RIP: 0010:flush_workqueue+0x42e/0x450
  Code: ff 0f 0b e9 7a fd ff ff 4d 89 ef e9 33 fe ff ff 0f 0b e9 7f fd ff ff 0f 0b e9 bc fd ff ff 0f 0b e9 a8 fd ff ff e8 52 2c fe ff <0f> 0b 31 d2 48 c7 c6 e0 88 c5 95 48 c7 c7 d8 ad f0 95 e8 19 f5 04
  RSP: 0000:ffffffff96203d80 EFLAGS: 00010246
  RAX: ffffffff96203dc8 RBX: 0000000000000000 RCX: 0000000000000000
  RDX: ffffffff96a63120 RSI: ffffffff95efcba2 RDI: ffffffff96203dc0
  RBP: ffffffff96203e08 R08: 0000000000000000 R09: ffffffff962a1828
  R10: 00000000f0000080 R11: dead000000000100 R12: ffff8d8a87c0a770
  R13: dead000000000100 R14: 0000000000000456 R15: ffffffff96203da0
  FS:  0000000000000000(0000) GS:ffff8d8dbd000000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: ffff8d91cfbff000 CR3: 000000078920a000 CR4: 00000000000406b0
  Call Trace:
   ? wait_for_completion+0x51/0x180
   kmem_cache_destroy+0x69/0x260
   iommu_go_to_state+0x40c/0x5ab
   amd_iommu_prepare+0x16/0x2a
   irq_remapping_prepare+0x36/0x5f
   enable_IR_x2apic+0x21/0x172
   default_setup_apic_routing+0x12/0x6f
   apic_intr_mode_init+0x1a1/0x1f1
   x86_late_time_init+0x17/0x1c
   start_kernel+0x480/0x53f
   secondary_startup_64+0xb6/0xc0
  ---[ end trace 30894107c3749449 ]---
  x2apic: IRQ remapping doesn't support X2APIC mode
  x2apic disabled

The warning is caused by the calling of 'kmem_cache_destroy()'
in free_iommu_resources(). Here is the call path:
  free_iommu_resources
    kmem_cache_destroy
      flush_memcg_workqueue
        flush_workqueue

The root cause is that the IOMMU subsystem runs before the workqueue
subsystem, which the variable 'wq_online' is still 'false'.  This leads to
the statement 'if (WARN_ON(!wq_online))' in flush_workqueue() is 'true'.

Since the variable 'memcg_kmem_cache_wq' is not allocated during the time,
it is unnecessary to call flush_memcg_workqueue().  This prevents the
WARNING message triggered by flush_workqueue().

Link: http://lkml.kernel.org/r/20200103085503.1665-1-ahuang12@lenovo.com
Fixes: 92ee383f6daab ("mm: fix race between kmem_cache destroy, create and deactivate")
Signed-off-by: Adrian Huang <ahuang12@lenovo.com>
Reported-by: Xiaochun Lee <lixc17@lenovo.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/slab_common.c~mm-memcg-slab-call-flush_memcg_workqueue-only-if-memcg-workqueue-is-valid
+++ a/mm/slab_common.c
@@ -903,7 +903,8 @@ static void flush_memcg_workqueue(struct
 	 * deactivates the memcg kmem_caches through workqueue. Make sure all
 	 * previous workitems on workqueue are processed.
 	 */
-	flush_workqueue(memcg_kmem_cache_wq);
+	if (likely(memcg_kmem_cache_wq))
+		flush_workqueue(memcg_kmem_cache_wq);
 
 	/*
 	 * If we're racing with children kmem_cache deactivation, it might
_
