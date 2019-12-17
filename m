Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15024122063
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727411AbfLQAyg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:54:36 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35350 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727066AbfLQAvo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:44 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15K-0003MA-KR; Tue, 17 Dec 2019 00:51:34 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15J-0005be-WB; Tue, 17 Dec 2019 00:51:34 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Johan Hovold" <johan@kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date:   Tue, 17 Dec 2019 00:47:19 +0000
Message-ID: <lsq.1576543535.605152971@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 105/136] USB: serial: whiteheat: fix potential slab
 corruption
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 1251dab9e0a2c4d0d2d48370ba5baa095a5e8774 upstream.

Fix a user-controlled slab buffer overflow due to a missing sanity check
on the bulk-out transfer buffer used for control requests.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191029102354.2733-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/whiteheat.c | 4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -604,6 +604,10 @@ static int firm_send_command(struct usb_
 
 	command_port = port->serial->port[COMMAND_PORT];
 	command_info = usb_get_serial_port_data(command_port);
+
+	if (command_port->bulk_out_size < datasize + 1)
+		return -EIO;
+
 	mutex_lock(&command_info->mutex);
 	command_info->command_finished = false;
 

