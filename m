Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 795DD4A40B8
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 11:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348441AbiAaK7u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 05:59:50 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47310 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348365AbiAaK7M (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 05:59:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50469B82A5D;
        Mon, 31 Jan 2022 10:59:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94EC6C340E8;
        Mon, 31 Jan 2022 10:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643626750;
        bh=imYH5bbG6S86GeRA86TEMDFwEd8PVDGQNFc7gSYzQA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eyd55errKvymF9KX84rOVK+mQktonV0YyMyFXEOKlugMdHD3Apxtt9+8Bsvam0TCO
         n4FVQVPAaHFF1Pws6nveMY4zhD28senxiUN6OPOxhbH4/jElp+kVSUPqxNafdujs/1
         fjSrMkHckd89gn/IZxoWIQlp0te51fVaIC5kCkC8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Kiran Bhandare <kiranx.bhandare@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.4 27/64] i40e: Fix queues reservation for XDP
Date:   Mon, 31 Jan 2022 11:56:12 +0100
Message-Id: <20220131105216.582709802@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105215.644174521@linuxfoundation.org>
References: <20220131105215.644174521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>

commit 92947844b8beee988c0ce17082b705c2f75f0742 upstream.

When XDP was configured on a system with large number of CPUs
and X722 NIC there was a call trace with NULL pointer dereference.

i40e 0000:87:00.0: failed to get tracking for 256 queues for VSI 0 err -12
i40e 0000:87:00.0: setup of MAIN VSI failed

BUG: kernel NULL pointer dereference, address: 0000000000000000
RIP: 0010:i40e_xdp+0xea/0x1b0 [i40e]
Call Trace:
? i40e_reconfig_rss_queues+0x130/0x130 [i40e]
dev_xdp_install+0x61/0xe0
dev_xdp_attach+0x18a/0x4c0
dev_change_xdp_fd+0x1e6/0x220
do_setlink+0x616/0x1030
? ahci_port_stop+0x80/0x80
? ata_qc_issue+0x107/0x1e0
? lock_timer_base+0x61/0x80
? __mod_timer+0x202/0x380
rtnl_setlink+0xe5/0x170
? bpf_lsm_binder_transaction+0x10/0x10
? security_capable+0x36/0x50
rtnetlink_rcv_msg+0x121/0x350
? rtnl_calcit.isra.0+0x100/0x100
netlink_rcv_skb+0x50/0xf0
netlink_unicast+0x1d3/0x2a0
netlink_sendmsg+0x22a/0x440
sock_sendmsg+0x5e/0x60
__sys_sendto+0xf0/0x160
? __sys_getsockname+0x7e/0xc0
? _copy_from_user+0x3c/0x80
? __sys_setsockopt+0xc8/0x1a0
__x64_sys_sendto+0x20/0x30
do_syscall_64+0x33/0x40
entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f83fa7a39e0

This was caused by PF queue pile fragmentation due to
flow director VSI queue being placed right after main VSI.
Because of this main VSI was not able to resize its
queue allocation for XDP resulting in no queues allocated
for main VSI when XDP was turned on.

Fix this by always allocating last queue in PF queue pile
for a flow director VSI.

Fixes: 41c445ff0f48 ("i40e: main driver core")
Fixes: 74608d17fe29 ("i40e: add support for XDP_TX action")
Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -218,6 +218,20 @@ static int i40e_get_lump(struct i40e_pf
 		return -EINVAL;
 	}
 
+	/* Allocate last queue in the pile for FDIR VSI queue
+	 * so it doesn't fragment the qp_pile
+	 */
+	if (pile == pf->qp_pile && pf->vsi[id]->type == I40E_VSI_FDIR) {
+		if (pile->list[pile->num_entries - 1] & I40E_PILE_VALID_BIT) {
+			dev_err(&pf->pdev->dev,
+				"Cannot allocate queue %d for I40E_VSI_FDIR\n",
+				pile->num_entries - 1);
+			return -ENOMEM;
+		}
+		pile->list[pile->num_entries - 1] = id | I40E_PILE_VALID_BIT;
+		return pile->num_entries - 1;
+	}
+
 	i = 0;
 	while (i < pile->num_entries) {
 		/* skip already allocated entries */


