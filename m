Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48C38492E4
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729416AbfFQVY6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:24:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:50798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730002AbfFQVY4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:24:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EBC22063F;
        Mon, 17 Jun 2019 21:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806695;
        bh=w/hydCOjqgW8uONSveZfIb+bT2z90YdWoK/qwoTe1VU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YMlYHdr2Jo0iOnbMDYONDOv7UA/CoP8H8w/E5Oj53tyESXfiEG9yKI8euAT2ZUVLM
         gQF0MHG8uizoHrhvUfL+vzYTRQ7NnoUR7SpsMGONal8SVqJo9BbL8gMNYbdJTqLt/w
         PYmSMt6jVcVikd2bxOIw5szVJHDP0HNwSQTX7Yoo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gerecke <jason.gerecke@wacom.com>,
        Aaron Armstrong Skomra <aaron.skomra@wacom.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 4.19 04/75] HID: wacom: Dont set tool type until were in range
Date:   Mon, 17 Jun 2019 23:09:15 +0200
Message-Id: <20190617210753.003156342@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210752.799453599@linuxfoundation.org>
References: <20190617210752.799453599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gerecke <jason.gerecke@wacom.com>

commit 2cc08800a6b9fcda7c7afbcf2da1a6e8808da725 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/wacom_wac.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -1234,13 +1234,13 @@ static void wacom_intuos_pro2_bt_pen(str
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
@@ -1249,9 +1249,24 @@ static void wacom_intuos_pro2_bt_pen(str
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
 


