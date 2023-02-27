Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0C496A3DF2
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 10:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbjB0JMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 04:12:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjB0JLw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 04:11:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D28641B576;
        Mon, 27 Feb 2023 01:03:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D770B80CAA;
        Mon, 27 Feb 2023 08:50:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA651C433D2;
        Mon, 27 Feb 2023 08:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677487845;
        bh=3sKuQJ5jig7mnQt+fJxNgFMbX5S1a3CrBBSTM63p7dw=;
        h=From:To:Cc:Subject:Date:From;
        b=nNH7A1K/eOE7QhHgTp7p1G4/MwW1haMZHD/4HxNMgfi+TqeO9gXqqjWf2vXTwtS6u
         PX7Tp6sIsC7hrc7L/LdRABgNDbs3tJfijVNN8DPbBEEqmRz7kQXztFGvjrtDPzTota
         e3+s2fEuSXConMg9b6bI4Iy/6wMq5bayM6HZoohUjybpW1e14zGXzKfT0gcr+HK0wV
         VzYuyMFWQ/H9MmT0fwmi2DSRAMLYDIRrhCv3Zo0Gx0R9vp9+j7MvFKlXcVVG2qVsVk
         kCGzOwR3WE/liGXFdlCL2yg2XHwyIn7mkr85/uExU4JN16lGB9z/TmAqRjFV56xd0G
         Fpf3o1f7GYIKw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1pWZDs-0006Jp-Ra; Mon, 27 Feb 2023 09:51:05 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jiri Slaby <jirislaby@kernel.org>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable@vger.kernel.org, Dan Carpenter <error27@gmail.com>
Subject: [PATCH] serial: 8250_fsl: fix handle_irq locking
Date:   Mon, 27 Feb 2023 09:50:46 +0100
Message-Id: <20230227085046.24282-1-johan@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The 8250 handle_irq callback is not just called from the interrupt
handler but also from a timer callback when polling (e.g. for ports
without an interrupt line). Consequently the callback must explicitly
disable interrupts to avoid a potential deadlock with another interrupt
in polled mode.

Fix up the two paths in the freescale callback that failed to re-enable
interrupts when polling.

Fixes: 853a9ae29e97 ("serial: 8250: fix handle_irq locking")
Cc: stable@vger.kernel.org	# 5.13
Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://lore.kernel.org/r/Y/xYzqp4ogmOF5t0@kili
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/tty/serial/8250/8250_fsl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_fsl.c b/drivers/tty/serial/8250/8250_fsl.c
index 8aad15622a2e..8adfaa183f77 100644
--- a/drivers/tty/serial/8250/8250_fsl.c
+++ b/drivers/tty/serial/8250/8250_fsl.c
@@ -34,7 +34,7 @@ int fsl8250_handle_irq(struct uart_port *port)
 
 	iir = port->serial_in(port, UART_IIR);
 	if (iir & UART_IIR_NO_INT) {
-		spin_unlock(&up->port.lock);
+		spin_unlock_irqrestore(&up->port.lock, flags);
 		return 0;
 	}
 
@@ -42,7 +42,7 @@ int fsl8250_handle_irq(struct uart_port *port)
 	if (unlikely(up->lsr_saved_flags & UART_LSR_BI)) {
 		up->lsr_saved_flags &= ~UART_LSR_BI;
 		port->serial_in(port, UART_RX);
-		spin_unlock(&up->port.lock);
+		spin_unlock_irqrestore(&up->port.lock, flags);
 		return 1;
 	}
 
-- 
2.39.2

