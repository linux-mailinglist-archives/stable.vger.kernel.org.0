Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27D0035BDE6
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237996AbhDLI4C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:56:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238322AbhDLIxH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:53:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2331761285;
        Mon, 12 Apr 2021 08:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217500;
        bh=5C1kcqYKpH8LmQDYoQ9ZRdeJZfU7nUFTTbFu8wbbdFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1DM7h4WbjxdkNRQGJvklAglFKTbKtmz9FZOD61llYAg74q7gg4ePUPutM2k7+7cy2
         RgYJOLnDStU10mHVP2RkFyI4sS3TVCYSxcspXAXHZMjEz7xZP1+BVmCraBhpinsvge
         V4BycjoAIaK46yuTQMRv80vO+xUtHE0ff/wui8so=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.10 039/188] ice: Use port number instead of PF ID for WoL
Date:   Mon, 12 Apr 2021 10:39:13 +0200
Message-Id: <20210412084014.952931559@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

commit 3176551979b92b02756979c0f1e2d03d1fc82b1e upstream.

As per the spec, the WoL control word read from the NVM should be
interpreted as port numbers, and not PF numbers. So when checking
if WoL supported, use the port number instead of the PF ID.

Also, ice_is_wol_supported doesn't really need a pointer to the pf
struct, but just needs a pointer to the hw instance.

Fixes: 769c500dcc1e ("ice: Add advanced power mgmt for WoL")
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice.h         |    2 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c |    4 ++--
 drivers/net/ethernet/intel/ice/ice_main.c    |    9 ++++-----
 3 files changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -586,7 +586,7 @@ int ice_schedule_reset(struct ice_pf *pf
 void ice_print_link_msg(struct ice_vsi *vsi, bool isup);
 const char *ice_stat_str(enum ice_status stat_err);
 const char *ice_aq_str(enum ice_aq_err aq_err);
-bool ice_is_wol_supported(struct ice_pf *pf);
+bool ice_is_wol_supported(struct ice_hw *hw);
 int
 ice_fdir_write_fltr(struct ice_pf *pf, struct ice_fdir_fltr *input, bool add,
 		    bool is_tun);
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3472,7 +3472,7 @@ static void ice_get_wol(struct net_devic
 		netdev_warn(netdev, "Wake on LAN is not supported on this interface!\n");
 
 	/* Get WoL settings based on the HW capability */
-	if (ice_is_wol_supported(pf)) {
+	if (ice_is_wol_supported(&pf->hw)) {
 		wol->supported = WAKE_MAGIC;
 		wol->wolopts = pf->wol_ena ? WAKE_MAGIC : 0;
 	} else {
@@ -3492,7 +3492,7 @@ static int ice_set_wol(struct net_device
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_pf *pf = vsi->back;
 
-	if (vsi->type != ICE_VSI_PF || !ice_is_wol_supported(pf))
+	if (vsi->type != ICE_VSI_PF || !ice_is_wol_supported(&pf->hw))
 		return -EOPNOTSUPP;
 
 	/* only magic packet is supported */
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3515,15 +3515,14 @@ static int ice_init_interrupt_scheme(str
 }
 
 /**
- * ice_is_wol_supported - get NVM state of WoL
- * @pf: board private structure
+ * ice_is_wol_supported - check if WoL is supported
+ * @hw: pointer to hardware info
  *
  * Check if WoL is supported based on the HW configuration.
  * Returns true if NVM supports and enables WoL for this port, false otherwise
  */
-bool ice_is_wol_supported(struct ice_pf *pf)
+bool ice_is_wol_supported(struct ice_hw *hw)
 {
-	struct ice_hw *hw = &pf->hw;
 	u16 wol_ctrl;
 
 	/* A bit set to 1 in the NVM Software Reserved Word 2 (WoL control
@@ -3532,7 +3531,7 @@ bool ice_is_wol_supported(struct ice_pf
 	if (ice_read_sr_word(hw, ICE_SR_NVM_WOL_CFG, &wol_ctrl))
 		return false;
 
-	return !(BIT(hw->pf_id) & wol_ctrl);
+	return !(BIT(hw->port_info->lport) & wol_ctrl);
 }
 
 /**


