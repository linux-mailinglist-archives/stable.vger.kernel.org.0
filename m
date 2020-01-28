Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 115CF14B824
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730970AbgA1OVA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:21:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:46076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731178AbgA1OU7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:20:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3080A2468A;
        Tue, 28 Jan 2020 14:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221258;
        bh=BDmzMUOv+jwCWIgzcr7uhDx7cxYkavGXJYJFdjJ7oTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gL60sfiX9gs5B8b0I8ug2B61HTS5a2CvWjk/btbtTr5P7ysq2Aq+vdjcT3uZH9wEr
         90b+KCeCNUM8apN2hbqgHrEv/L4jTtZnOLUgH5zsSPWAvyrLpYucSiHTin48/Kf/rz
         fbH95WiFqtPcHaX7iDIcDzcAlXW4cYS1k0NodK0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 116/271] hwmon: (w83627hf) Use request_muxed_region for Super-IO accesses
Date:   Tue, 28 Jan 2020 15:04:25 +0100
Message-Id: <20200128135901.212745091@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit e95fd518d05bfc087da6fcdea4900a57cfb083bd ]

Super-IO accesses may fail on a system with no or unmapped LPC bus.

Also, other drivers may attempt to access the LPC bus at the same time,
resulting in undefined behavior.

Use request_muxed_region() to ensure that IO access on the requested
address space is supported, and to ensure that access by multiple drivers
is synchronized.

Fixes: b72656dbc491 ("hwmon: (w83627hf) Stop using globals for I/O port numbers")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/w83627hf.c | 42 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 37 insertions(+), 5 deletions(-)

diff --git a/drivers/hwmon/w83627hf.c b/drivers/hwmon/w83627hf.c
index 721295b9a0517..43c0f89cefdf0 100644
--- a/drivers/hwmon/w83627hf.c
+++ b/drivers/hwmon/w83627hf.c
@@ -130,17 +130,23 @@ superio_select(struct w83627hf_sio_data *sio, int ld)
 	outb(ld,  sio->sioaddr + 1);
 }
 
-static inline void
+static inline int
 superio_enter(struct w83627hf_sio_data *sio)
 {
+	if (!request_muxed_region(sio->sioaddr, 2, DRVNAME))
+		return -EBUSY;
+
 	outb(0x87, sio->sioaddr);
 	outb(0x87, sio->sioaddr);
+
+	return 0;
 }
 
 static inline void
 superio_exit(struct w83627hf_sio_data *sio)
 {
 	outb(0xAA, sio->sioaddr);
+	release_region(sio->sioaddr, 2);
 }
 
 #define W627_DEVID 0x52
@@ -1275,7 +1281,7 @@ static DEVICE_ATTR(name, S_IRUGO, show_name, NULL);
 static int __init w83627hf_find(int sioaddr, unsigned short *addr,
 				struct w83627hf_sio_data *sio_data)
 {
-	int err = -ENODEV;
+	int err;
 	u16 val;
 
 	static __initconst char *const names[] = {
@@ -1287,7 +1293,11 @@ static int __init w83627hf_find(int sioaddr, unsigned short *addr,
 	};
 
 	sio_data->sioaddr = sioaddr;
-	superio_enter(sio_data);
+	err = superio_enter(sio_data);
+	if (err)
+		return err;
+
+	err = -ENODEV;
 	val = force_id ? force_id : superio_inb(sio_data, DEVID);
 	switch (val) {
 	case W627_DEVID:
@@ -1641,9 +1651,21 @@ static int w83627thf_read_gpio5(struct platform_device *pdev)
 	struct w83627hf_sio_data *sio_data = dev_get_platdata(&pdev->dev);
 	int res = 0xff, sel;
 
-	superio_enter(sio_data);
+	if (superio_enter(sio_data)) {
+		/*
+		 * Some other driver reserved the address space for itself.
+		 * We don't want to fail driver instantiation because of that,
+		 * so display a warning and keep going.
+		 */
+		dev_warn(&pdev->dev,
+			 "Can not read VID data: Failed to enable SuperIO access\n");
+		return res;
+	}
+
 	superio_select(sio_data, W83627HF_LD_GPIO5);
 
+	res = 0xff;
+
 	/* Make sure these GPIO pins are enabled */
 	if (!(superio_inb(sio_data, W83627THF_GPIO5_EN) & (1<<3))) {
 		dev_dbg(&pdev->dev, "GPIO5 disabled, no VID function\n");
@@ -1674,7 +1696,17 @@ static int w83687thf_read_vid(struct platform_device *pdev)
 	struct w83627hf_sio_data *sio_data = dev_get_platdata(&pdev->dev);
 	int res = 0xff;
 
-	superio_enter(sio_data);
+	if (superio_enter(sio_data)) {
+		/*
+		 * Some other driver reserved the address space for itself.
+		 * We don't want to fail driver instantiation because of that,
+		 * so display a warning and keep going.
+		 */
+		dev_warn(&pdev->dev,
+			 "Can not read VID data: Failed to enable SuperIO access\n");
+		return res;
+	}
+
 	superio_select(sio_data, W83627HF_LD_HWM);
 
 	/* Make sure these GPIO pins are enabled */
-- 
2.20.1



