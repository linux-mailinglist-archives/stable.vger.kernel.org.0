Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 310C3171F13
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733139AbgB0OCc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:02:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:37228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733137AbgB0OCc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:02:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25C4F20578;
        Thu, 27 Feb 2020 14:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812151;
        bh=snVZpr8Tc1ya9pgap+qDI7pE4d1cCVzZv7mgLWud5jc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BhKy47Wphif89SbAPNxa3gMlpX4cH35siByvnJ6aFzb5mC3gc09eOeA3jgCb7WLpz
         Pzj9UPK+wSQPXab9efg1zaz1k1/mAC+AR5r9juTxu0JkLir22TZXeLH8fl/X+PEkcw
         noQapM5GkvvTDIRTnO7HkVCKv9g0sxoAXFFgRIYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [PATCH 4.14 193/237] tty/serial: atmel: manage shutdown in case of RS485 or ISO7816 mode
Date:   Thu, 27 Feb 2020 14:36:47 +0100
Message-Id: <20200227132310.526193773@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@microchip.com>

commit 04b5bfe3dc94e64d0590c54045815cb5183fb095 upstream.

In atmel_shutdown() we call atmel_stop_rx() and atmel_stop_tx() functions.
Prevent the rx restart that is implemented in RS485 or ISO7816 modes when
calling atmel_stop_tx() by using the atomic information tasklet_shutdown
that is already in place for this purpose.

Fixes: 98f2082c3ac4 ("tty/serial: atmel: enforce tasklet init and termination sequences")
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200210152053.8289-1-nicolas.ferre@microchip.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/atmel_serial.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -498,7 +498,8 @@ static void atmel_stop_tx(struct uart_po
 	atmel_uart_writel(port, ATMEL_US_IDR, atmel_port->tx_done_mask);
 
 	if (atmel_uart_is_half_duplex(port))
-		atmel_start_rx(port);
+		if (!atomic_read(&atmel_port->tasklet_shutdown))
+			atmel_start_rx(port);
 
 }
 


