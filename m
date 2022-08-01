Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7692586A62
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233947AbiHAMQV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234212AbiHAMPN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:15:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2301978DD1;
        Mon,  1 Aug 2022 04:58:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD5A4601BD;
        Mon,  1 Aug 2022 11:58:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAF1CC433C1;
        Mon,  1 Aug 2022 11:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659355094;
        bh=kylcY1j2D2eTbNQf+jHP542bF54FMmv/+lnUvabInZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fImbhH9LZGCKCSmWF6zoGGYoFTkk16QLGZLo2wesqUVpcPgEvIrWmt8fEtUl2lqNu
         XUwro3y5hXkCwhLECqHrMqlNEovqz8DupNUyVUGSjFKTvWnZREOfUae9d/qw5406tq
         USmh51oX4YhrNxjp6M0b8D1j6V6ZHHPpg7aM3lQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.18 30/88] ice: Fix VSIs unable to share unicast MAC
Date:   Mon,  1 Aug 2022 13:46:44 +0200
Message-Id: <20220801114139.402674669@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
References: <20220801114138.041018499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

commit 5c8e3c7ff3e7bd7b938659be704f75cc746b697f upstream.

The driver currently does not allow two VSIs in the same PF domain
to have the same unicast MAC address. This is incorrect in the sense
that a policy decision is being made in the driver when it must be
left to the user. This approach was causing issues when rebooting
the system with VFs spawned not being able to change their MAC addresses.
Such errors were present in dmesg:

[ 7921.068237] ice 0000:b6:00.2 ens2f2: Unicast MAC 6a:0d:e4:70:ca:d1 already
exists on this PF. Preventing setting VF 7 unicast MAC address to 6a:0d:e4:70:ca:d1

Fix that by removing this restriction. Doing this also allows
us to remove some additional code that's checking if a unicast MAC
filter already exists.

Fixes: 47ebc7b02485 ("ice: Check if unicast MAC exists before setting VF MAC")
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Marek Szlosek <marek.szlosek@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c  |    2 +
 drivers/net/ethernet/intel/ice/ice_sriov.c |   40 -----------------------------
 2 files changed, 2 insertions(+), 40 deletions(-)

--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4640,6 +4640,8 @@ ice_probe(struct pci_dev *pdev, const st
 		ice_set_safe_mode_caps(hw);
 	}
 
+	hw->ucast_shared = true;
+
 	err = ice_init_pf(pf);
 	if (err) {
 		dev_err(dev, "ice_init_pf failed: %d\n", err);
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -1310,39 +1310,6 @@ out_put_vf:
 }
 
 /**
- * ice_unicast_mac_exists - check if the unicast MAC exists on the PF's switch
- * @pf: PF used to reference the switch's rules
- * @umac: unicast MAC to compare against existing switch rules
- *
- * Return true on the first/any match, else return false
- */
-static bool ice_unicast_mac_exists(struct ice_pf *pf, u8 *umac)
-{
-	struct ice_sw_recipe *mac_recipe_list =
-		&pf->hw.switch_info->recp_list[ICE_SW_LKUP_MAC];
-	struct ice_fltr_mgmt_list_entry *list_itr;
-	struct list_head *rule_head;
-	struct mutex *rule_lock; /* protect MAC filter list access */
-
-	rule_head = &mac_recipe_list->filt_rules;
-	rule_lock = &mac_recipe_list->filt_rule_lock;
-
-	mutex_lock(rule_lock);
-	list_for_each_entry(list_itr, rule_head, list_entry) {
-		u8 *existing_mac = &list_itr->fltr_info.l_data.mac.mac_addr[0];
-
-		if (ether_addr_equal(existing_mac, umac)) {
-			mutex_unlock(rule_lock);
-			return true;
-		}
-	}
-
-	mutex_unlock(rule_lock);
-
-	return false;
-}
-
-/**
  * ice_set_vf_mac
  * @netdev: network interface device structure
  * @vf_id: VF identifier
@@ -1376,13 +1343,6 @@ int ice_set_vf_mac(struct net_device *ne
 	if (ret)
 		goto out_put_vf;
 
-	if (ice_unicast_mac_exists(pf, mac)) {
-		netdev_err(netdev, "Unicast MAC %pM already exists on this PF. Preventing setting VF %u unicast MAC address to %pM\n",
-			   mac, vf_id, mac);
-		ret = -EINVAL;
-		goto out_put_vf;
-	}
-
 	mutex_lock(&vf->cfg_lock);
 
 	/* VF is notified of its new MAC via the PF's response to the


