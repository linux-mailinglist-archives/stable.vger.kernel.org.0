Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D37302E3F7A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502441AbgL1O2a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:28:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:36314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502423AbgL1O22 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:28:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F256207B2;
        Mon, 28 Dec 2020 14:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165668;
        bh=7cQDaEUqqy2Z+ZsG1YF2Up5+GInOJP/+GzQEoaKyGPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h1qU8KnzE4syDojaDtwplzBwdwjwICoumcDu/AAedXq/G6ouM7XY4xpY3hVzywiyq
         KFHXEvzNZ8p4kMCWwgPqcK0oF1Gy17hOS/WubzmPC/ZMrEUdotODB755p0dMn5b7EP
         05sej9S0NChSBtb1k7FKWZBi36bwuyCny+153tcg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 581/717] USB: serial: keyspan_pda: fix dropped unthrottle interrupts
Date:   Mon, 28 Dec 2020 13:49:39 +0100
Message-Id: <20201228125048.753578764@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
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


