Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7920111B4E9
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732555AbfLKPXW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:23:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:54304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732294AbfLKPXV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:23:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B7D322527;
        Wed, 11 Dec 2019 15:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077800;
        bh=QVso4X1jYkWKji8ZpZkq/h5rSTgPo5xduCy1zLlrYt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PdyjMQUWZ99LjW/9PC8qI5qD5xLRtsmA35NntG39zdSXz/mXOImjfFoAQX/n58NQJ
         9V9kqoeTMFNXtPW+ASoW2AaQsTGOPwKe2JNCfPvlcl+YTNX+rVf45Ua1JboxH5gNWt
         6gCOMOnVctEBegmKVhCOVMM8dOvOV5WCsm3cyz+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 175/243] media: uvcvideo: Abstract streaming object lifetime
Date:   Wed, 11 Dec 2019 16:05:37 +0100
Message-Id: <20191211150350.987745321@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kieran Bingham <kieran.bingham@ideasonboard.com>

[ Upstream commit ece41454c6a5ed8f301ef1c37710ab222e577823 ]

The streaming object is a key part of handling the UVC device. Although
not critical, we are currently missing a call to destroy the mutex on
clean up paths, and we are due to extend the objects complexity in the
near future.

Facilitate easy management of a stream object by creating a pair of
functions to handle creating and destroying the allocation. The new
uvc_stream_delete() function also performs the missing mutex_destroy()
operation.

Previously a failed streaming object allocation would cause
uvc_parse_streaming() to return -EINVAL, which is inappropriate. If the
constructor failes, we will instead return -ENOMEM.

While we're here, fix the trivial spelling error in the function banner
of uvc_delete().

Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_driver.c | 54 +++++++++++++++++++++---------
 1 file changed, 38 insertions(+), 16 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index cf4feff2a48c1..063e229ead5ef 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -390,6 +390,39 @@ static struct uvc_streaming *uvc_stream_by_id(struct uvc_device *dev, int id)
 	return NULL;
 }
 
+/* ------------------------------------------------------------------------
+ * Streaming Object Management
+ */
+
+static void uvc_stream_delete(struct uvc_streaming *stream)
+{
+	mutex_destroy(&stream->mutex);
+
+	usb_put_intf(stream->intf);
+
+	kfree(stream->format);
+	kfree(stream->header.bmaControls);
+	kfree(stream);
+}
+
+static struct uvc_streaming *uvc_stream_new(struct uvc_device *dev,
+					    struct usb_interface *intf)
+{
+	struct uvc_streaming *stream;
+
+	stream = kzalloc(sizeof(*stream), GFP_KERNEL);
+	if (stream == NULL)
+		return NULL;
+
+	mutex_init(&stream->mutex);
+
+	stream->dev = dev;
+	stream->intf = usb_get_intf(intf);
+	stream->intfnum = intf->cur_altsetting->desc.bInterfaceNumber;
+
+	return stream;
+}
+
 /* ------------------------------------------------------------------------
  * Descriptors parsing
  */
@@ -682,17 +715,12 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 		return -EINVAL;
 	}
 
-	streaming = kzalloc(sizeof(*streaming), GFP_KERNEL);
+	streaming = uvc_stream_new(dev, intf);
 	if (streaming == NULL) {
 		usb_driver_release_interface(&uvc_driver.driver, intf);
-		return -EINVAL;
+		return -ENOMEM;
 	}
 
-	mutex_init(&streaming->mutex);
-	streaming->dev = dev;
-	streaming->intf = usb_get_intf(intf);
-	streaming->intfnum = intf->cur_altsetting->desc.bInterfaceNumber;
-
 	/* The Pico iMage webcam has its class-specific interface descriptors
 	 * after the endpoint descriptors.
 	 */
@@ -899,10 +927,7 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 
 error:
 	usb_driver_release_interface(&uvc_driver.driver, intf);
-	usb_put_intf(intf);
-	kfree(streaming->format);
-	kfree(streaming->header.bmaControls);
-	kfree(streaming);
+	uvc_stream_delete(streaming);
 	return ret;
 }
 
@@ -1818,7 +1843,7 @@ static int uvc_scan_device(struct uvc_device *dev)
  * is released.
  *
  * As this function is called after or during disconnect(), all URBs have
- * already been canceled by the USB core. There is no need to kill the
+ * already been cancelled by the USB core. There is no need to kill the
  * interrupt URB manually.
  */
 static void uvc_delete(struct kref *kref)
@@ -1856,10 +1881,7 @@ static void uvc_delete(struct kref *kref)
 		streaming = list_entry(p, struct uvc_streaming, list);
 		usb_driver_release_interface(&uvc_driver.driver,
 			streaming->intf);
-		usb_put_intf(streaming->intf);
-		kfree(streaming->format);
-		kfree(streaming->header.bmaControls);
-		kfree(streaming);
+		uvc_stream_delete(streaming);
 	}
 
 	kfree(dev);
-- 
2.20.1



