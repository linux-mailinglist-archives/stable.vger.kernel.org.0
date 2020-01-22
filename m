Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0AC144FB7
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387450AbgAVJk2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:40:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:59326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387445AbgAVJk1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:40:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20CC624680;
        Wed, 22 Jan 2020 09:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579686026;
        bh=QbzSPHtU9cuKycGZVfisOWsZw2epy5XxYwUadro/hAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XM2aF05Ip8gUBVkxWE/NtKZHZDH0Ixl2Z8GeoILsaObaI1Zf7dJVYvPjl30OhZttd
         eIZDgWGcG4n70Uu5fFC1NWZ4HPfuiYzlFftZUbYpBps55qjNKyu4LpsyXWL4NibeYR
         lwoZihF4oJJxtEYa28VkEac8vZAphR+ToL78LioY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 014/103] USB: serial: io_edgeport: handle unbound ports on URB completion
Date:   Wed, 22 Jan 2020 10:28:30 +0100
Message-Id: <20200122092805.814202345@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092803.587683021@linuxfoundation.org>
References: <20200122092803.587683021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit e37d1aeda737a20b1846a91a3da3f8b0f00cf690 upstream.

Check for NULL port data in the shared interrupt and bulk completion
callbacks to avoid dereferencing a NULL pointer in case a device sends
data for a port device which isn't bound to a driver (e.g. due to a
malicious device having unexpected endpoints or after an allocation
failure on port probe).

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/io_edgeport.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -716,7 +716,7 @@ static void edge_interrupt_callback(stru
 			if (txCredits) {
 				port = edge_serial->serial->port[portNumber];
 				edge_port = usb_get_serial_port_data(port);
-				if (edge_port->open) {
+				if (edge_port && edge_port->open) {
 					spin_lock_irqsave(&edge_port->ep_lock,
 							  flags);
 					edge_port->txCredits += txCredits;
@@ -1843,7 +1843,7 @@ static void process_rcvd_data(struct edg
 				port = edge_serial->serial->port[
 							edge_serial->rxPort];
 				edge_port = usb_get_serial_port_data(port);
-				if (edge_port->open) {
+				if (edge_port && edge_port->open) {
 					dev_dbg(dev, "%s - Sending %d bytes to TTY for port %d\n",
 						__func__, rxLen,
 						edge_serial->rxPort);


