Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAD8744C7CA
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 19:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233808AbhKJSzd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 13:55:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:53388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233869AbhKJSxn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 13:53:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FAE86187A;
        Wed, 10 Nov 2021 18:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636570107;
        bh=AVQlWyKUF/GYoBG1RQPn3XUpzSClOSPv1HVhy+bEG/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iev4KiIQNngxxdyiUEGnmoKx8biT3Pbq+ICv+HPB58iWMoYQpL9wYREmfLNlZht63
         r02e088dBijilcPZqNUkcY0b8sKiwK7/5Xi3v5qiZ6qABu6Nlr+e8NZuywCMik/6HB
         N0malDvK8fEmyfrvdNFU6CsNNEe9cko+6B7gfRJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 19/21] staging: rtl8192u: fix control-message timeouts
Date:   Wed, 10 Nov 2021 19:44:05 +0100
Message-Id: <20211110182003.572445357@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211110182002.964190708@linuxfoundation.org>
References: <20211110182002.964190708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 4cfa36d312d6789448b59a7aae770ac8425017a3 upstream.

USB control-message timeouts are specified in milliseconds and should
specifically not vary with CONFIG_HZ.

Fixes: 8fc8598e61f6 ("Staging: Added Realtek rtl8192u driver to staging")
Cc: stable@vger.kernel.org      # 2.6.33
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20211025120910.6339-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8192u/r8192U_core.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -229,7 +229,7 @@ int write_nic_byte_E(struct net_device *
 
 	status = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 				 RTL8187_REQ_SET_REGS, RTL8187_REQT_WRITE,
-				 indx | 0xfe00, 0, usbdata, 1, HZ / 2);
+				 indx | 0xfe00, 0, usbdata, 1, 500);
 	kfree(usbdata);
 
 	if (status < 0) {
@@ -251,7 +251,7 @@ int read_nic_byte_E(struct net_device *d
 
 	status = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 				 RTL8187_REQ_GET_REGS, RTL8187_REQT_READ,
-				 indx | 0xfe00, 0, usbdata, 1, HZ / 2);
+				 indx | 0xfe00, 0, usbdata, 1, 500);
 	*data = *usbdata;
 	kfree(usbdata);
 
@@ -279,7 +279,7 @@ int write_nic_byte(struct net_device *de
 	status = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 				 RTL8187_REQ_SET_REGS, RTL8187_REQT_WRITE,
 				 (indx & 0xff) | 0xff00, (indx >> 8) & 0x0f,
-				 usbdata, 1, HZ / 2);
+				 usbdata, 1, 500);
 	kfree(usbdata);
 
 	if (status < 0) {
@@ -305,7 +305,7 @@ int write_nic_word(struct net_device *de
 	status = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 				 RTL8187_REQ_SET_REGS, RTL8187_REQT_WRITE,
 				 (indx & 0xff) | 0xff00, (indx >> 8) & 0x0f,
-				 usbdata, 2, HZ / 2);
+				 usbdata, 2, 500);
 	kfree(usbdata);
 
 	if (status < 0) {
@@ -331,7 +331,7 @@ int write_nic_dword(struct net_device *d
 	status = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 				 RTL8187_REQ_SET_REGS, RTL8187_REQT_WRITE,
 				 (indx & 0xff) | 0xff00, (indx >> 8) & 0x0f,
-				 usbdata, 4, HZ / 2);
+				 usbdata, 4, 500);
 	kfree(usbdata);
 
 	if (status < 0) {
@@ -355,7 +355,7 @@ int read_nic_byte(struct net_device *dev
 	status = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 				 RTL8187_REQ_GET_REGS, RTL8187_REQT_READ,
 				 (indx & 0xff) | 0xff00, (indx >> 8) & 0x0f,
-				 usbdata, 1, HZ / 2);
+				 usbdata, 1, 500);
 	*data = *usbdata;
 	kfree(usbdata);
 
@@ -380,7 +380,7 @@ int read_nic_word(struct net_device *dev
 	status = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 				 RTL8187_REQ_GET_REGS, RTL8187_REQT_READ,
 				 (indx & 0xff) | 0xff00, (indx >> 8) & 0x0f,
-				 usbdata, 2, HZ / 2);
+				 usbdata, 2, 500);
 	*data = *usbdata;
 	kfree(usbdata);
 
@@ -404,7 +404,7 @@ static int read_nic_word_E(struct net_de
 
 	status = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 				 RTL8187_REQ_GET_REGS, RTL8187_REQT_READ,
-				 indx | 0xfe00, 0, usbdata, 2, HZ / 2);
+				 indx | 0xfe00, 0, usbdata, 2, 500);
 	*data = *usbdata;
 	kfree(usbdata);
 
@@ -430,7 +430,7 @@ int read_nic_dword(struct net_device *de
 	status = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 				 RTL8187_REQ_GET_REGS, RTL8187_REQT_READ,
 				 (indx & 0xff) | 0xff00, (indx >> 8) & 0x0f,
-				 usbdata, 4, HZ / 2);
+				 usbdata, 4, 500);
 	*data = *usbdata;
 	kfree(usbdata);
 


