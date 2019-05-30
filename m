Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 203962F780
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 08:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727298AbfE3GnT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 02:43:19 -0400
Received: from inva021.nxp.com ([92.121.34.21]:41920 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725961AbfE3GnT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 May 2019 02:43:19 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id B333F2005ED;
        Thu, 30 May 2019 08:43:16 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 261A9200156;
        Thu, 30 May 2019 08:43:14 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 97541402B5;
        Thu, 30 May 2019 14:43:10 +0800 (SGT)
From:   Peter Chen <peter.chen@nxp.com>
To:     linux-usb@vger.kernel.org
Cc:     linux-imx@nxp.com, Peter Chen <peter.chen@nxp.com>,
        stable@vger.kernel.org, Jun Li <jun.li@nxp.com>
Subject: [PATCH 1/1] usb: chipidea: udc: workaround for endpoint conflict issue
Date:   Thu, 30 May 2019 14:45:05 +0800
Message-Id: <20190530064505.6292-1-peter.chen@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

An endpoint conflict occurs when the USB is working in device mode
during an isochronous communication. When the endpointA IN direction
is an isochronous IN endpoint, and the host sends an IN token to
endpointA on another device, then the OUT transaction may be missed
regardless the OUT endpoint number. Generally, this occurs when the
device is connected to the host through a hub and other devices are
connected to the same hub.

The affected OUT endpoint can be either control, bulk, isochronous, or
an interrupt endpoint. After the OUT endpoint is primed, if an IN token
to the same endpoint number on another device is received, then the OUT
endpoint may be unprimed (cannot be detected by software), which causes
this endpoint to no longer respond to the host OUT token, and thus, no
corresponding interrupt occurs.

There is no good workaround for this issue, the only thing the software
could do is numbering isochronous IN from the highest endpoint since we
have observed most of device number endpoint from the lowest.

Cc: <stable@vger.kernel.org> #v3.14+
Cc: Jun Li <jun.li@nxp.com>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
---
Changes for v2:
- Some coding style improvements

 drivers/usb/chipidea/udc.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/usb/chipidea/udc.c b/drivers/usb/chipidea/udc.c
index 829e947cabf5..411d387a45c9 100644
--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -1622,6 +1622,29 @@ static int ci_udc_pullup(struct usb_gadget *_gadget, int is_on)
 static int ci_udc_start(struct usb_gadget *gadget,
 			 struct usb_gadget_driver *driver);
 static int ci_udc_stop(struct usb_gadget *gadget);
+
+
+/* Match ISOC IN from the highest endpoint */
+static struct
+usb_ep *ci_udc_match_ep(struct usb_gadget *gadget,
+			      struct usb_endpoint_descriptor *desc,
+			      struct usb_ss_ep_comp_descriptor *comp_desc)
+{
+	struct ci_hdrc *ci = container_of(gadget, struct ci_hdrc, gadget);
+	struct usb_ep *ep;
+	u8 type = desc->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK;
+
+	if ((type == USB_ENDPOINT_XFER_ISOC) &&
+		(desc->bEndpointAddress & USB_DIR_IN)) {
+		list_for_each_entry_reverse(ep, &ci->gadget.ep_list, ep_list) {
+			if (ep->caps.dir_in && !ep->claimed)
+				return ep;
+		}
+	}
+
+	return NULL;
+}
+
 /**
  * Device operations part of the API to the USB controller hardware,
  * which don't involve endpoints (or i/o)
@@ -1635,6 +1658,7 @@ static const struct usb_gadget_ops usb_gadget_ops = {
 	.vbus_draw	= ci_udc_vbus_draw,
 	.udc_start	= ci_udc_start,
 	.udc_stop	= ci_udc_stop,
+	.match_ep	= ci_udc_match_ep,
 };
 
 static int init_eps(struct ci_hdrc *ci)
-- 
2.14.1

