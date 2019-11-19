Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE96B101417
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729092AbfKSFaM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:30:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:48890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729079AbfKSFaL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:30:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C197C2235E;
        Tue, 19 Nov 2019 05:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141410;
        bh=YaAnZe6wyX9fxEM1lRGTju1octGXXJSXfSe4283HvmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vqHR17Uyuzfvz7UvjyuaatYbFFUcLC7sRYpCxTST76yqs2PBycgd8hfzOqFnaj7dd
         FJcC7eH+/EMpT1b0Mb9xF2MZz1/rJuw9v3kFhcGyqSYRDvQt8xExB3NbK0k8ukEXq7
         s7rHL7EA5Ku7HsJlJhvHbW3vS5dI6cJVJwlPvCeg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 152/422] usb: mtu3: disable vbus rise/fall interrupts of ltssm
Date:   Tue, 19 Nov 2019 06:15:49 +0100
Message-Id: <20191119051408.462467925@linuxfoundation.org>
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



