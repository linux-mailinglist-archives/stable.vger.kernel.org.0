Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 440EE4C48BE
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 16:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232083AbiBYPYy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 10:24:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242043AbiBYPYx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 10:24:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B46E120198
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 07:24:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8EF4B83204
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 15:24:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44CC8C340E7;
        Fri, 25 Feb 2022 15:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645802657;
        bh=jUS+GMivKNxn20i4J3xZKKqlgbaEt4Pw+Fu/y58jfrE=;
        h=Subject:To:Cc:From:Date:From;
        b=GFVPMP6Ee9TJ5huexU/CUl4H8aR3Q9rtH1J3L5qaBt1/AfVW6x7zKxsHKKIxfQZxD
         +NyHv1IyhJvDevJax9DOsjgJu6IzKOxVO53L1enTgIXPxSWWcHG3uNEFARrU96UuSQ
         ArGUm7yoV3ej0T7Iz81n1kiIuIl+BodoPURgh3/o=
Subject: FAILED: patch "[PATCH] ice: Match on all profiles in slow-path" failed to apply to 5.16-stable tree
To:     wojciech.drewek@intel.com, anthony.l.nguyen@intel.com,
        sandeep.penigalapati@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 25 Feb 2022 16:24:14 +0100
Message-ID: <1645802654161233@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.16-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b70bc066d77b460a63a8c3fb2ea0d811ce862a83 Mon Sep 17 00:00:00 2001
From: Wojciech Drewek <wojciech.drewek@intel.com>
Date: Fri, 17 Dec 2021 12:36:25 +0100
Subject: [PATCH] ice: Match on all profiles in slow-path

In switchdev mode, slow-path rules need to match all protocols, in order
to correctly redirect unfiltered or missed packets to the uplink. To set
this up for the virtual function to uplink flow, the rule that redirects
packets to the control VSI must have the tunnel type set to
ICE_SW_TUN_AND_NON_TUN. As a result of that new tunnel type being set,
ice_get_compat_fv_bitmap will select ICE_PROF_ALL. At that point all
profiles would be selected for this rule, resulting in the desired
behavior. Without this change slow-path would not work with
tunnel protocols.

Fixes: 8b032a55c1bd ("ice: low level support for tunnels")
Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch.c b/drivers/net/ethernet/intel/ice/ice_eswitch.c
index 864692b157b6..73edc24d81d5 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch.c
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch.c
@@ -44,6 +44,7 @@ ice_eswitch_add_vf_mac_rule(struct ice_pf *pf, struct ice_vf *vf, const u8 *mac)
 				       ctrl_vsi->rxq_map[vf->vf_id];
 	rule_info.flags_info.act |= ICE_SINGLE_ACT_LB_ENABLE;
 	rule_info.flags_info.act_valid = true;
+	rule_info.tun_type = ICE_SW_TUN_AND_NON_TUN;
 
 	err = ice_add_adv_rule(hw, list, lkups_cnt, &rule_info,
 			       vf->repr->mac_rule);
diff --git a/drivers/net/ethernet/intel/ice/ice_protocol_type.h b/drivers/net/ethernet/intel/ice/ice_protocol_type.h
index dc1b0e9e6df5..695b6dd61dc2 100644
--- a/drivers/net/ethernet/intel/ice/ice_protocol_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_protocol_type.h
@@ -47,6 +47,7 @@ enum ice_protocol_type {
 
 enum ice_sw_tunnel_type {
 	ICE_NON_TUN = 0,
+	ICE_SW_TUN_AND_NON_TUN,
 	ICE_SW_TUN_VXLAN,
 	ICE_SW_TUN_GENEVE,
 	ICE_SW_TUN_NVGRE,
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 11ae0bee3590..475ec2afa210 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -4537,6 +4537,7 @@ ice_get_compat_fv_bitmap(struct ice_hw *hw, struct ice_adv_rule_info *rinfo,
 	case ICE_SW_TUN_NVGRE:
 		prof_type = ICE_PROF_TUN_GRE;
 		break;
+	case ICE_SW_TUN_AND_NON_TUN:
 	default:
 		prof_type = ICE_PROF_ALL;
 		break;
@@ -5305,7 +5306,8 @@ ice_add_adv_rule(struct ice_hw *hw, struct ice_adv_lkup_elem *lkups,
 	if (status)
 		goto err_ice_add_adv_rule;
 
-	if (rinfo->tun_type != ICE_NON_TUN) {
+	if (rinfo->tun_type != ICE_NON_TUN &&
+	    rinfo->tun_type != ICE_SW_TUN_AND_NON_TUN) {
 		status = ice_fill_adv_packet_tun(hw, rinfo->tun_type,
 						 s_rule->pdata.lkup_tx_rx.hdr,
 						 pkt_offsets);

