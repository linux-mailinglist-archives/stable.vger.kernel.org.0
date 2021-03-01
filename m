Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15DD2328EF2
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241592AbhCATlW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:41:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:50728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241618AbhCATcx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:32:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF61865063;
        Mon,  1 Mar 2021 17:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619416;
        bh=C42RWvOcA2qkUV0kar38veN2oPe7cDzW31YvZ+0SA5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QTfFZ/mKaHHTRYXOZ/hvdR5YGR+F3i5xxX+c2Tull4Xp/zePX7loM4bu+dTeB3hIo
         cLm4uLs0ZMJ2TGdatYs6w7Jp8CXu6TyK5qHGAEiLeRmf32TkSs0Ge8HwENyhnkWuqH
         fHdDnJBOD/LUn+ghQrwfkqFDRn5L+Ie4mlMNZ2Ok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brett Creeley <brett.creeley@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 446/663] ice: Account for port VLAN in VF max packet size calculation
Date:   Mon,  1 Mar 2021 17:11:34 +0100
Message-Id: <20210301161203.969587575@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

[ Upstream commit a6aa7c8f998f4afddd73410aa043dad38162ce9e ]

Currently if an AVF driver doesn't account for the possibility of a
port VLAN when determining its max packet size then packets at MTU will
be dropped. It is not the VF driver's responsibility to account for a
port VLAN so fix this. To fix this, do the following:

1. Add a function that determines the max packet size a VF is allowed by
   using the port's max packet size and whether the VF is in a port
   VLAN. If a port VLAN is configured then a VF's max packet size will
   always be the port's max packet size minus VLAN_HLEN. Otherwise it
   will be the port's max packet size.

2. Use this function to verify the max packet size from the VF.

3. If there is a port VLAN configured then add 4 bytes (VLAN_HLEN) to
   the VF's max packet size configuration.

Also, the VIRTCHNL_OP_GET_VF_RESOURCES message provides the capability
to communicate a VF's max packet size. Use the new function for this
purpose.

Fixes: 1071a8358a28 ("ice: Implement virtchnl commands for AVF support")
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 33 ++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index ec7f6c64132ee..b3161c5def465 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -1878,6 +1878,29 @@ static int ice_vc_get_ver_msg(struct ice_vf *vf, u8 *msg)
 				     sizeof(struct virtchnl_version_info));
 }
 
+/**
+ * ice_vc_get_max_frame_size - get max frame size allowed for VF
+ * @vf: VF used to determine max frame size
+ *
+ * Max frame size is determined based on the current port's max frame size and
+ * whether a port VLAN is configured on this VF. The VF is not aware whether
+ * it's in a port VLAN so the PF needs to account for this in max frame size
+ * checks and sending the max frame size to the VF.
+ */
+static u16 ice_vc_get_max_frame_size(struct ice_vf *vf)
+{
+	struct ice_vsi *vsi = vf->pf->vsi[vf->lan_vsi_idx];
+	struct ice_port_info *pi = vsi->port_info;
+	u16 max_frame_size;
+
+	max_frame_size = pi->phy.link_info.max_frame_size;
+
+	if (vf->port_vlan_info)
+		max_frame_size -= VLAN_HLEN;
+
+	return max_frame_size;
+}
+
 /**
  * ice_vc_get_vf_res_msg
  * @vf: pointer to the VF info
@@ -1960,6 +1983,7 @@ static int ice_vc_get_vf_res_msg(struct ice_vf *vf, u8 *msg)
 	vfres->max_vectors = pf->num_msix_per_vf;
 	vfres->rss_key_size = ICE_VSIQF_HKEY_ARRAY_SIZE;
 	vfres->rss_lut_size = ICE_VSIQF_HLUT_ARRAY_SIZE;
+	vfres->max_mtu = ice_vc_get_max_frame_size(vf);
 
 	vfres->vsi_res[0].vsi_id = vf->lan_vsi_num;
 	vfres->vsi_res[0].vsi_type = VIRTCHNL_VSI_SRIOV;
@@ -2952,6 +2976,8 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 
 		/* copy Rx queue info from VF into VSI */
 		if (qpi->rxq.ring_len > 0) {
+			u16 max_frame_size = ice_vc_get_max_frame_size(vf);
+
 			num_rxq++;
 			vsi->rx_rings[i]->dma = qpi->rxq.dma_ring_addr;
 			vsi->rx_rings[i]->count = qpi->rxq.ring_len;
@@ -2964,7 +2990,7 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 			}
 			vsi->rx_buf_len = qpi->rxq.databuffer_size;
 			vsi->rx_rings[i]->rx_buf_len = vsi->rx_buf_len;
-			if (qpi->rxq.max_pkt_size >= (16 * 1024) ||
+			if (qpi->rxq.max_pkt_size > max_frame_size ||
 			    qpi->rxq.max_pkt_size < 64) {
 				v_ret = VIRTCHNL_STATUS_ERR_PARAM;
 				goto error_param;
@@ -2972,6 +2998,11 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 		}
 
 		vsi->max_frame = qpi->rxq.max_pkt_size;
+		/* add space for the port VLAN since the VF driver is not
+		 * expected to account for it in the MTU calculation
+		 */
+		if (vf->port_vlan_info)
+			vsi->max_frame += VLAN_HLEN;
 	}
 
 	/* VF can request to configure less than allocated queues or default
-- 
2.27.0



