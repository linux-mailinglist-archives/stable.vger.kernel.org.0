Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B57EC1D406E
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 00:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727832AbgENWD2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 18:03:28 -0400
Received: from smtp1.de.adit-jv.com ([93.241.18.167]:50491 "EHLO
        smtp1.de.adit-jv.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgENWD2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 May 2020 18:03:28 -0400
Received: from localhost (smtp1.de.adit-jv.com [127.0.0.1])
        by smtp1.de.adit-jv.com (Postfix) with ESMTP id F3A423C04C1;
        Fri, 15 May 2020 00:03:24 +0200 (CEST)
Received: from smtp1.de.adit-jv.com ([127.0.0.1])
        by localhost (smtp1.de.adit-jv.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id o1TOWhpVUiKY; Fri, 15 May 2020 00:03:16 +0200 (CEST)
Received: from HI2EXCH01.adit-jv.com (hi2exch01.adit-jv.com [10.72.92.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp1.de.adit-jv.com (Postfix) with ESMTPS id 9B5E93C04C0;
        Fri, 15 May 2020 00:03:16 +0200 (CEST)
Received: from lxhi-065.adit-jv.com (10.72.94.5) by HI2EXCH01.adit-jv.com
 (10.72.92.24) with Microsoft SMTP Server (TLS) id 14.3.487.0; Fri, 15 May
 2020 00:03:16 +0200
From:   Eugeniu Rosca <erosca@de.adit-jv.com>
To:     Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        <stable@vger.kernel.org>, Hardik Gajjar <hgajjar@de.adit-jv.com>,
        <linux-renesas-soc@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [PATCH] usb: core: hub: limit HUB_QUIRK_DISABLE_AUTOSUSPEND to USB5534B
Date:   Fri, 15 May 2020 00:02:46 +0200
Message-ID: <20200514220246.13290-1-erosca@de.adit-jv.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.72.94.5]
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 12, 2020 at 09:36:07PM +0800, Kai-Heng Feng wrote [1]:
> This patch prevents my Raven Ridge xHCI from getting runtime suspend.

The problem described in v5.6 commit 1208f9e1d758c9 ("USB: hub: Fix the
broken detection of USB3 device in SMSC hub") applies solely to the
USB5534B hub [2] present on the Kingfisher Infotainment Carrier Board,
manufactured by Shimafuji Electric Inc [3].

Despite that, the aforementioned commit applied the quirk to _all_ hubs
carrying vendor ID 0x424 (i.e. SMSC), of which there are more [4] than
initially expected. Consequently, the quirk is now enabled on platforms
carrying SMSC/Microchip hub models which potentially don't exhibit the
original issue.

To avoid reports like [1], further limit the quirk's scope to
USB5534B [2], by employing both Vendor and Product ID checks.

Tested on H3ULCB + Kingfisher rev. M05.

[1] https://lore.kernel.org/linux-renesas-soc/73933975-6F0E-40F5-9584-D2B8F615C0F3@canonical.com/
[2] https://www.microchip.com/wwwproducts/en/USB5534B
[3] http://www.shimafuji.co.jp/wp/wp-content/uploads/2018/08/SBEV-RCAR-KF-M06Board_HWSpecificationEN_Rev130.pdf
[4] https://devicehunt.com/search/type/usb/vendor/0424/device/any

Fixes: 1208f9e1d758c9 ("USB: hub: Fix the broken detection of USB3 device in SMSC hub")
Cc: stable@vger.kernel.org # v4.14+
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Hardik Gajjar <hgajjar@de.adit-jv.com>
Cc: linux-renesas-soc@vger.kernel.org
Cc: linux-usb@vger.kernel.org
Reported-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Eugeniu Rosca <erosca@de.adit-jv.com>
---
 drivers/usb/core/hub.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 2b6565c06c23..fc748c731832 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -39,6 +39,7 @@
 
 #define USB_VENDOR_GENESYS_LOGIC		0x05e3
 #define USB_VENDOR_SMSC				0x0424
+#define USB_PRODUCT_USB5534B			0x5534
 #define HUB_QUIRK_CHECK_PORT_AUTOSUSPEND	0x01
 #define HUB_QUIRK_DISABLE_AUTOSUSPEND		0x02
 
@@ -5621,8 +5622,11 @@ static void hub_event(struct work_struct *work)
 }
 
 static const struct usb_device_id hub_id_table[] = {
-    { .match_flags = USB_DEVICE_ID_MATCH_VENDOR | USB_DEVICE_ID_MATCH_INT_CLASS,
+    { .match_flags = USB_DEVICE_ID_MATCH_VENDOR
+                   | USB_DEVICE_ID_MATCH_PRODUCT
+                   | USB_DEVICE_ID_MATCH_INT_CLASS,
       .idVendor = USB_VENDOR_SMSC,
+      .idProduct = USB_PRODUCT_USB5534B,
       .bInterfaceClass = USB_CLASS_HUB,
       .driver_info = HUB_QUIRK_DISABLE_AUTOSUSPEND},
     { .match_flags = USB_DEVICE_ID_MATCH_VENDOR
-- 
2.26.2

