Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FEBEEEF78
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388631AbfKDV5n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:57:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:54154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388568AbfKDV5m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:57:42 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57DA821744;
        Mon,  4 Nov 2019 21:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904661;
        bh=pSHZH/4w3nOlLE17v+y+HwO+fJvTz+CXttg0x1Q+dhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qRQNMlEJZBhsc7sh97DdkwpBozT93sfnGv3k12wpkkHVA4tUMtrJf8WZze7zhWf8L
         IWPdg9E6UwZrvu/F2siB2lmRoGX0uk0OpVcFzg+nN2v5H47WCkoQfaSHe21YJmPrah
         GpdTN9QOVYI9r3yWU+9uDxMycXHBn/vvT/T43YBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 025/149] HID: i2c-hid: Ignore input report if theres no data present on Elan touchpanels
Date:   Mon,  4 Nov 2019 22:43:38 +0100
Message-Id: <20191104212137.534015856@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit 1475af255e18f35dc46f8a7acc18354c73d45149 ]

While using Elan touchpads, the message floods:
[  136.138487] i2c_hid i2c-DELL08D6:00: i2c_hid_get_input: incomplete report (14/65535)

Though the message flood is annoying, the device it self works without
any issue. I suspect that the device in question takes too much time to
pull the IRQ back to high after I2C host has done reading its data.

Since the host receives all useful data, let's ignore the input report
when there's no data.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/i2c-hid/i2c-hid-core.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index 8555ce7e737b3..2f940c1de6169 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -50,6 +50,7 @@
 #define I2C_HID_QUIRK_NO_IRQ_AFTER_RESET	BIT(1)
 #define I2C_HID_QUIRK_NO_RUNTIME_PM		BIT(2)
 #define I2C_HID_QUIRK_DELAY_AFTER_SLEEP		BIT(3)
+#define I2C_HID_QUIRK_BOGUS_IRQ			BIT(4)
 
 /* flags */
 #define I2C_HID_STARTED		0
@@ -179,6 +180,8 @@ static const struct i2c_hid_quirks {
 		I2C_HID_QUIRK_DELAY_AFTER_SLEEP },
 	{ USB_VENDOR_ID_LG, I2C_DEVICE_ID_LG_8001,
 		I2C_HID_QUIRK_NO_RUNTIME_PM },
+	{ USB_VENDOR_ID_ELAN, HID_ANY_ID,
+		 I2C_HID_QUIRK_BOGUS_IRQ },
 	{ 0, 0 }
 };
 
@@ -503,6 +506,12 @@ static void i2c_hid_get_input(struct i2c_hid *ihid)
 		return;
 	}
 
+	if (ihid->quirks & I2C_HID_QUIRK_BOGUS_IRQ && ret_size == 0xffff) {
+		dev_warn_once(&ihid->client->dev, "%s: IRQ triggered but "
+			      "there's no data\n", __func__);
+		return;
+	}
+
 	if ((ret_size > size) || (ret_size < 2)) {
 		dev_err(&ihid->client->dev, "%s: incomplete report (%d/%d)\n",
 			__func__, size, ret_size);
-- 
2.20.1



