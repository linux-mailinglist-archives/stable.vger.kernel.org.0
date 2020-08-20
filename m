Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE60B24B5A1
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729928AbgHTK0S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:26:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:51842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731686AbgHTKXI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:23:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01CA220738;
        Thu, 20 Aug 2020 10:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918986;
        bh=hixA20xvTdZKt1cgfekH/mKHjoOFti/JKv/G0nEaHcE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hed65pBbiLOhdN7eT86y5ymYsTURnyM34EL7vpKJIoum58WU45/h/3IAfMCUaa04p
         0hhyFajHPSuPkiQ/mrN/tK7TfHslW8n+xi+yats6TfJ59j/xqwWKySVdaMZV2pvEGz
         COZD47L50CqziALtjIJmHMxM72Gvip3QsjC5gtSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 134/149] USB: serial: ftdi_sio: make process-packet buffer unsigned
Date:   Thu, 20 Aug 2020 11:23:31 +0200
Message-Id: <20200820092132.186524629@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820092125.688850368@linuxfoundation.org>
References: <20200820092125.688850368@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

[ Upstream commit ab4cc4ef6724ea588e835fc1e764c4b4407a70b7 ]

Use an unsigned type for the process-packet buffer argument and give it
a more apt name.

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/serial/ftdi_sio.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 8388f88ce6356..4b9404f99c010 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -2051,12 +2051,12 @@ static int ftdi_prepare_write_buffer(struct usb_serial_port *port,
 #define FTDI_RS_ERR_MASK (FTDI_RS_BI | FTDI_RS_PE | FTDI_RS_FE | FTDI_RS_OE)
 
 static int ftdi_process_packet(struct usb_serial_port *port,
-		struct ftdi_private *priv, char *packet, int len)
+		struct ftdi_private *priv, unsigned char *buf, int len)
 {
+	unsigned char status;
+	unsigned char *ch;
 	int i;
-	char status;
 	char flag;
-	char *ch;
 
 	if (len < 2) {
 		dev_dbg(&port->dev, "malformed packet\n");
@@ -2066,7 +2066,7 @@ static int ftdi_process_packet(struct usb_serial_port *port,
 	/* Compare new line status to the old one, signal if different/
 	   N.B. packet may be processed more than once, but differences
 	   are only processed once.  */
-	status = packet[0] & FTDI_STATUS_B0_MASK;
+	status = buf[0] & FTDI_STATUS_B0_MASK;
 	if (status != priv->prev_status) {
 		char diff_status = status ^ priv->prev_status;
 
@@ -2092,7 +2092,7 @@ static int ftdi_process_packet(struct usb_serial_port *port,
 	}
 
 	/* save if the transmitter is empty or not */
-	if (packet[1] & FTDI_RS_TEMT)
+	if (buf[1] & FTDI_RS_TEMT)
 		priv->transmit_empty = 1;
 	else
 		priv->transmit_empty = 0;
@@ -2106,29 +2106,29 @@ static int ftdi_process_packet(struct usb_serial_port *port,
 	 * data payload to avoid over-reporting.
 	 */
 	flag = TTY_NORMAL;
-	if (packet[1] & FTDI_RS_ERR_MASK) {
+	if (buf[1] & FTDI_RS_ERR_MASK) {
 		/* Break takes precedence over parity, which takes precedence
 		 * over framing errors */
-		if (packet[1] & FTDI_RS_BI) {
+		if (buf[1] & FTDI_RS_BI) {
 			flag = TTY_BREAK;
 			port->icount.brk++;
 			usb_serial_handle_break(port);
-		} else if (packet[1] & FTDI_RS_PE) {
+		} else if (buf[1] & FTDI_RS_PE) {
 			flag = TTY_PARITY;
 			port->icount.parity++;
-		} else if (packet[1] & FTDI_RS_FE) {
+		} else if (buf[1] & FTDI_RS_FE) {
 			flag = TTY_FRAME;
 			port->icount.frame++;
 		}
 		/* Overrun is special, not associated with a char */
-		if (packet[1] & FTDI_RS_OE) {
+		if (buf[1] & FTDI_RS_OE) {
 			port->icount.overrun++;
 			tty_insert_flip_char(&port->port, 0, TTY_OVERRUN);
 		}
 	}
 
 	port->icount.rx += len;
-	ch = packet + 2;
+	ch = buf + 2;
 
 	if (port->port.console && port->sysrq) {
 		for (i = 0; i < len; i++, ch++) {
-- 
2.25.1



