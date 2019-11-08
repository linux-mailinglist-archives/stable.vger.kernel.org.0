Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03C64F4639
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388997AbfKHLk4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:40:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:53962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389052AbfKHLk4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:40:56 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64FAF222C5;
        Fri,  8 Nov 2019 11:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213255;
        bh=YaAnZe6wyX9fxEM1lRGTju1octGXXJSXfSe4283HvmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CXPwREbCtbVYppQTaON/TDF3voKoDveYhuIhJwlX+y+vifr52iWyZmS+Xp0gFl+Fo
         KMwQg+/B4YwYj9YIi73g3iVKIICONfr702vWqul8gb5IwJwSmISd/7n66miYqN2WPk
         4+mmq41+z1pW+JAqZp32SM3/OLV65Vr7NCInDr44=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 120/205] usb: mtu3: disable vbus rise/fall interrupts of ltssm
Date:   Fri,  8 Nov 2019 06:36:27 -0500
Message-Id: <20191108113752.12502-120-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

[ Upstream commit 0eae49582b4dee1a0e96007e1dea5122db98371a ]

The vbus rise & fall interrupts are used to enable and disable
U3 function of device automatically, this cause some issues when
class driver is initialized as deactivated, and will skip over
software-controlled connect by pullup(), but UDC wants to keep
disconnect until usb_gadget_activate() is called which calls
pullup() if needed. So we disable vbus rise & fall interrupts
and just use pullup() to enable & disable U3 function, and reset
mtu3 state when disconnect instead when vbus fall.

Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/mtu3/mtu3_core.c   |  4 ++--
 drivers/usb/mtu3/mtu3_gadget.c | 22 ++++++++++++++--------
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/mtu3/mtu3_core.c b/drivers/usb/mtu3/mtu3_core.c
index 48d10a61e271c..8606935201326 100644
--- a/drivers/usb/mtu3/mtu3_core.c
+++ b/drivers/usb/mtu3/mtu3_core.c
@@ -185,8 +185,8 @@ static void mtu3_intr_enable(struct mtu3 *mtu)
 
 	if (mtu->is_u3_ip) {
 		/* Enable U3 LTSSM interrupts */
-		value = HOT_RST_INTR | WARM_RST_INTR | VBUS_RISE_INTR |
-		    VBUS_FALL_INTR | ENTER_U3_INTR | EXIT_U3_INTR;
+		value = HOT_RST_INTR | WARM_RST_INTR |
+			ENTER_U3_INTR | EXIT_U3_INTR;
 		mtu3_writel(mbase, U3D_LTSSM_INTR_ENABLE, value);
 	}
 
diff --git a/drivers/usb/mtu3/mtu3_gadget.c b/drivers/usb/mtu3/mtu3_gadget.c
index 5c60a8c5a0b5c..bbcd3332471dc 100644
--- a/drivers/usb/mtu3/mtu3_gadget.c
+++ b/drivers/usb/mtu3/mtu3_gadget.c
@@ -585,6 +585,17 @@ static const struct usb_gadget_ops mtu3_gadget_ops = {
 	.udc_stop = mtu3_gadget_stop,
 };
 
+static void mtu3_state_reset(struct mtu3 *mtu)
+{
+	mtu->address = 0;
+	mtu->ep0_state = MU3D_EP0_STATE_SETUP;
+	mtu->may_wakeup = 0;
+	mtu->u1_enable = 0;
+	mtu->u2_enable = 0;
+	mtu->delayed_status = false;
+	mtu->test_mode = false;
+}
+
 static void init_hw_ep(struct mtu3 *mtu, struct mtu3_ep *mep,
 		u32 epnum, u32 is_in)
 {
@@ -702,6 +713,7 @@ void mtu3_gadget_disconnect(struct mtu3 *mtu)
 		spin_lock(&mtu->lock);
 	}
 
+	mtu3_state_reset(mtu);
 	usb_gadget_set_state(&mtu->g, USB_STATE_NOTATTACHED);
 }
 
@@ -712,12 +724,6 @@ void mtu3_gadget_reset(struct mtu3 *mtu)
 	/* report disconnect, if we didn't flush EP state */
 	if (mtu->g.speed != USB_SPEED_UNKNOWN)
 		mtu3_gadget_disconnect(mtu);
-
-	mtu->address = 0;
-	mtu->ep0_state = MU3D_EP0_STATE_SETUP;
-	mtu->may_wakeup = 0;
-	mtu->u1_enable = 0;
-	mtu->u2_enable = 0;
-	mtu->delayed_status = false;
-	mtu->test_mode = false;
+	else
+		mtu3_state_reset(mtu);
 }
-- 
2.20.1

