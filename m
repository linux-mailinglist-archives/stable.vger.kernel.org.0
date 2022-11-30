Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1581563DE64
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbiK3Sgm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:36:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbiK3SgX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:36:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 061B894938
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:36:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4EDAB81B37
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:36:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13153C433C1;
        Wed, 30 Nov 2022 18:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833379;
        bh=x8dpzO+xTo4ysryYz+8zc4M2zmPxVyeiAi25B2pmvtk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MziM4yayx+fZUulBuBnChooc0giHMWsUOBOQBEDQMY9Rvq9Vb0pFSI3E3DnzJoNjT
         j41e2B6A054P2P4Jr3ADbRO1FeHMmZ2hY5dLJrhmECrJSG2G6va74/MCYwyopBH+wT
         i/mbGNqGDvMPTc9BHMp3mCJyLe6tFKUP4bxGSeHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jacob Keller <jacob.e.keller@intel.com>,
        Patryk Piotrowski <patryk.piotrowski@intel.com>,
        SlawomirX Laba <slawomirx.laba@intel.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 085/206] iavf: Do not restart Tx queues after reset task failure
Date:   Wed, 30 Nov 2022 19:22:17 +0100
Message-Id: <20221130180535.169232141@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit 08f1c147b7265245d67321585c68a27e990e0c4b ]

After commit aa626da947e9 ("iavf: Detach device during reset task")
the device is detached during reset task and re-attached at its end.
The problem occurs when reset task fails because Tx queues are
restarted during device re-attach and this leads later to a crash.

To resolve this issue properly close the net device in cause of
failure in reset task to avoid restarting of tx queues at the end.
Also replace the hacky manipulation with IFF_UP flag by device close
that clears properly both IFF_UP and __LINK_STATE_START flags.
In these case iavf_close() does not do anything because the adapter
state is already __IAVF_DOWN.

Reproducer:
1) Run some Tx traffic (e.g. iperf3) over iavf interface
2) Set VF trusted / untrusted in loop

[root@host ~]# cat repro.sh

PF=enp65s0f0
IF=${PF}v0

ip link set up $IF
ip addr add 192.168.0.2/24 dev $IF
sleep 1

iperf3 -c 192.168.0.1 -t 600 --logfile /dev/null &
sleep 2

while :; do
        ip link set $PF vf 0 trust on
        ip link set $PF vf 0 trust off
done
[root@host ~]# ./repro.sh

Result:
[ 2006.650969] iavf 0000:41:01.0: Failed to init adminq: -53
[ 2006.675662] ice 0000:41:00.0: VF 0 is now trusted
[ 2006.689997] iavf 0000:41:01.0: Reset task did not complete, VF disabled
[ 2006.696611] iavf 0000:41:01.0: failed to allocate resources during reinit
[ 2006.703209] ice 0000:41:00.0: VF 0 is now untrusted
[ 2006.737011] ice 0000:41:00.0: VF 0 is now trusted
[ 2006.764536] ice 0000:41:00.0: VF 0 is now untrusted
[ 2006.768919] BUG: kernel NULL pointer dereference, address: 0000000000000b4a
[ 2006.776358] #PF: supervisor read access in kernel mode
[ 2006.781488] #PF: error_code(0x0000) - not-present page
[ 2006.786620] PGD 0 P4D 0
[ 2006.789152] Oops: 0000 [#1] PREEMPT SMP NOPTI
[ 2006.792903] ice 0000:41:00.0: VF 0 is now trusted
[ 2006.793501] CPU: 4 PID: 0 Comm: swapper/4 Kdump: loaded Not tainted 6.1.0-rc3+ #2
[ 2006.805668] Hardware name: Abacus electric, s.r.o. - servis@abacus.cz Super Server/H12SSW-iN, BIOS 2.4 04/13/2022
[ 2006.815915] RIP: 0010:iavf_xmit_frame_ring+0x96/0xf70 [iavf]
[ 2006.821028] ice 0000:41:00.0: VF 0 is now untrusted
[ 2006.821572] Code: 48 83 c1 04 48 c1 e1 04 48 01 f9 48 83 c0 10 6b 50 f8 55 c1 ea 14 45 8d 64 14 01 48 39 c8 75 eb 41 83 fc 07 0f 8f e9 08 00 00 <0f> b7 45 4a 0f b7 55 48 41 8d 74 24 05 31 c9 66 39 d0 0f 86 da 00
[ 2006.845181] RSP: 0018:ffffb253004bc9e8 EFLAGS: 00010293
[ 2006.850397] RAX: ffff9d154de45b00 RBX: ffff9d15497d52e8 RCX: ffff9d154de45b00
[ 2006.856327] ice 0000:41:00.0: VF 0 is now trusted
[ 2006.857523] RDX: 0000000000000000 RSI: 00000000000005a8 RDI: ffff9d154de45ac0
[ 2006.857525] RBP: 0000000000000b00 R08: ffff9d159cb010ac R09: 0000000000000001
[ 2006.857526] R10: ffff9d154de45940 R11: 0000000000000000 R12: 0000000000000002
[ 2006.883600] R13: ffff9d1770838dc0 R14: 0000000000000000 R15: ffffffffc07b8380
[ 2006.885840] ice 0000:41:00.0: VF 0 is now untrusted
[ 2006.890725] FS:  0000000000000000(0000) GS:ffff9d248e900000(0000) knlGS:0000000000000000
[ 2006.890727] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2006.909419] CR2: 0000000000000b4a CR3: 0000000c39c10002 CR4: 0000000000770ee0
[ 2006.916543] PKRU: 55555554
[ 2006.918254] ice 0000:41:00.0: VF 0 is now trusted
[ 2006.919248] Call Trace:
[ 2006.919250]  <IRQ>
[ 2006.919252]  dev_hard_start_xmit+0x9e/0x1f0
[ 2006.932587]  sch_direct_xmit+0xa0/0x370
[ 2006.936424]  __dev_queue_xmit+0x7af/0xd00
[ 2006.940429]  ip_finish_output2+0x26c/0x540
[ 2006.944519]  ip_output+0x71/0x110
[ 2006.947831]  ? __ip_finish_output+0x2b0/0x2b0
[ 2006.952180]  __ip_queue_xmit+0x16d/0x400
[ 2006.952721] ice 0000:41:00.0: VF 0 is now untrusted
[ 2006.956098]  __tcp_transmit_skb+0xa96/0xbf0
[ 2006.965148]  __tcp_retransmit_skb+0x174/0x860
[ 2006.969499]  ? cubictcp_cwnd_event+0x40/0x40
[ 2006.973769]  tcp_retransmit_skb+0x14/0xb0
...

Fixes: aa626da947e9 ("iavf: Detach device during reset task")
Cc: Jacob Keller <jacob.e.keller@intel.com>
Cc: Patryk Piotrowski <patryk.piotrowski@intel.com>
Cc: SlawomirX Laba <slawomirx.laba@intel.com>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 493d3c407d4f..d6aa1805c55b 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2270,7 +2270,6 @@ static void iavf_disable_vf(struct iavf_adapter *adapter)
 	iavf_free_queues(adapter);
 	memset(adapter->vf_res, 0, IAVF_VIRTCHNL_VF_RESOURCE_SIZE);
 	iavf_shutdown_adminq(&adapter->hw);
-	adapter->netdev->flags &= ~IFF_UP;
 	adapter->flags &= ~IAVF_FLAG_RESET_PENDING;
 	iavf_change_state(adapter, __IAVF_DOWN);
 	wake_up(&adapter->down_waitqueue);
@@ -2369,6 +2368,11 @@ static void iavf_reset_task(struct work_struct *work)
 		iavf_disable_vf(adapter);
 		mutex_unlock(&adapter->client_lock);
 		mutex_unlock(&adapter->crit_lock);
+		if (netif_running(netdev)) {
+			rtnl_lock();
+			dev_close(netdev);
+			rtnl_unlock();
+		}
 		return; /* Do not attempt to reinit. It's dead, Jim. */
 	}
 
@@ -2504,6 +2508,16 @@ static void iavf_reset_task(struct work_struct *work)
 
 	mutex_unlock(&adapter->client_lock);
 	mutex_unlock(&adapter->crit_lock);
+
+	if (netif_running(netdev)) {
+		/* Close device to ensure that Tx queues will not be started
+		 * during netif_device_attach() at the end of the reset task.
+		 */
+		rtnl_lock();
+		dev_close(netdev);
+		rtnl_unlock();
+	}
+
 	dev_err(&adapter->pdev->dev, "failed to allocate resources during reinit\n");
 reset_finish:
 	rtnl_lock();
-- 
2.35.1



