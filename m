Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4C73449CE
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 16:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhCVPxT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 11:53:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:49030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230385AbhCVPxP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 11:53:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B48DB6199F;
        Mon, 22 Mar 2021 15:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616428394;
        bh=+Zhc0a9ydorofyGsDShMu+wWptgazNqMAEcHASrxkjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AIFuHItZDUfQfbKDQN0PRbJrOiU/izGVQyMW3LpNgkvvtshaovfwv33tg3BwpfuTY
         OEpk/hDoS/JJh0jOMRzOANFWMyREMG2UqJHlsO2pRphqog5C6SqObl9YQPJz5tNwxp
         SikATzOhA+kTjvX2HS2yyoKXk6uQH1OHEq2IwRb6TG1PvbbO5eXEnGMe+j+TtTuSHA
         j7E77jKrSm4oYG232aP0p+XwnXhwvNKgThNICffP/lpxv//wvHJENs6cK2oABfTFSf
         CJWlNkE/wxa1TCCr0G0mfnx8KmlvmDuzwEbZmFp40Dm/fkqEa3t7UfpavJzknnjd7D
         X41gUPuFyA7PQ==
Received: from johan by xi.lan with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1lOMs0-0002Za-Lk; Mon, 22 Mar 2021 16:53:32 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Oliver Neukum <oneukum@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: [PATCH v2 2/8] USB: cdc-acm: fix use-after-free after probe failure
Date:   Mon, 22 Mar 2021 16:53:12 +0100
Message-Id: <20210322155318.9837-3-johan@kernel.org>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210322155318.9837-1-johan@kernel.org>
References: <20210322155318.9837-1-johan@kernel.org>
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
Acked-by: Oliver Neukum <oneukum@suse.com>
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
2.26.3

