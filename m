Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B88345B61B
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 09:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240957AbhKXIE7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 03:04:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:58820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240954AbhKXIE4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 03:04:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F40C660F5B;
        Wed, 24 Nov 2021 08:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637740907;
        bh=/Vd6Jp/YXFsMZTOgheop2sZN5A2ZUSrIe7ML78a/pA4=;
        h=Subject:To:Cc:From:Date:From;
        b=bjI3Iz/6ijmtxjweGx9i+k6EFjaX1cobWNFwkYgKokWuADv9FTMvDEzf9DCnUjt6y
         wJT2OljHPzlJJ0PIDEjxg//mDgdvOJ6GUZdtGcQ9KtYIrPTRLCnOCOf4s6PBijejTF
         5znumhaHjAYGvgozvyJMxTzy7s5DDvcAJTbpY/pw=
Subject: FAILED: patch "[PATCH] ice: Remove toggling of antispoof for VF trusted promiscuous" failed to apply to 5.15-stable tree
To:     brett.creeley@intel.com, anthony.l.nguyen@intel.com,
        tony.brelinski@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 24 Nov 2021 09:01:36 +0100
Message-ID: <16377408961824@kroah.com>
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

From 0299faeaf8eb982103e4388af61fd94feb9c2d9f Mon Sep 17 00:00:00 2001
From: Brett Creeley <brett.creeley@intel.com>
Date: Wed, 5 May 2021 14:17:57 -0700
Subject: [PATCH] ice: Remove toggling of antispoof for VF trusted promiscuous
 mode

Currently when a trusted VF enables promiscuous mode spoofchk will be
disabled. This is wrong and should only be modified from the
ndo_set_vf_spoofchk callback. Fix this by removing the call to toggle
spoofchk for trusted VFs.

Fixes: 01b5e89aab49 ("ice: Add VF promiscuous support")
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 9b699419c933..3f8f94732a1f 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -3055,24 +3055,6 @@ static int ice_vc_cfg_promiscuous_mode_msg(struct ice_vf *vf, u8 *msg)
 	rm_promisc = !allmulti && !alluni;
 
 	if (vsi->num_vlan || vf->port_vlan_info) {
-		struct ice_vsi *pf_vsi = ice_get_main_vsi(pf);
-		struct net_device *pf_netdev;
-
-		if (!pf_vsi) {
-			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-			goto error_param;
-		}
-
-		pf_netdev = pf_vsi->netdev;
-
-		ret = ice_set_vf_spoofchk(pf_netdev, vf->vf_id, rm_promisc);
-		if (ret) {
-			dev_err(dev, "Failed to update spoofchk to %s for VF %d VSI %d when setting promiscuous mode\n",
-				rm_promisc ? "ON" : "OFF", vf->vf_id,
-				vsi->vsi_num);
-			v_ret = VIRTCHNL_STATUS_ERR_PARAM;
-		}
-
 		if (rm_promisc)
 			ret = ice_cfg_vlan_pruning(vsi, true);
 		else

