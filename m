Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 027B626EFB3
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbgIRChd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:37:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:39106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728085AbgIRCMg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:12:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBE7D22211;
        Fri, 18 Sep 2020 02:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395155;
        bh=COH4eSlS3uz0CxsPwpwSNpPHV9aOqW1p7YDfiDj/YBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iSeuhE2J23XFqmMm3tbiMkNPiHNyqJc9w/cWTVQ3E8aF3z4mFmCB2uUyKK+ifD0a9
         Sx61cZqf8FleIjj1yti8ydy94d4fl2+gC3vhQ6f8u+LP8RyoHo0TeYfZojLNJGCzgw
         uG3FhkKdLHrY4AxGiTVhzPOAhuW/f6eccBS3KhNw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 013/127] USB: serial: mos7840: fix probe error handling
Date:   Thu, 17 Sep 2020 22:10:26 -0400
Message-Id: <20200918021220.2066485-13-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021220.2066485-1-sashal@kernel.org>
References: <20200918021220.2066485-1-sashal@kernel.org>
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
index 285527f115dd7..994e2ffecbd6e 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -2131,6 +2131,23 @@ static int mos7840_calc_num_ports(struct usb_serial *serial,
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
@@ -2194,7 +2211,7 @@ static int mos7840_port_probe(struct usb_serial_port *port)
 			mos7840_port->ControlRegOffset, &Data);
 	if (status < 0) {
 		dev_dbg(&port->dev, "Reading ControlReg failed status-0x%x\n", status);
-		goto out;
+		goto error;
 	} else
 		dev_dbg(&port->dev, "ControlReg Reading success val is %x, status%d\n", Data, status);
 	Data |= 0x08;	/* setting driver done bit */
@@ -2206,7 +2223,7 @@ static int mos7840_port_probe(struct usb_serial_port *port)
 			mos7840_port->ControlRegOffset, Data);
 	if (status < 0) {
 		dev_dbg(&port->dev, "Writing ControlReg failed(rx_disable) status-0x%x\n", status);
-		goto out;
+		goto error;
 	} else
 		dev_dbg(&port->dev, "ControlReg Writing success(rx_disable) status%d\n", status);
 
@@ -2217,7 +2234,7 @@ static int mos7840_port_probe(struct usb_serial_port *port)
 			(__u16) (mos7840_port->DcrRegOffset + 0), Data);
 	if (status < 0) {
 		dev_dbg(&port->dev, "Writing DCR0 failed status-0x%x\n", status);
-		goto out;
+		goto error;
 	} else
 		dev_dbg(&port->dev, "DCR0 Writing success status%d\n", status);
 
@@ -2226,7 +2243,7 @@ static int mos7840_port_probe(struct usb_serial_port *port)
 			(__u16) (mos7840_port->DcrRegOffset + 1), Data);
 	if (status < 0) {
 		dev_dbg(&port->dev, "Writing DCR1 failed status-0x%x\n", status);
-		goto out;
+		goto error;
 	} else
 		dev_dbg(&port->dev, "DCR1 Writing success status%d\n", status);
 
@@ -2235,7 +2252,7 @@ static int mos7840_port_probe(struct usb_serial_port *port)
 			(__u16) (mos7840_port->DcrRegOffset + 2), Data);
 	if (status < 0) {
 		dev_dbg(&port->dev, "Writing DCR2 failed status-0x%x\n", status);
-		goto out;
+		goto error;
 	} else
 		dev_dbg(&port->dev, "DCR2 Writing success status%d\n", status);
 
@@ -2244,7 +2261,7 @@ static int mos7840_port_probe(struct usb_serial_port *port)
 	status = mos7840_set_reg_sync(port, CLK_START_VALUE_REGISTER, Data);
 	if (status < 0) {
 		dev_dbg(&port->dev, "Writing CLK_START_VALUE_REGISTER failed status-0x%x\n", status);
-		goto out;
+		goto error;
 	} else
 		dev_dbg(&port->dev, "CLK_START_VALUE_REGISTER Writing success status%d\n", status);
 
@@ -2261,7 +2278,7 @@ static int mos7840_port_probe(struct usb_serial_port *port)
 	status = mos7840_set_uart_reg(port, SCRATCH_PAD_REGISTER, Data);
 	if (status < 0) {
 		dev_dbg(&port->dev, "Writing SCRATCH_PAD_REGISTER failed status-0x%x\n", status);
-		goto out;
+		goto error;
 	} else
 		dev_dbg(&port->dev, "SCRATCH_PAD_REGISTER Writing success status%d\n", status);
 
@@ -2275,7 +2292,7 @@ static int mos7840_port_probe(struct usb_serial_port *port)
 				(__u16)(ZLP_REG1 + ((__u16) mos7840_port->port_num)));
 		if (status < 0) {
 			dev_dbg(&port->dev, "Writing ZLP_REG%d failed status-0x%x\n", pnum + 2, status);
-			goto out;
+			goto error;
 		} else
 			dev_dbg(&port->dev, "ZLP_REG%d Writing success status%d\n", pnum + 2, status);
 	} else {
@@ -2287,7 +2304,7 @@ static int mos7840_port_probe(struct usb_serial_port *port)
 				(__u16)(ZLP_REG1 + ((__u16) mos7840_port->port_num) - 0x1));
 		if (status < 0) {
 			dev_dbg(&port->dev, "Writing ZLP_REG%d failed status-0x%x\n", pnum + 1, status);
-			goto out;
+			goto error;
 		} else
 			dev_dbg(&port->dev, "ZLP_REG%d Writing success status%d\n", pnum + 1, status);
 
@@ -2328,17 +2345,7 @@ static int mos7840_port_probe(struct usb_serial_port *port)
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
@@ -2394,6 +2401,7 @@ static struct usb_serial_driver moschip7840_4port_device = {
 	.unthrottle = mos7840_unthrottle,
 	.calc_num_ports = mos7840_calc_num_ports,
 	.probe = mos7840_probe,
+	.attach = mos7840_attach,
 	.ioctl = mos7840_ioctl,
 	.set_termios = mos7840_set_termios,
 	.break_ctl = mos7840_break,
-- 
2.25.1

