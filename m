Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A16CF6226
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 03:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbfKJCkb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:40:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:33410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726900AbfKJCka (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:40:30 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B852321655;
        Sun, 10 Nov 2019 02:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353629;
        bh=4B1lfGVTlTuZKRFOEPEp1APClwPQiys1+IGzeX5ARuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IbDNbBIKHanH0ZI9rzPpCZ4D+Zg2sNyutnFqIwk7BlZEfiybYaTlykwZ5D8F00aOh
         uve0PmVhE5B25qJTfDY0Ytuxyf855NW0u7oCasp21gmJg2XZymsnBjqVrGKOiDnCv8
         qC1PuU1Mcru22XuV0U+w1cDPjarBEdwbMKh/apZw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Douglas Anderson <dianders@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 013/191] tty: serial: qcom_geni_serial: Fix serial when not used as console
Date:   Sat,  9 Nov 2019 21:37:15 -0500
Message-Id: <20191110024013.29782-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit c362272bdea32bf048d6916b0a2dc485eb9cf787 ]

If you've got the "console" serial port setup to use just as a UART
(AKA there is no "console=ttyMSMX" on the kernel command line) then
certain initialization is skipped.  When userspace later tries to do
something with the port then things go boom (specifically, on my
system, some sort of exception hit that caused the system to reboot
itself w/ no error messages).

Let's cleanup / refactor the init so that we always run the same init
code regardless of whether we're using the console.

To make this work, we make rely on qcom_geni_serial_pm doing its job
to turn resources on.

For the record, here is a trace of the order of things (after this
patch) when console= is specified on the command line and we have an
agetty on the port:
  qcom_geni_serial_pm: 4 (undefined) => 0 (on)
  qcom_geni_console_setup
  qcom_geni_serial_port_setup
  qcom_geni_serial_console_write
  qcom_geni_serial_startup
  qcom_geni_serial_start_tx

...and here is the order of things (after this patch) when console= is
_NOT_ specified on the command line and we have an agetty port:
  qcom_geni_serial_pm: 4 => 0
  qcom_geni_serial_pm: 0 => 3
  qcom_geni_serial_pm: 3 => 0
  qcom_geni_serial_startup
  qcom_geni_serial_port_setup
  qcom_geni_serial_pm: 0 => 3
  qcom_geni_serial_pm: 3 => 0
  qcom_geni_serial_startup
  qcom_geni_serial_start_tx

Fixes: c4f528795d1a ("tty: serial: msm_geni_serial: Add serial driver support for GENI based QUP")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/qcom_geni_serial.c | 55 +++++++++++++--------------
 1 file changed, 26 insertions(+), 29 deletions(-)

diff --git a/drivers/tty/serial/qcom_geni_serial.c b/drivers/tty/serial/qcom_geni_serial.c
index 5b96df4ad5b30..69b980bb8ac29 100644
--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -851,6 +851,23 @@ static int qcom_geni_serial_port_setup(struct uart_port *uport)
 {
 	struct qcom_geni_serial_port *port = to_dev_port(uport, uport);
 	unsigned int rxstale = DEFAULT_BITS_PER_CHAR * STALE_TIMEOUT;
+	u32 proto;
+
+	if (uart_console(uport))
+		port->tx_bytes_pw = 1;
+	else
+		port->tx_bytes_pw = 4;
+	port->rx_bytes_pw = RX_BYTES_PW;
+
+	proto = geni_se_read_proto(&port->se);
+	if (proto != GENI_SE_UART) {
+		dev_err(uport->dev, "Invalid FW loaded, proto: %d\n", proto);
+		return -ENXIO;
+	}
+
+	qcom_geni_serial_stop_rx(uport);
+
+	get_tx_fifo_size(port);
 
 	set_rfr_wm(port);
 	writel_relaxed(rxstale, uport->membase + SE_UART_RX_STALE_CNT);
@@ -874,30 +891,19 @@ static int qcom_geni_serial_port_setup(struct uart_port *uport)
 			return -ENOMEM;
 	}
 	port->setup = true;
+
 	return 0;
 }
 
 static int qcom_geni_serial_startup(struct uart_port *uport)
 {
 	int ret;
-	u32 proto;
 	struct qcom_geni_serial_port *port = to_dev_port(uport, uport);
 
 	scnprintf(port->name, sizeof(port->name),
 		  "qcom_serial_%s%d",
 		(uart_console(uport) ? "console" : "uart"), uport->line);
 
-	if (!uart_console(uport)) {
-		port->tx_bytes_pw = 4;
-		port->rx_bytes_pw = RX_BYTES_PW;
-	}
-	proto = geni_se_read_proto(&port->se);
-	if (proto != GENI_SE_UART) {
-		dev_err(uport->dev, "Invalid FW loaded, proto: %d\n", proto);
-		return -ENXIO;
-	}
-
-	get_tx_fifo_size(port);
 	if (!port->setup) {
 		ret = qcom_geni_serial_port_setup(uport);
 		if (ret)
@@ -1056,6 +1062,7 @@ static int __init qcom_geni_console_setup(struct console *co, char *options)
 	int bits = 8;
 	int parity = 'n';
 	int flow = 'n';
+	int ret;
 
 	if (co->index >= GENI_UART_CONS_PORTS  || co->index < 0)
 		return -ENXIO;
@@ -1071,21 +1078,10 @@ static int __init qcom_geni_console_setup(struct console *co, char *options)
 	if (unlikely(!uport->membase))
 		return -ENXIO;
 
-	if (geni_se_resources_on(&port->se)) {
-		dev_err(port->se.dev, "Error turning on resources\n");
-		return -ENXIO;
-	}
-
-	if (unlikely(geni_se_read_proto(&port->se) != GENI_SE_UART)) {
-		geni_se_resources_off(&port->se);
-		return -ENXIO;
-	}
-
 	if (!port->setup) {
-		port->tx_bytes_pw = 1;
-		port->rx_bytes_pw = RX_BYTES_PW;
-		qcom_geni_serial_stop_rx(uport);
-		qcom_geni_serial_port_setup(uport);
+		ret = qcom_geni_serial_port_setup(uport);
+		if (ret)
+			return ret;
 	}
 
 	if (options)
@@ -1203,11 +1199,12 @@ static void qcom_geni_serial_pm(struct uart_port *uport,
 {
 	struct qcom_geni_serial_port *port = to_dev_port(uport, uport);
 
+	/* If we've never been called, treat it as off */
+	if (old_state == UART_PM_STATE_UNDEFINED)
+		old_state = UART_PM_STATE_OFF;
+
 	if (new_state == UART_PM_STATE_ON && old_state == UART_PM_STATE_OFF)
 		geni_se_resources_on(&port->se);
-	else if (!uart_console(uport) && (new_state == UART_PM_STATE_ON &&
-				old_state == UART_PM_STATE_UNDEFINED))
-		geni_se_resources_on(&port->se);
 	else if (new_state == UART_PM_STATE_OFF &&
 			old_state == UART_PM_STATE_ON)
 		geni_se_resources_off(&port->se);
-- 
2.20.1

