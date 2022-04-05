Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78B194F2BF4
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350646AbiDEJ7S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344163AbiDEJS2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:18:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20A315F8CB;
        Tue,  5 Apr 2022 02:04:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF54AB81BAE;
        Tue,  5 Apr 2022 09:04:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F9CBC385A0;
        Tue,  5 Apr 2022 09:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149489;
        bh=9EuO7UVHxSLp8WUNHOXpL3UyGhIzosuk62e3w+V64/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xfHW1cDCG601ngfhGGekvP6DsNj2cVHQD7/6NtApfAKKPK8CMD0SlAvsQPOeARMok
         ttuzmnn7ywzxxvPFZViJoj+c9gkORrRzezcdDYxurkbfLM0vS9SbZTrtbXF5g+sX6b
         Mckg6bLj6qppbc1rwey4+aksu1Q5j1alyvQyD6zg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0733/1017] net: hns3: refine the process when PF set VF VLAN
Date:   Tue,  5 Apr 2022 09:27:26 +0200
Message-Id: <20220405070416.024458185@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 190cd8a72b0181c543ecada6243be3a50636941b ]

Currently, when PF set VF VLAN, it sends notify mailbox to VF
if VF alive. VF stop its traffic, and send request mailbox
to PF, then PF updates VF VLAN. It's a bit complex. If VF is
killed before sending request, PF will not set VF VLAN without
any log.

This patch refines the process, PF can set VF VLAN direclty,
and then notify the VF. If VF is resetting at that time, the
notify may be dropped, so VF should query it after reset finished.

Fixes: 92f11ea177cd ("net: hns3: fix set port based VLAN issue for VF")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c         | 18 +++++++++++++-----
 .../hisilicon/hns3/hns3vf/hclgevf_main.c       |  5 +++++
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 9866e5c1a71b..cf3c798e5400 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -9449,11 +9449,16 @@ static int hclge_set_vf_mac(struct hnae3_handle *handle, int vf,
 
 	ether_addr_copy(vport->vf_info.mac, mac_addr);
 
+	/* there is a timewindow for PF to know VF unalive, it may
+	 * cause send mailbox fail, but it doesn't matter, VF will
+	 * query it when reinit.
+	 */
 	if (test_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state)) {
 		dev_info(&hdev->pdev->dev,
 			 "MAC of VF %d has been set to %s, and it will be reinitialized!\n",
 			 vf, format_mac_addr);
-		return hclge_inform_reset_assert_to_vf(vport);
+		(void)hclge_inform_reset_assert_to_vf(vport);
+		return 0;
 	}
 
 	dev_info(&hdev->pdev->dev, "MAC of VF %d has been set to %s\n",
@@ -10681,14 +10686,17 @@ static int hclge_set_vf_vlan_filter(struct hnae3_handle *handle, int vfid,
 		return ret;
 	}
 
-	/* for DEVICE_VERSION_V3, vf doesn't need to know about the port based
+	/* there is a timewindow for PF to know VF unalive, it may
+	 * cause send mailbox fail, but it doesn't matter, VF will
+	 * query it when reinit.
+	 * for DEVICE_VERSION_V3, vf doesn't need to know about the port based
 	 * VLAN state.
 	 */
 	if (ae_dev->dev_version < HNAE3_DEVICE_VERSION_V3 &&
 	    test_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state))
-		hclge_push_vf_port_base_vlan_info(&hdev->vport[0],
-						  vport->vport_id, state,
-						  &vlan_info);
+		(void)hclge_push_vf_port_base_vlan_info(&hdev->vport[0],
+							vport->vport_id,
+							state, &vlan_info);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 4d3d14b637c0..7e30bad08356 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -3344,6 +3344,11 @@ static int hclgevf_reset_hdev(struct hclgevf_dev *hdev)
 		return ret;
 	}
 
+	/* get current port based vlan state from PF */
+	ret = hclgevf_get_port_base_vlan_filter_state(hdev);
+	if (ret)
+		return ret;
+
 	set_bit(HCLGEVF_STATE_PROMISC_CHANGED, &hdev->state);
 
 	hclgevf_init_rxd_adv_layout(hdev);
-- 
2.34.1



