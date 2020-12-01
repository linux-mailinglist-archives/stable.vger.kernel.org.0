Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB1BC2C9ADF
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388616AbgLAJBy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:01:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:38664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388610AbgLAJBx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:01:53 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E421C221FF;
        Tue,  1 Dec 2020 09:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813272;
        bh=c9cxOImaJr8Kv0UBxQSfz4AFdOoqybz7HSahaAzbbns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dYeg9b3Ckcnnly9PETBfRjDNrvY2MsSqSznqppXl2Unog76NOJKkgVkKu48Iokr8P
         D3UFCSsA/94+Il7zK3Lvr80BkpnxOsYEkfW9qONdxQAMf5hznqjxu6iGO/oM+fnfPo
         t9oZtMbap2YftlWR2/e0IDkL/cxSF2bKjhzIYp9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijun Pan <ljp@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 41/57] ibmvnic: fix NULL pointer dereference in reset_sub_crq_queues
Date:   Tue,  1 Dec 2020 09:53:46 +0100
Message-Id: <20201201084651.116506366@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084647.751612010@linuxfoundation.org>
References: <20201201084647.751612010@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lijun Pan <ljp@linux.ibm.com>

[ Upstream commit a0faaa27c71608799e0dd765c5af38a089091802 ]

adapter->tx_scrq and adapter->rx_scrq could be NULL if the previous reset
did not complete after freeing sub crqs. Check for NULL before
dereferencing them.

Snippet of call trace:
ibmvnic 30000006 env6: Releasing sub-CRQ
ibmvnic 30000006 env6: Releasing CRQ
...
ibmvnic 30000006 env6: Got Control IP offload Response
ibmvnic 30000006 env6: Re-setting tx_scrq[0]
BUG: Kernel NULL pointer dereference on read at 0x00000000
Faulting instruction address: 0xc008000003dea7cc
Oops: Kernel access of bad area, sig: 11 [#1]
LE PAGE_SIZE=64K MMU=Hash SMP NR_CPUS=2048 NUMA pSeries
Modules linked in: rpadlpar_io rpaphp xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_reject_ipv4 nft_compat nft_counter nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables xsk_diag tcp_diag udp_diag raw_diag inet_diag unix_diag af_packet_diag netlink_diag tun bridge stp llc rfkill sunrpc pseries_rng xts vmx_crypto uio_pdrv_genirq uio binfmt_misc ip_tables xfs libcrc32c sd_mod t10_pi sg ibmvscsi ibmvnic ibmveth scsi_transport_srp dm_mirror dm_region_hash dm_log dm_mod
CPU: 80 PID: 1856 Comm: kworker/80:2 Tainted: G        W         5.8.0+ #4
Workqueue: events __ibmvnic_reset [ibmvnic]
NIP:  c008000003dea7cc LR: c008000003dea7bc CTR: 0000000000000000
REGS: c0000007ef7db860 TRAP: 0380   Tainted: G        W          (5.8.0+)
MSR:  800000000280b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 28002422  XER: 0000000d
CFAR: c000000000bd9520 IRQMASK: 0
GPR00: c008000003dea7bc c0000007ef7dbaf0 c008000003df7400 c0000007fa26ec00
GPR04: c0000007fcd0d008 c0000007fcd96350 0000000000000027 c0000007fcd0d010
GPR08: 0000000000000023 0000000000000000 0000000000000000 0000000000000000
GPR12: 0000000000002000 c00000001ec18e00 c0000000001982f8 c0000007bad6e840
GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
GPR20: 0000000000000000 0000000000000000 0000000000000000 fffffffffffffef7
GPR24: 0000000000000402 c0000007fa26f3a8 0000000000000003 c00000016f8ec048
GPR28: 0000000000000000 0000000000000000 0000000000000000 c0000007fa26ec00
NIP [c008000003dea7cc] ibmvnic_reset_init+0x15c/0x258 [ibmvnic]
LR [c008000003dea7bc] ibmvnic_reset_init+0x14c/0x258 [ibmvnic]
Call Trace:
[c0000007ef7dbaf0] [c008000003dea7bc] ibmvnic_reset_init+0x14c/0x258 [ibmvnic] (unreliable)
[c0000007ef7dbb80] [c008000003de8860] __ibmvnic_reset+0x408/0x970 [ibmvnic]
[c0000007ef7dbc50] [c00000000018b7cc] process_one_work+0x2cc/0x800
[c0000007ef7dbd20] [c00000000018bd78] worker_thread+0x78/0x520
[c0000007ef7dbdb0] [c0000000001984c4] kthread+0x1d4/0x1e0
[c0000007ef7dbe20] [c00000000000cea8] ret_from_kernel_thread+0x5c/0x74

Fixes: 57a49436f4e8 ("ibmvnic: Reset sub-crqs during driver reset")
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index d8115a9333e05..2fc8f281c2766 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2560,6 +2560,9 @@ static int reset_sub_crq_queues(struct ibmvnic_adapter *adapter)
 {
 	int i, rc;
 
+	if (!adapter->tx_scrq || !adapter->rx_scrq)
+		return -EINVAL;
+
 	for (i = 0; i < adapter->req_tx_queues; i++) {
 		netdev_dbg(adapter->netdev, "Re-setting tx_scrq[%d]\n", i);
 		rc = reset_one_sub_crq_queue(adapter, adapter->tx_scrq[i]);
-- 
2.27.0



