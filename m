Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E28763587D
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236870AbiKWJ60 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:58:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236895AbiKWJ5i (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:57:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E844240
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:52:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49524B81EF0
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:52:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7455CC433B5;
        Wed, 23 Nov 2022 09:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197132;
        bh=OhKWinaIzpz10rv7EjrJXzgbVqN4jsKr8yLZMLHrmm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pHtZM/5iQs9dcjeXtkdF9OIp/XktUgteMGs9Vjaza11a5hJILqf0Elzkjcl02MmCL
         ssCJ4jyix4N3j6ueI52N+sytZApvw0+VhMJUdNFKKrPxTQbJ3PM1UN4w+qtKc/697A
         ZobkWmCQCzfIRJ226Iezjt9irvc28vJSy6m6Id08=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Hao Lan <lanhao@huawei.com>, Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 175/314] net: hns3: fix setting incorrect phy link ksettings for firmware in resetting process
Date:   Wed, 23 Nov 2022 09:50:20 +0100
Message-Id: <20221123084633.501013843@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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
index bd9a3b8f9e79..7e8a60f2401c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -3246,6 +3246,7 @@ static int hclge_update_tp_port_info(struct hclge_dev *hdev)
 	hdev->hw.mac.autoneg = cmd.base.autoneg;
 	hdev->hw.mac.speed = cmd.base.speed;
 	hdev->hw.mac.duplex = cmd.base.duplex;
+	linkmode_copy(hdev->hw.mac.advertising, cmd.link_modes.advertising);
 
 	return 0;
 }
@@ -11373,9 +11374,12 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
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



