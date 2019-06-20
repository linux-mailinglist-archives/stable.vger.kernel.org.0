Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F086F4D7B6
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbfFTSJ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:09:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:36868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727024AbfFTSJ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:09:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6418521530;
        Thu, 20 Jun 2019 18:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054164;
        bh=qtChJM3wYi/nDsqYmpo+7UfEXTZggKGl/B6JxWKoYI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hk+YRO9fOwt6dmniPmhtTSJNsF8Y5swZy5YtZskpzVIsH+M0vsYCJawiWLQOk4zk2
         IiuJCsTqNENZZwRJsYVyoMStmzhE5hSr2Gn/xh4ZF1tPpJimkMLYnZ+ZDSUT2tGWk7
         WpffWapydmHDzu8znnQuX6xaY6EjUp5uy3mFxVic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gerecke <jason.gerecke@wacom.com>,
        Aaron Armstrong Skomra <aaron.skomra@wacom.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 4.14 41/45] HID: wacom: Dont report anything prior to the tool entering range
Date:   Thu, 20 Jun 2019 19:57:43 +0200
Message-Id: <20190620174340.808229807@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174328.608036501@linuxfoundation.org>
References: <20190620174328.608036501@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gerecke <jason.gerecke@wacom.com>

commit e92a7be7fe5b2510fa60965eaf25f9e3dc08b8cc upstream.

If the tool spends some time in prox before entering range, a series of
events (e.g. ABS_DISTANCE, MSC_SERIAL) can be sent before we or userspace
have any clue about the pen whose data is being reported. We need to hold
off on reporting anything until the pen has entered range. Since we still
want to report events that occur "in prox" after the pen has *left* range
we use 'wacom-tool[0]' as the indicator that the pen did at one point
enter range and provide us/userspace with tool type and serial number
information.

Fixes: a48324de6d4d ("HID: wacom: Bluetooth IRQ for Intuos Pro should handle prox/range")
Cc: <stable@vger.kernel.org> # 4.11+
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Reviewed-by: Aaron Armstrong Skomra <aaron.skomra@wacom.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/wacom_wac.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -1271,17 +1271,19 @@ static void wacom_intuos_pro2_bt_pen(str
 			input_report_abs(pen_input, ABS_Z, rotation);
 			input_report_abs(pen_input, ABS_WHEEL, get_unaligned_le16(&frame[11]));
 		}
-		input_report_abs(pen_input, ABS_PRESSURE, get_unaligned_le16(&frame[5]));
-		input_report_abs(pen_input, ABS_DISTANCE, range ? frame[13] : wacom->features.distance_max);
+		if (wacom->tool[0]) {
+			input_report_abs(pen_input, ABS_PRESSURE, get_unaligned_le16(&frame[5]));
+			input_report_abs(pen_input, ABS_DISTANCE, range ? frame[13] : wacom->features.distance_max);
 
-		input_report_key(pen_input, BTN_TOUCH, frame[0] & 0x01);
-		input_report_key(pen_input, BTN_STYLUS, frame[0] & 0x02);
-		input_report_key(pen_input, BTN_STYLUS2, frame[0] & 0x04);
+			input_report_key(pen_input, BTN_TOUCH, frame[0] & 0x01);
+			input_report_key(pen_input, BTN_STYLUS, frame[0] & 0x02);
+			input_report_key(pen_input, BTN_STYLUS2, frame[0] & 0x04);
 
-		input_report_key(pen_input, wacom->tool[0], prox);
-		input_event(pen_input, EV_MSC, MSC_SERIAL, wacom->serial[0]);
-		input_report_abs(pen_input, ABS_MISC,
-				 wacom_intuos_id_mangle(wacom->id[0])); /* report tool id */
+			input_report_key(pen_input, wacom->tool[0], prox);
+			input_event(pen_input, EV_MSC, MSC_SERIAL, wacom->serial[0]);
+			input_report_abs(pen_input, ABS_MISC,
+					 wacom_intuos_id_mangle(wacom->id[0])); /* report tool id */
+		}
 
 		wacom->shared->stylus_in_proximity = prox;
 


