Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF03E590379
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238091AbiHKQ1v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238086AbiHKQ0b (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:26:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB879F746;
        Thu, 11 Aug 2022 09:07:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C1E16141C;
        Thu, 11 Aug 2022 16:07:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDFC3C433C1;
        Thu, 11 Aug 2022 16:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660234077;
        bh=NkubZo0iuIEQ73DnsM8xDQ7qZoOJxp9SYFv4homoy7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JikCspoQKL1PqVRzOY5hZr9Q5oeE+U/f/VIYFjqqDfmP7fiBdDEIKGG0IgVYqps9L
         vwEmSYp3mjVSkMA+UgbQ3uP751hv0cEfTLqgSpdQx07bl4ngeLT/3CpPsL7s+JBV1H
         8my/9s+23e0E098p04fYlqibhuag3FtM3+bDgdhA+EekRo6Ua93/pHC1QpcSHZewOG
         L+F3JQkQ+AnCTr9gWOIPHoxp/JG5hsPvRfEj5rVoP2kdGe/PVI4cocHVy199P5tIVq
         BkHatS0HOmKzoyWvh0I6XF7LHS8qNA9/o4uaR5Ck+ouqQ6ksuHLqS4snbFLaG7/xwG
         GuydMMxu/kIJg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 38/46] Bluetooth: hci_bcm: Add BCM4349B1 variant
Date:   Thu, 11 Aug 2022 12:04:02 -0400
Message-Id: <20220811160421.1539956-38-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811160421.1539956-1-sashal@kernel.org>
References: <20220811160421.1539956-1-sashal@kernel.org>
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
index 1b9743b7f2ef..d263eac784da 100644
--- a/drivers/bluetooth/btbcm.c
+++ b/drivers/bluetooth/btbcm.c
@@ -401,6 +401,8 @@ static const struct bcm_subver_table bcm_uart_subver_table[] = {
 	{ 0x6606, "BCM4345C5"	},	/* 003.006.006 */
 	{ 0x230f, "BCM4356A2"	},	/* 001.003.015 */
 	{ 0x220e, "BCM20702A1"  },	/* 001.002.014 */
+	{ 0x420d, "BCM4349B1"	},	/* 002.002.013 */
+	{ 0x420e, "BCM4349B1"	},	/* 002.002.014 */
 	{ 0x4217, "BCM4329B1"   },	/* 002.002.023 */
 	{ 0x6106, "BCM4359C0"	},	/* 003.001.006 */
 	{ 0x4106, "BCM4335A0"	},	/* 002.001.006 */
diff --git a/drivers/bluetooth/hci_bcm.c b/drivers/bluetooth/hci_bcm.c
index 259a643377c2..574f84708859 100644
--- a/drivers/bluetooth/hci_bcm.c
+++ b/drivers/bluetooth/hci_bcm.c
@@ -1489,6 +1489,7 @@ static const struct of_device_id bcm_bluetooth_of_match[] = {
 	{ .compatible = "brcm,bcm4345c5" },
 	{ .compatible = "brcm,bcm4330-bt" },
 	{ .compatible = "brcm,bcm43438-bt", .data = &bcm43438_device_data },
+	{ .compatible = "brcm,bcm4349-bt", .data = &bcm43438_device_data },
 	{ .compatible = "brcm,bcm43540-bt", .data = &bcm4354_device_data },
 	{ .compatible = "brcm,bcm4335a0" },
 	{ },
-- 
2.35.1

