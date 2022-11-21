Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0F9632131
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 12:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbiKULtW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 06:49:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbiKULtO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 06:49:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB5320190
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 03:49:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8620B80ED2
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 11:49:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE46C433C1;
        Mon, 21 Nov 2022 11:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669031351;
        bh=wuZcZ1hhyKSOtm7NIPTC2eeIxEJw/8JAY291bz2+wLY=;
        h=Subject:To:Cc:From:Date:From;
        b=XpMmbgUK6Fj6DUPbfPVnmzi60jT2dO5OvbhKA0SVNAh7ZdgFFs+60Pn71hnO+L4X8
         I6F81wJJeGnutS1MAJDS2p7myNrX3DDsClqN2xBCsbdqG++J90l79awY/OnyA54fjp
         T46/J3e48dRspsTHaxqpLFP7HVT+TNYqMDfFIHeA=
Subject: FAILED: patch "[PATCH] serial: 8250: Flush DMA Rx on RLSI" failed to apply to 4.19-stable tree
To:     ilpo.jarvinen@linux.intel.com, andriy.shevchenko@linux.intel.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Nov 2022 12:48:59 +0100
Message-ID: <166903133910188@kroah.com>
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


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

1980860e0c82 ("serial: 8250: Flush DMA Rx on RLSI")
a931237cbea2 ("serial: 8250: Fall back to non-DMA Rx if IIR_RDI occurs")
df561f6688fe ("treewide: Use fallthrough pseudo-keyword")
37711e5e2325 ("Merge tag 'nfs-for-5.9-1' of git://git.linux-nfs.org/projects/trondmy/linux-nfs")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1980860e0c8299316cddaf0992dd9e1258ec9d88 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Tue, 8 Nov 2022 14:19:52 +0200
Subject: [PATCH] serial: 8250: Flush DMA Rx on RLSI
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

