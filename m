Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2AEB9248
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388402AbfITObP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:31:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36908 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388396AbfITOZQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:16 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqT-000512-DD; Fri, 20 Sep 2019 15:25:13 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqE-0007ts-RA; Fri, 20 Sep 2019 15:24:58 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Oliver Neukum" <oneukum@suse.de>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.70460827@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 066/132] cdc-acm: fix race between callback and
 unthrottle
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.de>

commit 36e59e0d70d6150e7a2155c54612ea875e88ce8d upstream.

Abn URB may be may marked free only after the buffer has been
processed or there is a small window during which it could
be submitted on another CPU and overwrite an unprocessed buffer

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/class/cdc-acm.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -419,19 +419,21 @@ static void acm_read_bulk_callback(struc
 	struct acm_rb *rb = urb->context;
 	struct acm *acm = rb->instance;
 	unsigned long flags;
+	int status = urb->status;
 
 	dev_vdbg(&acm->data->dev, "%s - urb %d, len %d\n", __func__,
 					rb->index, urb->actual_length);
-	set_bit(rb->index, &acm->read_urbs_free);
 
 	if (!acm->dev) {
+		set_bit(rb->index, &acm->read_urbs_free);
 		dev_dbg(&acm->data->dev, "%s - disconnected\n", __func__);
 		return;
 	}
 
 	if (urb->status) {
+		set_bit(rb->index, &acm->read_urbs_free);
 		dev_dbg(&acm->data->dev, "%s - non-zero urb status: %d\n",
-							__func__, urb->status);
+							__func__, status);
 		if ((urb->status != -ENOENT) || (urb->actual_length == 0))
 			return;
 	}
@@ -439,6 +441,12 @@ static void acm_read_bulk_callback(struc
 	usb_mark_last_busy(acm->dev);
 
 	acm_process_read_urb(acm, urb);
+	/*
+	 * Unthrottle may run on another CPU which needs to see events
+	 * in the same order. Submission has an implict barrier
+	 */
+	smp_mb__before_atomic();
+	set_bit(rb->index, &acm->read_urbs_free);
 
 	/* throttle device if requested by tty */
 	spin_lock_irqsave(&acm->read_lock, flags);

