Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5446563570B
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237832AbiKWJhR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:37:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237827AbiKWJg2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:36:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 224BED06D1
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:33:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B327161B44
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:33:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD87EC433C1;
        Wed, 23 Nov 2022 09:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196037;
        bh=h6RcCJ0KUtB4xR20WEzzdRdH8XAPh3qyfEa9OaExBEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I/OIza152aRA5xro8JlUD0fbil7j8PPytCYcZOnRtCF0BezG+riU4S4VcvnG6vYz7
         nZxxWEwvkPbmG88X5I1xFSGZ0aq3AOPEyg0jcXi5ruGPP3Rqz3KFMPmP8cayNYk7+b
         02KHlhfguR0VcFztD0VPwADwLYORXR9mypHSSs1Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Hao Lan <lanhao@huawei.com>, Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 094/181] net: hns3: fix setting incorrect phy link ksettings for firmware in resetting process
Date:   Wed, 23 Nov 2022 09:50:57 +0100
Message-Id: <20221123084606.386855905@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
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

From: Guangbin Huang <huangguangbin2@huawei.com>

[ Upstream commit 510d7b6ae842e59ee00d57e5f07ac15131b6d899 ]

Currently, if driver is in phy-imp(phy controlled by imp firmware) mode, as
driver did not update phy link ksettings after initialization process or
not update advertising when getting phy link ksettings from firmware, it
may set incorrect phy link ksettings for firmware in resetting process.
So fix it.

Fixes: f5f2b3e4dcc0 ("net: hns3: add support for imp-controlled PHYs")
Fixes: c5ef83cbb1e9 ("net: hns3: fix for phy_addr error in hclge_mac_mdio_config")
Fixes: 2312e050f42b ("net: hns3: Fix for deadlock problem occurring when unregistering ae_algo")
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Hao Lan <lanhao@huawei.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 15d10775a757..2102b38b9c35 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3172,6 +3172,7 @@ static int hclge_update_tp_port_info(struct hclge_dev *hdev)
 	hdev->hw.mac.autoneg = cmd.base.autoneg;
 	hdev->hw.mac.speed = cmd.base.speed;
 	hdev->hw.mac.duplex = cmd.base.duplex;
+	linkmode_copy(hdev->hw.mac.advertising, cmd.link_modes.advertising);
 
 	return 0;
 }
@@ -11669,9 +11670,12 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	if (ret)
 		goto err_msi_irq_uninit;
 
-	if (hdev->hw.mac.media_type == HNAE3_MEDIA_TYPE_COPPER &&
-	    !hnae3_dev_phy_imp_supported(hdev)) {
-		ret = hclge_mac_mdio_config(hdev);
+	if (hdev->hw.mac.media_type == HNAE3_MEDIA_TYPE_COPPER) {
+		if (hnae3_dev_phy_imp_supported(hdev))
+			ret = hclge_update_tp_port_info(hdev);
+		else
+			ret = hclge_mac_mdio_config(hdev);
+
 		if (ret)
 			goto err_msi_irq_uninit;
 	}
-- 
2.35.1



