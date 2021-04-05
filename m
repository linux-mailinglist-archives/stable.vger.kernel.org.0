Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25C15354069
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239641AbhDEJRt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:17:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:39780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239792AbhDEJRn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:17:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5080613AC;
        Mon,  5 Apr 2021 09:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614250;
        bh=WL1ZxEQxzl/JQBs3FER3IAxgsvUr28RtXr896Fwniew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rYrNYnjbdNx8MQk+W0Gf6jTy4JBtb6hYIZecdiFDkEjfNAWcEpnL/Bd2g7nH4/vjV
         la1sPqXAXP3RcQ5e0Bdz3aRZgFHBaHi5qCPIgbe9i46kYEkIBjjcyfkQch4WmVBad9
         UB2DkxwWiGfQZpD9Jwx86MfX6L8C1TQtyqmX3x5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Oliver Neukum <oneukum@suse.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.11 138/152] USB: cdc-acm: fix use-after-free after probe failure
Date:   Mon,  5 Apr 2021 10:54:47 +0200
Message-Id: <20210405085038.701140984@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 4e49bf376c0451ad2eae2592e093659cde12be9a upstream.

If tty-device registration fails the driver would fail to release the
data interface. When the device is later disconnected, the disconnect
callback would still be called for the data interface and would go about
releasing already freed resources.

Fixes: c93d81955005 ("usb: cdc-acm: fix error handling in acm_probe()")
Cc: stable@vger.kernel.org      # 3.9
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>
Acked-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210322155318.9837-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1516,6 +1516,11 @@ skip_countries:
 
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


