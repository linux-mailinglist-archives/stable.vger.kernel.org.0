Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE7E141107
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 19:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbgAQSn6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 13:43:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:36118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726897AbgAQSn6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Jan 2020 13:43:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 479BF2082F;
        Fri, 17 Jan 2020 18:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579286637;
        bh=6HclHbOHFnk8gBe7FNxywZ5sg/sjquxxFsIESsKMHJ8=;
        h=Subject:To:From:Date:From;
        b=V21odZz9QPMphJYrdOw6eZSN8TRWpr9TYnfV2V0PetLTiQlX8lCM424AOl5NHBE75
         WSyB0ZLtHCq6kSHpf1dc7tudFnEOfa0IZk9zwRZhWY1e9mNKksfGhl24mjr3pKwQxS
         kRDccRo8Qh6BRVwUTTznHG9Lg38kz6VIlVoZlZdM=
Subject: patch "USB: serial: io_edgeport: handle unbound ports on URB completion" added to usb-linus
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 Jan 2020 19:43:40 +0100
Message-ID: <15792866208220@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: io_edgeport: handle unbound ports on URB completion

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From e37d1aeda737a20b1846a91a3da3f8b0f00cf690 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Fri, 17 Jan 2020 10:50:23 +0100
Subject: USB: serial: io_edgeport: handle unbound ports on URB completion

Check for NULL port data in the shared interrupt and bulk completion
callbacks to avoid dereferencing a NULL pointer in case a device sends
data for a port device which isn't bound to a driver (e.g. due to a
malicious device having unexpected endpoints or after an allocation
failure on port probe).

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/io_edgeport.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/io_edgeport.c b/drivers/usb/serial/io_edgeport.c
index 9690a5f4b9d6..0582d78bdb1d 100644
--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -716,7 +716,7 @@ static void edge_interrupt_callback(struct urb *urb)
 			if (txCredits) {
 				port = edge_serial->serial->port[portNumber];
 				edge_port = usb_get_serial_port_data(port);
-				if (edge_port->open) {
+				if (edge_port && edge_port->open) {
 					spin_lock_irqsave(&edge_port->ep_lock,
 							  flags);
 					edge_port->txCredits += txCredits;
@@ -1825,7 +1825,7 @@ static void process_rcvd_data(struct edgeport_serial *edge_serial,
 				port = edge_serial->serial->port[
 							edge_serial->rxPort];
 				edge_port = usb_get_serial_port_data(port);
-				if (edge_port->open) {
+				if (edge_port && edge_port->open) {
 					dev_dbg(dev, "%s - Sending %d bytes to TTY for port %d\n",
 						__func__, rxLen,
 						edge_serial->rxPort);
-- 
2.25.0


