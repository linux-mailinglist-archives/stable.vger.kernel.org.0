Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37BC3101808
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728617AbfKSGFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 01:05:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:58384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729238AbfKSFgv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:36:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BBB2206EC;
        Tue, 19 Nov 2019 05:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141810;
        bh=gq/tyBgrGlsGM3L2gYxx/1eDXdGI2DWlzbFuvWnoCfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DyPPfSfgHCBfKXn6kQsloMqFNipYr07TVf1bfq4yrEO6+nqjKjasqUILFrwHQuRx2
         kO3D9LPg/LjfJfZWJDQ8AkazZbGRa4ZKF1NXo10M8Vx7JjBSdNnsb0xMF8aWJ9jqdz
         JTSJhGEVxaj8hTlkM/Mprxy8gp0upjCC/gxUp6FI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Guido Kiener <guido.kiener@rohde-schwarz.com>,
        Steve Bayless <steve_bayless@keysight.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 288/422] usb: usbtmc: Fix ioctl USBTMC_IOCTL_ABORT_BULK_OUT
Date:   Tue, 19 Nov 2019 06:18:05 +0100
Message-Id: <20191119051417.648691342@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guido Kiener <guido@kiener-muenchen.de>

[ Upstream commit 0e59088e7ff7aeda49dedadbf0e967761b909ad8 ]

Add parameter 'tag' to function usbtmc_ioctl_abort_bulk_out_tag()
for future versions.

Use USBTMC_BUFSIZE (4k) instead of USBTMC_SIZE_IOBUFFER (2k).
Using USBTMC_SIZE_IOBUFFER is deprecated.

Insert a sleep of 50 ms between subsequent
CHECK_ABORT_BULK_OUT_STATUS control requests to avoid stressing
the instrument with repeated requests.

Use common macro USB_CTRL_GET_TIMEOUT instead of USBTMC_TIMEOUT.

Signed-off-by: Guido Kiener <guido.kiener@rohde-schwarz.com>
Reviewed-by: Steve Bayless <steve_bayless@keysight.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/class/usbtmc.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/class/usbtmc.c b/drivers/usb/class/usbtmc.c
index 83ffa5a14c3db..3ce45c9e9d20d 100644
--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -342,7 +342,8 @@ exit:
 
 }
 
-static int usbtmc_ioctl_abort_bulk_out(struct usbtmc_device_data *data)
+static int usbtmc_ioctl_abort_bulk_out_tag(struct usbtmc_device_data *data,
+					   u8 tag)
 {
 	struct device *dev;
 	u8 *buffer;
@@ -359,8 +360,8 @@ static int usbtmc_ioctl_abort_bulk_out(struct usbtmc_device_data *data)
 			     usb_rcvctrlpipe(data->usb_dev, 0),
 			     USBTMC_REQUEST_INITIATE_ABORT_BULK_OUT,
 			     USB_DIR_IN | USB_TYPE_CLASS | USB_RECIP_ENDPOINT,
-			     data->bTag_last_write, data->bulk_out,
-			     buffer, 2, USBTMC_TIMEOUT);
+			     tag, data->bulk_out,
+			     buffer, 2, USB_CTRL_GET_TIMEOUT);
 
 	if (rv < 0) {
 		dev_err(dev, "usb_control_msg returned %d\n", rv);
@@ -379,12 +380,14 @@ static int usbtmc_ioctl_abort_bulk_out(struct usbtmc_device_data *data)
 	n = 0;
 
 usbtmc_abort_bulk_out_check_status:
+	/* do not stress device with subsequent requests */
+	msleep(50);
 	rv = usb_control_msg(data->usb_dev,
 			     usb_rcvctrlpipe(data->usb_dev, 0),
 			     USBTMC_REQUEST_CHECK_ABORT_BULK_OUT_STATUS,
 			     USB_DIR_IN | USB_TYPE_CLASS | USB_RECIP_ENDPOINT,
 			     0, data->bulk_out, buffer, 0x08,
-			     USBTMC_TIMEOUT);
+			     USB_CTRL_GET_TIMEOUT);
 	n++;
 	if (rv < 0) {
 		dev_err(dev, "usb_control_msg returned %d\n", rv);
@@ -418,6 +421,11 @@ exit:
 	return rv;
 }
 
+static int usbtmc_ioctl_abort_bulk_out(struct usbtmc_device_data *data)
+{
+	return usbtmc_ioctl_abort_bulk_out_tag(data, data->bTag_last_write);
+}
+
 static int usbtmc488_ioctl_read_stb(struct usbtmc_file_data *file_data,
 				void __user *arg)
 {
-- 
2.20.1



