Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66A2BF66AE
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbfKJDOx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 22:14:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:37212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727719AbfKJCmD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:42:03 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E455E20650;
        Sun, 10 Nov 2019 02:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353722;
        bh=UfS95GJysZRLmUAshqxkU0vPr30zhIK/rGe4ZYB1oZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uu+Jo06soYQTVtxpXeuBCrWPusSIpe6S3r0NCHGzIGeiGoRasSNbJGBu3q0A7TNw1
         4Dplj3rVbGUC/zUHtjxQ1HEnaUyxViDOY81TOeCiSptCEBXmtAintMro/zTNxca1IO
         OyR86PQGongpQ/DvFhCAUOnjyI7PUmOrI48OyiQE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guido Kiener <guido@kiener-muenchen.de>,
        Guido Kiener <guido.kiener@rohde-schwarz.com>,
        Steve Bayless <steve_bayless@keysight.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 054/191] usb: usbtmc: Fix ioctl USBTMC_IOCTL_ABORT_BULK_OUT
Date:   Sat,  9 Nov 2019 21:37:56 -0500
Message-Id: <20191110024013.29782-54-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
@@ -342,7 +342,8 @@ static int usbtmc_ioctl_abort_bulk_in(struct usbtmc_device_data *data)
 
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
@@ -418,6 +421,11 @@ static int usbtmc_ioctl_abort_bulk_out(struct usbtmc_device_data *data)
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

