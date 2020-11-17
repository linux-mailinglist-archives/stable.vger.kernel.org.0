Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 408B62B642C
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732993AbgKQNhs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:37:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:49052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732989AbgKQNhr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:37:47 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B5022465E;
        Tue, 17 Nov 2020 13:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620266;
        bh=TG0/V4v9KS49lWth3adBoS1HWZHByNwkR6cJjgj/1rE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o53Y6ika4g5peAq++7iFDOqS+kJXR4URK9ubeXY5pGmQLGPcMwLZR1MK2VMLVNEkx
         yFfEt1fd0mMrJVQxCsyddij9gplrezp0WKJ444WItUjE1R2rmixYE+u4pwgRtq1XOk
         64PSVPKd8/i39ck1XYgmpph5AbIoZ41J1Ns7Ztlc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Slawomir Laba <slawomirx.laba@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 154/255] i40e: Fix MAC address setting for a VF via Host/VM
Date:   Tue, 17 Nov 2020 14:04:54 +0100
Message-Id: <20201117122146.450823154@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Slawomir Laba <slawomirx.laba@intel.com>

[ Upstream commit 3a7001788fed0311d6fb77ed0dabe7bed3567bc0 ]

Fix MAC setting flow for the PF driver.

Update the unicast VF's MAC address in VF structure if it is
a new setting in i40e_vc_add_mac_addr_msg.

When unicast MAC address gets deleted, record that and
set the new unicast MAC address that is already waiting in the filter
list. This logic is based on the order of messages arriving to
the PF driver.

Without this change the MAC address setting was interpreted
incorrectly in the following use cases:
1) Print incorrect VF MAC or zero MAC
ip link show dev $pf
2) Don't preserve MAC between driver reload
rmmod iavf; modprobe iavf
3) Update VF MAC when macvlan was set
ip link add link $vf address $mac $vf.1 type macvlan
4) Failed to update mac address when VF was trusted
ip link set dev $vf address $mac

This includes all other configurations including above commands.

Fixes: f657a6e1313b ("i40e: Fix VF driver MAC address configuration")
Signed-off-by: Slawomir Laba <slawomirx.laba@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 26 +++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 47bfb2e95e2db..343177d71f70a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -2712,6 +2712,10 @@ static int i40e_vc_add_mac_addr_msg(struct i40e_vf *vf, u8 *msg)
 				spin_unlock_bh(&vsi->mac_filter_hash_lock);
 				goto error_param;
 			}
+			if (is_valid_ether_addr(al->list[i].addr) &&
+			    is_zero_ether_addr(vf->default_lan_addr.addr))
+				ether_addr_copy(vf->default_lan_addr.addr,
+						al->list[i].addr);
 		}
 	}
 	spin_unlock_bh(&vsi->mac_filter_hash_lock);
@@ -2739,6 +2743,7 @@ static int i40e_vc_del_mac_addr_msg(struct i40e_vf *vf, u8 *msg)
 {
 	struct virtchnl_ether_addr_list *al =
 	    (struct virtchnl_ether_addr_list *)msg;
+	bool was_unimac_deleted = false;
 	struct i40e_pf *pf = vf->pf;
 	struct i40e_vsi *vsi = NULL;
 	i40e_status ret = 0;
@@ -2758,6 +2763,8 @@ static int i40e_vc_del_mac_addr_msg(struct i40e_vf *vf, u8 *msg)
 			ret = I40E_ERR_INVALID_MAC_ADDR;
 			goto error_param;
 		}
+		if (ether_addr_equal(al->list[i].addr, vf->default_lan_addr.addr))
+			was_unimac_deleted = true;
 	}
 	vsi = pf->vsi[vf->lan_vsi_idx];
 
@@ -2778,10 +2785,25 @@ static int i40e_vc_del_mac_addr_msg(struct i40e_vf *vf, u8 *msg)
 		dev_err(&pf->pdev->dev, "Unable to program VF %d MAC filters, error %d\n",
 			vf->vf_id, ret);
 
+	if (vf->trusted && was_unimac_deleted) {
+		struct i40e_mac_filter *f;
+		struct hlist_node *h;
+		u8 *macaddr = NULL;
+		int bkt;
+
+		/* set last unicast mac address as default */
+		spin_lock_bh(&vsi->mac_filter_hash_lock);
+		hash_for_each_safe(vsi->mac_filter_hash, bkt, h, f, hlist) {
+			if (is_valid_ether_addr(f->macaddr))
+				macaddr = f->macaddr;
+		}
+		if (macaddr)
+			ether_addr_copy(vf->default_lan_addr.addr, macaddr);
+		spin_unlock_bh(&vsi->mac_filter_hash_lock);
+	}
 error_param:
 	/* send the response to the VF */
-	return i40e_vc_send_resp_to_vf(vf, VIRTCHNL_OP_DEL_ETH_ADDR,
-				       ret);
+	return i40e_vc_send_resp_to_vf(vf, VIRTCHNL_OP_DEL_ETH_ADDR, ret);
 }
 
 /**
-- 
2.27.0



