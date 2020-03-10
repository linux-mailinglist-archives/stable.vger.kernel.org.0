Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52CEB17FAB1
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730193AbgCJNH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:07:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730976AbgCJNH2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:07:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA8BB20409;
        Tue, 10 Mar 2020 13:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845647;
        bh=oDh7SuUHFtSuw4pwi8W77mLorLw1uIiStk6IAmt32qA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iXgsUsRZzIST9oC5TWGUGFp3t83kj7rqQ22E0mDibXr8e/vVTv9vjYa4n/WrIpVyJ
         UXjGIsLwSESHB4IsvnvGisZtHHoAldDoS3hCFJG8D8PzL1Gx7CNRvln8hVFFszrVHF
         YMLIYyVccCgclkKXvCdaQkunpsE5wA66HmlkmqcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kristian Evensen <kristian.evensen@gmail.com>,
        Aleksander Morgado <aleksander@aleksander.es>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 012/126] qmi_wwan: unconditionally reject 2 ep interfaces
Date:   Tue, 10 Mar 2020 13:40:33 +0100
Message-Id: <20200310124204.841886268@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124203.704193207@linuxfoundation.org>
References: <20200310124203.704193207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjørn Mork <bjorn@mork.no>

[ Upstream commit 00516d13d4cfa56ce39da144db2dbf08b09b9357 ]

We have been using the fact that the QMI and DIAG functions
usually are the only ones with class/subclass/protocol being
ff/ff/ff on Quectel modems. This has allowed us to match the
QMI function without knowing the exact interface number,
which can vary depending on firmware configuration.

The ability to silently reject the DIAG function, which is
usually handled by the option driver, is important for this
method to work.  This is done based on the knowledge that it
has exactly 2 bulk endpoints.  QMI function control interfaces
will have either 3 or 1 endpoint. This rule is universal so
the quirk condition can be removed.

The fixed layouts known from the Gobi1k and Gobi2k modems
have been gradually replaced by more dynamic layouts, and
many vendors now use configurable layouts without changing
device IDs.  Renaming the class/subclass/protocol matching
macro makes it more obvious that this is now not Quectel
specific anymore.

Cc: Kristian Evensen <kristian.evensen@gmail.com>
Cc: Aleksander Morgado <aleksander@aleksander.es>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 42 ++++++++++++++------------------------
 1 file changed, 15 insertions(+), 27 deletions(-)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 08215a9f61454..189715438328f 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -63,7 +63,6 @@ enum qmi_wwan_flags {
 
 enum qmi_wwan_quirks {
 	QMI_WWAN_QUIRK_DTR = 1 << 0,	/* needs "set DTR" request */
-	QMI_WWAN_QUIRK_QUECTEL_DYNCFG = 1 << 1,	/* check num. endpoints */
 };
 
 struct qmimux_hdr {
@@ -853,16 +852,6 @@ static const struct driver_info	qmi_wwan_info_quirk_dtr = {
 	.data           = QMI_WWAN_QUIRK_DTR,
 };
 
-static const struct driver_info	qmi_wwan_info_quirk_quectel_dyncfg = {
-	.description	= "WWAN/QMI device",
-	.flags		= FLAG_WWAN | FLAG_SEND_ZLP,
-	.bind		= qmi_wwan_bind,
-	.unbind		= qmi_wwan_unbind,
-	.manage_power	= qmi_wwan_manage_power,
-	.rx_fixup       = qmi_wwan_rx_fixup,
-	.data           = QMI_WWAN_QUIRK_DTR | QMI_WWAN_QUIRK_QUECTEL_DYNCFG,
-};
-
 #define HUAWEI_VENDOR_ID	0x12D1
 
 /* map QMI/wwan function by a fixed interface number */
@@ -883,14 +872,18 @@ static const struct driver_info	qmi_wwan_info_quirk_quectel_dyncfg = {
 #define QMI_GOBI_DEVICE(vend, prod) \
 	QMI_FIXED_INTF(vend, prod, 0)
 
-/* Quectel does not use fixed interface numbers on at least some of their
- * devices. We need to check the number of endpoints to ensure that we bind to
- * the correct interface.
+/* Many devices have QMI and DIAG functions which are distinguishable
+ * from other vendor specific functions by class, subclass and
+ * protocol all being 0xff. The DIAG function has exactly 2 endpoints
+ * and is silently rejected when probed.
+ *
+ * This makes it possible to match dynamically numbered QMI functions
+ * as seen on e.g. many Quectel modems.
  */
-#define QMI_QUIRK_QUECTEL_DYNCFG(vend, prod) \
+#define QMI_MATCH_FF_FF_FF(vend, prod) \
 	USB_DEVICE_AND_INTERFACE_INFO(vend, prod, USB_CLASS_VENDOR_SPEC, \
 				      USB_SUBCLASS_VENDOR_SPEC, 0xff), \
-	.driver_info = (unsigned long)&qmi_wwan_info_quirk_quectel_dyncfg
+	.driver_info = (unsigned long)&qmi_wwan_info_quirk_dtr
 
 static const struct usb_device_id products[] = {
 	/* 1. CDC ECM like devices match on the control interface */
@@ -996,10 +989,10 @@ static const struct usb_device_id products[] = {
 		USB_DEVICE_AND_INTERFACE_INFO(0x03f0, 0x581d, USB_CLASS_VENDOR_SPEC, 1, 7),
 		.driver_info = (unsigned long)&qmi_wwan_info,
 	},
-	{QMI_QUIRK_QUECTEL_DYNCFG(0x2c7c, 0x0125)},	/* Quectel EC25, EC20 R2.0  Mini PCIe */
-	{QMI_QUIRK_QUECTEL_DYNCFG(0x2c7c, 0x0306)},	/* Quectel EP06/EG06/EM06 */
-	{QMI_QUIRK_QUECTEL_DYNCFG(0x2c7c, 0x0512)},	/* Quectel EG12/EM12 */
-	{QMI_QUIRK_QUECTEL_DYNCFG(0x2c7c, 0x0800)},	/* Quectel RM500Q-GL */
+	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0125)},	/* Quectel EC25, EC20 R2.0  Mini PCIe */
+	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0306)},	/* Quectel EP06/EG06/EM06 */
+	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0512)},	/* Quectel EG12/EM12 */
+	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0800)},	/* Quectel RM500Q-GL */
 
 	/* 3. Combined interface devices matching on interface number */
 	{QMI_FIXED_INTF(0x0408, 0xea42, 4)},	/* Yota / Megafon M100-1 */
@@ -1379,7 +1372,6 @@ static int qmi_wwan_probe(struct usb_interface *intf,
 {
 	struct usb_device_id *id = (struct usb_device_id *)prod;
 	struct usb_interface_descriptor *desc = &intf->cur_altsetting->desc;
-	const struct driver_info *info;
 
 	/* Workaround to enable dynamic IDs.  This disables usbnet
 	 * blacklisting functionality.  Which, if required, can be
@@ -1415,12 +1407,8 @@ static int qmi_wwan_probe(struct usb_interface *intf,
 	 * different. Ignore the current interface if the number of endpoints
 	 * equals the number for the diag interface (two).
 	 */
-	info = (void *)id->driver_info;
-
-	if (info->data & QMI_WWAN_QUIRK_QUECTEL_DYNCFG) {
-		if (desc->bNumEndpoints == 2)
-			return -ENODEV;
-	}
+	if (desc->bNumEndpoints == 2)
+		return -ENODEV;
 
 	return usbnet_probe(intf, id);
 }
-- 
2.20.1



