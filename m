Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3776B2FC6CA
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 02:29:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730685AbhATB3K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 20:29:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:47266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730322AbhATB26 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:28:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3FF6233E2;
        Wed, 20 Jan 2021 01:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611106037;
        bh=ZOvAljMvs8VIWRqWx7zqymNFNQ1t+YE93tmohaZ8N8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EN7JoJzg7kBndwGp+GMD4rH8ofhCnokloGdp0FTta3PxhCx5TAbgUPM4xaX4DKAEj
         ZcFc/b61VLUsanyk3jAiOxsAzQIUO+BoDxAAanc3tma2znSFs/VcaLXyaVEwrG4B6S
         zrP5g6tsQM5Jee/0oh7wdKEDMmCnrmxKXrZsRaJU5DDe6m4elIrBZKPDjYCaHkBt7K
         lao8QOytwrK8bfn0C0rHVe89iT9lm+PDG8u1V4wtOGvkz71DzjRmIR0A4bSycBJMeL
         cRXTxkfeW3a75/SocqnM00KjbC97QjrmOJCps6N8+af+O4aZH6FGW7bvxqX4cyhhBr
         UULJXmHT5VcGA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Seth Miller <miller.seth@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 10/26] HID: Ignore battery for Elan touchscreen on ASUS UX550
Date:   Tue, 19 Jan 2021 20:26:47 -0500
Message-Id: <20210120012704.770095-10-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012704.770095-1-sashal@kernel.org>
References: <20210120012704.770095-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Seth Miller <miller.seth@gmail.com>

[ Upstream commit 7c38e769d5c508939ce5dc26df72602f3c902342 ]

Battery status is being reported for the Elan touchscreen on ASUS
UX550 laptops despite not having a batter. It always shows either 0 or
1%.

Signed-off-by: Seth Miller <miller.seth@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h   | 1 +
 drivers/hid/hid-input.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 2aa810665a78c..33183933337af 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -393,6 +393,7 @@
 #define USB_DEVICE_ID_TOSHIBA_CLICK_L9W	0x0401
 #define USB_DEVICE_ID_HP_X2		0x074d
 #define USB_DEVICE_ID_HP_X2_10_COVER	0x0755
+#define USB_DEVICE_ID_ASUS_UX550_TOUCHSCREEN	0x2706
 
 #define USB_VENDOR_ID_ELECOM		0x056e
 #define USB_DEVICE_ID_ELECOM_BM084	0x0061
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index b2da8476d0d30..ec08895e7b1dc 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -322,6 +322,8 @@ static const struct hid_device_id hid_battery_quirks[] = {
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH,
 		USB_DEVICE_ID_LOGITECH_DINOVO_EDGE_KBD),
 	  HID_BATTERY_QUIRK_IGNORE },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ELAN, USB_DEVICE_ID_ASUS_UX550_TOUCHSCREEN),
+	  HID_BATTERY_QUIRK_IGNORE },
 	{}
 };
 
-- 
2.27.0

