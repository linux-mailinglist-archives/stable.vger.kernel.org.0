Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD711353D6C
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237017AbhDEI7o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 04:59:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237034AbhDEI7o (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 04:59:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E505860238;
        Mon,  5 Apr 2021 08:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613178;
        bh=F+tCI9jiNp1M/yvFYeNy9DRakJYCmpkSN3y1yNBWCGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MPaJFIwO2Iulu36qOguCcgucGYWAIOCRcva5jL8HN8otOGxRkWuco/UDpYcQB9GaF
         iU/+Q6URZFz1ec3pVAiS8fasycgWi2GqJUQEoV0FOcjMlCWFRDqUA9EP464EKCOdSl
         fj5Wylj/ufiFQ2Xr7HGeKa9cS93yJrg46dOixxKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Oliver Neukum <oneukum@suse.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 48/52] USB: cdc-acm: fix use-after-free after probe failure
Date:   Mon,  5 Apr 2021 10:54:14 +0200
Message-Id: <20210405085023.547130572@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085021.996963957@linuxfoundation.org>
References: <20210405085021.996963957@linuxfoundation.org>
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
@@ -1572,6 +1572,11 @@ skip_countries:
 
 	return 0;
 alloc_fail8:
+	if (!acm->combined_interfaces) {
+		/* Clear driver data so that disconnect() returns early. */
+		usb_set_intfdata(data_interface, NULL);
+		usb_driver_release_interface(&acm_driver, data_interface);
+	}
 	if (acm->country_codes) {
 		device_remove_file(&acm->control->dev,
 				&dev_attr_wCountryCodes);


