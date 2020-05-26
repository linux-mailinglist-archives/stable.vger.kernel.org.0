Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB88D1E2BCB
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403920AbgEZTIt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:08:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:37848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403914AbgEZTIs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:08:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADFB320873;
        Tue, 26 May 2020 19:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520128;
        bh=XFGAr/yVdP6a32+0QjjFLnsP3iMu2ZOO/HMkOvz2H2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a+HDDuknKw8kWUBfArTlNFiA3/aNLWRsqGiuQGdQbqgz0EaZg76ECSfwSO25xFS4+
         j4XPgsKsmU1+s4mbiOEJli4DBP7Ay9lDZxHo5DOUXLgApGU8loT9VBXyB1e+6VB3Pg
         /tMltBfhuq8cJgAw6OpsE5JPB6u072vVk1/8S9Fg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daniel Playfair Cal <daniel.playfair.cal@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 032/111] HID: i2c-hid: reset Synaptics SYNA2393 on resume
Date:   Tue, 26 May 2020 20:52:50 +0200
Message-Id: <20200526183935.860166811@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183932.245016380@linuxfoundation.org>
References: <20200526183932.245016380@linuxfoundation.org>
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
index 48eba9c4f39a..3341133df3a8 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1089,6 +1089,9 @@
 #define USB_DEVICE_ID_SYMBOL_SCANNER_2	0x1300
 #define USB_DEVICE_ID_SYMBOL_SCANNER_3	0x1200
 
+#define I2C_VENDOR_ID_SYNAPTICS     0x06cb
+#define I2C_PRODUCT_ID_SYNAPTICS_SYNA2393   0x7a13
+
 #define USB_VENDOR_ID_SYNAPTICS		0x06cb
 #define USB_DEVICE_ID_SYNAPTICS_TP	0x0001
 #define USB_DEVICE_ID_SYNAPTICS_INT_TP	0x0002
diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index 479934f7d241..b525b2715e07 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -179,6 +179,8 @@ static const struct i2c_hid_quirks {
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



