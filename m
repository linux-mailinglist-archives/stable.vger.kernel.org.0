Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BECB63DF7E
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbiK3Srm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:47:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbiK3Srl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:47:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C15438BE
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:47:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F18F61D73
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:47:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE15C433C1;
        Wed, 30 Nov 2022 18:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834058;
        bh=tvvS7rGrVp9+aAGXSNka3A9XunDVMnGZzk6TWHgY8Yw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1ADR4l+IoEwoy9xJ4JPknowv8h0rlfa8ggfvcWX7wlUfeUVmRD4Ye+RjGt48EXLBw
         D+14beTW/wzQWBQP4p5PXxnpMymEm5AJCevwQxAXM77Sx8pFIl+GIcU9bOdzlJ4m9x
         WB9GD6wRDiqu2gkOzPFUqgBLHZRbswj6BY9K0n28=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Stefan Assmann <sassmann@kpanic.de>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 086/289] iavf: remove INITIAL_MAC_SET to allow gARP to work properly
Date:   Wed, 30 Nov 2022 19:21:11 +0100
Message-Id: <20221130180546.095313002@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Assmann <sassmann@kpanic.de>

[ Upstream commit bb861c14f1b8cb9cbf03a132db7f22ec4e692b91 ]

IAVF_FLAG_INITIAL_MAC_SET prevents waiting on iavf_is_mac_set_handled()
the first time the MAC is set. This breaks gratuitous ARP because the
MAC address has not been updated yet when the gARP packet is sent out.

Current behaviour:
$ echo 1 > /sys/class/net/ens4f0/device/sriov_numvfs
iavf 0000:88:02.0: MAC address: ee:04:19:14:ec:ea
$ ip addr add 192.168.1.1/24 dev ens4f0v0
$ ip link set dev ens4f0v0 up
$ echo 1 > /proc/sys/net/ipv4/conf/ens4f0v0/arp_notify
$ ip link set ens4f0v0 addr 00:11:22:33:44:55
07:23:41.676611 ee:04:19:14:ec:ea > ff:ff:ff:ff:ff:ff, ethertype ARP (0x0806), length 42: Request who-has 192.168.1.1 tell 192.168.1.1, length 28

With IAVF_FLAG_INITIAL_MAC_SET removed:
$ echo 1 > /sys/class/net/ens4f0/device/sriov_numvfs
iavf 0000:88:02.0: MAC address: 3e:8a:16:a2:37:6d
$ ip addr add 192.168.1.1/24 dev ens4f0v0
$ ip link set dev ens4f0v0 up
$ echo 1 > /proc/sys/net/ipv4/conf/ens4f0v0/arp_notify
$ ip link set ens4f0v0 addr 00:11:22:33:44:55
07:28:01.836608 00:11:22:33:44:55 > ff:ff:ff:ff:ff:ff, ethertype ARP (0x0806), length 42: Request who-has 192.168.1.1 tell 192.168.1.1, length 28

Fixes: 35a2443d0910 ("iavf: Add waiting for response from PF in set mac")
Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf.h      | 1 -
 drivers/net/ethernet/intel/iavf/iavf_main.c | 8 --------
 2 files changed, 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 3f6187c16424..0d1bab4ac1b0 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -298,7 +298,6 @@ struct iavf_adapter {
 #define IAVF_FLAG_QUEUES_DISABLED		BIT(17)
 #define IAVF_FLAG_SETUP_NETDEV_FEATURES		BIT(18)
 #define IAVF_FLAG_REINIT_MSIX_NEEDED		BIT(20)
-#define IAVF_FLAG_INITIAL_MAC_SET		BIT(23)
 /* duplicates for common code */
 #define IAVF_FLAG_DCB_ENABLED			0
 	/* flags for admin queue service task */
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index f59b725785eb..005bb8378c76 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1087,12 +1087,6 @@ static int iavf_set_mac(struct net_device *netdev, void *p)
 	if (ret)
 		return ret;
 
-	/* If this is an initial set MAC during VF spawn do not wait */
-	if (adapter->flags & IAVF_FLAG_INITIAL_MAC_SET) {
-		adapter->flags &= ~IAVF_FLAG_INITIAL_MAC_SET;
-		return 0;
-	}
-
 	ret = wait_event_interruptible_timeout(adapter->vc_waitqueue,
 					       iavf_is_mac_set_handled(netdev, addr->sa_data),
 					       msecs_to_jiffies(2500));
@@ -2605,8 +2599,6 @@ static void iavf_init_config_adapter(struct iavf_adapter *adapter)
 		ether_addr_copy(netdev->perm_addr, adapter->hw.mac.addr);
 	}
 
-	adapter->flags |= IAVF_FLAG_INITIAL_MAC_SET;
-
 	adapter->tx_desc_count = IAVF_DEFAULT_TXD;
 	adapter->rx_desc_count = IAVF_DEFAULT_RXD;
 	err = iavf_init_interrupt_scheme(adapter);
-- 
2.35.1



