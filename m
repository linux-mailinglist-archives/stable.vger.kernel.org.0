Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E862C0860
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729496AbgKWMtu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:49:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:34338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732888AbgKWMtU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:49:20 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D4A820732;
        Mon, 23 Nov 2020 12:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135759;
        bh=X28O1xP+tJ8wQizQvbaBr8eQpYLXp9iinUosF3HbRGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SKpSpRfU3aAewcdo0QDhCDKGymxxYymw2wiNK45w1NsMDSGwYCLYSVPYwkHlMyeVr
         Bsin+qT/+MY5pm4uvRGVLy6NOEftltMLSt6YFi1m2kCbz5uRoSDmYnnUtOB9L2cTB/
         /nwTJCegHPl53/sVQMI8YevI/EhgyRqsmq3whPII=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rishi Gupta <gupt21@gmail.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 186/252] HID: mcp2221: Fix GPIO output handling
Date:   Mon, 23 Nov 2020 13:22:16 +0100
Message-Id: <20201123121844.567285320@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lars Povlsen <lars.povlsen@microchip.com>

[ Upstream commit 567b8e9fed8add9e20885be38ecd73bb0e07406b ]

The mcp2221 driver GPIO output handling has has several issues.

* A wrong value is used for the GPIO direction.

* Wrong offsets are calculated for some GPIO set value/set direction
  operations, when offset is larger than 0.

This has been fixed by introducing proper manifest constants for the
direction encoding, and using 'offsetof' when calculating GPIO
register offsets.

The updated driver has been tested with the Sparx5 pcb134/pcb135
board, which has the mcp2221 device with several (output) GPIO's.

Fixes: 328de1c519c5c092 ("HID: mcp2221: add GPIO functionality support")
Reviewed-by: Rishi Gupta <gupt21@gmail.com>
Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-mcp2221.c | 48 +++++++++++++++++++++++++++++++--------
 1 file changed, 39 insertions(+), 9 deletions(-)

diff --git a/drivers/hid/hid-mcp2221.c b/drivers/hid/hid-mcp2221.c
index 0d27ccb55dd93..4211b9839209b 100644
--- a/drivers/hid/hid-mcp2221.c
+++ b/drivers/hid/hid-mcp2221.c
@@ -49,6 +49,36 @@ enum {
 	MCP2221_ALT_F_NOT_GPIOD = 0xEF,
 };
 
+/* MCP GPIO direction encoding */
+enum {
+	MCP2221_DIR_OUT = 0x00,
+	MCP2221_DIR_IN = 0x01,
+};
+
+#define MCP_NGPIO	4
+
+/* MCP GPIO set command layout */
+struct mcp_set_gpio {
+	u8 cmd;
+	u8 dummy;
+	struct {
+		u8 change_value;
+		u8 value;
+		u8 change_direction;
+		u8 direction;
+	} gpio[MCP_NGPIO];
+} __packed;
+
+/* MCP GPIO get command layout */
+struct mcp_get_gpio {
+	u8 cmd;
+	u8 dummy;
+	struct {
+		u8 direction;
+		u8 value;
+	} gpio[MCP_NGPIO];
+} __packed;
+
 /*
  * There is no way to distinguish responses. Therefore next command
  * is sent only after response to previous has been received. Mutex
@@ -542,7 +572,7 @@ static int mcp_gpio_get(struct gpio_chip *gc,
 
 	mcp->txbuf[0] = MCP2221_GPIO_GET;
 
-	mcp->gp_idx = (offset + 1) * 2;
+	mcp->gp_idx = offsetof(struct mcp_get_gpio, gpio[offset].value);
 
 	mutex_lock(&mcp->lock);
 	ret = mcp_send_data_req_status(mcp, mcp->txbuf, 1);
@@ -559,7 +589,7 @@ static void mcp_gpio_set(struct gpio_chip *gc,
 	memset(mcp->txbuf, 0, 18);
 	mcp->txbuf[0] = MCP2221_GPIO_SET;
 
-	mcp->gp_idx = ((offset + 1) * 4) - 1;
+	mcp->gp_idx = offsetof(struct mcp_set_gpio, gpio[offset].value);
 
 	mcp->txbuf[mcp->gp_idx - 1] = 1;
 	mcp->txbuf[mcp->gp_idx] = !!value;
@@ -575,7 +605,7 @@ static int mcp_gpio_dir_set(struct mcp2221 *mcp,
 	memset(mcp->txbuf, 0, 18);
 	mcp->txbuf[0] = MCP2221_GPIO_SET;
 
-	mcp->gp_idx = (offset + 1) * 5;
+	mcp->gp_idx = offsetof(struct mcp_set_gpio, gpio[offset].direction);
 
 	mcp->txbuf[mcp->gp_idx - 1] = 1;
 	mcp->txbuf[mcp->gp_idx] = val;
@@ -590,7 +620,7 @@ static int mcp_gpio_direction_input(struct gpio_chip *gc,
 	struct mcp2221 *mcp = gpiochip_get_data(gc);
 
 	mutex_lock(&mcp->lock);
-	ret = mcp_gpio_dir_set(mcp, offset, 0);
+	ret = mcp_gpio_dir_set(mcp, offset, MCP2221_DIR_IN);
 	mutex_unlock(&mcp->lock);
 
 	return ret;
@@ -603,7 +633,7 @@ static int mcp_gpio_direction_output(struct gpio_chip *gc,
 	struct mcp2221 *mcp = gpiochip_get_data(gc);
 
 	mutex_lock(&mcp->lock);
-	ret = mcp_gpio_dir_set(mcp, offset, 1);
+	ret = mcp_gpio_dir_set(mcp, offset, MCP2221_DIR_OUT);
 	mutex_unlock(&mcp->lock);
 
 	/* Can't configure as output, bailout early */
@@ -623,7 +653,7 @@ static int mcp_gpio_get_direction(struct gpio_chip *gc,
 
 	mcp->txbuf[0] = MCP2221_GPIO_GET;
 
-	mcp->gp_idx = (offset + 1) * 2;
+	mcp->gp_idx = offsetof(struct mcp_get_gpio, gpio[offset].direction);
 
 	mutex_lock(&mcp->lock);
 	ret = mcp_send_data_req_status(mcp, mcp->txbuf, 1);
@@ -632,7 +662,7 @@ static int mcp_gpio_get_direction(struct gpio_chip *gc,
 	if (ret)
 		return ret;
 
-	if (mcp->gpio_dir)
+	if (mcp->gpio_dir == MCP2221_DIR_IN)
 		return GPIO_LINE_DIRECTION_IN;
 
 	return GPIO_LINE_DIRECTION_OUT;
@@ -758,7 +788,7 @@ static int mcp2221_raw_event(struct hid_device *hdev,
 				mcp->status = -ENOENT;
 			} else {
 				mcp->status = !!data[mcp->gp_idx];
-				mcp->gpio_dir = !!data[mcp->gp_idx + 1];
+				mcp->gpio_dir = data[mcp->gp_idx + 1];
 			}
 			break;
 		default:
@@ -860,7 +890,7 @@ static int mcp2221_probe(struct hid_device *hdev,
 	mcp->gc->get_direction = mcp_gpio_get_direction;
 	mcp->gc->set = mcp_gpio_set;
 	mcp->gc->get = mcp_gpio_get;
-	mcp->gc->ngpio = 4;
+	mcp->gc->ngpio = MCP_NGPIO;
 	mcp->gc->base = -1;
 	mcp->gc->can_sleep = 1;
 	mcp->gc->parent = &hdev->dev;
-- 
2.27.0



