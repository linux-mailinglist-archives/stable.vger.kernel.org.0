Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8552C9B8B
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388148AbgLAJJl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:09:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:47018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389479AbgLAJJb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:09:31 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC332206CA;
        Tue,  1 Dec 2020 09:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813730;
        bh=tCPauijckKAUxxrQpZinVNNIqmG0cK/SIAZLG7Y4xcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iWcnEDm7pQRaDX+siHhXIBNCz5QhJ+I/8rp1/DNjVfygZDAKiN2uz4sIqlPbF6JRE
         q1nMQs65Adg9CU0gnNGdmYdh/WaONw/a4Mfxu6kNsFVo9YvAdbruNGd49abV8hYgu+
         tvr0s5rv3urhsC7hHuW5iENWau9y/mLt5dpz48IE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Martijn van de Streek <martijn@zeewinde.xyz>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 039/152] HID: uclogic: Add ID for Trust Flex Design Tablet
Date:   Tue,  1 Dec 2020 09:52:34 +0100
Message-Id: <20201201084716.978984326@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martijn van de Streek <martijn@zeewinde.xyz>

[ Upstream commit 022fc5315b7aff69d3df2c953b892a6232642d50 ]

The Trust Flex Design Tablet has an UGTizer USB ID and requires the same
initialization as the UGTizer GP0610 to be detected as a graphics tablet
instead of a mouse.

Signed-off-by: Martijn van de Streek <martijn@zeewinde.xyz>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h            | 1 +
 drivers/hid/hid-uclogic-core.c   | 2 ++
 drivers/hid/hid-uclogic-params.c | 2 ++
 3 files changed, 5 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 79495e218b7fc..6b7f90a4721f0 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1297,6 +1297,7 @@
 
 #define USB_VENDOR_ID_UGTIZER			0x2179
 #define USB_DEVICE_ID_UGTIZER_TABLET_GP0610	0x0053
+#define USB_DEVICE_ID_UGTIZER_TABLET_GT5040	0x0077
 
 #define USB_VENDOR_ID_VIEWSONIC			0x0543
 #define USB_DEVICE_ID_VIEWSONIC_PD1011		0xe621
diff --git a/drivers/hid/hid-uclogic-core.c b/drivers/hid/hid-uclogic-core.c
index 86b568037cb8a..8e9c9e646cb7d 100644
--- a/drivers/hid/hid-uclogic-core.c
+++ b/drivers/hid/hid-uclogic-core.c
@@ -385,6 +385,8 @@ static const struct hid_device_id uclogic_devices[] = {
 				USB_DEVICE_ID_UCLOGIC_DRAWIMAGE_G3) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UGTIZER,
 				USB_DEVICE_ID_UGTIZER_TABLET_GP0610) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_UGTIZER,
+				USB_DEVICE_ID_UGTIZER_TABLET_GT5040) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UGEE,
 				USB_DEVICE_ID_UGEE_TABLET_G5) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UGEE,
diff --git a/drivers/hid/hid-uclogic-params.c b/drivers/hid/hid-uclogic-params.c
index 7d20d1fcf8d20..d26d8cd98efcf 100644
--- a/drivers/hid/hid-uclogic-params.c
+++ b/drivers/hid/hid-uclogic-params.c
@@ -997,6 +997,8 @@ int uclogic_params_init(struct uclogic_params *params,
 		break;
 	case VID_PID(USB_VENDOR_ID_UGTIZER,
 		     USB_DEVICE_ID_UGTIZER_TABLET_GP0610):
+	case VID_PID(USB_VENDOR_ID_UGTIZER,
+		     USB_DEVICE_ID_UGTIZER_TABLET_GT5040):
 	case VID_PID(USB_VENDOR_ID_UGEE,
 		     USB_DEVICE_ID_UGEE_XPPEN_TABLET_G540):
 	case VID_PID(USB_VENDOR_ID_UGEE,
-- 
2.27.0



