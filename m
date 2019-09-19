Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E46DEB86F3
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405957AbfISWMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:12:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:51092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405944AbfISWMP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:12:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0C1D21920;
        Thu, 19 Sep 2019 22:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931135;
        bh=wyklw6h7uu0PQ35u5IY/6t8dIFe54hrKDbD3NZ7d8xk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ulEqGzQsdQXzrGPBOL/dCzxRcRy4DYJrQs7LptGSJtyiwKowabn/9xUMq3ZgB176J
         420JznClrJaLeyJF0ftQijjRDTkzawGFWhl5JLnv6Vin5KLDWlemqEGs2fRQAuTrZ3
         Z5+q3htdFDC2n+tMU8X4jJMZspp2q01vcU6MHXB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Razvan Stefanescu <razvan.stefanescu@microchip.com>
Subject: [PATCH 4.19 16/79] tty/serial: atmel: reschedule TX after RX was started
Date:   Fri, 20 Sep 2019 00:03:01 +0200
Message-Id: <20190919214809.242105899@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214807.612593061@linuxfoundation.org>
References: <20190919214807.612593061@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Razvan Stefanescu <razvan.stefanescu@microchip.com>

commit d2ace81bf902a9f11d52e59e5d232d2255a0e353 upstream.

When half-duplex RS485 communication is used, after RX is started, TX
tasklet still needs to be  scheduled tasklet. This avoids console freezing
when more data is to be transmitted, if the serial communication is not
closed.

Fixes: 69646d7a3689 ("tty/serial: atmel: RS485 HD w/DMA: enable RX after TX is stopped")
Signed-off-by: Razvan Stefanescu <razvan.stefanescu@microchip.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190813074025.16218-1-razvan.stefanescu@microchip.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/atmel_serial.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -1270,7 +1270,6 @@ atmel_handle_transmit(struct uart_port *
 
 			atmel_port->hd_start_rx = false;
 			atmel_start_rx(port);
-			return;
 		}
 
 		atmel_tasklet_schedule(atmel_port, &atmel_port->tasklet_tx);


