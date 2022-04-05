Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D14E4F329A
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237029AbiDEI2v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239555AbiDEIUO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C860A1135;
        Tue,  5 Apr 2022 01:16:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82713B81A37;
        Tue,  5 Apr 2022 08:16:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E88FDC385A0;
        Tue,  5 Apr 2022 08:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146564;
        bh=GvjQIQS9ZDzPV3xPQVd2M8bsyUdqf+MAypI8OMpF5n4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D9pXgittca1YPYtGb5gBiHzH9yoSs8hd9o4s5mFyEyE4qoC5L9PLN2VjuwBxa0fCx
         XifLICHzmQiq+m1km+yF583tS5g5PvQ7o3QyXMKGESPVwq5J+DDOozOKxcewwubWG9
         b81g6DEO9Id4wZKXZta1x5Wi0dH4RbzY0kjD56h8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Shen <shenjian15@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0810/1126] net: hns3: refine the process when PF set VF VLAN
Date:   Tue,  5 Apr 2022 09:25:57 +0200
Message-Id: <20220405070431.342821953@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
index 9655a7d2c200..1fa13ae8c651 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8984,11 +8984,16 @@ static int hclge_set_vf_mac(struct hnae3_handle *handle, int vf,
 
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
@@ -10241,14 +10246,17 @@ static int hclge_set_vf_vlan_filter(struct hnae3_handle *handle, int vfid,
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
index 21442a9bb996..90c6197d9374 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2855,6 +2855,11 @@ static int hclgevf_reset_hdev(struct hclgevf_dev *hdev)
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



