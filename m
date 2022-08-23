Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69C7159D521
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347619AbiHWJGg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348047AbiHWJFp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:05:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E41E74DD7;
        Tue, 23 Aug 2022 01:29:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E86CFB81C52;
        Tue, 23 Aug 2022 08:28:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E10C433D6;
        Tue, 23 Aug 2022 08:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243279;
        bh=06rDHVyj14to00b6+dc3sf8vZFtqHsM2kx3cr8PLbb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E09IpiJMPkCxsJwO8pGpl2/xyRmAJJZSvBrkODijK+fRY4ITwT9PXEfTNsNmp0UWc
         /rZRrf0e7Kv7YgLa/rw3kprDVPwy++9dRm95Fxy29mN7/YFHAhYWdglN5xQ4EoVZBZ
         R/Itdhuo2Gi1MjJAaQE8snWufEdLoa9+3WbvDhbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Grzegorz Siwik <grzegorz.siwik@intel.com>,
        Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>,
        Igor Raits <igor@gooddata.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH 5.19 226/365] ice: Fix clearing of promisc mode with bridge over bond
Date:   Tue, 23 Aug 2022 10:02:07 +0200
Message-Id: <20220823080127.653236561@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Grzegorz Siwik <grzegorz.siwik@intel.com>

commit abddafd4585cc825d454da3cf308ad1226f6c554 upstream.

When at least two interfaces are bonded and a bridge is enabled on the
bond, an error can occur when the bridge is removed and re-added. The
reason for the error is because promiscuous mode was not fully cleared from
the VLAN VSI in the hardware. With this change, promiscuous mode is
properly removed when the bridge disconnects from bonding.

[ 1033.676359] bond1: link status definitely down for interface enp95s0f0, disabling it
[ 1033.676366] bond1: making interface enp175s0f0 the new active one
[ 1033.676369] device enp95s0f0 left promiscuous mode
[ 1033.676522] device enp175s0f0 entered promiscuous mode
[ 1033.676901] ice 0000:af:00.0 enp175s0f0: Error setting Multicast promiscuous mode on VSI 6
[ 1041.795662] ice 0000:af:00.0 enp175s0f0: Error setting Multicast promiscuous mode on VSI 6
[ 1041.944826] bond1: link status definitely down for interface enp175s0f0, disabling it
[ 1041.944874] device enp175s0f0 left promiscuous mode
[ 1041.944918] bond1: now running without any active interface!

Fixes: c31af68a1b94 ("ice: Add outer_vlan_ops and VSI specific VLAN ops implementations")
Co-developed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Grzegorz Siwik <grzegorz.siwik@intel.com>
Link: https://lore.kernel.org/all/CAK8fFZ7m-KR57M_rYX6xZN39K89O=LGooYkKsu6HKt0Bs+x6xQ@mail.gmail.com/
Tested-by: Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
Tested-by: Igor Raits <igor@gooddata.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_lib.c  |    6 +++++-
 drivers/net/ethernet/intel/ice/ice_main.c |   12 +++++++++++-
 2 files changed, 16 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -4078,7 +4078,11 @@ int ice_vsi_del_vlan_zero(struct ice_vsi
 	if (err && err != -EEXIST)
 		return err;
 
-	return 0;
+	/* when deleting the last VLAN filter, make sure to disable the VLAN
+	 * promisc mode so the filter isn't left by accident
+	 */
+	return ice_clear_vsi_promisc(&vsi->back->hw, vsi->idx,
+				    ICE_MCAST_VLAN_PROMISC_BITS, 0);
 }
 
 /**
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -267,8 +267,10 @@ static int ice_set_promisc(struct ice_vs
 		status = ice_fltr_set_vsi_promisc(&vsi->back->hw, vsi->idx,
 						  promisc_m, 0);
 	}
+	if (status && status != -EEXIST)
+		return status;
 
-	return status;
+	return 0;
 }
 
 /**
@@ -3572,6 +3574,14 @@ ice_vlan_rx_kill_vid(struct net_device *
 	while (test_and_set_bit(ICE_CFG_BUSY, vsi->state))
 		usleep_range(1000, 2000);
 
+	ret = ice_clear_vsi_promisc(&vsi->back->hw, vsi->idx,
+				    ICE_MCAST_VLAN_PROMISC_BITS, vid);
+	if (ret) {
+		netdev_err(netdev, "Error clearing multicast promiscuous mode on VSI %i\n",
+			   vsi->vsi_num);
+		vsi->current_netdev_flags |= IFF_ALLMULTI;
+	}
+
 	vlan_ops = ice_get_compat_vsi_vlan_ops(vsi);
 
 	/* Make sure VLAN delete is successful before updating VLAN


