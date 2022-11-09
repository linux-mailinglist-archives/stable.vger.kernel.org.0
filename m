Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2A3622B1B
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 13:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiKIMFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 07:05:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiKIMFc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 07:05:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 446912A728
        for <stable@vger.kernel.org>; Wed,  9 Nov 2022 04:05:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05323B81D52
        for <stable@vger.kernel.org>; Wed,  9 Nov 2022 12:05:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38DC6C433D7;
        Wed,  9 Nov 2022 12:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667995529;
        bh=RYrPeEAqEFoDnzslPebc50kNds0xAUBYjwrWoPTzzj0=;
        h=Subject:To:From:Date:From;
        b=n4za5ZCLnWrspkgZg4M9snzH0lSPhFBhN/9A4kuQpIcyjlPs9G7VBm3CxOg/CJPHF
         6LV548xGzFhGQVd+dPMlLppi3Qw5aAcS/REpmzoYM/Bxglmnod9xMu88uqEnOJt8YZ
         fGbLLuYzRdLBwb0ZEcHU4wNMuNIvi3hQsS/vOw98=
Subject: patch "serial: 8250: Flush DMA Rx on RLSI" added to tty-linus
To:     ilpo.jarvinen@linux.intel.com, andriy.shevchenko@linux.intel.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Nov 2022 13:05:12 +0100
Message-ID: <16679955129250@kroah.com>
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

    serial: 8250: Flush DMA Rx on RLSI

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 1980860e0c8299316cddaf0992dd9e1258ec9d88 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Tue, 8 Nov 2022 14:19:52 +0200
Subject: serial: 8250: Flush DMA Rx on RLSI
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Returning true from handle_rx_dma() without flushing DMA first creates
a data ordering hazard. If DMA Rx has handled any character at the
point when RLSI occurs, the non-DMA path handles any pending characters
jumping them ahead of those characters that are pending under DMA.

Fixes: 75df022b5f89 ("serial: 8250_dma: Fix RX handling")
Cc: <stable@vger.kernel.org>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20221108121952.5497-5-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_port.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 92dd18716169..388172289627 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -1901,10 +1901,9 @@ static bool handle_rx_dma(struct uart_8250_port *up, unsigned int iir)
 		if (!up->dma->rx_running)
 			break;
 		fallthrough;
+	case UART_IIR_RLSI:
 	case UART_IIR_RX_TIMEOUT:
 		serial8250_rx_dma_flush(up);
-		fallthrough;
-	case UART_IIR_RLSI:
 		return true;
 	}
 	return up->dma->rx_dma(up);
-- 
2.38.1


