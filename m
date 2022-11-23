Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A11C36355A6
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237448AbiKWJWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:22:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237469AbiKWJVT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:21:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7590510AD1F
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:21:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2986AB81EF5
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:21:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CEB9C433C1;
        Wed, 23 Nov 2022 09:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195272;
        bh=L+qlthEoiwBqpgSREsk3W+lXkr265keGeaI0PJMrYzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P9NNAhGvpkoTkEtll2TO4D8ipg8R2hagsIrfXzJLpSt0Zp5MshsaDAnO9YHq4rdS6
         z61M8g81D2mxMFHjBvj5P5IAJDwpYxJVB1mhKsZK4rKwEE6zrw9s2uddwod2cLrPM9
         l+SsZsidthnRyN9W8IM9D8ukFFH5PSDYUKcJkNoA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 038/149] serial: 8250_omap: remove wait loop from Errata i202 workaround
Date:   Wed, 23 Nov 2022 09:50:21 +0100
Message-Id: <20221123084559.355653104@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

[ Upstream commit e828e56684d61b17317e0cfdef83791fa61cb76b ]

We were occasionally seeing the "Errata i202: timedout" on an AM335x
board when repeatedly opening and closing a UART connected to an active
sender. As new input may arrive at any time, it is possible to miss the
"RX FIFO empty" condition, forcing the loop to wait until it times out.

Nothing in the i202 Advisory states that such a wait is even necessary;
other FIFO clear functions like serial8250_clear_fifos() do not wait
either. For this reason, it seems safe to remove the wait, fixing the
mentioned issue.

Fixes: 61929cf0169d ("tty: serial: Add 8250-core based omap driver")
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Link: https://lore.kernel.org/r/20221013112339.2540767-1-matthias.schiffer@ew.tq-group.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_omap.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index 7c7cfd6d48d8..655553a3c78a 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -211,27 +211,10 @@ static void omap8250_set_mctrl(struct uart_port *port, unsigned int mctrl)
 static void omap_8250_mdr1_errataset(struct uart_8250_port *up,
 				     struct omap8250_priv *priv)
 {
-	u8 timeout = 255;
-
 	serial_out(up, UART_OMAP_MDR1, priv->mdr1);
 	udelay(2);
 	serial_out(up, UART_FCR, up->fcr | UART_FCR_CLEAR_XMIT |
 			UART_FCR_CLEAR_RCVR);
-	/*
-	 * Wait for FIFO to empty: when empty, RX_FIFO_E bit is 0 and
-	 * TX_FIFO_E bit is 1.
-	 */
-	while (UART_LSR_THRE != (serial_in(up, UART_LSR) &
-				(UART_LSR_THRE | UART_LSR_DR))) {
-		timeout--;
-		if (!timeout) {
-			/* Should *never* happen. we warn and carry on */
-			dev_crit(up->port.dev, "Errata i202: timedout %x\n",
-				 serial_in(up, UART_LSR));
-			break;
-		}
-		udelay(1);
-	}
 }
 
 static void omap_8250_get_divisor(struct uart_port *port, unsigned int baud,
-- 
2.35.1



