Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7FC94F2814
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233467AbiDEIKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236093AbiDEIBT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:01:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D564549FB3;
        Tue,  5 Apr 2022 00:59:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87CC6B81B9C;
        Tue,  5 Apr 2022 07:59:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31C8C340EE;
        Tue,  5 Apr 2022 07:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145559;
        bh=X0G1GRfnpKv19esNmaAooFqK67HfZAdEUWwg/VnIFzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lZUwj26jd2uTVlmr/TfqTen4B0z9n8AE+loXP/8CEpiI3pCQg8d/ilS3CjXZGDauD
         /91MP3/CwNdHtfBhRAuwH84BwGuRaz9g+8gYh+Bo70RRaDUqMBZtZKtnjzTf3ZaHdQ
         p8xO9WMZus0oC33ms2guE8ytdOMcbv6fB6S9vFr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Mark Chen <mark-yw.chen@mediatek.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0449/1126] Bluetooth: mt7921s: fix btmtksdio_[drv|fw]_pmctrl()
Date:   Tue,  5 Apr 2022 09:19:56 +0200
Message-Id: <20220405070420.804121449@linuxfoundation.org>
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

[ Upstream commit 01ecc177b7d7ba055b79645e60e89385736ef2fc ]

According to the firmware behavior (even the oldest one in linux-firmware)

If the firmware is downloaded, MT7921S must rely on the additional mailbox
mechanism that resides in firmware to check if the device is the right
state for btmtksdio_mcu_[drv|fw]_pmctrl(). Otherwise, we still apply the
old way for that.

That is a necessary patch before we enable runtime pm for mt7921s as
default.

Fixes: c603bf1f94d0 ("Bluetooth: btmtksdio: add MT7921s Bluetooth support")
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Mark Chen <mark-yw.chen@mediatek.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtksdio.c | 38 +++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/bluetooth/btmtksdio.c b/drivers/bluetooth/btmtksdio.c
index cf757574fb63..72e00264d9f1 100644
--- a/drivers/bluetooth/btmtksdio.c
+++ b/drivers/bluetooth/btmtksdio.c
@@ -38,21 +38,25 @@ static bool enable_autosuspend;
 struct btmtksdio_data {
 	const char *fwname;
 	u16 chipid;
+	bool lp_mbox_supported;
 };
 
 static const struct btmtksdio_data mt7663_data = {
 	.fwname = FIRMWARE_MT7663,
 	.chipid = 0x7663,
+	.lp_mbox_supported = false,
 };
 
 static const struct btmtksdio_data mt7668_data = {
 	.fwname = FIRMWARE_MT7668,
 	.chipid = 0x7668,
+	.lp_mbox_supported = false,
 };
 
 static const struct btmtksdio_data mt7921_data = {
 	.fwname = FIRMWARE_MT7961,
 	.chipid = 0x7921,
+	.lp_mbox_supported = true,
 };
 
 static const struct sdio_device_id btmtksdio_table[] = {
@@ -90,8 +94,12 @@ MODULE_DEVICE_TABLE(sdio, btmtksdio_table);
 #define FW_MAILBOX_INT		BIT(15)
 #define RX_PKT_LEN		GENMASK(31, 16)
 
+#define MTK_REG_CSICR		0xc0
+#define CSICR_CLR_MBOX_ACK BIT(0)
 #define MTK_REG_PH2DSM0R	0xc4
 #define PH2DSM0R_DRIVER_OWN	BIT(0)
+#define MTK_REG_PD2HRM0R	0xdc
+#define PD2HRM0R_DRV_OWN	BIT(0)
 
 #define MTK_REG_CTDR		0x18
 
@@ -104,6 +112,7 @@ MODULE_DEVICE_TABLE(sdio, btmtksdio_table);
 #define BTMTKSDIO_TX_WAIT_VND_EVT	1
 #define BTMTKSDIO_HW_TX_READY		2
 #define BTMTKSDIO_FUNC_ENABLED		3
+#define BTMTKSDIO_PATCH_ENABLED		4
 
 struct mtkbtsdio_hdr {
 	__le16	len;
@@ -282,6 +291,11 @@ static u32 btmtksdio_drv_own_query(struct btmtksdio_dev *bdev)
 	return sdio_readl(bdev->func, MTK_REG_CHLPCR, NULL);
 }
 
+static u32 btmtksdio_drv_own_query_79xx(struct btmtksdio_dev *bdev)
+{
+	return sdio_readl(bdev->func, MTK_REG_PD2HRM0R, NULL);
+}
+
 static int btmtksdio_fw_pmctrl(struct btmtksdio_dev *bdev)
 {
 	u32 status;
@@ -289,6 +303,19 @@ static int btmtksdio_fw_pmctrl(struct btmtksdio_dev *bdev)
 
 	sdio_claim_host(bdev->func);
 
+	if (bdev->data->lp_mbox_supported &&
+	    test_bit(BTMTKSDIO_PATCH_ENABLED, &bdev->tx_state)) {
+		sdio_writel(bdev->func, CSICR_CLR_MBOX_ACK, MTK_REG_CSICR,
+			    &err);
+		err = readx_poll_timeout(btmtksdio_drv_own_query_79xx, bdev,
+					 status, !(status & PD2HRM0R_DRV_OWN),
+					 2000, 1000000);
+		if (err < 0) {
+			bt_dev_err(bdev->hdev, "mailbox ACK not cleared");
+			goto out;
+		}
+	}
+
 	/* Return ownership to the device */
 	sdio_writel(bdev->func, C_FW_OWN_REQ_SET, MTK_REG_CHLPCR, &err);
 	if (err < 0)
@@ -321,6 +348,12 @@ static int btmtksdio_drv_pmctrl(struct btmtksdio_dev *bdev)
 	err = readx_poll_timeout(btmtksdio_drv_own_query, bdev, status,
 				 status & C_COM_DRV_OWN, 2000, 1000000);
 
+	if (!err && bdev->data->lp_mbox_supported &&
+	    test_bit(BTMTKSDIO_PATCH_ENABLED, &bdev->tx_state))
+		err = readx_poll_timeout(btmtksdio_drv_own_query_79xx, bdev,
+					 status, status & PD2HRM0R_DRV_OWN,
+					 2000, 1000000);
+
 out:
 	sdio_release_host(bdev->func);
 
@@ -728,6 +761,7 @@ static int btmtksdio_func_query(struct hci_dev *hdev)
 
 static int mt76xx_setup(struct hci_dev *hdev, const char *fwname)
 {
+	struct btmtksdio_dev *bdev = hci_get_drvdata(hdev);
 	struct btmtk_hci_wmt_params wmt_params;
 	struct btmtk_tci_sleep tci_sleep;
 	struct sk_buff *skb;
@@ -788,6 +822,8 @@ static int mt76xx_setup(struct hci_dev *hdev, const char *fwname)
 		return err;
 	}
 
+	set_bit(BTMTKSDIO_PATCH_ENABLED, &bdev->tx_state);
+
 ignore_func_on:
 	/* Apply the low power environment setup */
 	tci_sleep.mode = 0x5;
@@ -810,6 +846,7 @@ static int mt76xx_setup(struct hci_dev *hdev, const char *fwname)
 
 static int mt79xx_setup(struct hci_dev *hdev, const char *fwname)
 {
+	struct btmtksdio_dev *bdev = hci_get_drvdata(hdev);
 	struct btmtk_hci_wmt_params wmt_params;
 	u8 param = 0x1;
 	int err;
@@ -835,6 +872,7 @@ static int mt79xx_setup(struct hci_dev *hdev, const char *fwname)
 
 	hci_set_msft_opcode(hdev, 0xFD30);
 	hci_set_aosp_capable(hdev);
+	set_bit(BTMTKSDIO_PATCH_ENABLED, &bdev->tx_state);
 
 	return err;
 }
-- 
2.34.1



