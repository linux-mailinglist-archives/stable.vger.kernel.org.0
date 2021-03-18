Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4A7340936
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 16:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbhCRPwT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 11:52:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:54664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231273AbhCRPwA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Mar 2021 11:52:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32EC664F3B;
        Thu, 18 Mar 2021 15:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616082720;
        bh=qO3rm93arLtFLEEeNwJWlSISTAbncxMUvYOkKzvd61k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GQPYdIV1eZImNBox0Vy5sSgjatrMZjWFAKn7P4c0XeG1cAH2Oz/Gio9sfOmJUzsUg
         J5IY3MNFolABuheKHRXB+TZupyKfhVZB2pmEHszJauk/bW6gmT0bhkSBS9n7AqWD6k
         PzPmioIQjm+YOH0M6+bvMxXCXODbwxYEwWqW4bUh9NiqYgLqR3Lpeqny3uIwfE/QXu
         YpZK3/mUVdrJrtYBWEhHE4miuS18HZE3Q09ZuQYqhwUwey1ReGLMjhNDf/ZcE/5Ezj
         QYD8qHdsWpr3Q1uYfbMjKoubSt1mtiIudlMqq006AikKSqwwkClH5L8ZY2hdcox9i8
         4P5eY6TY13NrA==
Received: from johan by xi.lan with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1lMuwc-0005nS-2b; Thu, 18 Mar 2021 16:52:18 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Oliver Neukum <oneukum@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: [PATCH 2/7] USB: cdc-acm: fix use-after-free after probe failure
Date:   Thu, 18 Mar 2021 16:51:57 +0100
Message-Id: <20210318155202.22230-3-johan@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210318155202.22230-1-johan@kernel.org>
References: <20210318155202.22230-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If tty-device registration fails the driver would fail to release the
data interface. When the device is later disconnected, the disconnect
callback would still be called for the data interface and would go about
releasing already freed resources.

Fixes: c93d81955005 ("usb: cdc-acm: fix error handling in acm_probe()")
Cc: stable@vger.kernel.org      # 3.9
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/class/cdc-acm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index d75a78ad464d..dfc2480add91 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1503,6 +1503,11 @@ static int acm_probe(struct usb_interface *intf,
 
 	return 0;
 alloc_fail6:
+	if (!acm->combined_interfaces) {
+		/* Clear driver data so that disconnect() returns early. */
+		usb_set_intfdata(data_interface, NULL);
+		usb_driver_release_interface(&acm_driver, data_interface);
+	}
 	if (acm->country_codes) {
 		device_remove_file(&acm->control->dev,
 				&dev_attr_wCountryCodes);
-- 
2.26.2

