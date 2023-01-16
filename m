Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDF266C7DE
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233456AbjAPQfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:35:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233331AbjAPQef (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:34:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE86329E24
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:22:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68B9F6104F
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:22:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C3FEC433F0;
        Mon, 16 Jan 2023 16:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886140;
        bh=oirjHvUm/24DGQLv4pPofWFz6LgNO1j6+Bh8e6KtH1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bZt/dzXapxVP/zuKqHNWjH7/MVDtCQyZXwuBEH0nOdlqNYrAGmU6P2Nkql4+dhkab
         wle9U4MeeHCbvfa1XW/LFUppqkfTRtrnwV8SgVBYFwIFYhC456t4yCwbbKQeec8ksv
         v1fYg17krDKosIkWiq4FJlO037u9IgTLBQ3ZN4Kk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tobias Klauser <tklauser@distanz.ch>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 288/658] tty: serial: clean up stop-tx part in altera_uart_tx_chars()
Date:   Mon, 16 Jan 2023 16:46:16 +0100
Message-Id: <20230116154922.767465666@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index 0e487ce091ac..508a3c2b7781 100644
--- a/drivers/tty/serial/altera_uart.c
+++ b/drivers/tty/serial/altera_uart.c
@@ -274,10 +274,8 @@ static void altera_uart_tx_chars(struct altera_uart *pp)
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



