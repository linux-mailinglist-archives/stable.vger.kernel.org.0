Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18CF526F448
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgIRCCH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:02:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:46776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726603AbgIRCCA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:02:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA713235F8;
        Fri, 18 Sep 2020 02:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394519;
        bh=9l4bQHr3v9jw7DguljB18wyJKpla5CiZi5MZ1PMF1iM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rFJFsggl74dQRtFLcQX2Eg30un2pDIhWZq5mH2rCw9S0Sa2w/OKJFg/mM5XNaMgwY
         8Ihicps10P8gLPDrHDIXqgGvnVh51NGlNuzSUuT0H5kIBT8hWL5psc1ZomvCW9Li2f
         1ku/thHRI9zCZvq+hGSIEtEjCOgtTjEHs29bolQY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 041/330] USB: serial: mos7840: fix probe error handling
Date:   Thu, 17 Sep 2020 21:56:21 -0400
Message-Id: <20200918020110.2063155-41-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 960fbd1ca584a5b4cd818255769769d42bfc6dbe ]

The driver would return success and leave the port structures
half-initialised if any of the register accesses during probe fails.

This would specifically leave the port control urb unallocated,
something which could trigger a NULL pointer dereference on interrupt
events.

Fortunately the interrupt implementation is completely broken and has
never even been enabled...

Note that the zero-length-enable register write used to set the zle-flag
for all ports is moved to attach.

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/serial/mos7840.c | 48 +++++++++++++++++++++---------------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index ab4bf8d6d7df0..e105ff0eb92e5 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -2090,6 +2090,23 @@ static int mos7840_calc_num_ports(struct usb_serial *serial,
 	return num_ports;
 }
 
+static int mos7840_attach(struct usb_serial *serial)
+{
+	struct device *dev = &serial->interface->dev;
+	int status;
+	u16 val;
+
+	/* Zero Length flag enable */
+	val = 0x0f;
+	status = mos7840_set_reg_sync(serial->port[0], ZLP_REG5, val);
+	if (status < 0)
+		dev_dbg(dev, "Writing ZLP_REG5 failed status-0x%x\n", status);
+	else
+		dev_dbg(dev, "ZLP_REG5 Writing success status%d\n", status);
+
+	return status;
+}
+
 static int mos7840_port_probe(struct usb_serial_port *port)
 {
 	struct usb_serial *serial = port->serial;
@@ -2147,7 +2164,7 @@ static int mos7840_port_probe(struct usb_serial_port *port)
 			mos7840_port->ControlRegOffset, &Data);
 	if (status < 0) {
 		dev_dbg(&port->dev, "Reading ControlReg failed status-0x%x\n", status);
-		goto out;
+		goto error;
 	} else
 		dev_dbg(&port->dev, "ControlReg Reading success val is %x, status%d\n", Data, status);
 	Data |= 0x08;	/* setting driver done bit */
@@ -2159,7 +2176,7 @@ static int mos7840_port_probe(struct usb_serial_port *port)
 			mos7840_port->ControlRegOffset, Data);
 	if (status < 0) {
 		dev_dbg(&port->dev, "Writing ControlReg failed(rx_disable) status-0x%x\n", status);
-		goto out;
+		goto error;
 	} else
 		dev_dbg(&port->dev, "ControlReg Writing success(rx_disable) status%d\n", status);
 
@@ -2170,7 +2187,7 @@ static int mos7840_port_probe(struct usb_serial_port *port)
 			(__u16) (mos7840_port->DcrRegOffset + 0), Data);
 	if (status < 0) {
 		dev_dbg(&port->dev, "Writing DCR0 failed status-0x%x\n", status);
-		goto out;
+		goto error;
 	} else
 		dev_dbg(&port->dev, "DCR0 Writing success status%d\n", status);
 
@@ -2179,7 +2196,7 @@ static int mos7840_port_probe(struct usb_serial_port *port)
 			(__u16) (mos7840_port->DcrRegOffset + 1), Data);
 	if (status < 0) {
 		dev_dbg(&port->dev, "Writing DCR1 failed status-0x%x\n", status);
-		goto out;
+		goto error;
 	} else
 		dev_dbg(&port->dev, "DCR1 Writing success status%d\n", status);
 
@@ -2188,7 +2205,7 @@ static int mos7840_port_probe(struct usb_serial_port *port)
 			(__u16) (mos7840_port->DcrRegOffset + 2), Data);
 	if (status < 0) {
 		dev_dbg(&port->dev, "Writing DCR2 failed status-0x%x\n", status);
-		goto out;
+		goto error;
 	} else
 		dev_dbg(&port->dev, "DCR2 Writing success status%d\n", status);
 
@@ -2197,7 +2214,7 @@ static int mos7840_port_probe(struct usb_serial_port *port)
 	status = mos7840_set_reg_sync(port, CLK_START_VALUE_REGISTER, Data);
 	if (status < 0) {
 		dev_dbg(&port->dev, "Writing CLK_START_VALUE_REGISTER failed status-0x%x\n", status);
-		goto out;
+		goto error;
 	} else
 		dev_dbg(&port->dev, "CLK_START_VALUE_REGISTER Writing success status%d\n", status);
 
@@ -2214,7 +2231,7 @@ static int mos7840_port_probe(struct usb_serial_port *port)
 	status = mos7840_set_uart_reg(port, SCRATCH_PAD_REGISTER, Data);
 	if (status < 0) {
 		dev_dbg(&port->dev, "Writing SCRATCH_PAD_REGISTER failed status-0x%x\n", status);
-		goto out;
+		goto error;
 	} else
 		dev_dbg(&port->dev, "SCRATCH_PAD_REGISTER Writing success status%d\n", status);
 
@@ -2228,7 +2245,7 @@ static int mos7840_port_probe(struct usb_serial_port *port)
 				(__u16)(ZLP_REG1 + ((__u16) mos7840_port->port_num)));
 		if (status < 0) {
 			dev_dbg(&port->dev, "Writing ZLP_REG%d failed status-0x%x\n", pnum + 2, status);
-			goto out;
+			goto error;
 		} else
 			dev_dbg(&port->dev, "ZLP_REG%d Writing success status%d\n", pnum + 2, status);
 	} else {
@@ -2240,7 +2257,7 @@ static int mos7840_port_probe(struct usb_serial_port *port)
 				(__u16)(ZLP_REG1 + ((__u16) mos7840_port->port_num) - 0x1));
 		if (status < 0) {
 			dev_dbg(&port->dev, "Writing ZLP_REG%d failed status-0x%x\n", pnum + 1, status);
-			goto out;
+			goto error;
 		} else
 			dev_dbg(&port->dev, "ZLP_REG%d Writing success status%d\n", pnum + 1, status);
 
@@ -2280,17 +2297,7 @@ static int mos7840_port_probe(struct usb_serial_port *port)
 		/* Turn off LED */
 		mos7840_set_led_sync(port, MODEM_CONTROL_REGISTER, 0x0300);
 	}
-out:
-	if (pnum == serial->num_ports - 1) {
-		/* Zero Length flag enable */
-		Data = 0x0f;
-		status = mos7840_set_reg_sync(serial->port[0], ZLP_REG5, Data);
-		if (status < 0) {
-			dev_dbg(&port->dev, "Writing ZLP_REG5 failed status-0x%x\n", status);
-			goto error;
-		} else
-			dev_dbg(&port->dev, "ZLP_REG5 Writing success status%d\n", status);
-	}
+
 	return 0;
 error:
 	kfree(mos7840_port->led_dr);
@@ -2346,6 +2353,7 @@ static struct usb_serial_driver moschip7840_4port_device = {
 	.unthrottle = mos7840_unthrottle,
 	.calc_num_ports = mos7840_calc_num_ports,
 	.probe = mos7840_probe,
+	.attach = mos7840_attach,
 	.ioctl = mos7840_ioctl,
 	.get_serial = mos7840_get_serial_info,
 	.set_termios = mos7840_set_termios,
-- 
2.25.1

