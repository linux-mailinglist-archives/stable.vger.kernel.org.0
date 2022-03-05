Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84E574CE481
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 12:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbiCELVu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 06:21:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiCELVt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 06:21:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7823E4C431
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 03:20:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 145C0611CF
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 11:20:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D35FC004E1;
        Sat,  5 Mar 2022 11:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646479258;
        bh=8YhTE4CUMiafwu/CLtdXftG6F2yhsJqNs25Aa5F6U7U=;
        h=Subject:To:Cc:From:Date:From;
        b=re4U9tM0nyvXbE9aUL+uC5PtdsaS5HiTkodP+F/oMutcxmG3DiRBS0VgDwwZSVB96
         k5hpZnGnILC1s9Kb7zf5CUphgu8jljCG9HgASiPlS/ZIeBmmn9s7um+C8VlaYf68/3
         z5qXg3q+8SVmLK/FtniGkVvUQr2sldITeukfp5DI=
Subject: FAILED: patch "[PATCH] xen/netfront: destroy queues before real_num_tx_queues is" failed to apply to 4.19-stable tree
To:     marmarek@invisiblethingslab.com, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 05 Mar 2022 12:20:47 +0100
Message-ID: <1646479247151142@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From dcf4ff7a48e7598e6b10126cc02177abb8ae4f3f Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?=
 <marmarek@invisiblethingslab.com>
Date: Wed, 23 Feb 2022 22:19:54 +0100
Subject: [PATCH] xen/netfront: destroy queues before real_num_tx_queues is
 zeroed
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

xennet_destroy_queues() relies on info->netdev->real_num_tx_queues to
delete queues. Since d7dac083414eb5bb99a6d2ed53dc2c1b405224e5
("net-sysfs: update the queue counts in the unregistration path"),
unregister_netdev() indirectly sets real_num_tx_queues to 0. Those two
facts together means, that xennet_destroy_queues() called from
xennet_remove() cannot do its job, because it's called after
unregister_netdev(). This results in kfree-ing queues that are still
linked in napi, which ultimately crashes:

    BUG: kernel NULL pointer dereference, address: 0000000000000000
    #PF: supervisor read access in kernel mode
    #PF: error_code(0x0000) - not-present page
    PGD 0 P4D 0
    Oops: 0000 [#1] PREEMPT SMP PTI
    CPU: 1 PID: 52 Comm: xenwatch Tainted: G        W         5.16.10-1.32.fc32.qubes.x86_64+ #226
    RIP: 0010:free_netdev+0xa3/0x1a0
    Code: ff 48 89 df e8 2e e9 00 00 48 8b 43 50 48 8b 08 48 8d b8 a0 fe ff ff 48 8d a9 a0 fe ff ff 49 39 c4 75 26 eb 47 e8 ed c1 66 ff <48> 8b 85 60 01 00 00 48 8d 95 60 01 00 00 48 89 ef 48 2d 60 01 00
    RSP: 0000:ffffc90000bcfd00 EFLAGS: 00010286
    RAX: 0000000000000000 RBX: ffff88800edad000 RCX: 0000000000000000
    RDX: 0000000000000001 RSI: ffffc90000bcfc30 RDI: 00000000ffffffff
    RBP: fffffffffffffea0 R08: 0000000000000000 R09: 0000000000000000
    R10: 0000000000000000 R11: 0000000000000001 R12: ffff88800edad050
    R13: ffff8880065f8f88 R14: 0000000000000000 R15: ffff8880066c6680
    FS:  0000000000000000(0000) GS:ffff8880f3300000(0000) knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: 0000000000000000 CR3: 00000000e998c006 CR4: 00000000003706e0
    Call Trace:
     <TASK>
     xennet_remove+0x13d/0x300 [xen_netfront]
     xenbus_dev_remove+0x6d/0xf0
     __device_release_driver+0x17a/0x240
     device_release_driver+0x24/0x30
     bus_remove_device+0xd8/0x140
     device_del+0x18b/0x410
     ? _raw_spin_unlock+0x16/0x30
     ? klist_iter_exit+0x14/0x20
     ? xenbus_dev_request_and_reply+0x80/0x80
     device_unregister+0x13/0x60
     xenbus_dev_changed+0x18e/0x1f0
     xenwatch_thread+0xc0/0x1a0
     ? do_wait_intr_irq+0xa0/0xa0
     kthread+0x16b/0x190
     ? set_kthread_struct+0x40/0x40
     ret_from_fork+0x22/0x30
     </TASK>

Fix this by calling xennet_destroy_queues() from xennet_uninit(),
when real_num_tx_queues is still available. This ensures that queues are
destroyed when real_num_tx_queues is set to 0, regardless of how
unregister_netdev() was called.

Originally reported at
https://github.com/QubesOS/qubes-issues/issues/7257

Fixes: d7dac083414eb5bb9 ("net-sysfs: update the queue counts in the unregistration path")
Cc: stable@vger.kernel.org
Signed-off-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 8b18246ad999..7748f07e2cf1 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -842,6 +842,28 @@ static int xennet_close(struct net_device *dev)
 	return 0;
 }
 
+static void xennet_destroy_queues(struct netfront_info *info)
+{
+	unsigned int i;
+
+	for (i = 0; i < info->netdev->real_num_tx_queues; i++) {
+		struct netfront_queue *queue = &info->queues[i];
+
+		if (netif_running(info->netdev))
+			napi_disable(&queue->napi);
+		netif_napi_del(&queue->napi);
+	}
+
+	kfree(info->queues);
+	info->queues = NULL;
+}
+
+static void xennet_uninit(struct net_device *dev)
+{
+	struct netfront_info *np = netdev_priv(dev);
+	xennet_destroy_queues(np);
+}
+
 static void xennet_set_rx_rsp_cons(struct netfront_queue *queue, RING_IDX val)
 {
 	unsigned long flags;
@@ -1611,6 +1633,7 @@ static int xennet_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 }
 
 static const struct net_device_ops xennet_netdev_ops = {
+	.ndo_uninit          = xennet_uninit,
 	.ndo_open            = xennet_open,
 	.ndo_stop            = xennet_close,
 	.ndo_start_xmit      = xennet_start_xmit,
@@ -2103,22 +2126,6 @@ static int write_queue_xenstore_keys(struct netfront_queue *queue,
 	return err;
 }
 
-static void xennet_destroy_queues(struct netfront_info *info)
-{
-	unsigned int i;
-
-	for (i = 0; i < info->netdev->real_num_tx_queues; i++) {
-		struct netfront_queue *queue = &info->queues[i];
-
-		if (netif_running(info->netdev))
-			napi_disable(&queue->napi);
-		netif_napi_del(&queue->napi);
-	}
-
-	kfree(info->queues);
-	info->queues = NULL;
-}
-
 
 
 static int xennet_create_page_pool(struct netfront_queue *queue)

