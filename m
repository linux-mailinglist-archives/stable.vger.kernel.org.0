Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26565145614
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729982AbgAVNUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:20:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:36778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729368AbgAVNUa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:20:30 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9EDC24125;
        Wed, 22 Jan 2020 13:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699229;
        bh=xhmPu01T1Q+loCI8xtjqHscvjwS+eSfiTFSimH8jT/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v1CMuedgLCRAPCeS2YU1UUIwX5zYrZrE9qDDjHvdzrmEjS8sh6abnx2Bv+/Nrk/0N
         FUSJCSlvlWM1bDY9lmSjAff9kSyTTYYEEB/oSF4cXRYUQlQE8hPoF8Ie8UxlEiV2Xg
         I3N/M3JXcARgc73p4gyqZKcZmC0iEuujt3g+R0aE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Huang <ahuang12@lenovo.com>,
        Xiaochun Lee <lixc17@lenovo.com>,
        Shakeel Butt <shakeelb@google.com>,
        Joerg Roedel <jroedel@suse.de>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Hocko <mhocko@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 081/222] mm: memcg/slab: call flush_memcg_workqueue() only if memcg workqueue is valid
Date:   Wed, 22 Jan 2020 10:27:47 +0100
Message-Id: <20200122092839.510902160@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Huang <ahuang12@lenovo.com>

commit 2fe20210fc5f5e62644678b8f927c49f2c6f42a7 upstream.

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
  Call Trace:
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
subsystem, which the variable 'wq_online' is still 'false'.  This leads
to the statement 'if (WARN_ON(!wq_online))' in flush_workqueue() is
'true'.

Since the variable 'memcg_kmem_cache_wq' is not allocated during the
time, it is unnecessary to call flush_memcg_workqueue().  This prevents
the WARNING message triggered by flush_workqueue().

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/slab_common.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -903,7 +903,8 @@ static void flush_memcg_workqueue(struct
 	 * deactivates the memcg kmem_caches through workqueue. Make sure all
 	 * previous workitems on workqueue are processed.
 	 */
-	flush_workqueue(memcg_kmem_cache_wq);
+	if (likely(memcg_kmem_cache_wq))
+		flush_workqueue(memcg_kmem_cache_wq);
 
 	/*
 	 * If we're racing with children kmem_cache deactivation, it might


