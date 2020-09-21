Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C71D2273066
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 19:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729010AbgIUREq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 13:04:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:34168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728449AbgIUQfH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:35:07 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 775E3239D1;
        Mon, 21 Sep 2020 16:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706091;
        bh=/xKZRHpuUhCdzTlEzBbF9J3CkbnG0hcLz3g+PF7Jsy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0dC6vd/tJQZK+XGlikMMb5ABHIPT6NN9bFbdiBvJGHNb4TfIpnq1MrnEPdexfWYBV
         Aa7zUQZwH3+SmaX1UvYhvYoRQofqdhBzN8NlhIRH8iTe4WisxIxfc5RED15HLJe8kR
         /6eNP7OOntgpNHzsWqaX6Fb/Nms9DBdggHeAD3Ak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.9 28/70] USB: core: add helpers to retrieve endpoints
Date:   Mon, 21 Sep 2020 18:27:28 +0200
Message-Id: <20200921162036.397651996@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.136047591@linuxfoundation.org>
References: <20200921162035.136047591@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 66a359390e7e34f9a4c489467234b107b3d76169 upstream.

Many USB drivers iterate over the available endpoints to find required
endpoints of a specific type and direction. Typically the endpoints are
required for proper function and a missing endpoint should abort probe.

To facilitate code reuse, add a helper to retrieve common endpoints
(bulk or interrupt, in or out) and four wrappers to find a single
endpoint.

Note that the helpers are marked as __must_check to serve as a reminder
to always verify that all expected endpoints are indeed present. This
also means that any optional endpoints, typically need to be looked up
through separate calls.

Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/usb.c |   83 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/usb.h    |   35 ++++++++++++++++++++
 2 files changed, 118 insertions(+)

--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -73,6 +73,89 @@ MODULE_PARM_DESC(autosuspend, "default a
 
 
 /**
+ * usb_find_common_endpoints() -- look up common endpoint descriptors
+ * @alt:	alternate setting to search
+ * @bulk_in:	pointer to descriptor pointer, or NULL
+ * @bulk_out:	pointer to descriptor pointer, or NULL
+ * @int_in:	pointer to descriptor pointer, or NULL
+ * @int_out:	pointer to descriptor pointer, or NULL
+ *
+ * Search the alternate setting's endpoint descriptors for the first bulk-in,
+ * bulk-out, interrupt-in and interrupt-out endpoints and return them in the
+ * provided pointers (unless they are NULL).
+ *
+ * If a requested endpoint is not found, the corresponding pointer is set to
+ * NULL.
+ *
+ * Return: Zero if all requested descriptors were found, or -ENXIO otherwise.
+ */
+int usb_find_common_endpoints(struct usb_host_interface *alt,
+		struct usb_endpoint_descriptor **bulk_in,
+		struct usb_endpoint_descriptor **bulk_out,
+		struct usb_endpoint_descriptor **int_in,
+		struct usb_endpoint_descriptor **int_out)
+{
+	struct usb_endpoint_descriptor *epd;
+	int i;
+
+	if (bulk_in)
+		*bulk_in = NULL;
+	if (bulk_out)
+		*bulk_out = NULL;
+	if (int_in)
+		*int_in = NULL;
+	if (int_out)
+		*int_out = NULL;
+
+	for (i = 0; i < alt->desc.bNumEndpoints; ++i) {
+		epd = &alt->endpoint[i].desc;
+
+		switch (usb_endpoint_type(epd)) {
+		case USB_ENDPOINT_XFER_BULK:
+			if (usb_endpoint_dir_in(epd)) {
+				if (bulk_in && !*bulk_in) {
+					*bulk_in = epd;
+					break;
+				}
+			} else {
+				if (bulk_out && !*bulk_out) {
+					*bulk_out = epd;
+					break;
+				}
+			}
+
+			continue;
+		case USB_ENDPOINT_XFER_INT:
+			if (usb_endpoint_dir_in(epd)) {
+				if (int_in && !*int_in) {
+					*int_in = epd;
+					break;
+				}
+			} else {
+				if (int_out && !*int_out) {
+					*int_out = epd;
+					break;
+				}
+			}
+
+			continue;
+		default:
+			continue;
+		}
+
+		if ((!bulk_in || *bulk_in) &&
+				(!bulk_out || *bulk_out) &&
+				(!int_in || *int_in) &&
+				(!int_out || *int_out)) {
+			return 0;
+		}
+	}
+
+	return -ENXIO;
+}
+EXPORT_SYMBOL_GPL(usb_find_common_endpoints);
+
+/**
  * usb_find_alt_setting() - Given a configuration, find the alternate setting
  * for the given interface.
  * @config: the configuration to search (not necessarily the current config).
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -99,6 +99,41 @@ enum usb_interface_condition {
 	USB_INTERFACE_UNBINDING,
 };
 
+int __must_check
+usb_find_common_endpoints(struct usb_host_interface *alt,
+		struct usb_endpoint_descriptor **bulk_in,
+		struct usb_endpoint_descriptor **bulk_out,
+		struct usb_endpoint_descriptor **int_in,
+		struct usb_endpoint_descriptor **int_out);
+
+static inline int __must_check
+usb_find_bulk_in_endpoint(struct usb_host_interface *alt,
+		struct usb_endpoint_descriptor **bulk_in)
+{
+	return usb_find_common_endpoints(alt, bulk_in, NULL, NULL, NULL);
+}
+
+static inline int __must_check
+usb_find_bulk_out_endpoint(struct usb_host_interface *alt,
+		struct usb_endpoint_descriptor **bulk_out)
+{
+	return usb_find_common_endpoints(alt, NULL, bulk_out, NULL, NULL);
+}
+
+static inline int __must_check
+usb_find_int_in_endpoint(struct usb_host_interface *alt,
+		struct usb_endpoint_descriptor **int_in)
+{
+	return usb_find_common_endpoints(alt, NULL, NULL, int_in, NULL);
+}
+
+static inline int __must_check
+usb_find_int_out_endpoint(struct usb_host_interface *alt,
+		struct usb_endpoint_descriptor **int_out)
+{
+	return usb_find_common_endpoints(alt, NULL, NULL, NULL, int_out);
+}
+
 /**
  * struct usb_interface - what usb device drivers talk to
  * @altsetting: array of interface structures, one for each alternate


