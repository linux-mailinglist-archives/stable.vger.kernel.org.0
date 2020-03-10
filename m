Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60CDE17FB2E
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731433AbgCJNLd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:11:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:33096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730887AbgCJNLc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:11:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98E9B208E4;
        Tue, 10 Mar 2020 13:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845892;
        bh=1Ab1FCoddUe1BX9XPSIJ0DoL+dXn+oXOQ+sECh6PTO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N/1KLIKNIaBHdNgx9wSw7+XBrgWB8NFamn2EMV2WH2Da3nJkiqJFo5F9Zb+WfG3DW
         f2TuM4pW/V9ch5SUg1lwx0koovXpljqB8arGr479/SAC6R0BTe88wi64PZ/vsSD7Dl
         yNIlgyisG0JHmKbsZqCbXupHZVLsGlRHNt+GBHNQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Organov <sorganov@gmail.com>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 12/86] usb: gadget: serial: fix Tx stall after buffer overflow
Date:   Tue, 10 Mar 2020 13:44:36 +0100
Message-Id: <20200310124531.459641903@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124530.808338541@linuxfoundation.org>
References: <20200310124530.808338541@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Organov <sorganov@gmail.com>

[ Upstream commit e4bfded56cf39b8d02733c1e6ef546b97961e18a ]

Symptom: application opens /dev/ttyGS0 and starts sending (writing) to
it while either USB cable is not connected, or nobody listens on the
other side of the cable. If driver circular buffer overflows before
connection is established, no data will be written to the USB layer
until/unless /dev/ttyGS0 is closed and re-opened again by the
application (the latter besides having no means of being notified about
the event of establishing of the connection.)

Fix: on open and/or connect, kick Tx to flush circular buffer data to
USB layer.

Signed-off-by: Sergey Organov <sorganov@gmail.com>
Reviewed-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/u_serial.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/u_serial.c b/drivers/usb/gadget/function/u_serial.c
index d4d317db89df5..38afe96c5cd26 100644
--- a/drivers/usb/gadget/function/u_serial.c
+++ b/drivers/usb/gadget/function/u_serial.c
@@ -567,8 +567,10 @@ static int gs_start_io(struct gs_port *port)
 	port->n_read = 0;
 	started = gs_start_rx(port);
 
-	/* unblock any pending writes into our circular buffer */
 	if (started) {
+		gs_start_tx(port);
+		/* Unblock any pending writes into our circular buffer, in case
+		 * we didn't in gs_start_tx() */
 		tty_wakeup(port->port.tty);
 	} else {
 		gs_free_requests(ep, head, &port->read_allocated);
-- 
2.20.1



