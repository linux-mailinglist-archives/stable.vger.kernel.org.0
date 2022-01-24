Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E18649A3A5
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365571AbiAXXvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:51:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449430AbiAXVyz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:54:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 225E8C08B4FE;
        Mon, 24 Jan 2022 12:34:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6B0D614FF;
        Mon, 24 Jan 2022 20:34:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E2AC340E5;
        Mon, 24 Jan 2022 20:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056489;
        bh=kvtpMf09zNVnWWbXCIVl9s/7VjcLSSErZYuDPGmkE3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ENRsXtafjEu++/ViKDqoO+I/NV2dNjYINFeQ7pl7v4CX1LpMTOLJmvMo72mRWDOyW
         U0uT3Cn4EaZc4jEcMisrsKFtDM+U7pt31AIdN4915MyPhyH7YRTvY9rFgqYJWmRZTE
         pHsa9epCaYOwaUR0Kau8t+WsfjAPsSCn/FTjBjvA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 500/846] mxser: keep only !tty test in ISR
Date:   Mon, 24 Jan 2022 19:40:17 +0100
Message-Id: <20220124184118.277897472@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

[ Upstream commit 274ab58dc2b460cc474ffc7ccfcede4b2be1a3f5 ]

The others are superfluous with tty refcounting in place now. And they
are racy in fact:
* tty_port_initialized() reports false for a small moment after
  interrupts are enabled.
* closing is 1 while the port is still alive.

The queues are flushed later during close anyway. So there is no need
for this special handling. Actually, the ISR should not flush the
queues. It should behave as every other driver, just queue the chars
into tty buffer and go on. But this will be changed later. There is
still a lot code depending on having tty in ISR (and not only tty_port).

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Link: https://lore.kernel.org/r/20211118073125.12283-4-jslaby@suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/mxser.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/tty/mxser.c b/drivers/tty/mxser.c
index 1216f3985e18e..da375851af4e6 100644
--- a/drivers/tty/mxser.c
+++ b/drivers/tty/mxser.c
@@ -261,7 +261,6 @@ struct mxser_port {
 	unsigned int xmit_head;
 	unsigned int xmit_tail;
 	unsigned int xmit_cnt;
-	int closing;
 
 	spinlock_t slock;
 };
@@ -923,7 +922,6 @@ static void mxser_close(struct tty_struct *tty, struct file *filp)
 		return;
 	if (tty_port_close_start(port, tty, filp) == 0)
 		return;
-	info->closing = 1;
 	mutex_lock(&port->mutex);
 	mxser_close_port(port);
 	mxser_flush_buffer(tty);
@@ -932,7 +930,6 @@ static void mxser_close(struct tty_struct *tty, struct file *filp)
 	mxser_shutdown_port(port);
 	tty_port_set_initialized(port, 0);
 	mutex_unlock(&port->mutex);
-	info->closing = 0;
 	/* Right now the tty_port set is done outside of the close_end helper
 	   as we don't yet have everyone using refcounts */	
 	tty_port_close_end(port, tty);
@@ -1693,7 +1690,7 @@ static bool mxser_port_isr(struct mxser_port *port)
 
 	iir &= MOXA_MUST_IIR_MASK;
 	tty = tty_port_tty_get(&port->port);
-	if (!tty || port->closing || !tty_port_initialized(&port->port)) {
+	if (!tty) {
 		status = inb(port->ioaddr + UART_LSR);
 		outb(MOXA_MUST_FCR_GDA_MODE_ENABLE | UART_FCR_ENABLE_FIFO |
 				UART_FCR_CLEAR_RCVR | UART_FCR_CLEAR_XMIT,
-- 
2.34.1



