Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E214A36CA
	for <lists+stable@lfdr.de>; Sun, 30 Jan 2022 15:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355011AbiA3Oln (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Jan 2022 09:41:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345078AbiA3Olm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Jan 2022 09:41:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C47C061714
        for <stable@vger.kernel.org>; Sun, 30 Jan 2022 06:41:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3F26611D3
        for <stable@vger.kernel.org>; Sun, 30 Jan 2022 14:41:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97B77C340E4;
        Sun, 30 Jan 2022 14:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643553701;
        bh=f89sesBMXPMDSSU1Z1KT1zZLt0yyIQtJcKiCmPNYisU=;
        h=Subject:To:Cc:From:Date:From;
        b=PMHnWH4VJ8GOYcTxgbA0tcV3k6jkvzYVlL1CmcFTh+N18F7drDz6t5SfB/WBnkSYI
         ta1ARgJUafZvZgd+N0Vq8Q/O3YijphST2x3NEKJUUyIhT3++ZCzegb+Wy2nTVx0auY
         49C7RB2YaO1ggd6GOjbb42UwqXKl6Oc5hVZ1Nxp4=
Subject: FAILED: patch "[PATCH] i40e: Fix queues reservation for XDP" failed to apply to 4.14-stable tree
To:     sylwesterx.dziedziuch@intel.com, anthony.l.nguyen@intel.com,
        kiranx.bhandare@intel.com, maciej.fijalkowski@intel.com,
        mateusz.palczewski@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 30 Jan 2022 15:41:38 +0100
Message-ID: <164355369865197@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 92947844b8beee988c0ce17082b705c2f75f0742 Mon Sep 17 00:00:00 2001
From: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Date: Fri, 26 Nov 2021 11:11:22 +0100
Subject: [PATCH] i40e: Fix queues reservation for XDP

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

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 9456641cd24a..9b65cb50282c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -210,6 +210,20 @@ static int i40e_get_lump(struct i40e_pf *pf, struct i40e_lump_tracking *pile,
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

