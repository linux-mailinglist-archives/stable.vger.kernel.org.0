Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34BBC14A0A6
	for <lists+stable@lfdr.de>; Mon, 27 Jan 2020 10:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729442AbgA0JZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jan 2020 04:25:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:41338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729213AbgA0JZj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jan 2020 04:25:39 -0500
Received: from localhost (unknown [84.241.194.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C693A21569;
        Mon, 27 Jan 2020 09:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580117139;
        bh=1tmmX+Mq+upVJZaC+IcTmxMcQVlPMEQyLZaKBtDAvD4=;
        h=Subject:To:From:Date:From;
        b=AhIOYVpeqOrMSCb7XYClE3DOgX7Dc2HN6vexorID2lYVW+BYZb17tSjW0UsUOGfBW
         Nu7OOiEO5bclBEqvt3bXUaHnAmjY9GhQWoqKfYju5i/onug/NBgA5gh49sGGKiqxlL
         sTNvnLGQkgN3zwqsl0EK6XunaUDYIuW8ZDgqey4k=
Subject: patch "USB: serial: ir-usb: add missing endpoint sanity check" added to usb-next
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 Jan 2020 10:25:32 +0100
Message-ID: <158011713232104@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: ir-usb: add missing endpoint sanity check

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 2988a8ae7476fe9535ab620320790d1714bdad1d Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Wed, 22 Jan 2020 11:15:26 +0100
Subject: USB: serial: ir-usb: add missing endpoint sanity check

Add missing endpoint sanity check to avoid dereferencing a NULL-pointer
on open() in case a device lacks a bulk-out endpoint.

Note that prior to commit f4a4cbb2047e ("USB: ir-usb: reimplement using
generic framework") the oops would instead happen on open() if the
device lacked a bulk-in endpoint and on write() if it lacked a bulk-out
endpoint.

Fixes: f4a4cbb2047e ("USB: ir-usb: reimplement using generic framework")
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/ir-usb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/serial/ir-usb.c b/drivers/usb/serial/ir-usb.c
index 302eb9530859..c3b06fc5a7f0 100644
--- a/drivers/usb/serial/ir-usb.c
+++ b/drivers/usb/serial/ir-usb.c
@@ -195,6 +195,9 @@ static int ir_startup(struct usb_serial *serial)
 	struct usb_irda_cs_descriptor *irda_desc;
 	int rates;
 
+	if (serial->num_bulk_in < 1 || serial->num_bulk_out < 1)
+		return -ENODEV;
+
 	irda_desc = irda_usb_find_class_desc(serial, 0);
 	if (!irda_desc) {
 		dev_err(&serial->dev->dev,
-- 
2.25.0


