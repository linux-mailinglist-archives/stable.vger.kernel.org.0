Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A10045B61F
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 09:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbhKXIFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 03:05:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:58930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240966AbhKXIFr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 03:05:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF93960F5D;
        Wed, 24 Nov 2021 08:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637740956;
        bh=1lVZATJhY9cCAp1Am5qh4dq3z6QhzN9fVXBOqqAulzY=;
        h=Subject:To:Cc:From:Date:From;
        b=09M9kXk7i/ZNHMTkFial/TrWkmm0lXMzo6hxKW3CMsRZjsDuXfgXVFywd3XNmqIUX
         zpZRo/SCcTSuTuk9a89a7DXF9mo19f4HY1rlc5DLlMNoJfsUk66XgrEywZPuXdqU/e
         cZ7P9sBe0KapuQo5K2fSqEgeJrhIXy9CgRt2VXdg=
Subject: FAILED: patch "[PATCH] ice: Fix race conditions between virtchnl handling and VF ndo" failed to apply to 5.15-stable tree
To:     brett.creeley@intel.com, anthony.l.nguyen@intel.com,
        konrad0.jankowski@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 24 Nov 2021 09:02:30 +0100
Message-ID: <1637740950240140@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e6ba5273d4ede03d075d7a116b8edad1f6115f4d Mon Sep 17 00:00:00 2001
From: Brett Creeley <brett.creeley@intel.com>
Date: Thu, 9 Sep 2021 14:38:09 -0700
Subject: [PATCH] ice: Fix race conditions between virtchnl handling and VF ndo
 ops

The VF can be configured via the PF's ndo ops at the same time the PF is
receiving/handling virtchnl messages. This has many issues, with
one of them being the ndo op could be actively resetting a VF (i.e.
resetting it to the default state and deleting/re-adding the VF's VSI)
while a virtchnl message is being handled. The following error was seen
because a VF ndo op was used to change a VF's trust setting while the
VIRTCHNL_OP_CONFIG_VSI_QUEUES was ongoing:

[35274.192484] ice 0000:88:00.0: Failed to set LAN Tx queue context, error: ICE_ERR_PARAM
[35274.193074] ice 0000:88:00.0: VF 0 failed opcode 6, retval: -5
[35274.193640] iavf 0000:88:01.0: PF returned error -5 (IAVF_ERR_PARAM) to our request 6

Fix this by making sure the virtchnl handling and VF ndo ops that
trigger VF resets cannot run concurrently. This is done by adding a
struct mutex cfg_lock to each VF structure. For VF ndo ops, the mutex
will be locked around the critical operations and VFR. Since the ndo ops
will trigger a VFR, the virtchnl thread will use mutex_trylock(). This
is done because if any other thread (i.e. VF ndo op) has the mutex, then
that means the current VF message being handled is no longer valid, so
just ignore it.

This issue can be seen using the following commands:

for i in {0..50}; do
        rmmod ice
        modprobe ice

        sleep 1

        echo 1 > /sys/class/net/ens785f0/device/sriov_numvfs
        echo 1 > /sys/class/net/ens785f1/device/sriov_numvfs

        ip link set ens785f1 vf 0 trust on
        ip link set ens785f0 vf 0 trust on

        sleep 2

        echo 0 > /sys/class/net/ens785f0/device/sriov_numvfs
        echo 0 > /sys/class/net/ens785f1/device/sriov_numvfs
        sleep 1
        echo 1 > /sys/class/net/ens785f0/device/sriov_numvfs
        echo 1 > /sys/class/net/ens785f1/device/sriov_numvfs

        ip link set ens785f1 vf 0 trust on
        ip link set ens785f0 vf 0 trust on
done

Fixes: 7c710869d64e ("ice: Add handlers for VF netdevice operations")
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 3f727df3b6fb..217ff5e9a6f1 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -650,6 +650,8 @@ void ice_free_vfs(struct ice_pf *pf)
 			set_bit(ICE_VF_STATE_DIS, pf->vf[i].vf_states);
 			ice_free_vf_res(&pf->vf[i]);
 		}
+
+		mutex_destroy(&pf->vf[i].cfg_lock);
 	}
 
 	if (ice_sriov_free_msix_res(pf))
@@ -1946,6 +1948,8 @@ static void ice_set_dflt_settings_vfs(struct ice_pf *pf)
 		ice_vf_fdir_init(vf);
 
 		ice_vc_set_dflt_vf_ops(&vf->vc_ops);
+
+		mutex_init(&vf->cfg_lock);
 	}
 }
 
@@ -4135,6 +4139,8 @@ ice_set_vf_port_vlan(struct net_device *netdev, int vf_id, u16 vlan_id, u8 qos,
 		return 0;
 	}
 
+	mutex_lock(&vf->cfg_lock);
+
 	vf->port_vlan_info = vlanprio;
 
 	if (vf->port_vlan_info)
@@ -4144,6 +4150,7 @@ ice_set_vf_port_vlan(struct net_device *netdev, int vf_id, u16 vlan_id, u8 qos,
 		dev_info(dev, "Clearing port VLAN on VF %d\n", vf_id);
 
 	ice_vc_reset_vf(vf);
+	mutex_unlock(&vf->cfg_lock);
 
 	return 0;
 }
@@ -4683,6 +4690,15 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 		return;
 	}
 
+	/* VF is being configured in another context that triggers a VFR, so no
+	 * need to process this message
+	 */
+	if (!mutex_trylock(&vf->cfg_lock)) {
+		dev_info(dev, "VF %u is being configured in another context that will trigger a VFR, so there is no need to handle this message\n",
+			 vf->vf_id);
+		return;
+	}
+
 	switch (v_opcode) {
 	case VIRTCHNL_OP_VERSION:
 		err = ops->get_ver_msg(vf, msg);
@@ -4771,6 +4787,8 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event)
 		dev_info(dev, "PF failed to honor VF %d, opcode %d, error %d\n",
 			 vf_id, v_opcode, err);
 	}
+
+	mutex_unlock(&vf->cfg_lock);
 }
 
 /**
@@ -4886,6 +4904,8 @@ int ice_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
 		return -EINVAL;
 	}
 
+	mutex_lock(&vf->cfg_lock);
+
 	/* VF is notified of its new MAC via the PF's response to the
 	 * VIRTCHNL_OP_GET_VF_RESOURCES message after the VF has been reset
 	 */
@@ -4904,6 +4924,7 @@ int ice_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
 	}
 
 	ice_vc_reset_vf(vf);
+	mutex_unlock(&vf->cfg_lock);
 	return 0;
 }
 
@@ -4938,11 +4959,15 @@ int ice_set_vf_trust(struct net_device *netdev, int vf_id, bool trusted)
 	if (trusted == vf->trusted)
 		return 0;
 
+	mutex_lock(&vf->cfg_lock);
+
 	vf->trusted = trusted;
 	ice_vc_reset_vf(vf);
 	dev_info(ice_pf_to_dev(pf), "VF %u is now %strusted\n",
 		 vf_id, trusted ? "" : "un");
 
+	mutex_unlock(&vf->cfg_lock);
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index 5ff93a08f54c..7e28ecbbe7af 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -100,6 +100,11 @@ struct ice_vc_vf_ops {
 struct ice_vf {
 	struct ice_pf *pf;
 
+	/* Used during virtchnl message handling and NDO ops against the VF
+	 * that will trigger a VFR
+	 */
+	struct mutex cfg_lock;
+
 	u16 vf_id;			/* VF ID in the PF space */
 	u16 lan_vsi_idx;		/* index into PF struct */
 	u16 ctrl_vsi_idx;

