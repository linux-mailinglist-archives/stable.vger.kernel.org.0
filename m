Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98E863A0353
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237321AbhFHTPu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:15:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:36962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237716AbhFHTMp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:12:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB7FF61465;
        Tue,  8 Jun 2021 18:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178179;
        bh=Yl7IPL85YzCd2CUddMcgindgnXZi0j50a/KS615JKeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0wEJzUSerth5+AyVWXZOwLdrkipxLG4fz88EwigV3wW0FVXFChy6w68NRmE16wV3d
         AH5V18lGIe4yy9/0g02Zecum12+3VzBh015nc5WcJnZclTKggXLtDpC9I/JuYpUBtR
         s6/5cXfqZMvmwjSOXce2RpzBSPAXsCb6HHMS8/+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.12 106/161] net: caif: fix memory leak in cfusbl_device_notify
Date:   Tue,  8 Jun 2021 20:27:16 +0200
Message-Id: <20210608175949.056066645@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

commit 7f5d86669fa4d485523ddb1d212e0a2d90bd62bb upstream.

In case of caif_enroll_dev() fail, allocated
link_support won't be assigned to the corresponding
structure. So simply free allocated pointer in case
of error.

Fixes: 7ad65bf68d70 ("caif: Add support for CAIF over CDC NCM USB interface")
Cc: stable@vger.kernel.org
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/caif/caif_usb.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/net/caif/caif_usb.c
+++ b/net/caif/caif_usb.c
@@ -115,6 +115,11 @@ static struct cflayer *cfusbl_create(int
 	return (struct cflayer *) this;
 }
 
+static void cfusbl_release(struct cflayer *layer)
+{
+	kfree(layer);
+}
+
 static struct packet_type caif_usb_type __read_mostly = {
 	.type = cpu_to_be16(ETH_P_802_EX1),
 };
@@ -127,6 +132,7 @@ static int cfusbl_device_notify(struct n
 	struct cflayer *layer, *link_support;
 	struct usbnet *usbnet;
 	struct usb_device *usbdev;
+	int res;
 
 	/* Check whether we have a NCM device, and find its VID/PID. */
 	if (!(dev->dev.parent && dev->dev.parent->driver &&
@@ -169,8 +175,11 @@ static int cfusbl_device_notify(struct n
 	if (dev->num_tx_queues > 1)
 		pr_warn("USB device uses more than one tx queue\n");
 
-	caif_enroll_dev(dev, &common, link_support, CFUSB_MAX_HEADLEN,
+	res = caif_enroll_dev(dev, &common, link_support, CFUSB_MAX_HEADLEN,
 			&layer, &caif_usb_type.func);
+	if (res)
+		goto err;
+
 	if (!pack_added)
 		dev_add_pack(&caif_usb_type);
 	pack_added = true;
@@ -178,6 +187,9 @@ static int cfusbl_device_notify(struct n
 	strlcpy(layer->name, dev->name, sizeof(layer->name));
 
 	return 0;
+err:
+	cfusbl_release(link_support);
+	return res;
 }
 
 static struct notifier_block caif_device_notifier = {


