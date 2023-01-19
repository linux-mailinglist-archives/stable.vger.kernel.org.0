Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3C6673ACF
	for <lists+stable@lfdr.de>; Thu, 19 Jan 2023 14:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjASN4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Jan 2023 08:56:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbjASNz4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Jan 2023 08:55:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98057E686
        for <stable@vger.kernel.org>; Thu, 19 Jan 2023 05:55:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C00661644
        for <stable@vger.kernel.org>; Thu, 19 Jan 2023 13:55:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57814C433D2;
        Thu, 19 Jan 2023 13:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674136534;
        bh=IS9AsYhKw5618AmOckeXjUebdDASQs/kW57l2pe3PFk=;
        h=Subject:To:From:Date:From;
        b=oQMsFvKUsE/wqmzPjVLpFQE+HD0EXnId7RCVS3UEZGcr7glWxvpSzv/LnB5AFFB0u
         z9+JPxiw1pI/n6oLlyrMhvyblnteHAaT4gmPEYGw8HAO+3FuNEqyfuS3ki0SzMRFi2
         Lb4S8Rl8M8ch8mpSsMgwTFDCCHA9QcaBNVK+gS7g=
Subject: patch "tty: serial: qcom-geni-serial: fix slab-out-of-bounds on RX FIFO" added to tty-linus
To:     krzysztof.kozlowski@linaro.org, gregkh@linuxfoundation.org,
        jirislaby@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 19 Jan 2023 14:55:32 +0100
Message-ID: <167413653215658@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    tty: serial: qcom-geni-serial: fix slab-out-of-bounds on RX FIFO

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b8caf69a6946e18ffebad49847e258f5b6d52ac2 Mon Sep 17 00:00:00 2001
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Wed, 21 Dec 2022 17:40:22 +0100
Subject: tty: serial: qcom-geni-serial: fix slab-out-of-bounds on RX FIFO
 buffer

Driver's probe allocates memory for RX FIFO (port->rx_fifo) based on
default RX FIFO depth, e.g. 16.  Later during serial startup the
qcom_geni_serial_port_setup() updates the RX FIFO depth
(port->rx_fifo_depth) to match real device capabilities, e.g. to 32.

The RX UART handle code will read "port->rx_fifo_depth" number of words
into "port->rx_fifo" buffer, thus exceeding the bounds.  This can be
observed in certain configurations with Qualcomm Bluetooth HCI UART
device and KASAN:

  Bluetooth: hci0: QCA Product ID   :0x00000010
  Bluetooth: hci0: QCA SOC Version  :0x400a0200
  Bluetooth: hci0: QCA ROM Version  :0x00000200
  Bluetooth: hci0: QCA Patch Version:0x00000d2b
  Bluetooth: hci0: QCA controller version 0x02000200
  Bluetooth: hci0: QCA Downloading qca/htbtfw20.tlv
  bluetooth hci0: Direct firmware load for qca/htbtfw20.tlv failed with error -2
  Bluetooth: hci0: QCA Failed to request file: qca/htbtfw20.tlv (-2)
  Bluetooth: hci0: QCA Failed to download patch (-2)
  ==================================================================
  BUG: KASAN: slab-out-of-bounds in handle_rx_uart+0xa8/0x18c
  Write of size 4 at addr ffff279347d578c0 by task swapper/0/0

  CPU: 0 PID: 0 Comm: swapper/0 Not tainted 6.1.0-rt5-00350-gb2450b7e00be-dirty #26
  Hardware name: Qualcomm Technologies, Inc. Robotics RB5 (DT)
  Call trace:
   dump_backtrace.part.0+0xe0/0xf0
   show_stack+0x18/0x40
   dump_stack_lvl+0x8c/0xb8
   print_report+0x188/0x488
   kasan_report+0xb4/0x100
   __asan_store4+0x80/0xa4
   handle_rx_uart+0xa8/0x18c
   qcom_geni_serial_handle_rx+0x84/0x9c
   qcom_geni_serial_isr+0x24c/0x760
   __handle_irq_event_percpu+0x108/0x500
   handle_irq_event+0x6c/0x110
   handle_fasteoi_irq+0x138/0x2cc
   generic_handle_domain_irq+0x48/0x64

If the RX FIFO depth changes after probe, be sure to resize the buffer.

Fixes: f9d690b6ece7 ("tty: serial: qcom_geni_serial: Allocate port->rx_fifo buffer in probe")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20221221164022.1087814-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/qcom_geni_serial.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/qcom_geni_serial.c b/drivers/tty/serial/qcom_geni_serial.c
index b487823f0e61..49b9ffeae676 100644
--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -864,9 +864,10 @@ static irqreturn_t qcom_geni_serial_isr(int isr, void *dev)
 	return IRQ_HANDLED;
 }
 
-static void get_tx_fifo_size(struct qcom_geni_serial_port *port)
+static int setup_fifos(struct qcom_geni_serial_port *port)
 {
 	struct uart_port *uport;
+	u32 old_rx_fifo_depth = port->rx_fifo_depth;
 
 	uport = &port->uport;
 	port->tx_fifo_depth = geni_se_get_tx_fifo_depth(&port->se);
@@ -874,6 +875,16 @@ static void get_tx_fifo_size(struct qcom_geni_serial_port *port)
 	port->rx_fifo_depth = geni_se_get_rx_fifo_depth(&port->se);
 	uport->fifosize =
 		(port->tx_fifo_depth * port->tx_fifo_width) / BITS_PER_BYTE;
+
+	if (port->rx_fifo && (old_rx_fifo_depth != port->rx_fifo_depth) && port->rx_fifo_depth) {
+		port->rx_fifo = devm_krealloc(uport->dev, port->rx_fifo,
+					      port->rx_fifo_depth * sizeof(u32),
+					      GFP_KERNEL);
+		if (!port->rx_fifo)
+			return -ENOMEM;
+	}
+
+	return 0;
 }
 
 
@@ -888,6 +899,7 @@ static int qcom_geni_serial_port_setup(struct uart_port *uport)
 	u32 rxstale = DEFAULT_BITS_PER_CHAR * STALE_TIMEOUT;
 	u32 proto;
 	u32 pin_swap;
+	int ret;
 
 	proto = geni_se_read_proto(&port->se);
 	if (proto != GENI_SE_UART) {
@@ -897,7 +909,9 @@ static int qcom_geni_serial_port_setup(struct uart_port *uport)
 
 	qcom_geni_serial_stop_rx(uport);
 
-	get_tx_fifo_size(port);
+	ret = setup_fifos(port);
+	if (ret)
+		return ret;
 
 	writel(rxstale, uport->membase + SE_UART_RX_STALE_CNT);
 
-- 
2.39.1


