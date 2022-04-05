Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28B554F27B8
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232688AbiDEIIM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236084AbiDEIBR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:01:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5225A49FB3;
        Tue,  5 Apr 2022 00:59:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2842B81B7F;
        Tue,  5 Apr 2022 07:59:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623D5C340EE;
        Tue,  5 Apr 2022 07:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145556;
        bh=V6Suz//XJZMYQ70bJZmNicQGPlgpqpYOtVsGgnsQ4/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0FNYJcsX6MWgJ8US4ofHT04ZKPp/BE31QyIOVcAKG31c2sGV8i3EPSzBX7r1T9iGC
         LcvmrqbBAKOGImSypIeChhRtAENH7wYWBMaDaL/IiXLB/Lo+2oTz6CpRb9y8e1M58X
         XHMgnwunb2hiygg4HCikAMR5yMb0dXyKu28YXhs8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Mark Chen <mark-yw.chen@mediatek.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0448/1126] Bluetooth: btmtksdio: refactor btmtksdio_runtime_[suspend|resume]()
Date:   Tue,  5 Apr 2022 09:19:55 +0200
Message-Id: <20220405070420.774164414@linuxfoundation.org>
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

From: Mark Chen <mark-yw.chen@mediatek.com>

[ Upstream commit c7e301d7c85544607ccc52ca5f26d20c59485342 ]

Refactor btmtksdio_runtime_[suspend|resume]() to create the common
funcitons btmtksdio_[fw|drv]_pmctrl() shared with btmtksdio_[open|close]()
to avoid the redundant code as well.

This is also a prerequisite patch for the incoming patches.

Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Mark Chen <mark-yw.chen@mediatek.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtksdio.c | 94 ++++++++++++++++++++---------------
 1 file changed, 53 insertions(+), 41 deletions(-)

diff --git a/drivers/bluetooth/btmtksdio.c b/drivers/bluetooth/btmtksdio.c
index c05578b52d33..cf757574fb63 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -282,6 +282,54 @@ static u32 btmtksdio_drv_own_query(struct btmtksdio_dev *bdev)
 	return sdio_readl(bdev->func, MTK_REG_CHLPCR, NULL);
 }
 
+static int btmtksdio_fw_pmctrl(struct btmtksdio_dev *bdev)
+{
+	u32 status;
+	int err;
+
+	sdio_claim_host(bdev->func);
+
+	/* Return ownership to the device */
+	sdio_writel(bdev->func, C_FW_OWN_REQ_SET, MTK_REG_CHLPCR, &err);
+	if (err < 0)
+		goto out;
+
+	err = readx_poll_timeout(btmtksdio_drv_own_query, bdev, status,
+				 !(status & C_COM_DRV_OWN), 2000, 1000000);
+
+out:
+	sdio_release_host(bdev->func);
+
+	if (err < 0)
+		bt_dev_err(bdev->hdev, "Cannot return ownership to device");
+
+	return err;
+}
+
+static int btmtksdio_drv_pmctrl(struct btmtksdio_dev *bdev)
+{
+	u32 status;
+	int err;
+
+	sdio_claim_host(bdev->func);
+
+	/* Get ownership from the device */
+	sdio_writel(bdev->func, C_FW_OWN_REQ_CLR, MTK_REG_CHLPCR, &err);
+	if (err < 0)
+		goto out;
+
+	err = readx_poll_timeout(btmtksdio_drv_own_query, bdev, status,
+				 status & C_COM_DRV_OWN, 2000, 1000000);
+
+out:
+	sdio_release_host(bdev->func);
+
+	if (err < 0)
+		bt_dev_err(bdev->hdev, "Cannot get ownership from device");
+
+	return err;
+}
+
 static int btmtksdio_recv_event(struct hci_dev *hdev, struct sk_buff *skb)
 {
 	struct btmtksdio_dev *bdev = hci_get_drvdata(hdev);
@@ -541,7 +589,7 @@ static void btmtksdio_interrupt(struct sdio_func *func)
 static int btmtksdio_open(struct hci_dev *hdev)
 {
 	struct btmtksdio_dev *bdev = hci_get_drvdata(hdev);
-	u32 status, val;
+	u32 val;
 	int err;
 
 	sdio_claim_host(bdev->func);
@@ -552,18 +600,10 @@ static int btmtksdio_open(struct hci_dev *hdev)
 
 	set_bit(BTMTKSDIO_FUNC_ENABLED, &bdev->tx_state);
 
-	/* Get ownership from the device */
-	sdio_writel(bdev->func, C_FW_OWN_REQ_CLR, MTK_REG_CHLPCR, &err);
+	err = btmtksdio_drv_pmctrl(bdev);
 	if (err < 0)
 		goto err_disable_func;
 
-	err = readx_poll_timeout(btmtksdio_drv_own_query, bdev, status,
-				 status & C_COM_DRV_OWN, 2000, 1000000);
-	if (err < 0) {
-		bt_dev_err(bdev->hdev, "Cannot get ownership from device");
-		goto err_disable_func;
-	}
-
 	/* Disable interrupt & mask out all interrupt sources */
 	sdio_writel(bdev->func, C_INT_EN_CLR, MTK_REG_CHLPCR, &err);
 	if (err < 0)
@@ -633,8 +673,6 @@ static int btmtksdio_open(struct hci_dev *hdev)
 static int btmtksdio_close(struct hci_dev *hdev)
 {
 	struct btmtksdio_dev *bdev = hci_get_drvdata(hdev);
-	u32 status;
-	int err;
 
 	sdio_claim_host(bdev->func);
 
@@ -645,13 +683,7 @@ static int btmtksdio_close(struct hci_dev *hdev)
 
 	cancel_work_sync(&bdev->txrx_work);
 
-	/* Return ownership to the device */
-	sdio_writel(bdev->func, C_FW_OWN_REQ_SET, MTK_REG_CHLPCR, NULL);
-
-	err = readx_poll_timeout(btmtksdio_drv_own_query, bdev, status,
-				 !(status & C_COM_DRV_OWN), 2000, 1000000);
-	if (err < 0)
-		bt_dev_err(bdev->hdev, "Cannot return ownership to device");
+	btmtksdio_fw_pmctrl(bdev);
 
 	clear_bit(BTMTKSDIO_FUNC_ENABLED, &bdev->tx_state);
 	sdio_disable_func(bdev->func);
@@ -1077,7 +1109,6 @@ static int btmtksdio_runtime_suspend(struct device *dev)
 {
 	struct sdio_func *func = dev_to_sdio_func(dev);
 	struct btmtksdio_dev *bdev;
-	u32 status;
 	int err;
 
 	bdev = sdio_get_drvdata(func);
@@ -1089,19 +1120,10 @@ static int btmtksdio_runtime_suspend(struct device *dev)
 
 	sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
 
-	sdio_claim_host(bdev->func);
-
-	sdio_writel(bdev->func, C_FW_OWN_REQ_SET, MTK_REG_CHLPCR, &err);
-	if (err < 0)
-		goto out;
+	err = btmtksdio_fw_pmctrl(bdev);
 
-	err = readx_poll_timeout(btmtksdio_drv_own_query, bdev, status,
-				 !(status & C_COM_DRV_OWN), 2000, 1000000);
-out:
 	bt_dev_info(bdev->hdev, "status (%d) return ownership to device", err);
 
-	sdio_release_host(bdev->func);
-
 	return err;
 }
 
@@ -1109,7 +1131,6 @@ static int btmtksdio_runtime_resume(struct device *dev)
 {
 	struct sdio_func *func = dev_to_sdio_func(dev);
 	struct btmtksdio_dev *bdev;
-	u32 status;
 	int err;
 
 	bdev = sdio_get_drvdata(func);
@@ -1119,19 +1140,10 @@ static int btmtksdio_runtime_resume(struct device *dev)
 	if (!test_bit(BTMTKSDIO_FUNC_ENABLED, &bdev->tx_state))
 		return 0;
 
-	sdio_claim_host(bdev->func);
-
-	sdio_writel(bdev->func, C_FW_OWN_REQ_CLR, MTK_REG_CHLPCR, &err);
-	if (err < 0)
-		goto out;
+	err = btmtksdio_drv_pmctrl(bdev);
 
-	err = readx_poll_timeout(btmtksdio_drv_own_query, bdev, status,
-				 status & C_COM_DRV_OWN, 2000, 1000000);
-out:
 	bt_dev_info(bdev->hdev, "status (%d) get ownership from device", err);
 
-	sdio_release_host(bdev->func);
-
 	return err;
 }
 
-- 
2.34.1



