Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15B0E63DF7C
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbiK3Srl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:47:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbiK3Srj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:47:39 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF197263E
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:47:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 29649CE1AD1
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:47:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C8DC433D6;
        Wed, 30 Nov 2022 18:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834053;
        bh=Fv8nXdI2n5EjYdqad/ATbirVjg0EAUyWREtemZaiNaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=twnAcdN6kUkMzX/AB3nqGwRxR3a/LroX3xz6vT0wrSSzaz6v1p4KnSZaDXV08rDul
         noLcOhhBb9AadbHkplB4xhvBn6N4uQpabP9f+6bfY1rsopzhgiwvsMQox5QQ8tALm+
         59F5uQBaSqOgiSYcHphjRrYjuLh9LpFj0+PIac5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jacob Keller <jacob.e.keller@intel.com>,
        Patryk Piotrowski <patryk.piotrowski@intel.com>,
        SlawomirX Laba <slawomirx.laba@intel.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 084/289] iavf: Fix a crash during reset task
Date:   Wed, 30 Nov 2022 19:21:09 +0100
Message-Id: <20221130180546.049732150@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

[ Upstream commit c678669d6b13b77de3b99b97526aaf23c3088d0a ]

Recent commit aa626da947e9 ("iavf: Detach device during reset task")
removed netif_tx_stop_all_queues() with an assumption that Tx queues
are already stopped by netif_device_detach() in the beginning of
reset task. This assumption is incorrect because during reset
task a potential link event can start Tx queues again.
Revert this change to fix this issue.

Reproducer:
1. Run some Tx traffic (e.g. iperf3) over iavf interface
2. Switch MTU of this interface in a loop

[root@host ~]# cat repro.sh

IF=enp2s0f0v0

iperf3 -c 192.168.0.1 -t 600 --logfile /dev/null &
sleep 2

while :; do
        for i in 1280 1500 2000 900 ; do
                ip link set $IF mtu $i
                sleep 2
        done
done
[root@host ~]# ./repro.sh

Result:
[  306.199917] iavf 0000:02:02.0 enp2s0f0v0: NIC Link is Up Speed is 40 Gbps Full Duplex
[  308.205944] iavf 0000:02:02.0 enp2s0f0v0: NIC Link is Up Speed is 40 Gbps Full Duplex
[  310.103223] BUG: kernel NULL pointer dereference, address: 0000000000000008
[  310.110179] #PF: supervisor write access in kernel mode
[  310.115396] #PF: error_code(0x0002) - not-present page
[  310.120526] PGD 0 P4D 0
[  310.123057] Oops: 0002 [#1] PREEMPT SMP NOPTI
[  310.127408] CPU: 24 PID: 183 Comm: kworker/u64:9 Kdump: loaded Not tainted 6.1.0-rc3+ #2
[  310.135485] Hardware name: Abacus electric, s.r.o. - servis@abacus.cz Super Server/H12SSW-iN, BIOS 2.4 04/13/2022
[  310.145728] Workqueue: iavf iavf_reset_task [iavf]
[  310.150520] RIP: 0010:iavf_xmit_frame_ring+0xd1/0xf70 [iavf]
[  310.156180] Code: d0 0f 86 da 00 00 00 83 e8 01 0f b7 fa 29 f8 01 c8 39 c6 0f 8f a0 08 00 00 48 8b 45 20 48 8d 14 92 bf 01 00 00 00 4c 8d 3c d0 <49> 89 5f 08 8b 43 70 66 41 89 7f 14 41 89 47 10 f6 83 82 00 00 00
[  310.174918] RSP: 0018:ffffbb5f0082caa0 EFLAGS: 00010293
[  310.180137] RAX: 0000000000000000 RBX: ffff92345471a6e8 RCX: 0000000000000200
[  310.187259] RDX: 0000000000000000 RSI: 000000000000000d RDI: 0000000000000001
[  310.194385] RBP: ffff92341d249000 R08: ffff92434987fcac R09: 0000000000000001
[  310.201509] R10: 0000000011f683b9 R11: 0000000011f50641 R12: 0000000000000008
[  310.208631] R13: ffff923447500000 R14: 0000000000000000 R15: 0000000000000000
[  310.215756] FS:  0000000000000000(0000) GS:ffff92434ee00000(0000) knlGS:0000000000000000
[  310.223835] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  310.229572] CR2: 0000000000000008 CR3: 0000000fbc210004 CR4: 0000000000770ee0
[  310.236696] PKRU: 55555554
[  310.239399] Call Trace:
[  310.241844]  <IRQ>
[  310.243855]  ? dst_alloc+0x5b/0xb0
[  310.247260]  dev_hard_start_xmit+0x9e/0x1f0
[  310.251439]  sch_direct_xmit+0xa0/0x370
[  310.255276]  __qdisc_run+0x13e/0x580
[  310.258848]  __dev_queue_xmit+0x431/0xd00
[  310.262851]  ? selinux_ip_postroute+0x147/0x3f0
[  310.267377]  ip_finish_output2+0x26c/0x540

Fixes: aa626da947e9 ("iavf: Detach device during reset task")
Cc: Jacob Keller <jacob.e.keller@intel.com>
Cc: Patryk Piotrowski <patryk.piotrowski@intel.com>
Cc: SlawomirX Laba <slawomirx.laba@intel.com>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 79fef8c59d65..7d349ca708c7 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3033,6 +3033,7 @@ static void iavf_reset_task(struct work_struct *work)
 
 	if (running) {
 		netif_carrier_off(netdev);
+		netif_tx_stop_all_queues(netdev);
 		adapter->link_up = false;
 		iavf_napi_disable_all(adapter);
 	}
-- 
2.35.1



