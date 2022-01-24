Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B527D498EE6
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357178AbiAXTt3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:49:29 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36048 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345983AbiAXToU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:44:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A20FB81215;
        Mon, 24 Jan 2022 19:44:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5DCFC340E5;
        Mon, 24 Jan 2022 19:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053457;
        bh=Lht58LNI8KdoxzRSF1qDz20MWcfbNF8A5zAHYBz8diQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Juf/LJDlgakA+hD2fISYbRWn/+dz2aIWLQOtAjx+kDIZ6JlCQmMXn6hWDktM8x/qx
         fowvxE6kYYS+usYc3TD0odkq0QCijLAcAZen1GkKUuNXrGIWeEOkx7hdO1sOEz5+AP
         l9G5/Wjolwfukfck6ZYVKNVtr7QB6JAsjJEi6SCE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baoquan He <bhe@redhat.com>,
        John Donnelly <john.p.donnelly@oracle.com>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Borislav Petkov <bp@alien8.de>, Christoph Hellwig <hch@lst.de>,
        David Hildenbrand <david@redhat.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 039/563] mm/page_alloc.c: do not warn allocation failure on zone DMA if no managed pages
Date:   Mon, 24 Jan 2022 19:36:44 +0100
Message-Id: <20220124184025.779821957@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baoquan He <bhe@redhat.com>

commit c4dc63f0032c77464fbd4e7a6afc22fa6913c4a7 upstream.

In kdump kernel of x86_64, page allocation failure is observed:

 kworker/u2:2: page allocation failure: order:0, mode:0xcc1(GFP_KERNEL|GFP_DMA), nodemask=(null),cpuset=/,mems_allowed=0
 CPU: 0 PID: 55 Comm: kworker/u2:2 Not tainted 5.16.0-rc4+ #5
 Hardware name: AMD Dinar/Dinar, BIOS RDN1505B 06/05/2013
 Workqueue: events_unbound async_run_entry_fn
 Call Trace:
  <TASK>
  dump_stack_lvl+0x48/0x5e
  warn_alloc.cold+0x72/0xd6
  __alloc_pages_slowpath.constprop.0+0xc69/0xcd0
  __alloc_pages+0x1df/0x210
  new_slab+0x389/0x4d0
  ___slab_alloc+0x58f/0x770
  __slab_alloc.constprop.0+0x4a/0x80
  kmem_cache_alloc_trace+0x24b/0x2c0
  sr_probe+0x1db/0x620
  ......
  device_add+0x405/0x920
  ......
  __scsi_add_device+0xe5/0x100
  ata_scsi_scan_host+0x97/0x1d0
  async_run_entry_fn+0x30/0x130
  process_one_work+0x1e8/0x3c0
  worker_thread+0x50/0x3b0
  ? rescuer_thread+0x350/0x350
  kthread+0x16b/0x190
  ? set_kthread_struct+0x40/0x40
  ret_from_fork+0x22/0x30
  </TASK>
 Mem-Info:
 ......

The above failure happened when calling kmalloc() to allocate buffer with
GFP_DMA.  It requests to allocate slab page from DMA zone while no managed
pages at all in there.

 sr_probe()
 --> get_capabilities()
     --> buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);

Because in the current kernel, dma-kmalloc will be created as long as
CONFIG_ZONE_DMA is enabled.  However, kdump kernel of x86_64 doesn't have
managed pages on DMA zone since commit 6f599d84231f ("x86/kdump: Always
reserve the low 1M when the crashkernel option is specified").  The
failure can be always reproduced.

For now, let's mute the warning of allocation failure if requesting pages
from DMA zone while no managed pages.

[akpm@linux-foundation.org: fix warning]

Link: https://lkml.kernel.org/r/20211223094435.248523-4-bhe@redhat.com
Fixes: 6f599d84231f ("x86/kdump: Always reserve the low 1M when the crashkernel option is specified")
Signed-off-by: Baoquan He <bhe@redhat.com>
Acked-by: John Donnelly  <john.p.donnelly@oracle.com>
Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3964,7 +3964,9 @@ void warn_alloc(gfp_t gfp_mask, nodemask
 	va_list args;
 	static DEFINE_RATELIMIT_STATE(nopage_rs, 10*HZ, 1);
 
-	if ((gfp_mask & __GFP_NOWARN) || !__ratelimit(&nopage_rs))
+	if ((gfp_mask & __GFP_NOWARN) ||
+	     !__ratelimit(&nopage_rs) ||
+	     ((gfp_mask & __GFP_DMA) && !has_managed_dma()))
 		return;
 
 	va_start(args, fmt);


