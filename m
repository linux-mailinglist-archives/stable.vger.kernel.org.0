Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 598D74B4BF3
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348347AbiBNKfT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:35:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348323AbiBNKes (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:34:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 869E310F5;
        Mon, 14 Feb 2022 02:01:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31BF1B80DD5;
        Mon, 14 Feb 2022 10:01:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463BCC340EF;
        Mon, 14 Feb 2022 10:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832896;
        bh=899ymr/v+41hyibqIyWULRGLI9lxt7B1PXrOqe4nSM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XatSoukcFIpingZZKkQ+VmWtXU9ztcABwmmADdcW1D4WfigM6v2v3u4fTCzb93waX
         l8njBvuDCG2TB6xEtdIb0VlNzM2LgJjaVrycrMLFBJgoUU3eOv49kRsko4qjl64Tbm
         U03BRKSjUmD4fsmRpNBZef7GfJ0iiG9XRwZ3Uj/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abdul Haleem <abdhalee@linux.vnet.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Dany Madden <drt@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 142/203] ibmvnic: dont release napi in __ibmvnic_open()
Date:   Mon, 14 Feb 2022 10:26:26 +0100
Message-Id: <20220214092515.064979187@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

[ Upstream commit 61772b0908c640d0309c40f7d41d062ca4e979fa ]

If __ibmvnic_open() encounters an error such as when setting link state,
it calls release_resources() which frees the napi structures needlessly.
Instead, have __ibmvnic_open() only clean up the work it did so far (i.e.
disable napi and irqs) and leave the rest to the callers.

If caller of __ibmvnic_open() is ibmvnic_open(), it should release the
resources immediately. If the caller is do_reset() or do_hard_reset(),
they will release the resources on the next reset.

This fixes following crash that occurred when running the drmgr command
several times to add/remove a vnic interface:

	[102056] ibmvnic 30000003 env3: Disabling rx_scrq[6] irq
	[102056] ibmvnic 30000003 env3: Disabling rx_scrq[7] irq
	[102056] ibmvnic 30000003 env3: Replenished 8 pools
	Kernel attempted to read user page (10) - exploit attempt? (uid: 0)
	BUG: Kernel NULL pointer dereference on read at 0x00000010
	Faulting instruction address: 0xc000000000a3c840
	Oops: Kernel access of bad area, sig: 11 [#1]
	LE PAGE_SIZE=64K MMU=Radix SMP NR_CPUS=2048 NUMA pSeries
	...
	CPU: 9 PID: 102056 Comm: kworker/9:2 Kdump: loaded Not tainted 5.16.0-rc5-autotest-g6441998e2e37 #1
	Workqueue: events_long __ibmvnic_reset [ibmvnic]
	NIP:  c000000000a3c840 LR: c0080000029b5378 CTR: c000000000a3c820
	REGS: c0000000548e37e0 TRAP: 0300   Not tainted  (5.16.0-rc5-autotest-g6441998e2e37)
	MSR:  8000000000009033 <SF,EE,ME,IR,DR,RI,LE>  CR: 28248484  XER: 00000004
	CFAR: c0080000029bdd24 DAR: 0000000000000010 DSISR: 40000000 IRQMASK: 0
	GPR00: c0080000029b55d0 c0000000548e3a80 c0000000028f0200 0000000000000000
	...
	NIP [c000000000a3c840] napi_enable+0x20/0xc0
	LR [c0080000029b5378] __ibmvnic_open+0xf0/0x430 [ibmvnic]
	Call Trace:
	[c0000000548e3a80] [0000000000000006] 0x6 (unreliable)
	[c0000000548e3ab0] [c0080000029b55d0] __ibmvnic_open+0x348/0x430 [ibmvnic]
	[c0000000548e3b40] [c0080000029bcc28] __ibmvnic_reset+0x500/0xdf0 [ibmvnic]
	[c0000000548e3c60] [c000000000176228] process_one_work+0x288/0x570
	[c0000000548e3d00] [c000000000176588] worker_thread+0x78/0x660
	[c0000000548e3da0] [c0000000001822f0] kthread+0x1c0/0x1d0
	[c0000000548e3e10] [c00000000000cf64] ret_from_kernel_thread+0x5c/0x64
	Instruction dump:
	7d2948f8 792307e0 4e800020 60000000 3c4c01eb 384239e0 f821ffd1 39430010
	38a0fff6 e92d1100 f9210028 39200000 <e9030010> f9010020 60420000 e9210020
	---[ end trace 5f8033b08fd27706 ]---

Fixes: ed651a10875f ("ibmvnic: Updated reset handling")
Reported-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Reviewed-by: Dany Madden <drt@linux.ibm.com>
Link: https://lore.kernel.org/r/20220208001918.900602-1-sukadev@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 682a440151a87..d5d33325a413e 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -110,6 +110,7 @@ static void ibmvnic_tx_scrq_clean_buffer(struct ibmvnic_adapter *adapter,
 					 struct ibmvnic_sub_crq_queue *tx_scrq);
 static void free_long_term_buff(struct ibmvnic_adapter *adapter,
 				struct ibmvnic_long_term_buff *ltb);
+static void ibmvnic_disable_irqs(struct ibmvnic_adapter *adapter);
 
 struct ibmvnic_stat {
 	char name[ETH_GSTRING_LEN];
@@ -1418,7 +1419,7 @@ static int __ibmvnic_open(struct net_device *netdev)
 	rc = set_link_state(adapter, IBMVNIC_LOGICAL_LNK_UP);
 	if (rc) {
 		ibmvnic_napi_disable(adapter);
-		release_resources(adapter);
+		ibmvnic_disable_irqs(adapter);
 		return rc;
 	}
 
@@ -1468,9 +1469,6 @@ static int ibmvnic_open(struct net_device *netdev)
 		rc = init_resources(adapter);
 		if (rc) {
 			netdev_err(netdev, "failed to initialize resources\n");
-			release_resources(adapter);
-			release_rx_pools(adapter);
-			release_tx_pools(adapter);
 			goto out;
 		}
 	}
@@ -1487,6 +1485,13 @@ static int ibmvnic_open(struct net_device *netdev)
 		adapter->state = VNIC_OPEN;
 		rc = 0;
 	}
+
+	if (rc) {
+		release_resources(adapter);
+		release_rx_pools(adapter);
+		release_tx_pools(adapter);
+	}
+
 	return rc;
 }
 
-- 
2.34.1



