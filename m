Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB2EF2E6507
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389316AbgL1NfU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:35:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:35420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389320AbgL1NfT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:35:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6477207C9;
        Mon, 28 Dec 2020 13:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162503;
        bh=7cQDaEUqqy2Z+ZsG1YF2Up5+GInOJP/+GzQEoaKyGPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n+SQjiZhubjptwgoDxg/EqHl4TIIzSLcS8RSZiufpXfgsomRmhqrhOrUvxspAv0fL
         2uVbnWoNcb91uG4HNQxZ5wcDz5MJV6MekPy2I/DrqdavED2UQ9czOLis9Z9GJtHsPl
         IkJJUH5bgaFvghuXkV6CO2s8ys/VcJttpWCjj/eg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 291/346] USB: serial: keyspan_pda: fix dropped unthrottle interrupts
Date:   Mon, 28 Dec 2020 13:50:10 +0100
Message-Id: <20201228124933.844993053@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 696c541c8c6cfa05d65aa24ae2b9e720fc01766e upstream.

Commit c528fcb116e6 ("USB: serial: keyspan_pda: fix receive sanity
checks") broke write-unthrottle handling by dropping well-formed
unthrottle-interrupt packets which are precisely two bytes long. This
could lead to blocked writers not being woken up when buffer space again
becomes available.

Instead, stop unconditionally printing the third byte which is
(presumably) only valid on modem-line changes.

Fixes: c528fcb116e6 ("USB: serial: keyspan_pda: fix receive sanity checks")
Cc: stable <stable@vger.kernel.org>     # 4.11
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/keyspan_pda.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -172,11 +172,11 @@ static void keyspan_pda_rx_interrupt(str
 		break;
 	case 1:
 		/* status interrupt */
-		if (len < 3) {
+		if (len < 2) {
 			dev_warn(&port->dev, "short interrupt message received\n");
 			break;
 		}
-		dev_dbg(&port->dev, "rx int, d1=%d, d2=%d\n", data[1], data[2]);
+		dev_dbg(&port->dev, "rx int, d1=%d\n", data[1]);
 		switch (data[1]) {
 		case 1: /* modemline change */
 			break;


