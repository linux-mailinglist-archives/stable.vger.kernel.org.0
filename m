Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB8785900DD
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236620AbiHKPrk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236817AbiHKPqV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:46:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F3AB792CC;
        Thu, 11 Aug 2022 08:40:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 117AEB82123;
        Thu, 11 Aug 2022 15:40:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A9AC433C1;
        Thu, 11 Aug 2022 15:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232445;
        bh=7F4iQuSJJ0mLfpgwzKRLbI7Q2lZgvFXyXN65Y3imF9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UPh86ZovxPZTTV1wbNLRRuvoqua/6Ph5w4kjKoFcD0OXKSWsqL1TcwdSLD4I2xYig
         tixua5PbxDQy8WwKT4pWvJ86vrYB3I06e6XlmF4jn0/H0CJQeEEzLAFfGtPJUp6Hv5
         VgeqP6N03Ej2cUEsz7JhdiaG9u+f6/n9YCyuLFw8SOz1NOhj/1xwq+BJiCnWLuukzi
         lfkeDGt/R17vSLFwFVRlftKBkusRjzOPLcpejFCCK6FzGmuw3QAX4+UxVpfTcvZl2a
         zv5IKPY/NBUcvlkqEtFlpEEBe788iHG0gs9kkAWus9XRaeKL/h28nFDZylD6noDfEh
         GW81szo572iJg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 081/105] Bluetooth: hci_bcm: Add BCM4349B1 variant
Date:   Thu, 11 Aug 2022 11:28:05 -0400
Message-Id: <20220811152851.1520029-81-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ahmad Fatoum <a.fatoum@pengutronix.de>

[ Upstream commit 4f17c2b6694d0c4098f33b07ee3a696976940aa5 ]

The BCM4349B1, aka CYW/BCM89359, is a WiFi+BT chip and its Bluetooth
portion can be controlled over serial.

Two subversions are added for the chip, because ROM firmware reports
002.002.013 (at least for the chips I have here), while depending on
patchram firmware revision, either 002.002.013 or 002.002.014 is
reported.

Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btbcm.c   | 2 ++
 drivers/bluetooth/hci_bcm.c | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/bluetooth/btbcm.c b/drivers/bluetooth/btbcm.c
index 76fbb046bdbe..c9cda681c691 100644
--- a/drivers/bluetooth/btbcm.c
+++ b/drivers/bluetooth/btbcm.c
@@ -454,6 +454,8 @@ static const struct bcm_subver_table bcm_uart_subver_table[] = {
 	{ 0x6606, "BCM4345C5"	},	/* 003.006.006 */
 	{ 0x230f, "BCM4356A2"	},	/* 001.003.015 */
 	{ 0x220e, "BCM20702A1"  },	/* 001.002.014 */
+	{ 0x420d, "BCM4349B1"	},	/* 002.002.013 */
+	{ 0x420e, "BCM4349B1"	},	/* 002.002.014 */
 	{ 0x4217, "BCM4329B1"   },	/* 002.002.023 */
 	{ 0x6106, "BCM4359C0"	},	/* 003.001.006 */
 	{ 0x4106, "BCM4335A0"	},	/* 002.001.006 */
diff --git a/drivers/bluetooth/hci_bcm.c b/drivers/bluetooth/hci_bcm.c
index 785f445dd60d..d0a6f9ff4e08 100644
--- a/drivers/bluetooth/hci_bcm.c
+++ b/drivers/bluetooth/hci_bcm.c
@@ -1544,6 +1544,7 @@ static const struct of_device_id bcm_bluetooth_of_match[] = {
 	{ .compatible = "brcm,bcm43430a0-bt" },
 	{ .compatible = "brcm,bcm43430a1-bt" },
 	{ .compatible = "brcm,bcm43438-bt", .data = &bcm43438_device_data },
+	{ .compatible = "brcm,bcm4349-bt", .data = &bcm43438_device_data },
 	{ .compatible = "brcm,bcm43540-bt", .data = &bcm4354_device_data },
 	{ .compatible = "brcm,bcm4335a0" },
 	{ },
-- 
2.35.1

