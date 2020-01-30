Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF43C14E273
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728148AbgA3SwV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:52:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:52444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728062AbgA3Snk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:43:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E153B20CC7;
        Thu, 30 Jan 2020 18:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409819;
        bh=zuEUBKlZdyeN4POlgMWZuq1e8qLu6fLRLaFLDyY2sQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zQro36d0HUNnN/x5tXLrbjEVCZgFsS1aT2ko3fDgRLwjqICJ/4UzKtE8REDAiOlCw
         QNbNc8aKKSX7gGNgBX2Km0awrd8S8GJeubEgC9OkFcFNzKQKLXlAiiArJa91ecPvIx
         WEJiXH3r9MJ4wQX5t6eYU3PWkG35hi90sooViItg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaron Ma <aaron.ma@canonical.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 044/110] HID: multitouch: Add LG MELF0410 I2C touchscreen support
Date:   Thu, 30 Jan 2020 19:38:20 +0100
Message-Id: <20200130183620.526273375@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
References: <20200130183613.810054545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaron Ma <aaron.ma@canonical.com>

[ Upstream commit 348b80b273fbf4ce2a307f9e38eadecf37828cad ]

Add multitouch support for LG MELF I2C touchscreen.
Apply the same workaround as LG USB touchscreen.

Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h        | 1 +
 drivers/hid/hid-multitouch.c | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 6273e7178e785..2888817261999 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -730,6 +730,7 @@
 #define USB_DEVICE_ID_LG_MULTITOUCH	0x0064
 #define USB_DEVICE_ID_LG_MELFAS_MT	0x6007
 #define I2C_DEVICE_ID_LG_8001		0x8001
+#define I2C_DEVICE_ID_LG_7010		0x7010
 
 #define USB_VENDOR_ID_LOGITECH		0x046d
 #define USB_DEVICE_ID_LOGITECH_AUDIOHUB 0x0a0e
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 3cfeb1629f79f..f0d4172d51319 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1985,6 +1985,9 @@ static const struct hid_device_id mt_devices[] = {
 	{ .driver_data = MT_CLS_LG,
 		HID_USB_DEVICE(USB_VENDOR_ID_LG,
 			USB_DEVICE_ID_LG_MELFAS_MT) },
+	{ .driver_data = MT_CLS_LG,
+		HID_DEVICE(BUS_I2C, HID_GROUP_GENERIC,
+			USB_VENDOR_ID_LG, I2C_DEVICE_ID_LG_7010) },
 
 	/* MosArt panels */
 	{ .driver_data = MT_CLS_CONFIDENCE_MINUS_ONE,
-- 
2.20.1



