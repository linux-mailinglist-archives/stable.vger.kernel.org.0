Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C61E51CC29
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 00:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386356AbiEEWia (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 May 2022 18:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386433AbiEEWi3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 May 2022 18:38:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B531F5EDE9
        for <stable@vger.kernel.org>; Thu,  5 May 2022 15:34:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C816F61F50
        for <stable@vger.kernel.org>; Thu,  5 May 2022 22:34:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E68C385AF;
        Thu,  5 May 2022 22:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651790077;
        bh=fLBmoQlSW5c09QlUXXyBjb6YTVPv5QCxnzNnxZemtuk=;
        h=Subject:To:From:Date:From;
        b=T3Br0BDfydZNIlWyW5zVnXnLK2nUXUHwOWlSjy/2HZC1+Y0bL/SgDai7SRW6n0P+1
         +lsHRCHtWGLkFePv1chBYuYpGZnIiaxrhFpwn2lk1q2rJMaweP+5M26sxCmUAtCXl/
         BaRRNWfLuxikXRwUNs6KD855VRYMxrMGs9pJyB6I=
Subject: patch "serial: 8250_mtk: Fix register address for XON/XOFF character" added to tty-linus
To:     angelogioacchino.delregno@collabora.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 05 May 2022 23:00:39 +0200
Message-ID: <165178443977159@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: 8250_mtk: Fix register address for XON/XOFF character

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From e1bfdbc7daca171c74a577b3dd0b36d76bb0ffcc Mon Sep 17 00:00:00 2001
From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Date: Wed, 27 Apr 2022 15:23:28 +0200
Subject: serial: 8250_mtk: Fix register address for XON/XOFF character

The XON1/XOFF1 character registers are at offset 0xa0 and 0xa8
respectively, so we cannot use the definition in serial_port.h.

Fixes: bdbd0a7f8f03 ("serial: 8250-mtk: modify baudrate setting")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220427132328.228297-4-angelogioacchino.delregno@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_mtk.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_mtk.c b/drivers/tty/serial/8250/8250_mtk.c
index 28e36459642c..21053db93ff1 100644
--- a/drivers/tty/serial/8250/8250_mtk.c
+++ b/drivers/tty/serial/8250/8250_mtk.c
@@ -57,6 +57,9 @@
 #define MTK_UART_FEATURE_SEL	39	/* Feature Selection register */
 #define MTK_UART_FEAT_NEWRMAP	BIT(0)	/* Use new register map */
 
+#define MTK_UART_XON1		40	/* I/O: Xon character 1 */
+#define MTK_UART_XOFF1		42	/* I/O: Xoff character 1 */
+
 #ifdef CONFIG_SERIAL_8250_DMA
 enum dma_rx_status {
 	DMA_RX_START = 0,
@@ -278,8 +281,8 @@ static void mtk8250_set_flow_ctrl(struct uart_8250_port *up, int mode)
 			(serial_in(up, MTK_UART_EFR) &
 			(~(MTK_UART_EFR_HW_FC | MTK_UART_EFR_SW_FC_MASK))));
 
-		serial_out(up, UART_XON1, START_CHAR(port->state->port.tty));
-		serial_out(up, UART_XOFF1, STOP_CHAR(port->state->port.tty));
+		serial_out(up, MTK_UART_XON1, START_CHAR(port->state->port.tty));
+		serial_out(up, MTK_UART_XOFF1, STOP_CHAR(port->state->port.tty));
 		serial_out(up, UART_LCR, lcr);
 		mtk8250_disable_intrs(up, MTK_UART_IER_CTSI|MTK_UART_IER_RTSI);
 		mtk8250_enable_intrs(up, MTK_UART_IER_XOFFI);
-- 
2.36.0


