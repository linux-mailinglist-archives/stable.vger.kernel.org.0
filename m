Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 441DB134BAC
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 20:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730451AbgAHTqD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 14:46:03 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43476 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730422AbgAHTqC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 14:46:02 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHC-0006o9-96; Wed, 08 Jan 2020 19:45:58 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHB-007dls-IY; Wed, 08 Jan 2020 19:45:57 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Philip Oberstaller" <Philip.Oberstaller@septentrio.com>,
        "Felipe Balbi" <balbi@ti.com>,
        "Arnout Vandecappelle (Essensium/Mind)" <arnout@mind.be>
Date:   Wed, 08 Jan 2020 19:43:16 +0000
Message-ID: <lsq.1578512578.745891120@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 18/63] usb: gadget: serial: fix re-ordering of tx data
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

From: Philip Oberstaller <Philip.Oberstaller@septentrio.com>

commit 3e9d3d2efc677b501b12512cab5adb4f32a0673a upstream.

When a single thread is sending out data over the gadget serial port,
gs_start_tx() will be called both from the sender context and from the
write completion. Since the port lock is released before the packet is
queued, the order in which the URBs are submitted is not guaranteed.
E.g.

  sending thread                      completion (interrupt)

  gs_write()
    LOCK
                                      gs_write_complete()
                                        LOCK (wait)
    gs_start_tx()
      req1 = list_entry(pool->next)
      UNLOCK
                                        LOCK (acquired)
                                        gs_start_tx()
                                          req2 = list_entry(pool->next)
                                          UNLOCK
                                          usb_ep_queue(req2)
      usb_ep_queue(req1)

I.e., req2 is submitted before req1 but it contains the data that
comes after req1.

To reproduce, use SMP with sending thread and completion pinned to
different CPUs, or use PREEMPT_RT, and add the following delay just
before the call to usb_ep_queue():

		if (port->write_started > 0 && !list_empty(pool))
			udelay(1000);

To work around this problem, make sure that only one thread is running
through the gs_start_tx() loop with an extra flag write_busy. Since
gs_start_tx() is always called with the port lock held, no further
synchronisation is needed. The original caller will continue through
the loop when the request was successfully submitted.

Signed-off-by: Philip Oberstaller <Philip.Oberstaller@septentrio.com>
Signed-off-by: Arnout Vandecappelle (Essensium/Mind) <arnout@mind.be>
Signed-off-by: Felipe Balbi <balbi@ti.com>
[bwh: Backported to 3.16: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/gadget/u_serial.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/u_serial.c
+++ b/drivers/usb/gadget/u_serial.c
@@ -116,6 +116,7 @@ struct gs_port {
 	int write_allocated;
 	struct gs_buf		port_write_buf;
 	wait_queue_head_t	drain_wait;	/* wait while writes drain */
+	bool                    write_busy;
 
 	/* REVISIT this state ... */
 	struct usb_cdc_line_coding port_line_coding;	/* 8-N-1 etc */
@@ -366,7 +367,7 @@ __acquires(&port->port_lock)
 	int			status = 0;
 	bool			do_tty_wake = false;
 
-	while (!list_empty(pool)) {
+	while (!port->write_busy && !list_empty(pool)) {
 		struct usb_request	*req;
 		int			len;
 
@@ -396,9 +397,11 @@ __acquires(&port->port_lock)
 		 * NOTE that we may keep sending data for a while after
 		 * the TTY closed (dev->ioport->port_tty is NULL).
 		 */
+		port->write_busy = true;
 		spin_unlock(&port->port_lock);
 		status = usb_ep_queue(in, req, GFP_ATOMIC);
 		spin_lock(&port->port_lock);
+		port->write_busy = false;
 
 		if (status) {
 			pr_debug("%s: %s %s err %d\n",

