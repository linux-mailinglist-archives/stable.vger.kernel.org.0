Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 666CE119756
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbfLJVcQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:32:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:57562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726777AbfLJVJQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:09:16 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32A0D2469E;
        Tue, 10 Dec 2019 21:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012155;
        bh=6qxVuvGp1IqwShizSavmY8GXUi0ZLBs7ZhpmsN4Op/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qjmrdYNHHzKh4KoKqki04HHqO5X2fqoaC+nJh8CKMtfalfq+y3jWHP7i+tQKTmYug
         BnCSr5eyJOugbgR/DqMHw6Qtt9/UgA0BJegkjYBwRHgOhCB59b14JVAJDvsOhx5ewy
         3sdvRGGWQbQIhHurNx5cg8jb4WuiUy6lajSU2G1g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 118/350] Bluetooth: btusb: avoid unused function warning
Date:   Tue, 10 Dec 2019 16:03:43 -0500
Message-Id: <20191210210735.9077-79-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 42d22098127d6384f789107f59caae87d7520fc4 ]

The btusb_rtl_cmd_timeout() function is used inside of an
ifdef, leading to a warning when this part is hidden
from the compiler:

drivers/bluetooth/btusb.c:530:13: error: unused function 'btusb_rtl_cmd_timeout' [-Werror,-Wunused-function]

Use an IS_ENABLED() check instead so the compiler can see
the code and then discard it silently.

Fixes: d7ef0d1e3968 ("Bluetooth: btusb: Use cmd_timeout to reset Realtek device")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index a9c35ebb30f86..23e606aaaea49 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3807,8 +3807,8 @@ static int btusb_probe(struct usb_interface *intf,
 		btusb_check_needs_reset_resume(intf);
 	}
 
-#ifdef CONFIG_BT_HCIBTUSB_RTL
-	if (id->driver_info & BTUSB_REALTEK) {
+	if (IS_ENABLED(CONFIG_BT_HCIBTUSB_RTL) &&
+	    (id->driver_info & BTUSB_REALTEK)) {
 		hdev->setup = btrtl_setup_realtek;
 		hdev->shutdown = btrtl_shutdown_realtek;
 		hdev->cmd_timeout = btusb_rtl_cmd_timeout;
@@ -3819,7 +3819,6 @@ static int btusb_probe(struct usb_interface *intf,
 		 */
 		set_bit(BTUSB_WAKEUP_DISABLE, &data->flags);
 	}
-#endif
 
 	if (id->driver_info & BTUSB_AMP) {
 		/* AMP controllers do not support SCO packets */
-- 
2.20.1

