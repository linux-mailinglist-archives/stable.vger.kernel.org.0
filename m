Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6E8744F3A2
	for <lists+stable@lfdr.de>; Sat, 13 Nov 2021 15:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235743AbhKMOYG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Nov 2021 09:24:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:42960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231672AbhKMOYG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Nov 2021 09:24:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 581CC60F44;
        Sat, 13 Nov 2021 14:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636813273;
        bh=5z4/NBawM8ML8rhShO4TsomaEIugnbxivZ+C4Ljqr14=;
        h=Subject:To:Cc:From:Date:From;
        b=tOb6gWH7NrLjZCxbPngiKJCAtsAF24zbaXCQB4xr4hpWJ1+NOF04ytxk3eF19UP+m
         9Xr7jiNvBXlxN/G1S0nWRlb8muBvsr8hBUUugMSZdPuMwiPeL0hoepJEROhsrGAEOu
         9dX/KPfdUOZRHWRL+zQpqDi6zFewieaclhMSp+n4=
Subject: FAILED: patch "[PATCH] rtl8187: fix control-message timeouts" failed to apply to 4.4-stable tree
To:     johan@kernel.org, kvalo@codeaurora.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Nov 2021 15:21:11 +0100
Message-ID: <163681327118329@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2e9be536a213e838daed6ba42024dd68954ac061 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Mon, 25 Oct 2021 14:05:21 +0200
Subject: [PATCH] rtl8187: fix control-message timeouts

USB control-message timeouts are specified in milliseconds and should
specifically not vary with CONFIG_HZ.

Fixes: 605bebe23bf6 ("[PATCH] Add rtl8187 wireless driver")
Cc: stable@vger.kernel.org      # 2.6.23
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20211025120522.6045-4-johan@kernel.org

diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8187/rtl8225.c b/drivers/net/wireless/realtek/rtl818x/rtl8187/rtl8225.c
index 585784258c66..4efab907a3ac 100644
--- a/drivers/net/wireless/realtek/rtl818x/rtl8187/rtl8225.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8187/rtl8225.c
@@ -28,7 +28,7 @@ u8 rtl818x_ioread8_idx(struct rtl8187_priv *priv,
 	usb_control_msg(priv->udev, usb_rcvctrlpipe(priv->udev, 0),
 			RTL8187_REQ_GET_REG, RTL8187_REQT_READ,
 			(unsigned long)addr, idx & 0x03,
-			&priv->io_dmabuf->bits8, sizeof(val), HZ / 2);
+			&priv->io_dmabuf->bits8, sizeof(val), 500);
 
 	val = priv->io_dmabuf->bits8;
 	mutex_unlock(&priv->io_mutex);
@@ -45,7 +45,7 @@ u16 rtl818x_ioread16_idx(struct rtl8187_priv *priv,
 	usb_control_msg(priv->udev, usb_rcvctrlpipe(priv->udev, 0),
 			RTL8187_REQ_GET_REG, RTL8187_REQT_READ,
 			(unsigned long)addr, idx & 0x03,
-			&priv->io_dmabuf->bits16, sizeof(val), HZ / 2);
+			&priv->io_dmabuf->bits16, sizeof(val), 500);
 
 	val = priv->io_dmabuf->bits16;
 	mutex_unlock(&priv->io_mutex);
@@ -62,7 +62,7 @@ u32 rtl818x_ioread32_idx(struct rtl8187_priv *priv,
 	usb_control_msg(priv->udev, usb_rcvctrlpipe(priv->udev, 0),
 			RTL8187_REQ_GET_REG, RTL8187_REQT_READ,
 			(unsigned long)addr, idx & 0x03,
-			&priv->io_dmabuf->bits32, sizeof(val), HZ / 2);
+			&priv->io_dmabuf->bits32, sizeof(val), 500);
 
 	val = priv->io_dmabuf->bits32;
 	mutex_unlock(&priv->io_mutex);
@@ -79,7 +79,7 @@ void rtl818x_iowrite8_idx(struct rtl8187_priv *priv,
 	usb_control_msg(priv->udev, usb_sndctrlpipe(priv->udev, 0),
 			RTL8187_REQ_SET_REG, RTL8187_REQT_WRITE,
 			(unsigned long)addr, idx & 0x03,
-			&priv->io_dmabuf->bits8, sizeof(val), HZ / 2);
+			&priv->io_dmabuf->bits8, sizeof(val), 500);
 
 	mutex_unlock(&priv->io_mutex);
 }
@@ -93,7 +93,7 @@ void rtl818x_iowrite16_idx(struct rtl8187_priv *priv,
 	usb_control_msg(priv->udev, usb_sndctrlpipe(priv->udev, 0),
 			RTL8187_REQ_SET_REG, RTL8187_REQT_WRITE,
 			(unsigned long)addr, idx & 0x03,
-			&priv->io_dmabuf->bits16, sizeof(val), HZ / 2);
+			&priv->io_dmabuf->bits16, sizeof(val), 500);
 
 	mutex_unlock(&priv->io_mutex);
 }
@@ -107,7 +107,7 @@ void rtl818x_iowrite32_idx(struct rtl8187_priv *priv,
 	usb_control_msg(priv->udev, usb_sndctrlpipe(priv->udev, 0),
 			RTL8187_REQ_SET_REG, RTL8187_REQT_WRITE,
 			(unsigned long)addr, idx & 0x03,
-			&priv->io_dmabuf->bits32, sizeof(val), HZ / 2);
+			&priv->io_dmabuf->bits32, sizeof(val), 500);
 
 	mutex_unlock(&priv->io_mutex);
 }
@@ -183,7 +183,7 @@ static void rtl8225_write_8051(struct ieee80211_hw *dev, u8 addr, __le16 data)
 	usb_control_msg(priv->udev, usb_sndctrlpipe(priv->udev, 0),
 			RTL8187_REQ_SET_REG, RTL8187_REQT_WRITE,
 			addr, 0x8225, &priv->io_dmabuf->bits16, sizeof(data),
-			HZ / 2);
+			500);
 
 	mutex_unlock(&priv->io_mutex);
 

