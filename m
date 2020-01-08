Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8777134C21
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 20:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729837AbgAHTtz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 14:49:55 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43428 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730398AbgAHTqB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 14:46:01 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHC-0006oF-Fz; Wed, 08 Jan 2020 19:45:58 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHB-007dlz-Lg; Wed, 08 Jan 2020 19:45:57 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        "Baolin Wang" <baolin.wang@linaro.org>,
        "Felipe Balbi" <felipe.balbi@linux.intel.com>
Date:   Wed, 08 Jan 2020 19:43:17 +0000
Message-ID: <lsq.1578512578.11016460@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 19/63] usb: gadget: Add the gserial port checking in
 gs_start_tx()
In-Reply-To: <lsq.1578512578.117275639@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.81-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Baolin Wang <baolin.wang@linaro.org>

commit 511a36d2f357724312bb3776d2f6eed3890928b2 upstream.

When usb gadget is set gadget serial function, it will be crash in below
situation.

It will clean the 'port->port_usb' pointer in gserial_disconnect() function
when usb link is inactive, but it will release lock for disabling the endpoints
in this function. Druing the lock release period, it maybe complete one request
to issue gs_write_complete()--->gs_start_tx() function, but the 'port->port_usb'
pointer had been set NULL, thus it will be crash in gs_start_tx() function.

This patch adds the 'port->port_usb' pointer checking in gs_start_tx() function
to avoid this situation.

Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
[bwh: Backported to 3.16: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/gadget/u_serial.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/u_serial.c
+++ b/drivers/usb/gadget/u_serial.c
@@ -363,10 +363,15 @@ __acquires(&port->port_lock)
 */
 {
 	struct list_head	*pool = &port->write_pool;
-	struct usb_ep		*in = port->port_usb->in;
+	struct usb_ep		*in;
 	int			status = 0;
 	bool			do_tty_wake = false;
 
+	if (!port->port_usb)
+		return status;
+
+	in = port->port_usb->in;
+
 	while (!port->write_busy && !list_empty(pool)) {
 		struct usb_request	*req;
 		int			len;

