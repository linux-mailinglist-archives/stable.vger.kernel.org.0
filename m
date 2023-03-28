Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0362F6CC28E
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232604AbjC1OqV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232965AbjC1OqS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:46:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79BEBD31F
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:45:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17A89B81D6D
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:45:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82DACC433EF;
        Tue, 28 Mar 2023 14:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014751;
        bh=B/9BWI9GAlAa3cmOEndRqBH+kJ1FpGjQwaKA74ck7bQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1sURDc+ijK0LT5xe65OekVWD/To7+G9FOTLliAoGCLvjl2+vjUlCl/9zLDV/37Vzm
         +oRsJVby0pqDNlJPfWEaxjgjGMMzNr6bLv80RzShU0CdiKHviF6csY3P+VWQyfyE5V
         RZGfS7qvrw21MB4KgIkam0Pxf46DXEOkUeTFVQz0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ahmed Zaki <ahmed.zaki@intel.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 032/240] iavf: do not track VLAN 0 filters
Date:   Tue, 28 Mar 2023 16:39:55 +0200
Message-Id: <20230328142620.957004795@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
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
index 4b09785d2147a..01e73415dec5c 100644
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
index 365ca0c710c4a..0fea6b9b599fb 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -2446,8 +2446,6 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
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



