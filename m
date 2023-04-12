Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC3D96DEEC8
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbjDLIpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbjDLIoj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:44:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B41DAE45
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:44:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06B0263081
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:44:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D38AC433EF;
        Wed, 12 Apr 2023 08:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289045;
        bh=4sYj83CJDCChZKahyCiEMM2QVihTmqHguGieoTLcR3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=diGn8EQVBsWyRmuuzfM7mJx4UfKwv/IJ0Dj152U/tVc/Tqs7ivByhIwOuM6p+Aff9
         HEvpYu6JMFsJKR9OSKAb7gAuVo46tblG3Z/TwP0l7UvpAv77KIrxxFD3MrR6KfPiRj
         6IAvcx+yDYXnS6RBNCkLuTtsOTokbvkW731fZtZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.1 085/164] serial: 8250: Prevent starting up DMA Rx on THRI interrupt
Date:   Wed, 12 Apr 2023 10:33:27 +0200
Message-Id: <20230412082840.338536320@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

commit 90b8596ac46043e4a782d9111f5b285251b13756 upstream.

Hans de Goede reported Bluetooth adapters (HCIs) connected over an UART
connection failed due corrupted Rx payload. The problem was narrowed
down to DMA Rx starting on UART_IIR_THRI interrupt. The problem occurs
despite LSR having DR bit set, which is precondition for attempting to
start DMA Rx in the first place.

>From a debug patch:
[x.807834] 8250irq: iir=cc lsr+saved=60 received=0/15 ier=0f dma_t/rx/err=0/0/0
[x.808676] 8250irq: iir=c2 lsr+saved=61 received=0/0 ier=0f dma_t/rx/err=0/0/0
[x.808776] 8250irq: iir=cc lsr+saved=60 received=1/12 ier=0d dma_t/rx/err=0/1/0
[x.808870] Bluetooth: hci0: Frame reassembly failed (-84)

In the debug snippet, received field indicates 1 byte was transferred
over DMA and 12 bytes after that with the non-DMA Rx. The sole byte DMA
handled was corrupted (gets zeroed) which leads to the HCI failure.

This problem became apparent after commit e8ffbb71f783 ("serial: 8250:
use THRE & __stop_tx also with DMA") changed Tx stop behavior. Tx stop
is now triggered from a THRI interrupt.

Despite that this problem looks like a HW bug, this fix is not adding
UART_BUG_xx flag to the driver beucase it seems useful in general to
avoid starting DMA when there are only a few bytes to transfer.
Skipping DMA for small transfers avoids the extra overhead DMA incurs.

Thus, don't setup DMA Rx on UART_IIR_THRI but leave it to a subsequent
interrupt which has Rx a related IIR value.

By returning false from handle_rx_dma(), the DMA vs non-DMA decision is
postponed until either UART_IIR_RDI (FIFO threshold worth of bytes
awaiting) or UART_IIR_TIMEOUT (inter-character timeout) triggers at a
later time which allows better to discern whether the number of bytes
warrants starting DMA or not.

Reported-by: Hans de Goede <hdegoede@redhat.com>
Tested-by: Hans de Goede <hdegoede@redhat.com>
Fixes: e8ffbb71f783 ("serial: 8250: use THRE & __stop_tx also with DMA")
Cc: stable@vger.kernel.org
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Acked-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20230317103034.12881-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_port.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -1897,6 +1897,17 @@ EXPORT_SYMBOL_GPL(serial8250_modem_statu
 static bool handle_rx_dma(struct uart_8250_port *up, unsigned int iir)
 {
 	switch (iir & 0x3f) {
+	case UART_IIR_THRI:
+		/*
+		 * Postpone DMA or not decision to IIR_RDI or IIR_RX_TIMEOUT
+		 * because it's impossible to do an informed decision about
+		 * that with IIR_THRI.
+		 *
+		 * This also fixes one known DMA Rx corruption issue where
+		 * DR is asserted but DMA Rx only gets a corrupted zero byte
+		 * (too early DR?).
+		 */
+		return false;
 	case UART_IIR_RDI:
 		if (!up->dma->rx_running)
 			break;


