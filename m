Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C487E622B19
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 13:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbiKIMFQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 07:05:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiKIMFP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 07:05:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F12D2AC72
        for <stable@vger.kernel.org>; Wed,  9 Nov 2022 04:05:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 005B0B81E00
        for <stable@vger.kernel.org>; Wed,  9 Nov 2022 12:05:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F8BC433C1;
        Wed,  9 Nov 2022 12:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667995512;
        bh=J3hyjMGYx4Ff8ChBf313j5Q1MIkz+M2384BDHvU/rJI=;
        h=Subject:To:From:Date:From;
        b=03uOszCWRIYd8/7GB5WDZNXPrSDQ6ndNfe6HFMtJl/terg+RmZQd35MoLc7zWueVq
         PVVp8H3t4ZAuwBfLDSxLwHod3j29BxEmdPcTaZwmdxEpt5obROiK3jsSKQM2w3wrdJ
         q2oGAA0CIFILOVZ0nh5/2Jq2MAaPTcyyrfogVg90=
Subject: patch "serial: 8250: Fall back to non-DMA Rx if IIR_RDI occurs" added to tty-linus
To:     ilpo.jarvinen@linux.intel.com, aman.kumar@intel.com,
        andriy.shevchenko@linux.intel.com, gregkh@linuxfoundation.org,
        srikanth.thokala@intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Nov 2022 13:05:10 +0100
Message-ID: <166799551093207@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

    serial: 8250: Fall back to non-DMA Rx if IIR_RDI occurs

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From a931237cbea256aff13bb403da13a97b2d1605d9 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Tue, 8 Nov 2022 14:19:49 +0200
Subject: serial: 8250: Fall back to non-DMA Rx if IIR_RDI occurs
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

DW UART sometimes triggers IIR_RDI during DMA Rx when IIR_RX_TIMEOUT
should have been triggered instead. Since IIR_RDI has higher priority
than IIR_RX_TIMEOUT, this causes the Rx to hang into interrupt loop.
The problem seems to occur at least with some combinations of
small-sized transfers (I've reproduced the problem on Elkhart Lake PSE
UARTs).

If there's already an on-going Rx DMA and IIR_RDI triggers, fall
graciously back to non-DMA Rx. That is, behave as if IIR_RX_TIMEOUT had
occurred.

8250_omap already considers IIR_RDI similar to this change so its
nothing unheard of.

Fixes: 75df022b5f89 ("serial: 8250_dma: Fix RX handling")
Cc: <stable@vger.kernel.org>
Co-developed-by: Srikanth Thokala <srikanth.thokala@intel.com>
Signed-off-by: Srikanth Thokala <srikanth.thokala@intel.com>
Co-developed-by: Aman Kumar <aman.kumar@intel.com>
Signed-off-by: Aman Kumar <aman.kumar@intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20221108121952.5497-2-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_port.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index fe8662cd9402..92dd18716169 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -1897,6 +1897,10 @@ EXPORT_SYMBOL_GPL(serial8250_modem_status);
 static bool handle_rx_dma(struct uart_8250_port *up, unsigned int iir)
 {
 	switch (iir & 0x3f) {
+	case UART_IIR_RDI:
+		if (!up->dma->rx_running)
+			break;
+		fallthrough;
 	case UART_IIR_RX_TIMEOUT:
 		serial8250_rx_dma_flush(up);
 		fallthrough;
-- 
2.38.1


