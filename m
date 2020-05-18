Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48C421D81FA
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730977AbgERRwc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:52:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730986AbgERRwc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:52:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F2A120715;
        Mon, 18 May 2020 17:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824351;
        bh=ZKnpzjS+1IXbi1HA1HZSgCrEQdDz9VPjJYTYfFSTaf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t9DbYVxsZm6qT2c0jXho0Nhtnmo0BYTacG9QtRSpqcISQIjJXAoL1RrK1QN1Y97c8
         CbEj9F4Iv4+40F0tUGyKCjDomxdsvLtqWd94RAepgg+YrLA1owIRUVF34tZD+UWFQC
         WkAp2uFLA0yNUJYlPFiuXK//Jkpfj61czcqYfZy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Hardik Gajjar <hgajjar@de.adit-jv.com>,
        linux-renesas-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Eugeniu Rosca <erosca@de.adit-jv.com>
Subject: [PATCH 4.19 56/80] usb: core: hub: limit HUB_QUIRK_DISABLE_AUTOSUSPEND to USB5534B
Date:   Mon, 18 May 2020 19:37:14 +0200
Message-Id: <20200518173501.711638330@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.097837707@linuxfoundation.org>
References: <20200518173450.097837707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugeniu Rosca <erosca@de.adit-jv.com>

commit 76e1ef1d81a4129d7e2fb8c48c83b166d1c8e040 upstream.

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
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Hardik Gajjar <hgajjar@de.adit-jv.com>
Cc: linux-renesas-soc@vger.kernel.org
Cc: linux-usb@vger.kernel.org
Reported-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Eugeniu Rosca <erosca@de.adit-jv.com>
Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Link: https://lore.kernel.org/r/20200514220246.13290-1-erosca@de.adit-jv.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/hub.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -37,6 +37,7 @@
 
 #define USB_VENDOR_GENESYS_LOGIC		0x05e3
 #define USB_VENDOR_SMSC				0x0424
+#define USB_PRODUCT_USB5534B			0x5534
 #define HUB_QUIRK_CHECK_PORT_AUTOSUSPEND	0x01
 #define HUB_QUIRK_DISABLE_AUTOSUSPEND		0x02
 
@@ -5434,8 +5435,11 @@ out_hdev_lock:
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


