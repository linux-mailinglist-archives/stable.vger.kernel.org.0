Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 758286C18E2
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232855AbjCTP23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232469AbjCTP2A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:28:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 634043754D
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:21:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43CF6615AF
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:21:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 524EDC433D2;
        Mon, 20 Mar 2023 15:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325668;
        bh=AdwM2ak8m/ZCPpd2z6sk/k1U5ngJRPUOOwaUY7yIXg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yGBlnuvrlE0oG4J84xG402B4F1zvmCcEL4Ld8jD9W3AyOqe8bPQIHqlt3g8QXJHuj
         WXF4+xyRvOC2vl5cYXEyElJnDrT+sNCdnz5bQvVA01D7GGnwV8SYXenJlnJTm+RWsT
         3iCWxz9DGUcEcYAdupFey2SbtHp4Le19Yt2dfnD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <error27@gmail.com>,
        Johan Hovold <johan@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 6.1 120/198] serial: 8250_fsl: fix handle_irq locking
Date:   Mon, 20 Mar 2023 15:54:18 +0100
Message-Id: <20230320145512.588463830@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 6e01f9a594ee0f69fb52cc8d11971612b4817f0b upstream.

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
Acked-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20230227085046.24282-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_fsl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/8250/8250_fsl.c
+++ b/drivers/tty/serial/8250/8250_fsl.c
@@ -34,7 +34,7 @@ int fsl8250_handle_irq(struct uart_port
 
 	iir = port->serial_in(port, UART_IIR);
 	if (iir & UART_IIR_NO_INT) {
-		spin_unlock(&up->port.lock);
+		spin_unlock_irqrestore(&up->port.lock, flags);
 		return 0;
 	}
 
@@ -42,7 +42,7 @@ int fsl8250_handle_irq(struct uart_port
 	if (unlikely(up->lsr_saved_flags & UART_LSR_BI)) {
 		up->lsr_saved_flags &= ~UART_LSR_BI;
 		port->serial_in(port, UART_RX);
-		spin_unlock(&up->port.lock);
+		spin_unlock_irqrestore(&up->port.lock, flags);
 		return 1;
 	}
 


