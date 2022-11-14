Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 608B4627F59
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237591AbiKNM6J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:58:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237612AbiKNM6I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:58:08 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE6B27DEB
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:58:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A2789CE0FFA
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:58:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 625BDC433C1;
        Mon, 14 Nov 2022 12:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430681;
        bh=pbjHkRa32eCxvtsv1gRPCfndlC5deERTDpYYYAbdaQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=clj9k/1nz8RfQkmhMcRDI80P40hrvxAEl+BHk0ZmCW74roYWozbkXRX/tGsRvzJFi
         RNgRzBhyPZ1TJ+RuvAfiKRmZL0ICJbx6B4/DmkVYw3azr+8A2xXpWO5HuKs4Caf8kG
         4NyEMS3dNoEzXojvk6CZzBlVuqZv1oiEcO5yYyyM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 070/131] stmmac: dwmac-loongson: fix missing pci_disable_msi() while module exiting
Date:   Mon, 14 Nov 2022 13:45:39 +0100
Message-Id: <20221114124451.669537752@linuxfoundation.org>
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

[ Upstream commit f2d45fdf9a0ed2c94c01c422a0d0add8ffd42099 ]

pci_enable_msi() has been called in loongson_dwmac_probe(),
so pci_disable_msi() needs be called in remove path and error
path of probe().

Fixes: 30bba69d7db4 ("stmmac: pci: Add dwmac support for Loongson")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/dwmac-loongson.c    | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
index 220bb454626c..b18f1e24f4f3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
@@ -125,6 +125,7 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
 	if (res.irq < 0) {
 		dev_err(&pdev->dev, "IRQ macirq not found\n");
 		ret = -ENODEV;
+		goto err_disable_msi;
 	}
 
 	res.wol_irq = of_irq_get_byname(np, "eth_wake_irq");
@@ -137,9 +138,18 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
 	if (res.lpi_irq < 0) {
 		dev_err(&pdev->dev, "IRQ eth_lpi not found\n");
 		ret = -ENODEV;
+		goto err_disable_msi;
 	}
 
-	return stmmac_dvr_probe(&pdev->dev, plat, &res);
+	ret = stmmac_dvr_probe(&pdev->dev, plat, &res);
+	if (ret)
+		goto err_disable_msi;
+
+	return ret;
+
+err_disable_msi:
+	pci_disable_msi(pdev);
+	return ret;
 }
 
 static void loongson_dwmac_remove(struct pci_dev *pdev)
@@ -155,6 +165,7 @@ static void loongson_dwmac_remove(struct pci_dev *pdev)
 		break;
 	}
 
+	pci_disable_msi(pdev);
 	pci_disable_device(pdev);
 }
 
-- 
2.35.1



