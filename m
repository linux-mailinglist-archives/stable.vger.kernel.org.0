Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92251246EB5
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 19:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729456AbgHQRfH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 13:35:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:56220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730322AbgHQQRu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:17:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E567822CAF;
        Mon, 17 Aug 2020 16:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597681068;
        bh=oH4VHohmkYgfHQ4bhyNLNm4/Q8IS8mB1/jcuedtF8ps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VX6Ub9N/TM6uIQk7G4JaZWsPREO85LAqGlx/8JWlHdNeqaVM2xvnsbMptz/8641ua
         twPx7zRoODczuNi4WmPhxNeZYTjRX2ClM6y0krzC2OujwQTKTA22HL2QJYde9vvAFH
         lmBSoi6mANQ4hN3BzlZZ3F80AQtTDQSX6yCyOCbI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brant Merryman <brant.merryman@silabs.com>,
        Phu Luu <phu.luu@silabs.com>, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 138/168] USB: serial: cp210x: re-enable auto-RTS on open
Date:   Mon, 17 Aug 2020 17:17:49 +0200
Message-Id: <20200817143740.592062851@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143733.692105228@linuxfoundation.org>
References: <20200817143733.692105228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brant Merryman <brant.merryman@silabs.com>

commit c7614ff9b73a1e6fb2b1b51396da132ed22fecdb upstream.

CP210x hardware disables auto-RTS but leaves auto-CTS when in hardware
flow control mode and UART on cp210x hardware is disabled. When
re-opening the port, if auto-CTS is enabled on the cp210x, then auto-RTS
must be re-enabled in the driver.

Signed-off-by: Brant Merryman <brant.merryman@silabs.com>
Co-developed-by: Phu Luu <phu.luu@silabs.com>
Signed-off-by: Phu Luu <phu.luu@silabs.com>
Link: https://lore.kernel.org/r/ECCF8E73-91F3-4080-BE17-1714BC8818FB@silabs.com
[ johan: fix up tags and problem description ]
Fixes: 39a66b8d22a3 ("[PATCH] USB: CP2101 Add support for flow control")
Cc: stable <stable@vger.kernel.org>     # 2.6.12
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/cp210x.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -893,6 +893,7 @@ static void cp210x_get_termios_port(stru
 	u32 baud;
 	u16 bits;
 	u32 ctl_hs;
+	u32 flow_repl;
 
 	cp210x_read_u32_reg(port, CP210X_GET_BAUDRATE, &baud);
 
@@ -993,6 +994,22 @@ static void cp210x_get_termios_port(stru
 	ctl_hs = le32_to_cpu(flow_ctl.ulControlHandshake);
 	if (ctl_hs & CP210X_SERIAL_CTS_HANDSHAKE) {
 		dev_dbg(dev, "%s - flow control = CRTSCTS\n", __func__);
+		/*
+		 * When the port is closed, the CP210x hardware disables
+		 * auto-RTS and RTS is deasserted but it leaves auto-CTS when
+		 * in hardware flow control mode. When re-opening the port, if
+		 * auto-CTS is enabled on the cp210x, then auto-RTS must be
+		 * re-enabled in the driver.
+		 */
+		flow_repl = le32_to_cpu(flow_ctl.ulFlowReplace);
+		flow_repl &= ~CP210X_SERIAL_RTS_MASK;
+		flow_repl |= CP210X_SERIAL_RTS_SHIFT(CP210X_SERIAL_RTS_FLOW_CTL);
+		flow_ctl.ulFlowReplace = cpu_to_le32(flow_repl);
+		cp210x_write_reg_block(port,
+				CP210X_SET_FLOW,
+				&flow_ctl,
+				sizeof(flow_ctl));
+
 		cflag |= CRTSCTS;
 	} else {
 		dev_dbg(dev, "%s - flow control = NONE\n", __func__);


