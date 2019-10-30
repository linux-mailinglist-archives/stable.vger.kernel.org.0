Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E686DE98D4
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 10:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbfJ3JHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 05:07:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:36528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbfJ3JHU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 05:07:20 -0400
Received: from localhost (unknown [91.217.168.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2AE62083E;
        Wed, 30 Oct 2019 09:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572426439;
        bh=DaU1b3cNFt2phZC2WKLxqXxzoRbF/g/8HhKlhvcyVOA=;
        h=Subject:To:From:Date:From;
        b=S5XU5NUbU73hTzaoWMuS8d/MM2SMd+6A07WNwAifOG3g9CdPM0ZMITkp4UXfcKnoo
         xkWQZODLxoeChpIhw6c7+C6iE2QY1m6iGna0p+iRHbBZMgqip1at+UxTlAGh64de+Z
         zohz/AfciWRuybfUqiQM49VYsIWRzNsTr7M00c9g=
Subject: patch "USB: serial: whiteheat: fix potential slab corruption" added to usb-linus
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 30 Oct 2019 10:07:16 +0100
Message-ID: <1572426436178243@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: whiteheat: fix potential slab corruption

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 1251dab9e0a2c4d0d2d48370ba5baa095a5e8774 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Tue, 29 Oct 2019 11:23:53 +0100
Subject: USB: serial: whiteheat: fix potential slab corruption

Fix a user-controlled slab buffer overflow due to a missing sanity check
on the bulk-out transfer buffer used for control requests.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191029102354.2733-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/whiteheat.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/serial/whiteheat.c b/drivers/usb/serial/whiteheat.c
index 79314d8c94a4..76cabcb30d21 100644
--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -559,6 +559,10 @@ static int firm_send_command(struct usb_serial_port *port, __u8 command,
 
 	command_port = port->serial->port[COMMAND_PORT];
 	command_info = usb_get_serial_port_data(command_port);
+
+	if (command_port->bulk_out_size < datasize + 1)
+		return -EIO;
+
 	mutex_lock(&command_info->mutex);
 	command_info->command_finished = false;
 
-- 
2.23.0


