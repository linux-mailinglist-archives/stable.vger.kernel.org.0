Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E95781B6875
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728575AbgDWXPS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:15:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49750 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728427AbgDWXGs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:48 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvU-0004hn-8r; Fri, 24 Apr 2020 00:06:36 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvR-00E6pY-Ga; Fri, 24 Apr 2020 00:06:33 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Alan Stern" <stern@rowland.harvard.edu>,
        "Erkka Talvitie" <erkka.talvitie@vincit.fi>
Date:   Fri, 24 Apr 2020 00:05:58 +0100
Message-ID: <lsq.1587683028.208930441@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 131/245] USB: EHCI: Do not return -EPIPE when hub is
 disconnected
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Erkka Talvitie <erkka.talvitie@vincit.fi>

commit 64cc3f12d1c7dd054a215bc1ff9cc2abcfe35832 upstream.

When disconnecting a USB hub that has some child device(s) connected to it
(such as a USB mouse), then the stack tries to clear halt and
reset device(s) which are _already_ physically disconnected.

The issue has been reproduced with:

CPU: IMX6D5EYM10AD or MCIMX6D5EYM10AE.
SW: U-Boot 2019.07 and kernel 4.19.40.

CPU: HP Proliant Microserver Gen8.
SW: Linux version 4.2.3-300.fc23.x86_64

In this situation there will be error bit for MMF active yet the
CERR equals EHCI_TUNE_CERR + halt. Existing implementation
interprets this as a stall [1] (chapter 8.4.5).

The possible conditions when the MMF will be active + halt
can be found from [2] (Table 4-13).

Fix for the issue is to check whether MMF is active and PID Code is
IN before checking for the stall. If these conditions are true then
it is not a stall.

What happens after the fix is that when disconnecting a hub with
attached device(s) the situation is not interpret as a stall.

[1] [https://www.usb.org/document-library/usb-20-specification, usb_20.pdf]
[2] [https://www.intel.com/content/dam/www/public/us/en/documents/
     technical-specifications/ehci-specification-for-usb.pdf]

Signed-off-by: Erkka Talvitie <erkka.talvitie@vincit.fi>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/ef70941d5f349767f19c0ed26b0dd9eed8ad81bb.1576050523.git.erkka.talvitie@vincit.fi
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/ehci-q.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/ehci-q.c
+++ b/drivers/usb/host/ehci-q.c
@@ -40,6 +40,10 @@
 
 /*-------------------------------------------------------------------------*/
 
+/* PID Codes that are used here, from EHCI specification, Table 3-16. */
+#define PID_CODE_IN    1
+#define PID_CODE_SETUP 2
+
 /* fill a qtd, returning how much of the buffer we were able to queue up */
 
 static int
@@ -199,7 +203,7 @@ static int qtd_copy_status (
 	int	status = -EINPROGRESS;
 
 	/* count IN/OUT bytes, not SETUP (even short packets) */
-	if (likely (QTD_PID (token) != 2))
+	if (likely(QTD_PID(token) != PID_CODE_SETUP))
 		urb->actual_length += length - QTD_LENGTH (token);
 
 	/* don't modify error codes */
@@ -215,6 +219,13 @@ static int qtd_copy_status (
 		if (token & QTD_STS_BABBLE) {
 			/* FIXME "must" disable babbling device's port too */
 			status = -EOVERFLOW;
+		/*
+		 * When MMF is active and PID Code is IN, queue is halted.
+		 * EHCI Specification, Table 4-13.
+		 */
+		} else if ((token & QTD_STS_MMF) &&
+					(QTD_PID(token) == PID_CODE_IN)) {
+			status = -EPROTO;
 		/* CERR nonzero + halt --> stall */
 		} else if (QTD_CERR(token)) {
 			status = -EPIPE;

