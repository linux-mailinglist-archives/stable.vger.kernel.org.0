Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1BB6BE6C3
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 11:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbjCQKar (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 06:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjCQKaq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 06:30:46 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B41C834328;
        Fri, 17 Mar 2023 03:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679049044; x=1710585044;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JjbrSAPPpxCv7orXEzp/qzb0yoFhw8whzb7/+Tbqop0=;
  b=PAK/KclMzMt861mECEaYy6xboNdVIOeA8zFWmbG6oYlEWrhVs8wl9jpR
   A86yMHnk8+HWSPretodFqfaj64RadOTbBQRuL+nCESVMCmRtDbBW2vw5W
   QWMeWtICZ4mm9t2ZTBMg7K6lq+NhM6PA/x+omCatFQnY0xQKG5XcG1lOA
   dWnFhBsBmRWhJSl/c9ngowkzjUmdAKbHHQyIu8avsZ6A5xO/arusqYvuf
   i6UB2JulGY0C3zuMK6buxqpJ1JaEgbI59fn3QNKEwBPeTs4eDTRZuOJDT
   GPY2WvO/+DXiM202/JuvmGt3vDP7+8RxHtmsJNyRx/rf6fnNpBRXRUiGR
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="336930940"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="336930940"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 03:30:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="926098291"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="926098291"
Received: from bstach-mobl1.ger.corp.intel.com (HELO ijarvine-MOBL2.ger.corp.intel.com) ([10.251.221.222])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 03:30:42 -0700
From:   =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>, stable@vger.kernel.org
Subject: [PATCH 1/1] serial: 8250: Prevent starting up DMA Rx on THRI interrupt
Date:   Fri, 17 Mar 2023 12:30:34 +0200
Message-Id: <20230317103034.12881-1-ilpo.jarvinen@linux.intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hans de Goede reported Bluetooth adapters (HCIs) connected over an UART
connection failed due corrupted Rx payload. The problem was narrowed
down to DMA Rx starting on UART_IIR_THRI interrupt. The problem occurs
despite LSR having DR bit set, which is precondition for attempting to
start DMA Rx in the first place.

From a debug patch:
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
---
 drivers/tty/serial/8250/8250_port.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index fa43df05342b..3ba9c8b93ae6 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -1903,6 +1903,17 @@ EXPORT_SYMBOL_GPL(serial8250_modem_status);
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
-- 
2.30.2

