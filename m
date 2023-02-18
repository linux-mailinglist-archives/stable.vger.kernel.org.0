Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4504F69B995
	for <lists+stable@lfdr.de>; Sat, 18 Feb 2023 12:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjBRLHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Feb 2023 06:07:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjBRLHC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Feb 2023 06:07:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62FB91A4B1
        for <stable@vger.kernel.org>; Sat, 18 Feb 2023 03:07:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27459B8229B
        for <stable@vger.kernel.org>; Sat, 18 Feb 2023 11:07:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F6BC433D2;
        Sat, 18 Feb 2023 11:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676718418;
        bh=GZ5zd56B6ny8CfDD5R1X/XpyfUQJHuxLtsLjg91a0Co=;
        h=Subject:To:Cc:From:Date:From;
        b=TJJtLsB/QcbROaRO9BlXVA1YT4Zekr+MnkLkeQ7ne+NBElrZY+FuDC/+qInEY/8TQ
         j4h9UlFL+Q1gL2FEyLj5FR+IvMGYaMON6/bzOHq3Fk5U3I1OJ0WxfzUwRBF7atFK64
         ZZP2pE4TG0Xyjb6Sc2T3tmN8+VtOEYq61GSBqLXQ=
Subject: FAILED: patch "[PATCH] ice: fix lost multicast packets in promisc mode" failed to apply to 5.15-stable tree
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        rafal.romanowski@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 18 Feb 2023 12:06:56 +0100
Message-ID: <16767184162783@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

43fbca02c2dd ("ice: fix lost multicast packets in promisc mode")
abddafd4585c ("ice: Fix clearing of promisc mode with bridge over bond")
1273f89578f2 ("ice: Fix broken IFF_ALLMULTI handling")
1babaf77f49d ("ice: Advertise 802.1ad VLAN filtering and offloads for PF netdev")
c31af68a1b94 ("ice: Add outer_vlan_ops and VSI specific VLAN ops implementations")
7bd527aa174f ("ice: Adjust naming for inner VLAN operations")
2bfefa2dab6b ("ice: Use the proto argument for VLAN ops")
a19d7f7f0122 ("ice: Refactor vf->port_vlan_info to use ice_vlan")
fb05ba1257d7 ("ice: Introduce ice_vlan struct")
bc42afa95487 ("ice: Add new VSI VLAN ops")
3e0b59714bd4 ("ice: Add helper function for adding VLAN 0")
daf4dd16438b ("ice: Refactor spoofcheck configuration functions")
c1e5da5dd465 ("ice: improve switchdev's slow-path")
c36a2b971627 ("ice: replay advanced rules after reset")
3a7496234d17 ("ice: implement basic E822 PTP support")
b2ee72565cd0 ("ice: introduce ice_ptp_init_phc function")
39b2810642e8 ("ice: use 'int err' instead of 'int status' in ice_ptp_hw.c")
78267d0c9cab ("ice: introduce ice_base_incval function")
4809671015a1 ("ice: Fix E810 PTP reset flow")
c14846914ed6 ("ice: Propagate error codes")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 43fbca02c2ddc39ff5879b6f3a4a097b1ba02098 Mon Sep 17 00:00:00 2001
From: Jesse Brandeburg <jesse.brandeburg@intel.com>
Date: Mon, 6 Feb 2023 15:54:36 -0800
Subject: [PATCH] ice: fix lost multicast packets in promisc mode

There was a problem reported to us where the addition of a VF with an IPv6
address ending with a particular sequence would cause the parent device on
the PF to no longer be able to respond to neighbor discovery packets.

In this case, we had an ovs-bridge device living on top of a VLAN, which
was on top of a PF, and it would not be able to talk anymore (the neighbor
entry would expire and couldn't be restored).

The root cause of the issue is that if the PF is asked to be in IFF_PROMISC
mode (promiscuous mode) and it had an ipv6 address that needed the
33:33:ff:00:00:04 multicast address to work, then when the VF was added
with the need for the same multicast address, the VF would steal all the
traffic destined for that address.

The ice driver didn't auto-subscribe a request of IFF_PROMISC to the
"multicast replication from other port's traffic" meaning that it won't get
for instance, packets with an exact destination in the VF, as above.

The VF's IPv6 address, which adds a "perfect filter" for 33:33:ff:00:00:04,
results in no packets for that multicast address making it to the PF (which
is in promisc but NOT "multicast replication").

The fix is to enable "multicast promiscuous" whenever the driver is asked
to enable IFF_PROMISC, and make sure to disable it when appropriate.

Fixes: e94d44786693 ("ice: Implement filter sync, NDO operations and bump version")
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index b288a01a321a..8ec24f6cf6be 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -275,6 +275,8 @@ static int ice_set_promisc(struct ice_vsi *vsi, u8 promisc_m)
 	if (status && status != -EEXIST)
 		return status;
 
+	netdev_dbg(vsi->netdev, "set promisc filter bits for VSI %i: 0x%x\n",
+		   vsi->vsi_num, promisc_m);
 	return 0;
 }
 
@@ -300,6 +302,8 @@ static int ice_clear_promisc(struct ice_vsi *vsi, u8 promisc_m)
 						    promisc_m, 0);
 	}
 
+	netdev_dbg(vsi->netdev, "clear promisc filter bits for VSI %i: 0x%x\n",
+		   vsi->vsi_num, promisc_m);
 	return status;
 }
 
@@ -414,6 +418,16 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 				}
 				err = 0;
 				vlan_ops->dis_rx_filtering(vsi);
+
+				/* promiscuous mode implies allmulticast so
+				 * that VSIs that are in promiscuous mode are
+				 * subscribed to multicast packets coming to
+				 * the port
+				 */
+				err = ice_set_promisc(vsi,
+						      ICE_MCAST_PROMISC_BITS);
+				if (err)
+					goto out_promisc;
 			}
 		} else {
 			/* Clear Rx filter to remove traffic from wire */
@@ -430,6 +444,18 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 				    NETIF_F_HW_VLAN_CTAG_FILTER)
 					vlan_ops->ena_rx_filtering(vsi);
 			}
+
+			/* disable allmulti here, but only if allmulti is not
+			 * still enabled for the netdev
+			 */
+			if (!(vsi->current_netdev_flags & IFF_ALLMULTI)) {
+				err = ice_clear_promisc(vsi,
+							ICE_MCAST_PROMISC_BITS);
+				if (err) {
+					netdev_err(netdev, "Error %d clearing multicast promiscuous on VSI %i\n",
+						   err, vsi->vsi_num);
+				}
+			}
 		}
 	}
 	goto exit;

