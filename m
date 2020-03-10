Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1291A17FAD4
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730204AbgCJNIh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:08:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:55154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727876AbgCJNIh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:08:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB0252468C;
        Tue, 10 Mar 2020 13:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845716;
        bh=t562I3QUMTAhEUUq5KX4N5DKIqd6jTbpEv4WFsO02Dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oqd1uGaaveiAOWbX5v3UQcXjSgErBLy3Xh7Kmf5y1J3kU2hM7Otg0XPkSxthPFhwd
         WlgPDpOMxBYLoWagOwhnqRfweJdKX9aXJUMAkitu20PHa6JLw2YgSc5p1LjAPzXX4b
         UGmQzhZVuUh4CJxAFEvywEYJh6KWFogSzbqH0p38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuanhong Guo <gch981213@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 074/126] serial: ar933x_uart: set UART_CS_{RX,TX}_READY_ORIDE
Date:   Tue, 10 Mar 2020 13:41:35 +0100
Message-Id: <20200310124208.710962051@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124203.704193207@linuxfoundation.org>
References: <20200310124203.704193207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit 87c5cbf71ecbb9e289d60a2df22eb686c70bf196 ]

On AR934x this UART is usually not initialized by the bootloader
as it is only used as a secondary serial port while the primary
UART is a newly introduced NS16550-compatible.
In order to make use of the ar933x-uart on AR934x without RTS/CTS
hardware flow control, one needs to set the
UART_CS_{RX,TX}_READY_ORIDE bits as other than on AR933x where this
UART is used as primary/console, the bootloader on AR934x typically
doesn't set those bits.
Setting them explicitely on AR933x should not do any harm, so just
set them unconditionally.

Tested-by: Chuanhong Guo <gch981213@gmail.com>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Link: https://lore.kernel.org/r/20200207095335.GA179836@makrotopia.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/ar933x_uart.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/tty/serial/ar933x_uart.c b/drivers/tty/serial/ar933x_uart.c
index ed545a61413c0..ac56a5131a9cc 100644
--- a/drivers/tty/serial/ar933x_uart.c
+++ b/drivers/tty/serial/ar933x_uart.c
@@ -289,6 +289,10 @@ static void ar933x_uart_set_termios(struct uart_port *port,
 	ar933x_uart_rmw_set(up, AR933X_UART_CS_REG,
 			    AR933X_UART_CS_HOST_INT_EN);
 
+	/* enable RX and TX ready overide */
+	ar933x_uart_rmw_set(up, AR933X_UART_CS_REG,
+		AR933X_UART_CS_TX_READY_ORIDE | AR933X_UART_CS_RX_READY_ORIDE);
+
 	/* reenable the UART */
 	ar933x_uart_rmw(up, AR933X_UART_CS_REG,
 			AR933X_UART_CS_IF_MODE_M << AR933X_UART_CS_IF_MODE_S,
@@ -421,6 +425,10 @@ static int ar933x_uart_startup(struct uart_port *port)
 	ar933x_uart_rmw_set(up, AR933X_UART_CS_REG,
 			    AR933X_UART_CS_HOST_INT_EN);
 
+	/* enable RX and TX ready overide */
+	ar933x_uart_rmw_set(up, AR933X_UART_CS_REG,
+		AR933X_UART_CS_TX_READY_ORIDE | AR933X_UART_CS_RX_READY_ORIDE);
+
 	/* Enable RX interrupts */
 	up->ier = AR933X_UART_INT_RX_VALID;
 	ar933x_uart_write(up, AR933X_UART_INT_EN_REG, up->ier);
-- 
2.20.1



