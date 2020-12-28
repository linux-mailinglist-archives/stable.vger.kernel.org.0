Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B691A2E3A3F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387636AbgL1NeI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:34:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:34650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731558AbgL1NeH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:34:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE3E3207C9;
        Mon, 28 Dec 2020 13:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162406;
        bh=ZVH6mPmmfFa3nYou8QGvUJ84cqwMDtba7EMR8XuKack=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bBtieJpWMrd3rRaWH8eUWxRHea7cTOU0F1xU+MLL2vg6VGOi+1qz6xzuMEdnHDvr2
         ozce/nrS8smiKcpXHkUM4l0a3gsX2ZZPedxYAXanwfiEsmCzMjk6pYQKvNUDnzh+lX
         vi99/SBO+8yKgJEn9fGWBi03d2H56iZU4YAUE3Qw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 295/346] USB: serial: keyspan_pda: fix tx-unthrottle use-after-free
Date:   Mon, 28 Dec 2020 13:50:14 +0100
Message-Id: <20201228124934.042282957@linuxfoundation.org>
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

commit 49fbb8e37a961396a5b6c82937c70df91de45e9d upstream.

The driver's transmit-unthrottle work was never flushed on disconnect,
something which could lead to the driver port data being freed while the
unthrottle work is still scheduled.

Fix this by cancelling the unthrottle work when shutting down the port.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/keyspan_pda.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -647,8 +647,12 @@ error:
 }
 static void keyspan_pda_close(struct usb_serial_port *port)
 {
+	struct keyspan_pda_private *priv = usb_get_serial_port_data(port);
+
 	usb_kill_urb(port->write_urb);
 	usb_kill_urb(port->interrupt_in_urb);
+
+	cancel_work_sync(&priv->unthrottle_work);
 }
 
 


