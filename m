Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB3D1126D79
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbfLSSgN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:36:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:53078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727414AbfLSSgN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:36:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22B8124679;
        Thu, 19 Dec 2019 18:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780571;
        bh=OUnLvqpeW7buRbpimdUMUa3+KvpyBiKvmorsgjNCtPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WI1Gn2CHnkWO0MsHdm/pfsW+cBQvUD5f8RIH0nlYoVssg93GrSjC6F9MaZNuL8zNj
         1Qob+Mx6C7ocFZnBMPgki16lnn6baI1/yuEH5B5CesCXiv+E9rApZgNrwWScnXfRa9
         29DY3c2iY0xu3mokpxoQHN/m+doRaxxiL56V0zNU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>
Subject: [PATCH 4.4 003/162] tty: serial: msm_serial: Fix flow control
Date:   Thu, 19 Dec 2019 19:31:51 +0100
Message-Id: <20191219183154.899455796@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183150.477687052@linuxfoundation.org>
References: <20191219183150.477687052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>

commit b027ce258369cbfa88401a691c23dad01deb9f9b upstream.

hci_qca interfaces to the wcn3990 via a uart_dm on the msm8998 mtp and
Lenovo Miix 630 laptop.  As part of initializing the wcn3990, hci_qca
disables flow, configures the uart baudrate, and then reenables flow - at
which point an event is expected to be received over the uart from the
wcn3990.  It is observed that this event comes after the baudrate change
but before hci_qca re-enables flow. This is unexpected, and is a result of
msm_reset() being broken.

According to the uart_dm hardware documentation, it is recommended that
automatic hardware flow control be enabled by setting RX_RDY_CTL.  Auto
hw flow control will manage RFR based on the configured watermark.  When
there is space to receive data, the hw will assert RFR.  When the watermark
is hit, the hw will de-assert RFR.

The hardware documentation indicates that RFR can me manually managed via
CR when RX_RDY_CTL is not set.  SET_RFR asserts RFR, and RESET_RFR
de-asserts RFR.

msm_reset() is broken because after resetting the hardware, it
unconditionally asserts RFR via SET_RFR.  This enables flow regardless of
the current configuration, and would undo a previous flow disable
operation.  It should instead de-assert RFR via RESET_RFR to block flow
until the hardware is reconfigured.  msm_serial should rely on the client
to specify that flow should be enabled, either via mctrl() or the termios
structure, and only assert RFR in response to those triggers.

Fixes: 04896a77a97b ("msm_serial: serial driver for MSM7K onboard serial peripheral.")
Signed-off-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Andy Gross <agross@kernel.org>
Link: https://lore.kernel.org/r/20191021154616.25457-1-jeffrey.l.hugo@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/msm_serial.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -823,6 +823,7 @@ static unsigned int msm_get_mctrl(struct
 static void msm_reset(struct uart_port *port)
 {
 	struct msm_port *msm_port = UART_TO_MSM(port);
+	unsigned int mr;
 
 	/* reset everything */
 	msm_write(port, UART_CR_CMD_RESET_RX, UART_CR);
@@ -830,7 +831,10 @@ static void msm_reset(struct uart_port *
 	msm_write(port, UART_CR_CMD_RESET_ERR, UART_CR);
 	msm_write(port, UART_CR_CMD_RESET_BREAK_INT, UART_CR);
 	msm_write(port, UART_CR_CMD_RESET_CTS, UART_CR);
-	msm_write(port, UART_CR_CMD_SET_RFR, UART_CR);
+	msm_write(port, UART_CR_CMD_RESET_RFR, UART_CR);
+	mr = msm_read(port, UART_MR1);
+	mr &= ~UART_MR1_RX_RDY_CTL;
+	msm_write(port, mr, UART_MR1);
 
 	/* Disable DM modes */
 	if (msm_port->is_uartdm)


