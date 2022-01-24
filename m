Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 936B149A3A6
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2368695AbiAXX7u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:59:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1846419AbiAXXPz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:15:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AAEEC0604D0;
        Mon, 24 Jan 2022 13:24:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD3DA61320;
        Mon, 24 Jan 2022 21:24:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FB5C340E4;
        Mon, 24 Jan 2022 21:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059453;
        bh=cdFXuFaCObFyYMFaICM/VLalkvjImrTRIgfaj6Fp60w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HhtcIFzBKrctYhB0946H0Efteh9tYp+NuxJYzBDVZP0FaB2DnzLf475y27Mnt5PDz
         +YXcN5Jvbdb0h2IKHCfc6ii0WRj2LgHdPLKXYx/J6X62gnG1e9UWZSUOhqWdxt4M6N
         2eu/d/RjsI2Q41EJp7jSWePmrPxL31D1fT51khhU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0588/1039] mxser: keep only !tty test in ISR
Date:   Mon, 24 Jan 2022 19:39:37 +0100
Message-Id: <20220124184145.101983897@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
index 93a95a135a71a..27caa2f9ba79b 100644
--- a/drivers/tty/mxser.c
+++ b/drivers/tty/mxser.c
@@ -262,7 +262,6 @@ struct mxser_port {
 	unsigned int xmit_head;
 	unsigned int xmit_tail;
 	unsigned int xmit_cnt;
-	int closing;
 
 	spinlock_t slock;
 };
@@ -918,7 +917,6 @@ static void mxser_close(struct tty_struct *tty, struct file *filp)
 		return;
 	if (tty_port_close_start(port, tty, filp) == 0)
 		return;
-	info->closing = 1;
 	mutex_lock(&port->mutex);
 	mxser_close_port(port);
 	mxser_flush_buffer(tty);
@@ -927,7 +925,6 @@ static void mxser_close(struct tty_struct *tty, struct file *filp)
 	mxser_shutdown_port(port);
 	tty_port_set_initialized(port, 0);
 	mutex_unlock(&port->mutex);
-	info->closing = 0;
 	/* Right now the tty_port set is done outside of the close_end helper
 	   as we don't yet have everyone using refcounts */	
 	tty_port_close_end(port, tty);
@@ -1683,7 +1680,7 @@ static bool mxser_port_isr(struct mxser_port *port)
 
 	iir &= MOXA_MUST_IIR_MASK;
 	tty = tty_port_tty_get(&port->port);
-	if (!tty || port->closing || !tty_port_initialized(&port->port)) {
+	if (!tty) {
 		status = inb(port->ioaddr + UART_LSR);
 		outb(port->FCR | UART_FCR_CLEAR_RCVR | UART_FCR_CLEAR_XMIT,
 				port->ioaddr + UART_FCR);
-- 
2.34.1



