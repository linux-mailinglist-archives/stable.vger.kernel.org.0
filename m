Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8C95A48B3
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbiH2LOx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:14:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231192AbiH2LNQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:13:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661F86F243;
        Mon, 29 Aug 2022 04:09:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90FF1611F4;
        Mon, 29 Aug 2022 11:09:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C858C433C1;
        Mon, 29 Aug 2022 11:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771359;
        bh=7P2foW//QNA8St8AIdk4jMc6oIwkRSrDqoPNbrrxInA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ph0Thp3myS2iDzXx0dut2p7pdeeSO++uoxj4Kl7dt9AXVrRpQnXrBhtVt7MI6BHST
         gR360HBflM8TLRHCHFApl+HTN90tSl8SwZwpYd7D8WyYFC3iChov583iuQ7+LSMdzX
         hmGFpBsHPFJhDsC+8NpJXH3mAIPqx2qy7khihgOQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        George Kuruvinakunnel <george.kuruvinakunnel@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 24/86] ice: xsk: prohibit usage of non-balanced queue id
Date:   Mon, 29 Aug 2022 12:58:50 +0200
Message-Id: <20220829105757.521676150@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105756.500128871@linuxfoundation.org>
References: <20220829105756.500128871@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit 5a42f112d367bb4700a8a41f5c12724fde6bfbb9 ]

Fix the following scenario:
1. ethtool -L $IFACE rx 8 tx 96
2. xdpsock -q 10 -t -z

Above refers to a case where user would like to attach XSK socket in
txonly mode at a queue id that does not have a corresponding Rx queue.
At this moment ice's XSK logic is tightly bound to act on a "queue pair",
e.g. both Tx and Rx queues at a given queue id are disabled/enabled and
both of them will get XSK pool assigned, which is broken for the presented
queue configuration. This results in the splat included at the bottom,
which is basically an OOB access to Rx ring array.

To fix this, allow using the ids only in scope of "combined" queues
reported by ethtool. However, logic should be rewritten to allow such
configurations later on, which would end up as a complete rewrite of the
control path, so let us go with this temporary fix.

[420160.558008] BUG: kernel NULL pointer dereference, address: 0000000000000082
[420160.566359] #PF: supervisor read access in kernel mode
[420160.572657] #PF: error_code(0x0000) - not-present page
[420160.579002] PGD 0 P4D 0
[420160.582756] Oops: 0000 [#1] PREEMPT SMP NOPTI
[420160.588396] CPU: 10 PID: 21232 Comm: xdpsock Tainted: G           OE     5.19.0-rc7+ #10
[420160.597893] Hardware name: Intel Corporation S2600WFT/S2600WFT, BIOS SE5C620.86B.02.01.0008.031920191559 03/19/2019
[420160.609894] RIP: 0010:ice_xsk_pool_setup+0x44/0x7d0 [ice]
[420160.616968] Code: f3 48 83 ec 40 48 8b 4f 20 48 8b 3f 65 48 8b 04 25 28 00 00 00 48 89 44 24 38 31 c0 48 8d 04 ed 00 00 00 00 48 01 c1 48 8b 11 <0f> b7 92 82 00 00 00 48 85 d2 0f 84 2d 75 00 00 48 8d 72 ff 48 85
[420160.639421] RSP: 0018:ffffc9002d2afd48 EFLAGS: 00010282
[420160.646650] RAX: 0000000000000050 RBX: ffff88811d8bdd00 RCX: ffff888112c14ff8
[420160.655893] RDX: 0000000000000000 RSI: ffff88811d8bdd00 RDI: ffff888109861000
[420160.665166] RBP: 000000000000000a R08: 000000000000000a R09: 0000000000000000
[420160.674493] R10: 000000000000889f R11: 0000000000000000 R12: 000000000000000a
[420160.683833] R13: 000000000000000a R14: 0000000000000000 R15: ffff888117611828
[420160.693211] FS:  00007fa869fc1f80(0000) GS:ffff8897e0880000(0000) knlGS:0000000000000000
[420160.703645] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[420160.711783] CR2: 0000000000000082 CR3: 00000001d076c001 CR4: 00000000007706e0
[420160.721399] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[420160.731045] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[420160.740707] PKRU: 55555554
[420160.745960] Call Trace:
[420160.750962]  <TASK>
[420160.755597]  ? kmalloc_large_node+0x79/0x90
[420160.762703]  ? __kmalloc_node+0x3f5/0x4b0
[420160.769341]  xp_assign_dev+0xfd/0x210
[420160.775661]  ? shmem_file_read_iter+0x29a/0x420
[420160.782896]  xsk_bind+0x152/0x490
[420160.788943]  __sys_bind+0xd0/0x100
[420160.795097]  ? exit_to_user_mode_prepare+0x20/0x120
[420160.802801]  __x64_sys_bind+0x16/0x20
[420160.809298]  do_syscall_64+0x38/0x90
[420160.815741]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[420160.823731] RIP: 0033:0x7fa86a0dd2fb
[420160.830264] Code: c3 66 0f 1f 44 00 00 48 8b 15 69 8b 0c 00 f7 d8 64 89 02 b8 ff ff ff ff eb bc 0f 1f 44 00 00 f3 0f 1e fa b8 31 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 3d 8b 0c 00 f7 d8 64 89 01 48
[420160.855410] RSP: 002b:00007ffc1146f618 EFLAGS: 00000246 ORIG_RAX: 0000000000000031
[420160.866366] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fa86a0dd2fb
[420160.876957] RDX: 0000000000000010 RSI: 00007ffc1146f680 RDI: 0000000000000003
[420160.887604] RBP: 000055d7113a0520 R08: 00007fa868fb8000 R09: 0000000080000000
[420160.898293] R10: 0000000000008001 R11: 0000000000000246 R12: 000055d7113a04e0
[420160.909038] R13: 000055d7113a0320 R14: 000000000000000a R15: 0000000000000000
[420160.919817]  </TASK>
[420160.925659] Modules linked in: ice(OE) af_packet binfmt_misc nls_iso8859_1 ipmi_ssif intel_rapl_msr intel_rapl_common x86_pkg_temp_thermal intel_powerclamp mei_me coretemp ioatdma mei ipmi_si wmi ipmi_msghandler acpi_pad acpi_power_meter ip_tables x_tables autofs4 ixgbe i40e crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel crypto_simd cryptd ahci mdio dca libahci lpc_ich [last unloaded: ice]
[420160.977576] CR2: 0000000000000082
[420160.985037] ---[ end trace 0000000000000000 ]---
[420161.097724] RIP: 0010:ice_xsk_pool_setup+0x44/0x7d0 [ice]
[420161.107341] Code: f3 48 83 ec 40 48 8b 4f 20 48 8b 3f 65 48 8b 04 25 28 00 00 00 48 89 44 24 38 31 c0 48 8d 04 ed 00 00 00 00 48 01 c1 48 8b 11 <0f> b7 92 82 00 00 00 48 85 d2 0f 84 2d 75 00 00 48 8d 72 ff 48 85
[420161.134741] RSP: 0018:ffffc9002d2afd48 EFLAGS: 00010282
[420161.144274] RAX: 0000000000000050 RBX: ffff88811d8bdd00 RCX: ffff888112c14ff8
[420161.155690] RDX: 0000000000000000 RSI: ffff88811d8bdd00 RDI: ffff888109861000
[420161.168088] RBP: 000000000000000a R08: 000000000000000a R09: 0000000000000000
[420161.179295] R10: 000000000000889f R11: 0000000000000000 R12: 000000000000000a
[420161.190420] R13: 000000000000000a R14: 0000000000000000 R15: ffff888117611828
[420161.201505] FS:  00007fa869fc1f80(0000) GS:ffff8897e0880000(0000) knlGS:0000000000000000
[420161.213628] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[420161.223413] CR2: 0000000000000082 CR3: 00000001d076c001 CR4: 00000000007706e0
[420161.234653] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[420161.245893] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[420161.257052] PKRU: 55555554

Fixes: 2d4238f55697 ("ice: Add support for AF_XDP")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 4bb62950d92de..59963b901be0f 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -371,6 +371,12 @@ int ice_xsk_pool_setup(struct ice_vsi *vsi, struct xsk_buff_pool *pool, u16 qid)
 	bool if_running, pool_present = !!pool;
 	int ret = 0, pool_failure = 0;
 
+	if (qid >= vsi->num_rxq || qid >= vsi->num_txq) {
+		netdev_err(vsi->netdev, "Please use queue id in scope of combined queues count\n");
+		pool_failure = -EINVAL;
+		goto failure;
+	}
+
 	if (!is_power_of_2(vsi->rx_rings[qid]->count) ||
 	    !is_power_of_2(vsi->tx_rings[qid]->count)) {
 		netdev_err(vsi->netdev, "Please align ring sizes to power of 2\n");
-- 
2.35.1



