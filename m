Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C107DEF58C
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 07:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727606AbfKEGeZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 01:34:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:48370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726033AbfKEGeZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Nov 2019 01:34:25 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DBC42084D;
        Tue,  5 Nov 2019 06:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572935662;
        bh=hY5vhhWlvc6ZQ4PZ05UJ9H9lLdSyGM0EWHTqDntLIyo=;
        h=Subject:To:From:Date:From;
        b=HAc1QzSXuY9z/dA0YhAOgui1SfgjFxNzfBLQlECy69LI8dQ4mbGssJA4Fu5dqUqIX
         0irSZMRyW1Bm5fdIgwmWvzw8Dh+x+GPZ43wxKuHflOu80uNGbXQoJZa9lH2+j82sRd
         xN55wVyysHKn+iiOVEDkyMnTTAHUEFFuixWA1cIg=
Subject: patch "tty: serial: msm_serial: Fix flow control" added to tty-next
To:     jeffrey.l.hugo@gmail.com, agross@kernel.org,
        bjorn.andersson@linaro.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 05 Nov 2019 07:34:08 +0100
Message-ID: <1572935648161185@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    tty: serial: msm_serial: Fix flow control

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From b027ce258369cbfa88401a691c23dad01deb9f9b Mon Sep 17 00:00:00 2001
From: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Date: Mon, 21 Oct 2019 08:46:16 -0700
Subject: tty: serial: msm_serial: Fix flow control

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
 drivers/tty/serial/msm_serial.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index 3657a24913fc..00964b6e4ac1 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -980,6 +980,7 @@ static unsigned int msm_get_mctrl(struct uart_port *port)
 static void msm_reset(struct uart_port *port)
 {
 	struct msm_port *msm_port = UART_TO_MSM(port);
+	unsigned int mr;
 
 	/* reset everything */
 	msm_write(port, UART_CR_CMD_RESET_RX, UART_CR);
@@ -987,7 +988,10 @@ static void msm_reset(struct uart_port *port)
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
-- 
2.23.0


