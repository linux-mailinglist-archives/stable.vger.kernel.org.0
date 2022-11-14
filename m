Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2AF5627F2F
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237542AbiKNM42 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:56:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237546AbiKNM4Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:56:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E1E27DF3
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:56:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B107561154
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:56:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A474AC4347C;
        Mon, 14 Nov 2022 12:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430582;
        bh=JJIMv1cd1d1Uz+wxvY+AKgWoCkySvogoIX2iyaRSJ2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=13gbBqkcbnb3FFE8UzKW5SYhzEBS8I0FTbsoao9fc1X5TZc98jpMaJ3WrCpWQoJIU
         cTJnYOJ+wbWp/kkszIPFji93qW1zxvmJA3zNOWr0Sx1pxfjFNa/NW51LB1tpzv4JDn
         8TFMIly/G/FMcHageWMImIYn4zbLvdMdIa03HTg0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 071/131] stmmac: dwmac-loongson: fix missing pci_disable_device() in loongson_dwmac_probe()
Date:   Mon, 14 Nov 2022 13:45:40 +0100
Message-Id: <20221114124451.716700452@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit fe5b3ce8b4377e543960220f539b989a927afd8a ]

Add missing pci_disable_device() in the error path in loongson_dwmac_probe().

Fixes: 30bba69d7db4 ("stmmac: pci: Add dwmac support for Loongson")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
index b18f1e24f4f3..bf6e9f3fe1ef 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
@@ -97,7 +97,7 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
 			continue;
 		ret = pcim_iomap_regions(pdev, BIT(0), pci_name(pdev));
 		if (ret)
-			return ret;
+			goto err_disable_device;
 		break;
 	}
 
@@ -108,7 +108,8 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
 	phy_mode = device_get_phy_mode(&pdev->dev);
 	if (phy_mode < 0) {
 		dev_err(&pdev->dev, "phy_mode not found\n");
-		return phy_mode;
+		ret = phy_mode;
+		goto err_disable_device;
 	}
 
 	plat->phy_interface = phy_mode;
@@ -149,6 +150,8 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
 
 err_disable_msi:
 	pci_disable_msi(pdev);
+err_disable_device:
+	pci_disable_device(pdev);
 	return ret;
 }
 
-- 
2.35.1



