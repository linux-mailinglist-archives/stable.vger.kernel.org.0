Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1171D86A6
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729996AbgERSZ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:25:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:45418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729998AbgERRqC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:46:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD53320674;
        Mon, 18 May 2020 17:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823962;
        bh=pBf0XhgFQd7xKxxEm+vthMbvXZNC6xtGEr3S4kcDNIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dG4VIvj5oIUktrWxJx+0ekgGVZuojilDt4bE2MFDz/+IK1v9QbBsKTtvLW+BdzF+l
         oe/ofaly5Fbr9ofpyWkAHJTZ3pT29tWnOF4aO3EF2AlBHYjfMPJ4BZhUYgvyLGDZqk
         lOqd1N/H3TGXZT9QcKGEsLBq0sU2coUZ6+Yiv5hE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gerecke <jason.gerecke@wacom.com>,
        Aaron Armstrong Skomra <aaron.skomra@wacom.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.14 016/114] HID: wacom: Read HID_DG_CONTACTMAX directly for non-generic devices
Date:   Mon, 18 May 2020 19:35:48 +0200
Message-Id: <20200518173506.610881590@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173503.033975649@linuxfoundation.org>
References: <20200518173503.033975649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gerecke <jason.gerecke@wacom.com>

commit 778fbf4179991e7652e97d7f1ca1f657ef828422 upstream.

We've recently switched from extracting the value of HID_DG_CONTACTMAX
at a fixed offset (which may not be correct for all tablets) to
injecting the report into the driver for the generic codepath to handle.
Unfortunately, this change was made for *all* tablets, even those which
aren't generic. Because `wacom_wac_report` ignores reports from non-
generic devices, the contact count never gets initialized. Ultimately
this results in the touch device itself failing to probe, and thus the
loss of touch input.

This commit adds back the fixed-offset extraction for non-generic devices.

Link: https://github.com/linuxwacom/input-wacom/issues/155
Fixes: 184eccd40389 ("HID: wacom: generic: read HID_DG_CONTACTMAX from any feature report")
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Reviewed-by: Aaron Armstrong Skomra <aaron.skomra@wacom.com>
CC: stable@vger.kernel.org # 5.3+
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/wacom_sys.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -132,9 +132,11 @@ static void wacom_feature_mapping(struct
 			data[0] = field->report->id;
 			ret = wacom_get_report(hdev, HID_FEATURE_REPORT,
 					       data, n, WAC_CMD_RETRIES);
-			if (ret == n) {
+			if (ret == n && features->type == HID_GENERIC) {
 				ret = hid_report_raw_event(hdev,
 					HID_FEATURE_REPORT, data, n, 0);
+			} else if (ret == 2 && features->type != HID_GENERIC) {
+				features->touch_max = data[1];
 			} else {
 				features->touch_max = 16;
 				hid_warn(hdev, "wacom_feature_mapping: "


