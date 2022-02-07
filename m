Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6148E4ABCC2
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387099AbiBGLjM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:39:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384232AbiBGL0a (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:26:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 847EDC03E938;
        Mon,  7 Feb 2022 03:25:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1873661388;
        Mon,  7 Feb 2022 11:25:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCDBEC004E1;
        Mon,  7 Feb 2022 11:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233148;
        bh=mEtObQG33qfn2d7Uum/gcizK3oGUXgWfZ3PZj7UOunU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iD/a638ulLYLlgdIFiVzaAU7jvAiZVye0R6DRIeMVdxxvEXmnORMiJFFsVI7OxMDk
         yDcQkW9hc2CV6dV5GIoRLf2daHIj7Yu7HO1KRojp0bTk+/bbn6LiY9RJsvq5uaYfdS
         8Hm7rjabn3PhomoXp7j7+VCfNV1ygymdj8yc7/7M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.15 032/110] IB/hfi1: Fix AIP early init panic
Date:   Mon,  7 Feb 2022 12:06:05 +0100
Message-Id: <20220207103803.337478670@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103802.280120990@linuxfoundation.org>
References: <20220207103802.280120990@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>

commit 5f8f55b92edd621f056bdf09e572092849fabd83 upstream.

An early failure in hfi1_ipoib_setup_rn() can lead to the following panic:

  BUG: unable to handle kernel NULL pointer dereference at 00000000000001b0
  PGD 0 P4D 0
  Oops: 0002 [#1] SMP NOPTI
  Workqueue: events work_for_cpu_fn
  RIP: 0010:try_to_grab_pending+0x2b/0x140
  Code: 1f 44 00 00 41 55 41 54 55 48 89 d5 53 48 89 fb 9c 58 0f 1f 44 00 00 48 89 c2 fa 66 0f 1f 44 00 00 48 89 55 00 40 84 f6 75 77 <f0> 48 0f ba 2b 00 72 09 31 c0 5b 5d 41 5c 41 5d c3 48 89 df e8 6c
  RSP: 0018:ffffb6b3cf7cfa48 EFLAGS: 00010046
  RAX: 0000000000000246 RBX: 00000000000001b0 RCX: 0000000000000000
  RDX: 0000000000000246 RSI: 0000000000000000 RDI: 00000000000001b0
  RBP: ffffb6b3cf7cfa70 R08: 0000000000000f09 R09: 0000000000000001
  R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
  R13: ffffb6b3cf7cfa90 R14: ffffffff9b2fbfc0 R15: ffff8a4fdf244690
  FS:  0000000000000000(0000) GS:ffff8a527f400000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00000000000001b0 CR3: 00000017e2410003 CR4: 00000000007706f0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  PKRU: 55555554
  Call Trace:
   __cancel_work_timer+0x42/0x190
   ? dev_printk_emit+0x4e/0x70
   iowait_cancel_work+0x15/0x30 [hfi1]
   hfi1_ipoib_txreq_deinit+0x5a/0x220 [hfi1]
   ? dev_err+0x6c/0x90
   hfi1_ipoib_netdev_dtor+0x15/0x30 [hfi1]
   hfi1_ipoib_setup_rn+0x10e/0x150 [hfi1]
   rdma_init_netdev+0x5a/0x80 [ib_core]
   ? hfi1_ipoib_free_rdma_netdev+0x20/0x20 [hfi1]
   ipoib_intf_init+0x6c/0x350 [ib_ipoib]
   ipoib_intf_alloc+0x5c/0xc0 [ib_ipoib]
   ipoib_add_one+0xbe/0x300 [ib_ipoib]
   add_client_context+0x12c/0x1a0 [ib_core]
   enable_device_and_get+0xdc/0x1d0 [ib_core]
   ib_register_device+0x572/0x6b0 [ib_core]
   rvt_register_device+0x11b/0x220 [rdmavt]
   hfi1_register_ib_device+0x6b4/0x770 [hfi1]
   do_init_one.isra.20+0x3e3/0x680 [hfi1]
   local_pci_probe+0x41/0x90
   work_for_cpu_fn+0x16/0x20
   process_one_work+0x1a7/0x360
   ? create_worker+0x1a0/0x1a0
   worker_thread+0x1cf/0x390
   ? create_worker+0x1a0/0x1a0
   kthread+0x116/0x130
   ? kthread_flush_work_fn+0x10/0x10
   ret_from_fork+0x1f/0x40

The panic happens in hfi1_ipoib_txreq_deinit() because there is a NULL
deref when hfi1_ipoib_netdev_dtor() is called in this error case.

hfi1_ipoib_txreq_init() and hfi1_ipoib_rxq_init() are self unwinding so
fix by adjusting the error paths accordingly.

Other changes:
- hfi1_ipoib_free_rdma_netdev() is deleted including the free_netdev()
  since the netdev core code deletes calls free_netdev()
- The switch to the accelerated entrances is moved to the success path.

Cc: stable@vger.kernel.org
Fixes: d99dc602e2a5 ("IB/hfi1: Add functions to transmit datagram ipoib packets")
Link: https://lore.kernel.org/r/1642287756-182313-4-git-send-email-mike.marciniszyn@cornelisnetworks.com
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/hfi1/ipoib_main.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

--- a/drivers/infiniband/hw/hfi1/ipoib_main.c
+++ b/drivers/infiniband/hw/hfi1/ipoib_main.c
@@ -168,12 +168,6 @@ static void hfi1_ipoib_netdev_dtor(struc
 	free_percpu(dev->tstats);
 }
 
-static void hfi1_ipoib_free_rdma_netdev(struct net_device *dev)
-{
-	hfi1_ipoib_netdev_dtor(dev);
-	free_netdev(dev);
-}
-
 static void hfi1_ipoib_set_id(struct net_device *dev, int id)
 {
 	struct hfi1_ipoib_dev_priv *priv = hfi1_ipoib_priv(dev);
@@ -211,24 +205,23 @@ static int hfi1_ipoib_setup_rn(struct ib
 	priv->port_num = port_num;
 	priv->netdev_ops = netdev->netdev_ops;
 
-	netdev->netdev_ops = &hfi1_ipoib_netdev_ops;
-
 	ib_query_pkey(device, port_num, priv->pkey_index, &priv->pkey);
 
 	rc = hfi1_ipoib_txreq_init(priv);
 	if (rc) {
 		dd_dev_err(dd, "IPoIB netdev TX init - failed(%d)\n", rc);
-		hfi1_ipoib_free_rdma_netdev(netdev);
 		return rc;
 	}
 
 	rc = hfi1_ipoib_rxq_init(netdev);
 	if (rc) {
 		dd_dev_err(dd, "IPoIB netdev RX init - failed(%d)\n", rc);
-		hfi1_ipoib_free_rdma_netdev(netdev);
+		hfi1_ipoib_txreq_deinit(priv);
 		return rc;
 	}
 
+	netdev->netdev_ops = &hfi1_ipoib_netdev_ops;
+
 	netdev->priv_destructor = hfi1_ipoib_netdev_dtor;
 	netdev->needs_free_netdev = true;
 


