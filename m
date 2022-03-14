Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE93D4D83EF
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240922AbiCNMWX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242230AbiCNMSw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:18:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8AEF4707F;
        Mon, 14 Mar 2022 05:13:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C3C2B80DFC;
        Mon, 14 Mar 2022 12:13:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D71C340E9;
        Mon, 14 Mar 2022 12:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647260025;
        bh=P6Y//lgQvQIIUKox+h4ug/qJJmYj1NRzE9h67itRfPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AUgeJfv/jIagwRZ4sdBQA9p0pHq43SWU1xW1a9hShN2q1RUrxDLxsqyOnO/qkYG9t
         7J3JLxrSBwSLuqzCqcksX0bWhFCxH7/eLyTpnytVsJTJSNnWbiF6ucJysnewYAWXvg
         wOzaRqSXZM6dmSG/+j8yo8sR5Jvm2+j/AH9GVYUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Ertman <david.m.ertman@intel.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH 5.16 036/121] ice: Fix error with handling of bonding MTU
Date:   Mon, 14 Mar 2022 12:53:39 +0100
Message-Id: <20220314112745.136746753@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
References: <20220314112744.120491875@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

[ Upstream commit 97b0129146b1544bbb0773585327896da3bb4e0a ]

When a bonded interface is destroyed, .ndo_change_mtu can be called
during the tear-down process while the RTNL lock is held.  This is a
problem since the auxiliary driver linked to the LAN driver needs to be
notified of the MTU change, and this requires grabbing a device_lock on
the auxiliary_device's dev.  Currently this is being attempted in the
same execution context as the call to .ndo_change_mtu which is causing a
dead-lock.

Move the notification of the changed MTU to a separate execution context
(watchdog service task) and eliminate the "before" notification.

Fixes: 348048e724a0e ("ice: Implement iidc operations")
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Tested-by: Jonathan Toppins <jtoppins@redhat.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice.h      |  1 +
 drivers/net/ethernet/intel/ice/ice_main.c | 29 +++++++++++------------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index b067dd9c71e7..fa91896ae699 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -483,6 +483,7 @@ enum ice_pf_flags {
 	ICE_FLAG_MDD_AUTO_RESET_VF,
 	ICE_FLAG_LINK_LENIENT_MODE_ENA,
 	ICE_FLAG_PLUG_AUX_DEV,
+	ICE_FLAG_MTU_CHANGED,
 	ICE_PF_FLAGS_NBITS		/* must be last */
 };
 
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 8ee778aaa800..fc04b4cf4ae0 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2240,6 +2240,17 @@ static void ice_service_task(struct work_struct *work)
 	if (test_and_clear_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags))
 		ice_plug_aux_dev(pf);
 
+	if (test_and_clear_bit(ICE_FLAG_MTU_CHANGED, pf->flags)) {
+		struct iidc_event *event;
+
+		event = kzalloc(sizeof(*event), GFP_KERNEL);
+		if (event) {
+			set_bit(IIDC_EVENT_AFTER_MTU_CHANGE, event->type);
+			ice_send_event_to_aux(pf, event);
+			kfree(event);
+		}
+	}
+
 	ice_clean_adminq_subtask(pf);
 	ice_check_media_subtask(pf);
 	ice_check_for_hang_subtask(pf);
@@ -6822,7 +6833,6 @@ static int ice_change_mtu(struct net_device *netdev, int new_mtu)
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_pf *pf = vsi->back;
-	struct iidc_event *event;
 	u8 count = 0;
 	int err = 0;
 
@@ -6857,14 +6867,6 @@ static int ice_change_mtu(struct net_device *netdev, int new_mtu)
 		return -EBUSY;
 	}
 
-	event = kzalloc(sizeof(*event), GFP_KERNEL);
-	if (!event)
-		return -ENOMEM;
-
-	set_bit(IIDC_EVENT_BEFORE_MTU_CHANGE, event->type);
-	ice_send_event_to_aux(pf, event);
-	clear_bit(IIDC_EVENT_BEFORE_MTU_CHANGE, event->type);
-
 	netdev->mtu = (unsigned int)new_mtu;
 
 	/* if VSI is up, bring it down and then back up */
@@ -6872,21 +6874,18 @@ static int ice_change_mtu(struct net_device *netdev, int new_mtu)
 		err = ice_down(vsi);
 		if (err) {
 			netdev_err(netdev, "change MTU if_down err %d\n", err);
-			goto event_after;
+			return err;
 		}
 
 		err = ice_up(vsi);
 		if (err) {
 			netdev_err(netdev, "change MTU if_up err %d\n", err);
-			goto event_after;
+			return err;
 		}
 	}
 
 	netdev_dbg(netdev, "changed MTU to %d\n", new_mtu);
-event_after:
-	set_bit(IIDC_EVENT_AFTER_MTU_CHANGE, event->type);
-	ice_send_event_to_aux(pf, event);
-	kfree(event);
+	set_bit(ICE_FLAG_MTU_CHANGED, pf->flags);
 
 	return err;
 }
-- 
2.34.1



