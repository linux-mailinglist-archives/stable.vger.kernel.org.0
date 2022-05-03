Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02F1E5185AA
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 15:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235703AbiECNla (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 09:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236269AbiECNla (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 09:41:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E429B2AC72
        for <stable@vger.kernel.org>; Tue,  3 May 2022 06:37:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A24B6B81ECB
        for <stable@vger.kernel.org>; Tue,  3 May 2022 13:37:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C94C385AE;
        Tue,  3 May 2022 13:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651585075;
        bh=iLaSFAcTOcF5W7mbpEdyDDP/7PGTzsMozvQw6SPu2VQ=;
        h=Subject:To:Cc:From:Date:From;
        b=mFWEBDTrghARsRprPvrpdQPPLBoHr+JH5NnrizCg1II1XbQVBf8moce5wjjao+baM
         9DmRhk49nO1rUH5VeLUaDgSZGCz/8diZ5JF406NbGfjf3q/k8e+7OAiD4QL6yh+ivc
         xJhkWQ+8lIoQ6prizl6htoWnYSBR98B96rEePb58=
Subject: FAILED: patch "[PATCH] tty: n_gsm: fix reset fifo race condition" failed to apply to 4.9-stable tree
To:     daniel.starke@siemens.com, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 May 2022 15:37:52 +0200
Message-ID: <1651585072154162@kroah.com>
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 73029a4d7161f8b6c0934553145ef574d2d0c645 Mon Sep 17 00:00:00 2001
From: Daniel Starke <daniel.starke@siemens.com>
Date: Thu, 14 Apr 2022 02:42:22 -0700
Subject: [PATCH] tty: n_gsm: fix reset fifo race condition

gsmtty_write() and gsm_dlci_data_output() properly guard the fifo access.
However, gsm_dlci_close() and gsmtty_flush_buffer() modifies the fifo but
do not guard this.
Add a guard here to prevent race conditions on parallel writes to the fifo.

Fixes: e1eaea46bb40 ("tty: n_gsm line discipline")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220414094225.4527-17-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index f3fb66be8513..15be4a235783 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1442,13 +1442,17 @@ static int gsm_control_wait(struct gsm_mux *gsm, struct gsm_control *control)
 
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
@@ -3148,13 +3152,17 @@ static unsigned int gsmtty_chars_in_buffer(struct tty_struct *tty)
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
 

