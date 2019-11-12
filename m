Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4DD4F9E6F
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 00:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbfKLXvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 18:51:06 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57352 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727015AbfKLXug (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 18:50:36 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iUfvd-0008IN-WE; Tue, 12 Nov 2019 23:50:34 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iUfvc-00057c-SZ; Tue, 12 Nov 2019 23:50:32 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Mathias Payer" <mathias.payer@nebelwelt.net>,
        "Hui Peng" <benquike@gmail.com>,
        "Kalle Valo" <kvalo@codeaurora.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date:   Tue, 12 Nov 2019 23:48:13 +0000
Message-ID: <lsq.1573602477.324913677@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 16/25] ath6kl: fix a NULL-ptr-deref bug in
 ath6kl_usb_alloc_urb_from_pipe()
In-Reply-To: <lsq.1573602477.548403712@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.77-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Peng <benquike@gmail.com>

commit 39d170b3cb62ba98567f5c4f40c27b5864b304e5 upstream.

The `ar_usb` field of `ath6kl_usb_pipe_usb_pipe` objects
are initialized to point to the containing `ath6kl_usb` object
according to endpoint descriptors read from the device side, as shown
below in `ath6kl_usb_setup_pipe_resources`:

for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
	endpoint = &iface_desc->endpoint[i].desc;

	// get the address from endpoint descriptor
	pipe_num = ath6kl_usb_get_logical_pipe_num(ar_usb,
						endpoint->bEndpointAddress,
						&urbcount);
	......
	// select the pipe object
	pipe = &ar_usb->pipes[pipe_num];

	// initialize the ar_usb field
	pipe->ar_usb = ar_usb;
}

The driver assumes that the addresses reported in endpoint
descriptors from device side  to be complete. If a device is
malicious and does not report complete addresses, it may trigger
NULL-ptr-deref `ath6kl_usb_alloc_urb_from_pipe` and
`ath6kl_usb_free_urb_to_pipe`.

This patch fixes the bug by preventing potential NULL-ptr-deref
(CVE-2019-15098).

Signed-off-by: Hui Peng <benquike@gmail.com>
Reported-by: Hui Peng <benquike@gmail.com>
Reported-by: Mathias Payer <mathias.payer@nebelwelt.net>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/ath/ath6kl/usb.c | 8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/net/wireless/ath/ath6kl/usb.c
+++ b/drivers/net/wireless/ath/ath6kl/usb.c
@@ -132,6 +132,10 @@ ath6kl_usb_alloc_urb_from_pipe(struct at
 	struct ath6kl_urb_context *urb_context = NULL;
 	unsigned long flags;
 
+	/* bail if this pipe is not initialized */
+	if (!pipe->ar_usb)
+		return NULL;
+
 	spin_lock_irqsave(&pipe->ar_usb->cs_lock, flags);
 	if (!list_empty(&pipe->urb_list_head)) {
 		urb_context =
@@ -150,6 +154,10 @@ static void ath6kl_usb_free_urb_to_pipe(
 {
 	unsigned long flags;
 
+	/* bail if this pipe is not initialized */
+	if (!pipe->ar_usb)
+		return;
+
 	spin_lock_irqsave(&pipe->ar_usb->cs_lock, flags);
 	pipe->urb_cnt++;
 

