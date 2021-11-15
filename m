Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8CD450AE3
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236953AbhKORPb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:15:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:49898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236615AbhKOROi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:14:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6ABBE6324A;
        Mon, 15 Nov 2021 17:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996259;
        bh=Evu+K9Wkb9pU6sX9ikL1VUHN234Qn9kIHg2N8HqSdVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tyrk3/JAk2bMXDaAEGNlogCuV1jjcq8Dr/cAreYSUl2b54x14ZY56dRkvLzJTmvLH
         3ORdmOR4A8Dk35knOm5b4eTRe0KiCHj3w7b2nQ49vPQPl9KF96hLjQpm0gubyQYqxm
         cv6+gmBPEGn8VFLjglt7rKpeE2Q4s09XpqngoK+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.4 075/355] rtl8187: fix control-message timeouts
Date:   Mon, 15 Nov 2021 17:59:59 +0100
Message-Id: <20211115165316.234199680@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 2e9be536a213e838daed6ba42024dd68954ac061 upstream.

USB control-message timeouts are specified in milliseconds and should
specifically not vary with CONFIG_HZ.

Fixes: 605bebe23bf6 ("[PATCH] Add rtl8187 wireless driver")
Cc: stable@vger.kernel.org      # 2.6.23
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20211025120522.6045-4-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtl818x/rtl8187/rtl8225.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/net/wireless/realtek/rtl818x/rtl8187/rtl8225.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8187/rtl8225.c
@@ -28,7 +28,7 @@ u8 rtl818x_ioread8_idx(struct rtl8187_pr
 	usb_control_msg(priv->udev, usb_rcvctrlpipe(priv->udev, 0),
 			RTL8187_REQ_GET_REG, RTL8187_REQT_READ,
 			(unsigned long)addr, idx & 0x03,
-			&priv->io_dmabuf->bits8, sizeof(val), HZ / 2);
+			&priv->io_dmabuf->bits8, sizeof(val), 500);
 
 	val = priv->io_dmabuf->bits8;
 	mutex_unlock(&priv->io_mutex);
@@ -45,7 +45,7 @@ u16 rtl818x_ioread16_idx(struct rtl8187_
 	usb_control_msg(priv->udev, usb_rcvctrlpipe(priv->udev, 0),
 			RTL8187_REQ_GET_REG, RTL8187_REQT_READ,
 			(unsigned long)addr, idx & 0x03,
-			&priv->io_dmabuf->bits16, sizeof(val), HZ / 2);
+			&priv->io_dmabuf->bits16, sizeof(val), 500);
 
 	val = priv->io_dmabuf->bits16;
 	mutex_unlock(&priv->io_mutex);
@@ -62,7 +62,7 @@ u32 rtl818x_ioread32_idx(struct rtl8187_
 	usb_control_msg(priv->udev, usb_rcvctrlpipe(priv->udev, 0),
 			RTL8187_REQ_GET_REG, RTL8187_REQT_READ,
 			(unsigned long)addr, idx & 0x03,
-			&priv->io_dmabuf->bits32, sizeof(val), HZ / 2);
+			&priv->io_dmabuf->bits32, sizeof(val), 500);
 
 	val = priv->io_dmabuf->bits32;
 	mutex_unlock(&priv->io_mutex);
@@ -79,7 +79,7 @@ void rtl818x_iowrite8_idx(struct rtl8187
 	usb_control_msg(priv->udev, usb_sndctrlpipe(priv->udev, 0),
 			RTL8187_REQ_SET_REG, RTL8187_REQT_WRITE,
 			(unsigned long)addr, idx & 0x03,
-			&priv->io_dmabuf->bits8, sizeof(val), HZ / 2);
+			&priv->io_dmabuf->bits8, sizeof(val), 500);
 
 	mutex_unlock(&priv->io_mutex);
 }
@@ -93,7 +93,7 @@ void rtl818x_iowrite16_idx(struct rtl818
 	usb_control_msg(priv->udev, usb_sndctrlpipe(priv->udev, 0),
 			RTL8187_REQ_SET_REG, RTL8187_REQT_WRITE,
 			(unsigned long)addr, idx & 0x03,
-			&priv->io_dmabuf->bits16, sizeof(val), HZ / 2);
+			&priv->io_dmabuf->bits16, sizeof(val), 500);
 
 	mutex_unlock(&priv->io_mutex);
 }
@@ -107,7 +107,7 @@ void rtl818x_iowrite32_idx(struct rtl818
 	usb_control_msg(priv->udev, usb_sndctrlpipe(priv->udev, 0),
 			RTL8187_REQ_SET_REG, RTL8187_REQT_WRITE,
 			(unsigned long)addr, idx & 0x03,
-			&priv->io_dmabuf->bits32, sizeof(val), HZ / 2);
+			&priv->io_dmabuf->bits32, sizeof(val), 500);
 
 	mutex_unlock(&priv->io_mutex);
 }
@@ -183,7 +183,7 @@ static void rtl8225_write_8051(struct ie
 	usb_control_msg(priv->udev, usb_sndctrlpipe(priv->udev, 0),
 			RTL8187_REQ_SET_REG, RTL8187_REQT_WRITE,
 			addr, 0x8225, &priv->io_dmabuf->bits16, sizeof(data),
-			HZ / 2);
+			500);
 
 	mutex_unlock(&priv->io_mutex);
 


