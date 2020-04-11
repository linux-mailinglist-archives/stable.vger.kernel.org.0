Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 653BD1A5960
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbgDKXgO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:36:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:45992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729001AbgDKXIq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:08:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4909021D79;
        Sat, 11 Apr 2020 23:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646526;
        bh=EHKM173hDAEkxmP/uNv4sY3k5Xn+LR2ptxQZRGg5XFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NMIkAP4To63Y3mEPwWIYRnczeX9CZp/92UI08feZtfSWHxhdI6Fccxqm2uFqkg8Zk
         ANkOh1/0noP+6KTpBlgFSLDgWhpKUTw1OrGqW/H6koJXYRiED9NA4gKhZVGUpUhSIF
         4wEmBmAmuBCT0h4Ckmg5IRNM1e8ANamRMkO3fCnA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Douglas Anderson <dianders@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 081/121] tty: serial: qcom_geni_serial: No need to stop tx/rx on UART shutdown
Date:   Sat, 11 Apr 2020 19:06:26 -0400
Message-Id: <20200411230706.23855-81-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230706.23855-1-sashal@kernel.org>
References: <20200411230706.23855-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit e83766334f96b3396a71c7baa3b0b53dfd5190cd ]

On a board using qcom_geni_serial I found that I could no longer
interact with kdb if I got a crash after the "agetty" running on the
same serial port was killed.  This meant that various classes of
crashes that happened at reboot time were undebuggable.

Reading through the code, I couldn't figure out why qcom_geni_serial
felt the need to run so much code at port shutdown time.  All we need
to do is disable the interrupt.

After I make this change then a hardcoded kgdb_breakpoint in some late
shutdown code now allows me to interact with the debugger.  I also
could freely close / re-open the port without problems.

Fixes: c4f528795d1a ("tty: serial: msm_geni_serial: Add serial driver support for GENI based QUP")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20200313134635.1.Icf54c533065306b02b880c46dfd401d8db34e213@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/qcom_geni_serial.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/tty/serial/qcom_geni_serial.c b/drivers/tty/serial/qcom_geni_serial.c
index ebace5ad175ca..7a6fa4ab780f7 100644
--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -846,17 +846,11 @@ static void get_tx_fifo_size(struct qcom_geni_serial_port *port)
 
 static void qcom_geni_serial_shutdown(struct uart_port *uport)
 {
-	unsigned long flags;
-
 	/* Stop the console before stopping the current tx */
 	if (uart_console(uport))
 		console_stop(uport->cons);
 
 	disable_irq(uport->irq);
-	spin_lock_irqsave(&uport->lock, flags);
-	qcom_geni_serial_stop_tx(uport);
-	qcom_geni_serial_stop_rx(uport);
-	spin_unlock_irqrestore(&uport->lock, flags);
 }
 
 static int qcom_geni_serial_port_setup(struct uart_port *uport)
-- 
2.20.1

