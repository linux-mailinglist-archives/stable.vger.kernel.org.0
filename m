Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 528386500BA
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbiLRQSO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:18:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231853AbiLRQRH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:17:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C371116A;
        Sun, 18 Dec 2022 08:07:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFAD460DC8;
        Sun, 18 Dec 2022 16:07:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D421C433D2;
        Sun, 18 Dec 2022 16:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379654;
        bh=zf7RAbo9htvu/+5dLGrdZRXxBzlJZ32Qyt64KwWEkBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nVj96XpiH3n+dsROyJi9idQTVqdCzdbjWmEtV6rIsJmum5MnxGTlz412Q7UJ6AvCJ
         thP7w6dY8YWu5CPPDgoxzo4tyqB3jz9a8t7toqH65osBqLm31OIfpnzOXK6uMmB/2L
         d/PiJr65ZfBznIO60xiaN4PlbjC6RPSa3YtL28oUavQ7JFe3m3JFQ1enXZg49oeQSj
         jryWiZWNvMb4zoy796KZrOcaYXKuhbJ81fUzbm5L91tIXHj5dcHQ+/lkTmnEv/SKnY
         ZGv4ZZjIgRtnhAWaayM7aKII8eSzCvzWwQnTlonJ551CqCJ/U4gthegTE+ZOqYKFbA
         LMLL3xv/WXScA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 83/85] Bluetooth: hci_bcm: Add CYW4373A0 support
Date:   Sun, 18 Dec 2022 11:01:40 -0500
Message-Id: <20221218160142.925394-83-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218160142.925394-1-sashal@kernel.org>
References: <20221218160142.925394-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 02d056a3404e20245a69dcb4022a0930085fc5ec ]

CYW4373A0 is a Wi-Fi + Bluetooth combo device from Cypress.
This chip is present e.g. on muRata 2AE module.

This chip has additional quirk where the HCI command 0xfc45, used on
older chips to switch UART clock from 24 MHz to 48 MHz, to support
baudrates over 3 Mbdps, is no longer recognized by this newer chip.
This newer chip can configure the 4 Mbdps baudrate without the need
to issue HCI command 0xfc45, so add flag to indicate this and do not
issue the command on this chip to avoid failure to set 4 Mbdps baud
rate.

It is not clear whether there is a way to determine which chip does
and which chip does not support the HCI command 0xfc45, other than
trial and error.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_bcm.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/hci_bcm.c b/drivers/bluetooth/hci_bcm.c
index d7e0b75db8a6..2b6c0e1922cb 100644
--- a/drivers/bluetooth/hci_bcm.c
+++ b/drivers/bluetooth/hci_bcm.c
@@ -53,11 +53,13 @@
  * struct bcm_device_data - device specific data
  * @no_early_set_baudrate: Disallow set baudrate before driver setup()
  * @drive_rts_on_open: drive RTS signal on ->open() when platform requires it
+ * @no_uart_clock_set: UART clock set command for >3Mbps mode is unavailable
  * @max_autobaud_speed: max baudrate supported by device in autobaud mode
  */
 struct bcm_device_data {
 	bool	no_early_set_baudrate;
 	bool	drive_rts_on_open;
+	bool	no_uart_clock_set;
 	u32	max_autobaud_speed;
 };
 
@@ -100,6 +102,7 @@ struct bcm_device_data {
  * @is_suspended: whether flow control is currently disabled
  * @no_early_set_baudrate: don't set_baudrate before setup()
  * @drive_rts_on_open: drive RTS signal on ->open() when platform requires it
+ * @no_uart_clock_set: UART clock set command for >3Mbps mode is unavailable
  * @pcm_int_params: keep the initial PCM configuration
  * @use_autobaud_mode: start Bluetooth device in autobaud mode
  * @max_autobaud_speed: max baudrate supported by device in autobaud mode
@@ -140,6 +143,7 @@ struct bcm_device {
 #endif
 	bool			no_early_set_baudrate;
 	bool			drive_rts_on_open;
+	bool			no_uart_clock_set;
 	bool			use_autobaud_mode;
 	u8			pcm_int_params[5];
 	u32			max_autobaud_speed;
@@ -172,10 +176,11 @@ static inline void host_set_baudrate(struct hci_uart *hu, unsigned int speed)
 static int bcm_set_baudrate(struct hci_uart *hu, unsigned int speed)
 {
 	struct hci_dev *hdev = hu->hdev;
+	struct bcm_data *bcm = hu->priv;
 	struct sk_buff *skb;
 	struct bcm_update_uart_baud_rate param;
 
-	if (speed > 3000000) {
+	if (speed > 3000000 && !bcm->dev->no_uart_clock_set) {
 		struct bcm_write_uart_clock_setting clock;
 
 		clock.type = BCM_UART_CLOCK_48MHZ;
@@ -1529,6 +1534,7 @@ static int bcm_serdev_probe(struct serdev_device *serdev)
 		bcmdev->max_autobaud_speed = data->max_autobaud_speed;
 		bcmdev->no_early_set_baudrate = data->no_early_set_baudrate;
 		bcmdev->drive_rts_on_open = data->drive_rts_on_open;
+		bcmdev->no_uart_clock_set = data->no_uart_clock_set;
 	}
 
 	return hci_uart_register_device(&bcmdev->serdev_hu, &bcm_proto);
@@ -1550,6 +1556,10 @@ static struct bcm_device_data bcm43438_device_data = {
 	.drive_rts_on_open = true,
 };
 
+static struct bcm_device_data cyw4373a0_device_data = {
+	.no_uart_clock_set = true,
+};
+
 static struct bcm_device_data cyw55572_device_data = {
 	.max_autobaud_speed = 921600,
 };
@@ -1566,6 +1576,7 @@ static const struct of_device_id bcm_bluetooth_of_match[] = {
 	{ .compatible = "brcm,bcm4349-bt", .data = &bcm43438_device_data },
 	{ .compatible = "brcm,bcm43540-bt", .data = &bcm4354_device_data },
 	{ .compatible = "brcm,bcm4335a0" },
+	{ .compatible = "cypress,cyw4373a0-bt", .data = &cyw4373a0_device_data },
 	{ .compatible = "infineon,cyw55572-bt", .data = &cyw55572_device_data },
 	{ },
 };
-- 
2.35.1

