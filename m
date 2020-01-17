Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A85E141109
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 19:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729108AbgAQSoI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 13:44:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:36362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726935AbgAQSoH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Jan 2020 13:44:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5F312082F;
        Fri, 17 Jan 2020 18:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579286647;
        bh=LL9WEzg7Il2ZIUnHTMmkS74PN4SjADjw5eNZat5aKfY=;
        h=Subject:To:From:Date:From;
        b=aoh3+W/IuQCUx2r5uyJsaKP0jIfDraIW1joFdX2Lzyt7roPTC59C7BRjr6vrlKjYl
         Hw/IAVSrXDsT+aDcDM1AGNtWn9HEjnKtokrmGv4NfjPhFkVjQmR6xDDwqroYcLJu0a
         NWhVc6uD7NaOVhgbPX25shOn+FiJ4ys0+Rp+21rw=
Subject: patch "USB: serial: keyspan: handle unbound ports" added to usb-linus
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 Jan 2020 19:43:41 +0100
Message-ID: <1579286621207131@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: keyspan: handle unbound ports

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 3018dd3fa114b13261e9599ddb5656ef97a1fa17 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Fri, 17 Jan 2020 10:50:25 +0100
Subject: USB: serial: keyspan: handle unbound ports

Check for NULL port data in the control URB completion handlers to avoid
dereferencing a NULL pointer in the unlikely case where a port device
isn't bound to a driver (e.g. after an allocation failure on port
probe()).

Fixes: 0ca1268e109a ("USB Serial Keyspan: add support for USA-49WG & USA-28XG")
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/keyspan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index e66a59ef43a1..aa3dbce22cfb 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -1058,6 +1058,8 @@ static void	usa49_glocont_callback(struct urb *urb)
 	for (i = 0; i < serial->num_ports; ++i) {
 		port = serial->port[i];
 		p_priv = usb_get_serial_port_data(port);
+		if (!p_priv)
+			continue;
 
 		if (p_priv->resend_cont) {
 			dev_dbg(&port->dev, "%s - sending setup\n", __func__);
@@ -1459,6 +1461,8 @@ static void usa67_glocont_callback(struct urb *urb)
 	for (i = 0; i < serial->num_ports; ++i) {
 		port = serial->port[i];
 		p_priv = usb_get_serial_port_data(port);
+		if (!p_priv)
+			continue;
 
 		if (p_priv->resend_cont) {
 			dev_dbg(&port->dev, "%s - sending setup\n", __func__);
-- 
2.25.0


