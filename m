Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD90B408ECB
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241409AbhIMNgz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:36:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:32892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242944AbhIMNeg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:34:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F8EA61209;
        Mon, 13 Sep 2021 13:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539594;
        bh=uKrNE2LSeeJMdBjhDw/gA4UAWVuBNAGvWIlywK0v8aY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nZXJazo8rTZ6goqoGiyxcyFHngzR0SMZ8oTiXbdV4tq39WJcz5Wm1izIpyPweM/s0
         1XxsOGUoiCn44yrgtX01LA9BvpVxWZiCN/7GgkXc3EZ7GY+QC0hqu0CobVO+TnURsy
         7OfQkF0qdPmCsUNpmhFMqMo0rAeoPejdDKduPhTw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Assmann <sassmann@kpanic.de>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 084/236] i40e: improve locking of mac_filter_hash
Date:   Mon, 13 Sep 2021 15:13:09 +0200
Message-Id: <20210913131103.214694704@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Assmann <sassmann@kpanic.de>

[ Upstream commit 8b4b06919fd66caf49fdf4fe59f9d6312cf7956d ]

i40e_config_vf_promiscuous_mode() calls
i40e_getnum_vf_vsi_vlan_filters() without acquiring the
mac_filter_hash_lock spinlock.

This is unsafe because mac_filter_hash may get altered in another thread
while i40e_getnum_vf_vsi_vlan_filters() traverses the hashes.

Simply adding the spinlock in i40e_getnum_vf_vsi_vlan_filters() is not
possible as it already gets called in i40e_get_vlan_list_sync() with the
spinlock held. Therefore adding a wrapper that acquires the spinlock and
call the correct function where appropriate.

Fixes: 37d318d7805f ("i40e: Remove scheduling while atomic possibility")
Fix-suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 23 ++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index e4f13a49c3df..a02167cce81e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -1107,12 +1107,12 @@ static int i40e_quiesce_vf_pci(struct i40e_vf *vf)
 }
 
 /**
- * i40e_getnum_vf_vsi_vlan_filters
+ * __i40e_getnum_vf_vsi_vlan_filters
  * @vsi: pointer to the vsi
  *
  * called to get the number of VLANs offloaded on this VF
  **/
-static int i40e_getnum_vf_vsi_vlan_filters(struct i40e_vsi *vsi)
+static int __i40e_getnum_vf_vsi_vlan_filters(struct i40e_vsi *vsi)
 {
 	struct i40e_mac_filter *f;
 	u16 num_vlans = 0, bkt;
@@ -1125,6 +1125,23 @@ static int i40e_getnum_vf_vsi_vlan_filters(struct i40e_vsi *vsi)
 	return num_vlans;
 }
 
+/**
+ * i40e_getnum_vf_vsi_vlan_filters
+ * @vsi: pointer to the vsi
+ *
+ * wrapper for __i40e_getnum_vf_vsi_vlan_filters() with spinlock held
+ **/
+static int i40e_getnum_vf_vsi_vlan_filters(struct i40e_vsi *vsi)
+{
+	int num_vlans;
+
+	spin_lock_bh(&vsi->mac_filter_hash_lock);
+	num_vlans = __i40e_getnum_vf_vsi_vlan_filters(vsi);
+	spin_unlock_bh(&vsi->mac_filter_hash_lock);
+
+	return num_vlans;
+}
+
 /**
  * i40e_get_vlan_list_sync
  * @vsi: pointer to the VSI
@@ -1142,7 +1159,7 @@ static void i40e_get_vlan_list_sync(struct i40e_vsi *vsi, u16 *num_vlans,
 	int bkt;
 
 	spin_lock_bh(&vsi->mac_filter_hash_lock);
-	*num_vlans = i40e_getnum_vf_vsi_vlan_filters(vsi);
+	*num_vlans = __i40e_getnum_vf_vsi_vlan_filters(vsi);
 	*vlan_list = kcalloc(*num_vlans, sizeof(**vlan_list), GFP_ATOMIC);
 	if (!(*vlan_list))
 		goto err;
-- 
2.30.2



