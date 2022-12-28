Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAAB5657C08
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233227AbiL1P20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:28:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233766AbiL1P2D (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:28:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C079414D0A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:28:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79082B81647
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:28:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DABF9C433D2;
        Wed, 28 Dec 2022 15:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241280;
        bh=x++abdEdA5YeJWNT91x244a/UXG9Z0k1DSxTOQ2bMOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AYYUMIow0eKVSrpFwYDsJJqOiW3uAjKPnotQ3dpj6N5WrFVvk4hnNlvXxXabnd0i5
         CnKnklWRLUdT1NhPciXt/RTphGjVcaohb0F7q5S32tRG14ccXK8X1PpMRlf/le7FcI
         NBKtXcVaSRF+sK17PKTM4y8/lk7aDXNmwT73/udg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tobias Klauser <tklauser@distanz.ch>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 461/731] tty: serial: clean up stop-tx part in altera_uart_tx_chars()
Date:   Wed, 28 Dec 2022 15:39:28 +0100
Message-Id: <20221228144309.914341250@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Jiri Slaby <jslaby@suse.cz>

[ Upstream commit d9c128117da41cf4cb0e80ae565b5d3ac79dffac ]

The "stop TX" path in altera_uart_tx_chars() is open-coded, so:
* use uart_circ_empty() to check if the buffer is empty, and
* when true, call altera_uart_stop_tx().

Cc: Tobias Klauser <tklauser@distanz.ch>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Acked-by: Tobias Klauser <tklauser@distanz.ch>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Link: https://lore.kernel.org/r/20220920052049.20507-3-jslaby@suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 1307c5d33cce ("serial: altera_uart: fix locking in polling mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/altera_uart.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/altera_uart.c b/drivers/tty/serial/altera_uart.c
index 7c5f4e966b59..0e194556d76e 100644
--- a/drivers/tty/serial/altera_uart.c
+++ b/drivers/tty/serial/altera_uart.c
@@ -272,10 +272,8 @@ static void altera_uart_tx_chars(struct altera_uart *pp)
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
 		uart_write_wakeup(port);
 
-	if (xmit->head == xmit->tail) {
-		pp->imr &= ~ALTERA_UART_CONTROL_TRDY_MSK;
-		altera_uart_update_ctrl_reg(pp);
-	}
+	if (uart_circ_empty(xmit))
+		altera_uart_stop_tx(port);
 }
 
 static irqreturn_t altera_uart_interrupt(int irq, void *data)
-- 
2.35.1



