Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3F2C1E2D3C
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404110AbgEZTMK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:12:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:41676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403888AbgEZTMJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:12:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9069320776;
        Tue, 26 May 2020 19:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520329;
        bh=0s4kw//tMF6/0U/1tQBmB3KpJtoo0PmRghH2t4jItlg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vy1KLqWUgYUh1bUs+U6XHfYAFoPmQGR6LgPyWi/djNQYsgukWwFp9nIgL9R+gIWxP
         pzkyocK9eohc49qQ5YWO/ZqSFUEC4ANETn4QFYrI38SfdoNK1uHM1z3o239CA7VYGC
         8IBcJ/vkdSFgyD/tlym4D7iVgNSgq77oIdxH26Uw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daniel Playfair Cal <daniel.playfair.cal@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 037/126] HID: i2c-hid: reset Synaptics SYNA2393 on resume
Date:   Tue, 26 May 2020 20:52:54 +0200
Message-Id: <20200526183941.025193206@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183937.471379031@linuxfoundation.org>
References: <20200526183937.471379031@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Playfair Cal <daniel.playfair.cal@gmail.com>

[ Upstream commit 538f67407e2c0e5ed2a46e7d7ffa52f2e30c7ef8 ]

On the Dell XPS 9570, the Synaptics SYNA2393 touchpad generates spurious
interrupts after resuming from suspend until it receives some input or
is reset. Add it to the quirk I2C_HID_QUIRK_RESET_ON_RESUME so that it
is reset when resuming from suspend.

More information about the bug can be found in this mailing list
discussion: https://www.spinics.net/lists/linux-input/msg59530.html

Signed-off-by: Daniel Playfair Cal <daniel.playfair.cal@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h              | 3 +++
 drivers/hid/i2c-hid/i2c-hid-core.c | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index b3cc26ca375f..55afc089cb25 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1094,6 +1094,9 @@
 #define USB_DEVICE_ID_SYMBOL_SCANNER_2	0x1300
 #define USB_DEVICE_ID_SYMBOL_SCANNER_3	0x1200
 
+#define I2C_VENDOR_ID_SYNAPTICS     0x06cb
+#define I2C_PRODUCT_ID_SYNAPTICS_SYNA2393   0x7a13
+
 #define USB_VENDOR_ID_SYNAPTICS		0x06cb
 #define USB_DEVICE_ID_SYNAPTICS_TP	0x0001
 #define USB_DEVICE_ID_SYNAPTICS_INT_TP	0x0002
diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index 009000c5d55c..294c84e136d7 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -177,6 +177,8 @@ static const struct i2c_hid_quirks {
 		 I2C_HID_QUIRK_BOGUS_IRQ },
 	{ USB_VENDOR_ID_ALPS_JP, HID_ANY_ID,
 		 I2C_HID_QUIRK_RESET_ON_RESUME },
+	{ I2C_VENDOR_ID_SYNAPTICS, I2C_PRODUCT_ID_SYNAPTICS_SYNA2393,
+		 I2C_HID_QUIRK_RESET_ON_RESUME },
 	{ USB_VENDOR_ID_ITE, I2C_DEVICE_ID_ITE_LENOVO_LEGION_Y720,
 		I2C_HID_QUIRK_BAD_INPUT_SIZE },
 	{ 0, 0 }
-- 
2.25.1



