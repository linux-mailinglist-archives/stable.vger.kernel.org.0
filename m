Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 992563A64BD
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235185AbhFNL2c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:28:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235155AbhFNL02 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:26:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 103A061421;
        Mon, 14 Jun 2021 10:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623668091;
        bh=K8WNgMKmxQOuLa/n15i8LwtTj8DbdKGAi3bDsO8+GQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IjHPF7Cksaj3GiMrEeteskJP0YJihRUw7rPRR1SenFGibNeY1cODw/y8Bfk453uhj
         VxkuNGjgcJ63IDODUNcq8uKNzjiUDhO2hf8oOCQFD4HmYSMUBcqyTzQjA6T+o4Ai+x
         /W8indCBtOh+JtXgOqHTDLCen2plWtgOVqBz+Mu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wilken Gottwalt <wilken.gottwalt@posteo.net>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.12 133/173] hwmon: (corsair-psu) fix suspend behavior
Date:   Mon, 14 Jun 2021 12:27:45 +0200
Message-Id: <20210614102702.591428265@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wilken Gottwalt <wilken.gottwalt@posteo.net>

commit 7656cd2177612aa7c299b083ecff30a4d3e9a587 upstream.

During standby some PSUs turn off the microcontroller. A re-init is
required during resume or the microcontroller stays unresponsive.

Fixes: d115b51e0e56 ("hwmon: add Corsair PSU HID controller driver")
Signed-off-by: Wilken Gottwalt <wilken.gottwalt@posteo.net>
Link: https://lore.kernel.org/r/YLjCJiVtu5zgTabI@monster.powergraphx.local
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/corsair-psu.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/hwmon/corsair-psu.c
+++ b/drivers/hwmon/corsair-psu.c
@@ -570,6 +570,16 @@ static int corsairpsu_raw_event(struct h
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int corsairpsu_resume(struct hid_device *hdev)
+{
+	struct corsairpsu_data *priv = hid_get_drvdata(hdev);
+
+	/* some PSUs turn off the microcontroller during standby, so a reinit is required */
+	return corsairpsu_init(priv);
+}
+#endif
+
 static const struct hid_device_id corsairpsu_idtable[] = {
 	{ HID_USB_DEVICE(0x1b1c, 0x1c03) }, /* Corsair HX550i */
 	{ HID_USB_DEVICE(0x1b1c, 0x1c04) }, /* Corsair HX650i */
@@ -592,6 +602,10 @@ static struct hid_driver corsairpsu_driv
 	.probe		= corsairpsu_probe,
 	.remove		= corsairpsu_remove,
 	.raw_event	= corsairpsu_raw_event,
+#ifdef CONFIG_PM
+	.resume		= corsairpsu_resume,
+	.reset_resume	= corsairpsu_resume,
+#endif
 };
 module_hid_driver(corsairpsu_driver);
 


