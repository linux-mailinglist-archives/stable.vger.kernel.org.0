Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5C95507DB
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729965AbfFXKLK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:11:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:39288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730183AbfFXKGw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:06:52 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EF20214DA;
        Mon, 24 Jun 2019 10:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370811;
        bh=36Uks9N0n+g+dl+fWGwq7q+BLR2zuL27kYpLylCMGSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QCI46K0wPPGpq9K12T9WkPSsF5CMcFE8vPpmw3zW5r6xsv1gS21A5DRafEeUmDw0z
         VvX5yYzAnpcqDgBqbQi12KGEbNtA65mml6c9Aaeqe9YkwQjS1nOy2boQzbq8MhEtx+
         XDSPrgVvkhxW4d5/AroXaqLS7IaNaZMZnuvBDOjs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Jun Li <jun.li@nxp.com>, Peter Chen <peter.chen@nxp.com>
Subject: [PATCH 5.1 010/121] usb: chipidea: udc: workaround for endpoint conflict issue
Date:   Mon, 24 Jun 2019 17:55:42 +0800
Message-Id: <20190624092321.172344958@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Chen <peter.chen@nxp.com>

commit c19dffc0a9511a7d7493ec21019aefd97e9a111b upstream.

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
Cc: Fabio Estevam <festevam@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Jun Li <jun.li@nxp.com>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/chipidea/udc.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -1622,6 +1622,25 @@ static int ci_udc_pullup(struct usb_gadg
 static int ci_udc_start(struct usb_gadget *gadget,
 			 struct usb_gadget_driver *driver);
 static int ci_udc_stop(struct usb_gadget *gadget);
+
+/* Match ISOC IN from the highest endpoint */
+static struct usb_ep *ci_udc_match_ep(struct usb_gadget *gadget,
+			      struct usb_endpoint_descriptor *desc,
+			      struct usb_ss_ep_comp_descriptor *comp_desc)
+{
+	struct ci_hdrc *ci = container_of(gadget, struct ci_hdrc, gadget);
+	struct usb_ep *ep;
+
+	if (usb_endpoint_xfer_isoc(desc) && usb_endpoint_dir_in(desc)) {
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
@@ -1635,6 +1654,7 @@ static const struct usb_gadget_ops usb_g
 	.vbus_draw	= ci_udc_vbus_draw,
 	.udc_start	= ci_udc_start,
 	.udc_stop	= ci_udc_stop,
+	.match_ep 	= ci_udc_match_ep,
 };
 
 static int init_eps(struct ci_hdrc *ci)


