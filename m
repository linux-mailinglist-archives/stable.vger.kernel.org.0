Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27AF724B74B
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731238AbgHTKuf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:50:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:34358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730744AbgHTKPN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:15:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E8A5206DA;
        Thu, 20 Aug 2020 10:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918512;
        bh=7FTVTN5umYaD610qgAVqutc9HXcdKmd8Wnr4zIcgjw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d1rh6wo7gJoFW0/BaqcdxPh2haWWBmkR7AsjhDghHTegyT8V1g58wtGPdImMcvRoj
         HZExM17DN7YCjKoQyvcDnof3NOjjKyV9WYy6Ik+fzFsDSdrOBtjaoRZclfpBM3iSSG
         Q6BYsrEfe/qwFanCA2lwpDCEztp2wSL+p4Jh8ypQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 198/228] USB: serial: ftdi_sio: clean up receive processing
Date:   Thu, 20 Aug 2020 11:22:53 +0200
Message-Id: <20200820091617.460355988@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

[ Upstream commit ce054039ba5e47b75a3be02a00274e52b06a6456 ]

Clean up receive processing by dropping the character pointer and
keeping the length argument unchanged throughout the function.

Also make it more apparent that sysrq processing can consume a
characters by adding an explicit continue.

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/serial/ftdi_sio.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 4959fcac5e030..8abb30c797d30 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -2045,7 +2045,6 @@ static int ftdi_process_packet(struct usb_serial_port *port,
 		struct ftdi_private *priv, unsigned char *buf, int len)
 {
 	unsigned char status;
-	unsigned char *ch;
 	int i;
 	char flag;
 
@@ -2088,8 +2087,7 @@ static int ftdi_process_packet(struct usb_serial_port *port,
 	else
 		priv->transmit_empty = 0;
 
-	len -= 2;
-	if (!len)
+	if (len == 2)
 		return 0;	/* status only */
 
 	/*
@@ -2118,19 +2116,20 @@ static int ftdi_process_packet(struct usb_serial_port *port,
 		}
 	}
 
-	port->icount.rx += len;
-	ch = buf + 2;
+	port->icount.rx += len - 2;
 
 	if (port->port.console && port->sysrq) {
-		for (i = 0; i < len; i++, ch++) {
-			if (!usb_serial_handle_sysrq_char(port, *ch))
-				tty_insert_flip_char(&port->port, *ch, flag);
+		for (i = 2; i < len; i++) {
+			if (usb_serial_handle_sysrq_char(port, buf[i]))
+				continue;
+			tty_insert_flip_char(&port->port, buf[i], flag);
 		}
 	} else {
-		tty_insert_flip_string_fixed_flag(&port->port, ch, flag, len);
+		tty_insert_flip_string_fixed_flag(&port->port, buf + 2, flag,
+				len - 2);
 	}
 
-	return len;
+	return len - 2;
 }
 
 static void ftdi_process_read_urb(struct urb *urb)
-- 
2.25.1



