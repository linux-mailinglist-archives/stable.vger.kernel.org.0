Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58AA16CC3B0
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233271AbjC1O42 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233593AbjC1O4Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:56:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8AF0E061
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:56:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55E8EB81D77
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:56:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C37FAC433D2;
        Tue, 28 Mar 2023 14:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015380;
        bh=mAHpkmi05QflHOCIMpQCMSwfagSYBGtmFIV6du/vM1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vMGuZxQuQZLrAzsNUK0OUbY75LNvn0JLaJkT7sbN1JnqYmXQ1sEbFWXP3jGWqmQJP
         Q1865d0RLQFkrXwooiYBm7eMSvYMb07HgFVgfz8HSr8V8CEGGyqa0lX5LIsAJIv6pq
         1AaVk2Vc7l1ppZ4y2cDQSWFzfHI52Ml6TJHGqPFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ahmed Zaki <ahmed.zaki@intel.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 028/224] iavf: do not track VLAN 0 filters
Date:   Tue, 28 Mar 2023 16:40:24 +0200
Message-Id: <20230328142618.482448206@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ahmed Zaki <ahmed.zaki@intel.com>

[ Upstream commit 964290ff32d132bf971d45b29f7de39756dab7c8 ]

When an interface with the maximum number of VLAN filters is brought up,
a spurious error is logged:

    [257.483082] 8021q: adding VLAN 0 to HW filter on device enp0s3
    [257.483094] iavf 0000:00:03.0 enp0s3: Max allowed VLAN filters 8. Remove existing VLANs or disable filtering via Ethtool if supported.

The VF driver complains that it cannot add the VLAN 0 filter.

On the other hand, the PF driver always adds VLAN 0 filter on VF
initialization. The VF does not need to ask the PF for that filter at
all.

Fix the error by not tracking VLAN 0 filters altogether. With that, the
check added by commit 0e710a3ffd0c ("iavf: Fix VF driver counting VLAN 0
filters") in iavf_virtchnl.c is useless and might be confusing if left as
it suggests that we track VLAN 0.

Fixes: 0e710a3ffd0c ("iavf: Fix VF driver counting VLAN 0 filters")
Signed-off-by: Ahmed Zaki <ahmed.zaki@intel.com>
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c     | 8 ++++++++
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c | 2 --
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 3dad834b9b8e5..41edcf9e154a3 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -893,6 +893,10 @@ static int iavf_vlan_rx_add_vid(struct net_device *netdev,
 {
 	struct iavf_adapter *adapter = netdev_priv(netdev);
 
+	/* Do not track VLAN 0 filter, always added by the PF on VF init */
+	if (!vid)
+		return 0;
+
 	if (!VLAN_FILTERING_ALLOWED(adapter))
 		return -EIO;
 
@@ -919,6 +923,10 @@ static int iavf_vlan_rx_kill_vid(struct net_device *netdev,
 {
 	struct iavf_adapter *adapter = netdev_priv(netdev);
 
+	/* We do not track VLAN 0 filter */
+	if (!vid)
+		return 0;
+
 	iavf_del_vlan(adapter, IAVF_VLAN(vid, be16_to_cpu(proto)));
 	if (proto == cpu_to_be16(ETH_P_8021Q))
 		clear_bit(vid, adapter->vsi.active_cvlans);
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 0752fd67c96e5..2c03ca01fdd9c 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -2438,8 +2438,6 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 		list_for_each_entry(f, &adapter->vlan_filter_list, list) {
 			if (f->is_new_vlan) {
 				f->is_new_vlan = false;
-				if (!f->vlan.vid)
-					continue;
 				if (f->vlan.tpid == ETH_P_8021Q)
 					set_bit(f->vlan.vid,
 						adapter->vsi.active_cvlans);
-- 
2.39.2



