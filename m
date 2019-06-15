Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 863C1470E1
	for <lists+stable@lfdr.de>; Sat, 15 Jun 2019 17:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbfFOPbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jun 2019 11:31:08 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:43919 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726934AbfFOPbI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jun 2019 11:31:08 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id F232C21E56;
        Sat, 15 Jun 2019 11:31:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sat, 15 Jun 2019 11:31:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=OanErY
        Ny5FH9Om+qSG7uofvmQ+oCy7zkEULUfvQnfVo=; b=HJo6tKpEGZuOfwgHU+vWjl
        UpQK6Jm8LHAxwSD778+PT4c3T7vYU7lGVCFiac1CsM8mfgllgY9sxB2oo3jW3cbe
        +ki1odVVbSW+mAYaKBNcIL7g3A0SzA25qLJXG6iFz6dnummKfymOsPF8yW4XS2KE
        CiZNx/X9B51tgVttUdHuvaNbxX5mHb4iQcjkDIKB9COI1MpQs4naZQFSXQY80iM6
        8irJ7mcuYDrieq740FSf67kBe2Kcf2Jih3YvhLUAcaZlQFa2nPrWld13WbmsTcwL
        wsIojVxmGidLfxxc4KT0pOS73VlLPIePPv3JswqTiqWBxVBTPXenX5upnYDR0suA
        ==
X-ME-Sender: <xms:Og8FXbJsobjABez9-GDAP0XYKDAc0EBeJ1oFTHIrgOCQJsZEj1KLyQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudeifedgleduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:Og8FXRsUL2ezNqX_s94JptZNxzvCpjMMinmxmHJwFT1JfOmSeIllEw>
    <xmx:Og8FXXWmHbWcWJrsDBHliBrYgFxXMjsVU3xi-IDnxpb5d_0h8jEDHA>
    <xmx:Og8FXUizlbitF9SbMW9l0d6Sd1lRPt3DTq-4_d9sxcSW_gftZAszVg>
    <xmx:Og8FXZGCTpMdPSllXP6vaw8ihntdsxZ5fOuWIxeaRfMX-4KLrT_Hug>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C33BD8005B;
        Sat, 15 Jun 2019 11:31:05 -0400 (EDT)
Subject: FAILED: patch "[PATCH] HID: wacom: Don't set tool type until we're in range" failed to apply to 4.14-stable tree
To:     jason.gerecke@wacom.com, aaron.skomra@wacom.com,
        benjamin.tissoires@redhat.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 15 Jun 2019 17:31:04 +0200
Message-ID: <15606126649212@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2cc08800a6b9fcda7c7afbcf2da1a6e8808da725 Mon Sep 17 00:00:00 2001
From: Jason Gerecke <jason.gerecke@wacom.com>
Date: Wed, 24 Apr 2019 15:12:57 -0700
Subject: [PATCH] HID: wacom: Don't set tool type until we're in range

The serial number and tool type information that is reported by the tablet
while a pen is merely "in prox" instead of fully "in range" can be stale
and cause us to report incorrect tool information. Serial number, tool
type, and other information is only valid once the pen comes fully in range
so we should be careful to not use this information until that point.

In particular, this issue may cause the driver to incorectly report
BTN_TOOL_RUBBER after switching from the eraser tool back to the pen.

Fixes: a48324de6d4d ("HID: wacom: Bluetooth IRQ for Intuos Pro should handle prox/range")
Cc: <stable@vger.kernel.org> # 4.11+
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Reviewed-by: Aaron Armstrong Skomra <aaron.skomra@wacom.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index 747730d32ab6..4c1bc239207e 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -1236,13 +1236,13 @@ static void wacom_intuos_pro2_bt_pen(struct wacom_wac *wacom)
 		/* Add back in missing bits of ID for non-USI pens */
 		wacom->id[0] |= (wacom->serial[0] >> 32) & 0xFFFFF;
 	}
-	wacom->tool[0]   = wacom_intuos_get_tool_type(wacom_intuos_id_mangle(wacom->id[0]));
 
 	for (i = 0; i < pen_frames; i++) {
 		unsigned char *frame = &data[i*pen_frame_len + 1];
 		bool valid = frame[0] & 0x80;
 		bool prox = frame[0] & 0x40;
 		bool range = frame[0] & 0x20;
+		bool invert = frame[0] & 0x10;
 
 		if (!valid)
 			continue;
@@ -1251,9 +1251,24 @@ static void wacom_intuos_pro2_bt_pen(struct wacom_wac *wacom)
 			wacom->shared->stylus_in_proximity = false;
 			wacom_exit_report(wacom);
 			input_sync(pen_input);
+
+			wacom->tool[0] = 0;
+			wacom->id[0] = 0;
+			wacom->serial[0] = 0;
 			return;
 		}
+
 		if (range) {
+			if (!wacom->tool[0]) { /* first in range */
+				/* Going into range select tool */
+				if (invert)
+					wacom->tool[0] = BTN_TOOL_RUBBER;
+				else if (wacom->id[0])
+					wacom->tool[0] = wacom_intuos_get_tool_type(wacom->id[0]);
+				else
+					wacom->tool[0] = BTN_TOOL_PEN;
+			}
+
 			input_report_abs(pen_input, ABS_X, get_unaligned_le16(&frame[1]));
 			input_report_abs(pen_input, ABS_Y, get_unaligned_le16(&frame[3]));
 

