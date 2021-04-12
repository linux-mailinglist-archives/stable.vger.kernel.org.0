Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19EDC35BF63
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238489AbhDLJGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:06:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:56770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238899AbhDLJCG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:02:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9589361247;
        Mon, 12 Apr 2021 09:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218044;
        bh=02qXiYDbP2E1NT0s53S4mTXWll3kX6hzAWhOgI7777I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mpSx42EZHAfxXlG/vlFexs575HHvSbVVGV8ys7syBf2lOHe+qdhxPu+JhhvciA6SI
         Q4LHt5sfqdGUyqjYEOt1pFj4xZYPrDJe+ZJvax6g6K04g+KIhn5RrcdMFdMZjsTamw
         ce8L+sRSHqxT9eI6KpGmLZoHyE2vejiI4sXXxPOw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yongxin Liu <yongxin.liu@windriver.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.11 049/210] ice: fix memory leak of aRFS after resuming from suspend
Date:   Mon, 12 Apr 2021 10:39:14 +0200
Message-Id: <20210412084017.641418464@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yongxin Liu <yongxin.liu@windriver.com>

commit 1831da7ea5bdf5531d78bcf81f526faa4c4375fa upstream.

In ice_suspend(), ice_clear_interrupt_scheme() is called, and then
irq_free_descs() will be eventually called to free irq and its descriptor.

In ice_resume(), ice_init_interrupt_scheme() is called to allocate new
irqs. However, in ice_rebuild_arfs(), struct irq_glue and struct cpu_rmap
maybe cannot be freed, if the irqs that released in ice_suspend() were
reassigned to other devices, which makes irq descriptor's affinity_notify
lost.

So call ice_free_cpu_rx_rmap() before ice_clear_interrupt_scheme(), which
can make sure all irq_glue and cpu_rmap can be correctly released before
corresponding irq and descriptor are released.

Fix the following memory leak.

unreferenced object 0xffff95bd951afc00 (size 512):
  comm "kworker/0:1", pid 134, jiffies 4294684283 (age 13051.958s)
  hex dump (first 32 bytes):
    18 00 00 00 18 00 18 00 70 fc 1a 95 bd 95 ff ff  ........p.......
    00 00 ff ff 01 00 ff ff 02 00 ff ff 03 00 ff ff  ................
  backtrace:
    [<0000000072e4b914>] __kmalloc+0x336/0x540
    [<0000000054642a87>] alloc_cpu_rmap+0x3b/0xb0
    [<00000000f220deec>] ice_set_cpu_rx_rmap+0x6a/0x110 [ice]
    [<000000002370a632>] ice_probe+0x941/0x1180 [ice]
    [<00000000d692edba>] local_pci_probe+0x47/0xa0
    [<00000000503934f0>] work_for_cpu_fn+0x1a/0x30
    [<00000000555a9e4a>] process_one_work+0x1dd/0x410
    [<000000002c4b414a>] worker_thread+0x221/0x3f0
    [<00000000bb2b556b>] kthread+0x14c/0x170
    [<00000000ad2cf1cd>] ret_from_fork+0x1f/0x30
unreferenced object 0xffff95bd81b0a2a0 (size 96):
  comm "kworker/0:1", pid 134, jiffies 4294684283 (age 13051.958s)
  hex dump (first 32 bytes):
    38 00 00 00 01 00 00 00 e0 ff ff ff 0f 00 00 00  8...............
    b0 a2 b0 81 bd 95 ff ff b0 a2 b0 81 bd 95 ff ff  ................
  backtrace:
    [<00000000582dd5c5>] kmem_cache_alloc_trace+0x31f/0x4c0
    [<000000002659850d>] irq_cpu_rmap_add+0x25/0xe0
    [<00000000495a3055>] ice_set_cpu_rx_rmap+0xb4/0x110 [ice]
    [<000000002370a632>] ice_probe+0x941/0x1180 [ice]
    [<00000000d692edba>] local_pci_probe+0x47/0xa0
    [<00000000503934f0>] work_for_cpu_fn+0x1a/0x30
    [<00000000555a9e4a>] process_one_work+0x1dd/0x410
    [<000000002c4b414a>] worker_thread+0x221/0x3f0
    [<00000000bb2b556b>] kthread+0x14c/0x170
    [<00000000ad2cf1cd>] ret_from_fork+0x1f/0x30

Fixes: 769c500dcc1e ("ice: Add advanced power mgmt for WoL")
Signed-off-by: Yongxin Liu <yongxin.liu@windriver.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4535,6 +4535,7 @@ static int __maybe_unused ice_suspend(st
 			continue;
 		ice_vsi_free_q_vectors(pf->vsi[v]);
 	}
+	ice_free_cpu_rx_rmap(ice_get_main_vsi(pf));
 	ice_clear_interrupt_scheme(pf);
 
 	pci_save_state(pdev);


