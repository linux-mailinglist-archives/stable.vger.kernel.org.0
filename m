Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDF7133326
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbgAGVQW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:16:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:57698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729501AbgAGVHQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:07:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D65A20678;
        Tue,  7 Jan 2020 21:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431236;
        bh=kHWeVqFe+m0kkb4VihQ/ZQA4wtRTqA+ReUP+mQlbl0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PFfDfLWzNN+yw+L3+t4utARzaihDboTm6Y8bAHjHffBttSwhK/8n2SkUoVYJ07Y5R
         YVfBxGcJ7yOLJxYGCgK3pjQySPOvfFwCSPA2kDUmF+3Y+8Yx/48KEJP8LKC/xtNa9f
         Eiq2d+64gReBXu1gNzuaGn60FGNUj8e1RrxDDL/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.19 082/115] HID: i2c-hid: Reset ALPS touchpads on resume
Date:   Tue,  7 Jan 2020 21:54:52 +0100
Message-Id: <20200107205305.171742306@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205240.283674026@linuxfoundation.org>
References: <20200107205240.283674026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit fd70466d37bf3fe0118d18c56ddde85b428f86cf upstream.

Commit 52cf93e63ee6 ("HID: i2c-hid: Don't reset device upon system
resume") fixes many touchpads and touchscreens, however ALPS touchpads
start to trigger IRQ storm after system resume.

Since it's total silence from ALPS, let's bring the old behavior back
to ALPS touchpads.

Fixes: 52cf93e63ee6 ("HID: i2c-hid: Don't reset device upon system resume")
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/i2c-hid/i2c-hid-core.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -51,6 +51,7 @@
 #define I2C_HID_QUIRK_NO_RUNTIME_PM		BIT(2)
 #define I2C_HID_QUIRK_DELAY_AFTER_SLEEP		BIT(3)
 #define I2C_HID_QUIRK_BOGUS_IRQ			BIT(4)
+#define I2C_HID_QUIRK_RESET_ON_RESUME		BIT(5)
 
 /* flags */
 #define I2C_HID_STARTED		0
@@ -182,6 +183,8 @@ static const struct i2c_hid_quirks {
 		I2C_HID_QUIRK_NO_RUNTIME_PM },
 	{ USB_VENDOR_ID_ELAN, HID_ANY_ID,
 		 I2C_HID_QUIRK_BOGUS_IRQ },
+	{ USB_VENDOR_ID_ALPS_JP, HID_ANY_ID,
+		 I2C_HID_QUIRK_RESET_ON_RESUME },
 	{ 0, 0 }
 };
 
@@ -1290,8 +1293,15 @@ static int i2c_hid_resume(struct device
 	 * solves "incomplete reports" on Raydium devices 2386:3118 and
 	 * 2386:4B33 and fixes various SIS touchscreens no longer sending
 	 * data after a suspend/resume.
+	 *
+	 * However some ALPS touchpads generate IRQ storm without reset, so
+	 * let's still reset them here.
 	 */
-	ret = i2c_hid_set_power(client, I2C_HID_PWR_ON);
+	if (ihid->quirks & I2C_HID_QUIRK_RESET_ON_RESUME)
+		ret = i2c_hid_hwreset(client);
+	else
+		ret = i2c_hid_set_power(client, I2C_HID_PWR_ON);
+
 	if (ret)
 		return ret;
 


