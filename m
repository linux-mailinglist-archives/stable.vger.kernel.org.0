Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4516F8BA82
	for <lists+stable@lfdr.de>; Tue, 13 Aug 2019 15:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729168AbfHMNiS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 09:38:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11132 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729055AbfHMNiR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 09:38:17 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D4CF13003C52;
        Tue, 13 Aug 2019 13:38:17 +0000 (UTC)
Received: from plouf.redhat.com (ovpn-117-165.ams2.redhat.com [10.36.117.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A49C6E6F0;
        Tue, 13 Aug 2019 13:38:16 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     =?UTF-8?q?Filipe=20La=C3=ADns?= <lains@archlinux.org>,
        Jiri Kosina <jikos@kernel.org>
Cc:     linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/2] HID: logitech-hidpp: remove support for the G700 over USB
Date:   Tue, 13 Aug 2019 15:38:07 +0200
Message-Id: <20190813133807.12384-3-benjamin.tissoires@redhat.com>
In-Reply-To: <20190813133807.12384-1-benjamin.tissoires@redhat.com>
References: <20190813133807.12384-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Tue, 13 Aug 2019 13:38:17 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The G700 suffers from the same issue than the G502:
when plugging it in, the driver tries to contact it but it fails.

This timeout is problematic as it introduce a delay in the boot,
and having only the mouse event node means that the hardware
macros keys can not be relayed to the userspace.

Link: https://github.com/libratbag/libratbag/issues/797
Fixes: 91cf9a98ae41 ("HID: logitech-hidpp: make .probe usbhid capable")
Cc: stable@vger.kernel.org # v5.2
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-logitech-hidpp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 343052b117a9..0179f7ed77e5 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -3751,8 +3751,6 @@ static const struct hid_device_id hidpp_devices[] = {
 
 	{ /* Logitech G403 Wireless Gaming Mouse over USB */
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC082) },
-	{ /* Logitech G700 Gaming Mouse over USB */
-	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC06B) },
 	{ /* Logitech G703 Gaming Mouse over USB */
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC087) },
 	{ /* Logitech G703 Hero Gaming Mouse over USB */
-- 
2.19.2

