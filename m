Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD2645BF89
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346283AbhKXM7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:59:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:32872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346975AbhKXM51 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:57:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6064A6187D;
        Wed, 24 Nov 2021 12:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757183;
        bh=BkKXLQNYfTkx2I0te5W41J5T9C5in+TRlC6OyCZ4Dn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=midXiYF21d+8bP65RhULcvz1Xi2h5qsk7oN6dKM7jcjB9Oz0Yi+QCuwS/ItWMJD+/
         Vr0ZHIgAbQwsyDa4zlNmWbDIzLxxkGSy8kSFcH5l+dkwU/aQOwzst6S18BxlH4lNzW
         R0Y5RCkkCCRXRBXUi4aKboFKWefnyF5AvIBmHV74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.19 052/323] rtl8187: fix control-message timeouts
Date:   Wed, 24 Nov 2021 12:54:02 +0100
Message-Id: <20211124115720.631288034@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
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
@@ -31,7 +31,7 @@ u8 rtl818x_ioread8_idx(struct rtl8187_pr
 	usb_control_msg(priv->udev, usb_rcvctrlpipe(priv->udev, 0),
 			RTL8187_REQ_GET_REG, RTL8187_REQT_READ,
 			(unsigned long)addr, idx & 0x03,
-			&priv->io_dmabuf->bits8, sizeof(val), HZ / 2);
+			&priv->io_dmabuf->bits8, sizeof(val), 500);
 
 	val = priv->io_dmabuf->bits8;
 	mutex_unlock(&priv->io_mutex);
@@ -48,7 +48,7 @@ u16 rtl818x_ioread16_idx(struct rtl8187_
 	usb_control_msg(priv->udev, usb_rcvctrlpipe(priv->udev, 0),
 			RTL8187_REQ_GET_REG, RTL8187_REQT_READ,
 			(unsigned long)addr, idx & 0x03,
-			&priv->io_dmabuf->bits16, sizeof(val), HZ / 2);
+			&priv->io_dmabuf->bits16, sizeof(val), 500);
 
 	val = priv->io_dmabuf->bits16;
 	mutex_unlock(&priv->io_mutex);
@@ -65,7 +65,7 @@ u32 rtl818x_ioread32_idx(struct rtl8187_
 	usb_control_msg(priv->udev, usb_rcvctrlpipe(priv->udev, 0),
 			RTL8187_REQ_GET_REG, RTL8187_REQT_READ,
 			(unsigned long)addr, idx & 0x03,
-			&priv->io_dmabuf->bits32, sizeof(val), HZ / 2);
+			&priv->io_dmabuf->bits32, sizeof(val), 500);
 
 	val = priv->io_dmabuf->bits32;
 	mutex_unlock(&priv->io_mutex);
@@ -82,7 +82,7 @@ void rtl818x_iowrite8_idx(struct rtl8187
 	usb_control_msg(priv->udev, usb_sndctrlpipe(priv->udev, 0),
 			RTL8187_REQ_SET_REG, RTL8187_REQT_WRITE,
 			(unsigned long)addr, idx & 0x03,
-			&priv->io_dmabuf->bits8, sizeof(val), HZ / 2);
+			&priv->io_dmabuf->bits8, sizeof(val), 500);
 
 	mutex_unlock(&priv->io_mutex);
 }
@@ -96,7 +96,7 @@ void rtl818x_iowrite16_idx(struct rtl818
 	usb_control_msg(priv->udev, usb_sndctrlpipe(priv->udev, 0),
 			RTL8187_REQ_SET_REG, RTL8187_REQT_WRITE,
 			(unsigned long)addr, idx & 0x03,
-			&priv->io_dmabuf->bits16, sizeof(val), HZ / 2);
+			&priv->io_dmabuf->bits16, sizeof(val), 500);
 
 	mutex_unlock(&priv->io_mutex);
 }
@@ -110,7 +110,7 @@ void rtl818x_iowrite32_idx(struct rtl818
 	usb_control_msg(priv->udev, usb_sndctrlpipe(priv->udev, 0),
 			RTL8187_REQ_SET_REG, RTL8187_REQT_WRITE,
 			(unsigned long)addr, idx & 0x03,
-			&priv->io_dmabuf->bits32, sizeof(val), HZ / 2);
+			&priv->io_dmabuf->bits32, sizeof(val), 500);
 
 	mutex_unlock(&priv->io_mutex);
 }
@@ -186,7 +186,7 @@ static void rtl8225_write_8051(struct ie
 	usb_control_msg(priv->udev, usb_sndctrlpipe(priv->udev, 0),
 			RTL8187_REQ_SET_REG, RTL8187_REQT_WRITE,
 			addr, 0x8225, &priv->io_dmabuf->bits16, sizeof(data),
-			HZ / 2);
+			500);
 
 	mutex_unlock(&priv->io_mutex);
 


