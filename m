Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7642E6911
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728938AbgL1M5Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 07:57:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:53436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728936AbgL1M5Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:57:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FE93229C6;
        Mon, 28 Dec 2020 12:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160220;
        bh=WxAUeKSKOvzBCHMhXnRw11xywl3lvvwy8E/MCivO0EQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yKrzjQN0Avva92je7x4bca0vjANqgaGDboHz1Ki+rhgTArIdf7/cknJdbrBWn6gtH
         SPS1cVYXwFSMLTyeTzz04IuyOqMVZ1kUymXH9zGXLhu5i8HTcDsvAIMr1zbWOTPzj+
         hgjaFSt5KZFEdXNwAc40EypC5ZVeQZWNTxJdNdBI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.4 109/132] USB: serial: keyspan_pda: fix dropped unthrottle interrupts
Date:   Mon, 28 Dec 2020 13:49:53 +0100
Message-Id: <20201228124851.682215879@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124846.409999325@linuxfoundation.org>
References: <20201228124846.409999325@linuxfoundation.org>
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
@@ -176,11 +176,11 @@ static void keyspan_pda_rx_interrupt(str
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


