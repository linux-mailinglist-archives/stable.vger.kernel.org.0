Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A80F4395A7
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 14:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbhJYML5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 08:11:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:51168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231129AbhJYML4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 08:11:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 300C261027;
        Mon, 25 Oct 2021 12:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635163774;
        bh=EGjKXJy8loDvFC96rlnDTCB3Gw3397vC7wfYDdq4+DQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l5+WSdKuJ2Jh84SJBmuDrG5TZLruGTPB8NjY1TlVvU6hc7I6y/YnVR/D9srLMnVgD
         mAqRHHS6wTA6g6AgkWUbyYZugsVNC0p+uqx/Hjb7d5MJRwSXCliw1cLpsajPsRFpHX
         KVnnKs/zg6Kvk9jfb6IB2VjQMh0+qLoiZ/YHnRYbHg5rjerxJseDuCeOqyQxRNA0vj
         GTluVdeK5LYzaUBifbyESt0hmdt7bSNB2CnxpQ5J92OUF2jbBt9eE9cms4kwySRq1i
         9AbRxFQrcN3mb4mVibAygsVqrR0rU8FmO2CjXFdlZRxYcYLWw7xr3JiM+VR1wYCr60
         AFdh1uWJvalMA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1meymz-0001f7-2P; Mon, 25 Oct 2021 14:09:17 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        linux-staging@lists.linux.dev, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] staging: rtl8192u: fix control-message timeouts
Date:   Mon, 25 Oct 2021 14:09:09 +0200
Message-Id: <20211025120910.6339-2-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211025120910.6339-1-johan@kernel.org>
References: <20211025120910.6339-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

USB control-message timeouts are specified in milliseconds and should
specifically not vary with CONFIG_HZ.

Fixes: 8fc8598e61f6 ("Staging: Added Realtek rtl8192u driver to staging")
Cc: stable@vger.kernel.org      # 2.6.33
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/staging/rtl8192u/r8192U_core.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index b6698656fc01..cf5cfee2936f 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -229,7 +229,7 @@ int write_nic_byte_E(struct net_device *dev, int indx, u8 data)
 
 	status = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 				 RTL8187_REQ_SET_REGS, RTL8187_REQT_WRITE,
-				 indx | 0xfe00, 0, usbdata, 1, HZ / 2);
+				 indx | 0xfe00, 0, usbdata, 1, 500);
 	kfree(usbdata);
 
 	if (status < 0) {
@@ -251,7 +251,7 @@ int read_nic_byte_E(struct net_device *dev, int indx, u8 *data)
 
 	status = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 				 RTL8187_REQ_GET_REGS, RTL8187_REQT_READ,
-				 indx | 0xfe00, 0, usbdata, 1, HZ / 2);
+				 indx | 0xfe00, 0, usbdata, 1, 500);
 	*data = *usbdata;
 	kfree(usbdata);
 
@@ -279,7 +279,7 @@ int write_nic_byte(struct net_device *dev, int indx, u8 data)
 	status = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 				 RTL8187_REQ_SET_REGS, RTL8187_REQT_WRITE,
 				 (indx & 0xff) | 0xff00, (indx >> 8) & 0x0f,
-				 usbdata, 1, HZ / 2);
+				 usbdata, 1, 500);
 	kfree(usbdata);
 
 	if (status < 0) {
@@ -305,7 +305,7 @@ int write_nic_word(struct net_device *dev, int indx, u16 data)
 	status = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 				 RTL8187_REQ_SET_REGS, RTL8187_REQT_WRITE,
 				 (indx & 0xff) | 0xff00, (indx >> 8) & 0x0f,
-				 usbdata, 2, HZ / 2);
+				 usbdata, 2, 500);
 	kfree(usbdata);
 
 	if (status < 0) {
@@ -331,7 +331,7 @@ int write_nic_dword(struct net_device *dev, int indx, u32 data)
 	status = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 				 RTL8187_REQ_SET_REGS, RTL8187_REQT_WRITE,
 				 (indx & 0xff) | 0xff00, (indx >> 8) & 0x0f,
-				 usbdata, 4, HZ / 2);
+				 usbdata, 4, 500);
 	kfree(usbdata);
 
 	if (status < 0) {
@@ -355,7 +355,7 @@ int read_nic_byte(struct net_device *dev, int indx, u8 *data)
 	status = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 				 RTL8187_REQ_GET_REGS, RTL8187_REQT_READ,
 				 (indx & 0xff) | 0xff00, (indx >> 8) & 0x0f,
-				 usbdata, 1, HZ / 2);
+				 usbdata, 1, 500);
 	*data = *usbdata;
 	kfree(usbdata);
 
@@ -380,7 +380,7 @@ int read_nic_word(struct net_device *dev, int indx, u16 *data)
 	status = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 				 RTL8187_REQ_GET_REGS, RTL8187_REQT_READ,
 				 (indx & 0xff) | 0xff00, (indx >> 8) & 0x0f,
-				 usbdata, 2, HZ / 2);
+				 usbdata, 2, 500);
 	*data = *usbdata;
 	kfree(usbdata);
 
@@ -404,7 +404,7 @@ static int read_nic_word_E(struct net_device *dev, int indx, u16 *data)
 
 	status = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 				 RTL8187_REQ_GET_REGS, RTL8187_REQT_READ,
-				 indx | 0xfe00, 0, usbdata, 2, HZ / 2);
+				 indx | 0xfe00, 0, usbdata, 2, 500);
 	*data = *usbdata;
 	kfree(usbdata);
 
@@ -430,7 +430,7 @@ int read_nic_dword(struct net_device *dev, int indx, u32 *data)
 	status = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 				 RTL8187_REQ_GET_REGS, RTL8187_REQT_READ,
 				 (indx & 0xff) | 0xff00, (indx >> 8) & 0x0f,
-				 usbdata, 4, HZ / 2);
+				 usbdata, 4, 500);
 	*data = *usbdata;
 	kfree(usbdata);
 
-- 
2.32.0

