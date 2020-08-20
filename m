Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0ED24B57F
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731748AbgHTKXb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:23:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:52948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731745AbgHTKX2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:23:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2652020658;
        Thu, 20 Aug 2020 10:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597919007;
        bh=1s9FwGZUK+qhmXdAyBcA6SiRJrNldkfYO8/z90el1XY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JVZo0HGDaZkGY09+Z4z8Sx+NsgSS1WIg3O5kE4Ded054pznEdPErx5OKr1GhGd9xx
         LXOwT7j61DZYabGjdvWutSBJqtCqytC99auUSqvTz+zzY0iKkdUXOAJuJxuf1qi/ST
         pqeY29Pxr3tDP0rlLQImIiCvTWafOXj8Z/tcBkqo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 136/149] USB: serial: ftdi_sio: fix break and sysrq handling
Date:   Thu, 20 Aug 2020 11:23:33 +0200
Message-Id: <20200820092132.283288416@linuxfoundation.org>
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

[ Upstream commit 733fff67941dad64b8a630450b8372b1873edc41 ]

Only the last NUL in a packet should be flagged as a break character,
for example, to avoid dropping unrelated characters when IGNBRK is set.

Also make sysrq work by consuming the break character instead of having
it immediately cancel the sysrq request, and by not processing it
prematurely to avoid triggering a sysrq based on an unrelated character
received in the same packet (which was received *before* the break).

Note that the break flag can be left set also for a packet received
immediately following a break and that and an ending NUL in such a
packet will continue to be reported as a break as there's no good way to
tell it apart from an actual break.

Tested on FT232R and FT232H.

Fixes: 72fda3ca6fc1 ("USB: serial: ftd_sio: implement sysrq handling on break")
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/serial/ftdi_sio.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 0afea511eb376..2dfec4c1ef4de 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -2054,6 +2054,7 @@ static int ftdi_process_packet(struct usb_serial_port *port,
 		struct ftdi_private *priv, unsigned char *buf, int len)
 {
 	unsigned char status;
+	bool brkint = false;
 	int i;
 	char flag;
 
@@ -2105,13 +2106,17 @@ static int ftdi_process_packet(struct usb_serial_port *port,
 	 */
 	flag = TTY_NORMAL;
 	if (buf[1] & FTDI_RS_ERR_MASK) {
-		/* Break takes precedence over parity, which takes precedence
-		 * over framing errors */
-		if (buf[1] & FTDI_RS_BI) {
-			flag = TTY_BREAK;
+		/*
+		 * Break takes precedence over parity, which takes precedence
+		 * over framing errors. Note that break is only associated
+		 * with the last character in the buffer and only when it's a
+		 * NUL.
+		 */
+		if (buf[1] & FTDI_RS_BI && buf[len - 1] == '\0') {
 			port->icount.brk++;
-			usb_serial_handle_break(port);
-		} else if (buf[1] & FTDI_RS_PE) {
+			brkint = true;
+		}
+		if (buf[1] & FTDI_RS_PE) {
 			flag = TTY_PARITY;
 			port->icount.parity++;
 		} else if (buf[1] & FTDI_RS_FE) {
@@ -2127,8 +2132,13 @@ static int ftdi_process_packet(struct usb_serial_port *port,
 
 	port->icount.rx += len - 2;
 
-	if (port->port.console && port->sysrq) {
+	if (brkint || (port->port.console && port->sysrq)) {
 		for (i = 2; i < len; i++) {
+			if (brkint && i == len - 1) {
+				if (usb_serial_handle_break(port))
+					return len - 3;
+				flag = TTY_BREAK;
+			}
 			if (usb_serial_handle_sysrq_char(port, buf[i]))
 				continue;
 			tty_insert_flip_char(&port->port, buf[i], flag);
-- 
2.25.1



