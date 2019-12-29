Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8C012C7F7
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731004AbfL2RtF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:49:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:60832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731261AbfL2RtE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:49:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9073206DB;
        Sun, 29 Dec 2019 17:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641744;
        bh=mPXe+j/UekjGyeu7KFX+1upusvWLubhG5A9IVZjXqoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sds4mOiWPaF336M2gcGWHsLqE84s1x1BsEvMmULUHvBKmevJKISXJmAydgT6a93NF
         BxgX0G4CCMNJkvoH3Cl0tBu9Bb76H9HkCwyfAAjzuyW9lVgGnLB0zsoDQxyGVTveKd
         v8CGSnHEUwgY6NKK9kWLZ7kV/0BABcxzeHUcxEGY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 152/434] Bluetooth: btusb: avoid unused function warning
Date:   Sun, 29 Dec 2019 18:23:25 +0100
Message-Id: <20191229172711.854616098@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a9c35ebb30f8..23e606aaaea4 100644
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



