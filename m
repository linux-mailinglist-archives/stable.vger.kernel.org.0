Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C22489130
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239427AbiAJHaJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:30:09 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36178 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239536AbiAJH17 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:27:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66B59611EC;
        Mon, 10 Jan 2022 07:27:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D80DC36AED;
        Mon, 10 Jan 2022 07:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799678;
        bh=LkCMpxp7In/MPx9LiMkILMu1+LY++XK6Yts1zoTFPOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Ft6oUr3yFEHSdJHcCqVcHFS1/w11LgzfXi5SlQFWM9SkxNL1lcxRmVGWKJRUZpT/
         oltMwpXprYk50OE+1lzRkzHd36AZleEuWmeFuez10RLdDmI4znjzAM3e1Ag3Crnv9B
         6mxNRhjxPkzwhZimvdUkTF8CM2IyMjib0b0mRE7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Di Zhu <zhudi2@huawei.com>,
        Rui Zhang <zhangrui182@huawei.com>,
        Gurucharan G <gurucharanx.g@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.4 11/34] i40e: fix use-after-free in i40e_sync_filters_subtask()
Date:   Mon, 10 Jan 2022 08:23:06 +0100
Message-Id: <20220110071816.028374195@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071815.647309738@linuxfoundation.org>
References: <20220110071815.647309738@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Di Zhu <zhudi2@huawei.com>

commit 3116f59c12bd24c513194cd3acb3ec1f7d468954 upstream.

Using ifconfig command to delete the ipv6 address will cause
the i40e network card driver to delete its internal mac_filter and
i40e_service_task kernel thread will concurrently access the mac_filter.
These two processes are not protected by lock
so causing the following use-after-free problems.

 print_address_description+0x70/0x360
 ? vprintk_func+0x5e/0xf0
 kasan_report+0x1b2/0x330
 i40e_sync_vsi_filters+0x4f0/0x1850 [i40e]
 i40e_sync_filters_subtask+0xe3/0x130 [i40e]
 i40e_service_task+0x195/0x24c0 [i40e]
 process_one_work+0x3f5/0x7d0
 worker_thread+0x61/0x6c0
 ? process_one_work+0x7d0/0x7d0
 kthread+0x1c3/0x1f0
 ? kthread_park+0xc0/0xc0
 ret_from_fork+0x35/0x40

Allocated by task 2279810:
 kasan_kmalloc+0xa0/0xd0
 kmem_cache_alloc_trace+0xf3/0x1e0
 i40e_add_filter+0x127/0x2b0 [i40e]
 i40e_add_mac_filter+0x156/0x190 [i40e]
 i40e_addr_sync+0x2d/0x40 [i40e]
 __hw_addr_sync_dev+0x154/0x210
 i40e_set_rx_mode+0x6d/0xf0 [i40e]
 __dev_set_rx_mode+0xfb/0x1f0
 __dev_mc_add+0x6c/0x90
 igmp6_group_added+0x214/0x230
 __ipv6_dev_mc_inc+0x338/0x4f0
 addrconf_join_solict.part.7+0xa2/0xd0
 addrconf_dad_work+0x500/0x980
 process_one_work+0x3f5/0x7d0
 worker_thread+0x61/0x6c0
 kthread+0x1c3/0x1f0
 ret_from_fork+0x35/0x40

Freed by task 2547073:
 __kasan_slab_free+0x130/0x180
 kfree+0x90/0x1b0
 __i40e_del_filter+0xa3/0xf0 [i40e]
 i40e_del_mac_filter+0xf3/0x130 [i40e]
 i40e_addr_unsync+0x85/0xa0 [i40e]
 __hw_addr_sync_dev+0x9d/0x210
 i40e_set_rx_mode+0x6d/0xf0 [i40e]
 __dev_set_rx_mode+0xfb/0x1f0
 __dev_mc_del+0x69/0x80
 igmp6_group_dropped+0x279/0x510
 __ipv6_dev_mc_dec+0x174/0x220
 addrconf_leave_solict.part.8+0xa2/0xd0
 __ipv6_ifa_notify+0x4cd/0x570
 ipv6_ifa_notify+0x58/0x80
 ipv6_del_addr+0x259/0x4a0
 inet6_addr_del+0x188/0x260
 addrconf_del_ifaddr+0xcc/0x130
 inet6_ioctl+0x152/0x190
 sock_do_ioctl+0xd8/0x2b0
 sock_ioctl+0x2e5/0x4c0
 do_vfs_ioctl+0x14e/0xa80
 ksys_ioctl+0x7c/0xa0
 __x64_sys_ioctl+0x42/0x50
 do_syscall_64+0x98/0x2c0
 entry_SYSCALL_64_after_hwframe+0x65/0xca

Fixes: 41c445ff0f48 ("i40e: main driver core")
Signed-off-by: Di Zhu <zhudi2@huawei.com>
Signed-off-by: Rui Zhang <zhangrui182@huawei.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -107,6 +107,24 @@ MODULE_VERSION(DRV_VERSION);
 
 static struct workqueue_struct *i40e_wq;
 
+static void netdev_hw_addr_refcnt(struct i40e_mac_filter *f,
+				  struct net_device *netdev, int delta)
+{
+	struct netdev_hw_addr *ha;
+
+	if (!f || !netdev)
+		return;
+
+	netdev_for_each_mc_addr(ha, netdev) {
+		if (ether_addr_equal(ha->addr, f->macaddr)) {
+			ha->refcount += delta;
+			if (ha->refcount <= 0)
+				ha->refcount = 1;
+			break;
+		}
+	}
+}
+
 /**
  * i40e_allocate_dma_mem_d - OS specific memory alloc for shared code
  * @hw:   pointer to the HW structure
@@ -2022,6 +2040,7 @@ static void i40e_undo_add_filter_entries
 	hlist_for_each_entry_safe(new, h, from, hlist) {
 		/* We can simply free the wrapper structure */
 		hlist_del(&new->hlist);
+		netdev_hw_addr_refcnt(new->f, vsi->netdev, -1);
 		kfree(new);
 	}
 }
@@ -2369,6 +2388,10 @@ int i40e_sync_vsi_filters(struct i40e_vs
 						       &tmp_add_list,
 						       &tmp_del_list,
 						       vlan_filters);
+
+		hlist_for_each_entry(new, &tmp_add_list, hlist)
+			netdev_hw_addr_refcnt(new->f, vsi->netdev, 1);
+
 		if (retval)
 			goto err_no_memory_locked;
 
@@ -2501,6 +2524,7 @@ int i40e_sync_vsi_filters(struct i40e_vs
 			if (new->f->state == I40E_FILTER_NEW)
 				new->f->state = new->state;
 			hlist_del(&new->hlist);
+			netdev_hw_addr_refcnt(new->f, vsi->netdev, -1);
 			kfree(new);
 		}
 		spin_unlock_bh(&vsi->mac_filter_hash_lock);


