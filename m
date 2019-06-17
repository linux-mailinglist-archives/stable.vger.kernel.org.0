Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4825D49330
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729588AbfFQV2c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:28:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729095AbfFQV23 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:28:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27BC3204FD;
        Mon, 17 Jun 2019 21:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806908;
        bh=W0nEJ2HcSn5ppc2AopiwdJYBkCjGNiQP/SC3t8g1ZkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q3t6bHRiT+HKyCOg3aKbeIUpIW+rwxv2LGidZhyXbExZSiufZvnoqpq5AENLQV6gz
         UVWfO9ucJJTP/VkEtxJAaCcMRSloWEAqQ6kdrwGY6+QYeZ2DLEg+GjzKyV+T8zzXA3
         CFnhCVAtU043+tMClMGiMdo1QY7sSnkq5XedEwhM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gerecke <jason.gerecke@wacom.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 4.14 04/53] HID: wacom: Sync INTUOSP2_BT touch state after each frame if necessary
Date:   Mon, 17 Jun 2019 23:09:47 +0200
Message-Id: <20190617210746.039489860@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210745.104187490@linuxfoundation.org>
References: <20190617210745.104187490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gerecke <jason.gerecke@wacom.com>

commit 69dbdfffef20c715df9f381b2cee4e9e0a4efd93 upstream.

The Bluetooth interface of the 2nd-gen Intuos Pro batches together four
independent "frames" of finger data into a single report. Each frame
is essentially equivalent to a single USB report, with the up-to-10
fingers worth of information being spread across two frames. At the
moment the driver only calls `input_sync` after processing all four
frames have been processed, which can result in the driver sending
multiple updates for a single slot within the same SYN_REPORT. This
can confuse userspace, so modify the driver to sync more often if
necessary (i.e., after reporting the state of all fingers).

Fixes: 4922cd26f03c ("HID: wacom: Support 2nd-gen Intuos Pro's Bluetooth classic interface")
Cc: <stable@vger.kernel.org> # 4.11+
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/wacom_wac.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -1328,11 +1328,17 @@ static void wacom_intuos_pro2_bt_touch(s
 		if (wacom->num_contacts_left <= 0) {
 			wacom->num_contacts_left = 0;
 			wacom->shared->touch_down = wacom_wac_finger_count_touches(wacom);
+			input_sync(touch_input);
 		}
 	}
 
-	input_report_switch(touch_input, SW_MUTE_DEVICE, !(data[281] >> 7));
-	input_sync(touch_input);
+	if (wacom->num_contacts_left == 0) {
+		// Be careful that we don't accidentally call input_sync with
+		// only a partial set of fingers of processed
+		input_report_switch(touch_input, SW_MUTE_DEVICE, !(data[281] >> 7));
+		input_sync(touch_input);
+	}
+
 }
 
 static void wacom_intuos_pro2_bt_pad(struct wacom_wac *wacom)


