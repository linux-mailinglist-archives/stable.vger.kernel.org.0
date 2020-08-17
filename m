Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97FE0246C20
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 18:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388538AbgHQQKj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 12:10:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:36716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388543AbgHQQK3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:10:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FCE722D06;
        Mon, 17 Aug 2020 16:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680617;
        bh=4sgduH5P5O73KnNHItFH0MRZIlGcnmkccmJ2zfLYU+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I1MQRcMmVH5GwIO+Ay987DLlAiQX6OHd3KeyCCthlVa89e8O4krkvw3Ezd2LneYEG
         DPQkJ+uTSh6h0hWcUSVdrW9WicPkrdGnxSOiossRsIBerw4+1DWWQwhibesK9Q9sif
         WgTgJ39HJjp8w517It/H1890EoNoms8bUk0OzsjI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brant Merryman <brant.merryman@silabs.com>,
        Phu Luu <phu.luu@silabs.com>, Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 228/270] USB: serial: cp210x: re-enable auto-RTS on open
Date:   Mon, 17 Aug 2020 17:17:09 +0200
Message-Id: <20200817143807.141561591@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
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
@@ -915,6 +915,7 @@ static void cp210x_get_termios_port(stru
 	u32 baud;
 	u16 bits;
 	u32 ctl_hs;
+	u32 flow_repl;
 
 	cp210x_read_u32_reg(port, CP210X_GET_BAUDRATE, &baud);
 
@@ -1015,6 +1016,22 @@ static void cp210x_get_termios_port(stru
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


