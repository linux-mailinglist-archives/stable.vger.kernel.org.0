Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C33E51A902
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356507AbiEDRNu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356394AbiEDRJN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AAEE49F33;
        Wed,  4 May 2022 09:55:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9EE83B82792;
        Wed,  4 May 2022 16:55:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AABFC385A4;
        Wed,  4 May 2022 16:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683305;
        bh=tu6l9fKoJQRRQfGhMHhs099JASbvUAe14tz+M+Fikp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Px2DojIiu0X1elwCKkxpjkYIDCB/5aNYatAek/ubhSSwH7MNLQ5tJeUtlkNnM6HfS
         apqlxMGDH9d7wnyJ7Iopk0exGgYswWgs77aUQ5NlKh7pVbWReFPloKoAaOm2eN1o2n
         k+3Ah9aHNmOrc8rHScKE/G8VisvWirUdRm3JHEq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>
Subject: [PATCH 5.15 170/177] tty: n_gsm: fix reset fifo race condition
Date:   Wed,  4 May 2022 18:46:03 +0200
Message-Id: <20220504153108.816450783@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Daniel Starke <daniel.starke@siemens.com>

commit 73029a4d7161f8b6c0934553145ef574d2d0c645 upstream.

gsmtty_write() and gsm_dlci_data_output() properly guard the fifo access.
However, gsm_dlci_close() and gsmtty_flush_buffer() modifies the fifo but
do not guard this.
Add a guard here to prevent race conditions on parallel writes to the fifo.

Fixes: e1eaea46bb40 ("tty: n_gsm line discipline")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220414094225.4527-17-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_gsm.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1417,13 +1417,17 @@ static int gsm_control_wait(struct gsm_m
 
 static void gsm_dlci_close(struct gsm_dlci *dlci)
 {
+	unsigned long flags;
+
 	del_timer(&dlci->t1);
 	if (debug & 8)
 		pr_debug("DLCI %d goes closed.\n", dlci->addr);
 	dlci->state = DLCI_CLOSED;
 	if (dlci->addr != 0) {
 		tty_port_tty_hangup(&dlci->port, false);
+		spin_lock_irqsave(&dlci->lock, flags);
 		kfifo_reset(&dlci->fifo);
+		spin_unlock_irqrestore(&dlci->lock, flags);
 		/* Ensure that gsmtty_open() can return. */
 		tty_port_set_initialized(&dlci->port, 0);
 		wake_up_interruptible(&dlci->port.open_wait);
@@ -3078,13 +3082,17 @@ static unsigned int gsmtty_chars_in_buff
 static void gsmtty_flush_buffer(struct tty_struct *tty)
 {
 	struct gsm_dlci *dlci = tty->driver_data;
+	unsigned long flags;
+
 	if (dlci->state == DLCI_CLOSED)
 		return;
 	/* Caution needed: If we implement reliable transport classes
 	   then the data being transmitted can't simply be junked once
 	   it has first hit the stack. Until then we can just blow it
 	   away */
+	spin_lock_irqsave(&dlci->lock, flags);
 	kfifo_reset(&dlci->fifo);
+	spin_unlock_irqrestore(&dlci->lock, flags);
 	/* Need to unhook this DLCI from the transmit queue logic */
 }
 


