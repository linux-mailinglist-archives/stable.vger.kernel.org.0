Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96D7C4CF792
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237702AbiCGJqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:46:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235301AbiCGJm2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:42:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF93F10FE5;
        Mon,  7 Mar 2022 01:41:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 591876128E;
        Mon,  7 Mar 2022 09:41:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6595FC340E9;
        Mon,  7 Mar 2022 09:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646077;
        bh=FDzh0ZHeyKx2upDiIZLBZOLXmyWGOvmDhGV6edFVnBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g2nGW+8wjxXbpLcY0JG1mmnPWd7FmhdxrVQKS9FagbDiSyETVg0okxKZF0eyyRLzK
         Z129sCZsnnpRQo+NJ8oN1JvzB0lVZ6Z5qIV4K9bBsXbcUi7FusgLh9Qzf1pr+RHoob
         A1ImySt8iejKJmTkZ0jo4UgJ3iEiTIkQKPNPybW8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abdul Haleem <abdhalee@linux.vnet.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Dany Madden <drt@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 124/262] ibmvnic: dont release napi in __ibmvnic_open()
Date:   Mon,  7 Mar 2022 10:17:48 +0100
Message-Id: <20220307091705.959547578@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 drivers/net/ethernet/ibm/ibmvnic.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 14a729ba737a8..cc5ab66a81850 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -108,6 +108,7 @@ static int init_crq_queue(struct ibmvnic_adapter *adapter);
 static int send_query_phys_parms(struct ibmvnic_adapter *adapter);
 static void ibmvnic_tx_scrq_clean_buffer(struct ibmvnic_adapter *adapter,
 					 struct ibmvnic_sub_crq_queue *tx_scrq);
+static void ibmvnic_disable_irqs(struct ibmvnic_adapter *adapter);
 
 struct ibmvnic_stat {
 	char name[ETH_GSTRING_LEN];
@@ -1245,7 +1246,7 @@ static int __ibmvnic_open(struct net_device *netdev)
 	rc = set_link_state(adapter, IBMVNIC_LOGICAL_LNK_UP);
 	if (rc) {
 		ibmvnic_napi_disable(adapter);
-		release_resources(adapter);
+		ibmvnic_disable_irqs(adapter);
 		return rc;
 	}
 
@@ -1295,7 +1296,6 @@ static int ibmvnic_open(struct net_device *netdev)
 		rc = init_resources(adapter);
 		if (rc) {
 			netdev_err(netdev, "failed to initialize resources\n");
-			release_resources(adapter);
 			goto out;
 		}
 	}
@@ -1312,6 +1312,11 @@ static int ibmvnic_open(struct net_device *netdev)
 		adapter->state = VNIC_OPEN;
 		rc = 0;
 	}
+
+	if (rc) {
+		release_resources(adapter);
+	}
+
 	return rc;
 }
 
-- 
2.34.1



