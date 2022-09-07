Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEA325B0737
	for <lists+stable@lfdr.de>; Wed,  7 Sep 2022 16:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiIGOlf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 10:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiIGOlK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 10:41:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E688293217
        for <stable@vger.kernel.org>; Wed,  7 Sep 2022 07:41:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F90DB81D3F
        for <stable@vger.kernel.org>; Wed,  7 Sep 2022 14:41:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C11C433C1;
        Wed,  7 Sep 2022 14:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662561664;
        bh=q0VDzc/V/AGxDEQuqCvZq/jicpixdYBrKLo5WH3Jbv0=;
        h=Subject:To:From:Date:From;
        b=xankSbbFW9IVfB3lgdn9G+Zp0m1J1DwzQ5jrOo9PTLbCOkZ3xDZ+8MK/hJWSsd44X
         Ji9svtkJaTCdWPwawD1nvc1Dl7GdnnoCjoGKGRzZ+bCP6MhVHd3d9yFvF/m6dWNO88
         iHoIx806aTSGDFaHw+G+45ZoXFxsRnMPoIZSClD8=
Subject: patch "serial: tegra-tcu: Use uart_xmit_advance(), fixes icount.tx" added to tty-linus
To:     ilpo.jarvinen@linux.intel.com, andy.shevchenko@gmail.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 07 Sep 2022 16:40:51 +0200
Message-ID: <16625616514126@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: tegra-tcu: Use uart_xmit_advance(), fixes icount.tx

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 1d10cd4da593bc0196a239dcc54dac24b6b0a74e Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Thu, 1 Sep 2022 17:39:34 +0300
Subject: serial: tegra-tcu: Use uart_xmit_advance(), fixes icount.tx
 accounting
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Tx'ing does not correctly account Tx'ed characters into icount.tx.
Using uart_xmit_advance() fixes the problem.

Fixes: 2d908b38d409 ("serial: Add Tegra Combined UART driver")
Cc: <stable@vger.kernel.org> # serial: Create uart_xmit_advance()
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20220901143934.8850-4-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/tegra-tcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/tegra-tcu.c b/drivers/tty/serial/tegra-tcu.c
index 4877c54c613d..889b701ba7c6 100644
--- a/drivers/tty/serial/tegra-tcu.c
+++ b/drivers/tty/serial/tegra-tcu.c
@@ -101,7 +101,7 @@ static void tegra_tcu_uart_start_tx(struct uart_port *port)
 			break;
 
 		tegra_tcu_write(tcu, &xmit->buf[xmit->tail], count);
-		xmit->tail = (xmit->tail + count) & (UART_XMIT_SIZE - 1);
+		uart_xmit_advance(port, count);
 	}
 
 	uart_write_wakeup(port);
-- 
2.37.3


