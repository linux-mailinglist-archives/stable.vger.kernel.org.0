Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA949517A82
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 01:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233550AbiEBXOd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 19:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232463AbiEBXOY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 19:14:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A732F01C
        for <stable@vger.kernel.org>; Mon,  2 May 2022 16:10:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 477FBCE1B4C
        for <stable@vger.kernel.org>; Mon,  2 May 2022 23:10:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F88DC385A4;
        Mon,  2 May 2022 23:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651533050;
        bh=be3yBN0o3Qv+O9nv0OYXxWjyLkIoAM0CmiD4H9QNSWQ=;
        h=Subject:To:Cc:From:Date:From;
        b=hUtGaltbqvb4UpefLKqkh6fYaW/If8GbwJjoj8XG7FvF41eGQZi+00+Xv7StQP0mj
         yz1rcZmbijRWY0mtW62pOMqrtaJtABRrhjIdIpIB2RnMeWKq5BucTUPBfV+GETTa+V
         fDOzyL16UY82rle3ar/JlG0K5h6np/Biui8UbwN8=
Subject: FAILED: patch "[PATCH] tty: n_gsm: fix restart handling via CLD command" failed to apply to 5.4-stable tree
To:     daniel.starke@siemens.com, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 May 2022 01:10:49 +0200
Message-ID: <1651533049225200@kroah.com>
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From aa371e96f05dcb36a88298f5cb70aa7234d5e8b8 Mon Sep 17 00:00:00 2001
From: Daniel Starke <daniel.starke@siemens.com>
Date: Thu, 14 Apr 2022 02:42:07 -0700
Subject: [PATCH] tty: n_gsm: fix restart handling via CLD command

n_gsm is based on the 3GPP 07.010 and its newer version is the 3GPP 27.010.
See https://portal.3gpp.org/desktopmodules/Specifications/SpecificationDetails.aspx?specificationId=1516
The changes from 07.010 to 27.010 are non-functional. Therefore, I refer to
the newer 27.010 here. Chapter 5.8.2 states that both sides will revert to
the non-multiplexed mode via a close-down message (CLD). The usual program
flow is as following:
- start multiplex mode by sending AT+CMUX to the mobile
- establish the control channel (DLCI 0)
- establish user channels (DLCI >0)
- terminate user channels
- send close-down message (CLD)
- revert to AT protocol (i.e. leave multiplexed mode)

The AT protocol is out of scope of the n_gsm driver. However,
gsm_disconnect() sends CLD if gsm_config() detects that the requested
parameters require the mux protocol to restart. The next immediate action
is to start the mux protocol by opening DLCI 0 again. Any responder side
which handles CLD commands correctly forces us to fail at this point
because AT+CMUX needs to be sent to the mobile to start the mux again.
Therefore, remove the CLD command in this phase and keep both sides in
multiplexed mode.
Remove the gsm_disconnect() function as it become unnecessary and merge the
remaining parts into gsm_cleanup_mux() to handle the termination order and
locking correctly.

Fixes: 71e077915396 ("tty: n_gsm: do not send/receive in ldisc close path")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220414094225.4527-2-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 3d28ecebd473..daaffcfadaae 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2106,49 +2106,35 @@ static void gsm_error(struct gsm_mux *gsm)
 	gsm->io_error++;
 }
 
-static int gsm_disconnect(struct gsm_mux *gsm)
-{
-	struct gsm_dlci *dlci = gsm->dlci[0];
-	struct gsm_control *gc;
-
-	if (!dlci)
-		return 0;
-
-	/* In theory disconnecting DLCI 0 is sufficient but for some
-	   modems this is apparently not the case. */
-	gc = gsm_control_send(gsm, CMD_CLD, NULL, 0);
-	if (gc)
-		gsm_control_wait(gsm, gc);
-
-	del_timer_sync(&gsm->t2_timer);
-	/* Now we are sure T2 has stopped */
-
-	gsm_dlci_begin_close(dlci);
-	wait_event_interruptible(gsm->event,
-				dlci->state == DLCI_CLOSED);
-
-	if (signal_pending(current))
-		return -EINTR;
-
-	return 0;
-}
-
 /**
  *	gsm_cleanup_mux		-	generic GSM protocol cleanup
  *	@gsm: our mux
+ *	@disc: disconnect link?
  *
  *	Clean up the bits of the mux which are the same for all framing
  *	protocols. Remove the mux from the mux table, stop all the timers
  *	and then shut down each device hanging up the channels as we go.
  */
 
-static void gsm_cleanup_mux(struct gsm_mux *gsm)
+static void gsm_cleanup_mux(struct gsm_mux *gsm, bool disc)
 {
 	int i;
 	struct gsm_dlci *dlci = gsm->dlci[0];
 	struct gsm_msg *txq, *ntxq;
 
 	gsm->dead = true;
+	mutex_lock(&gsm->mutex);
+
+	if (dlci) {
+		if (disc && dlci->state != DLCI_CLOSED) {
+			gsm_dlci_begin_close(dlci);
+			wait_event(gsm->event, dlci->state == DLCI_CLOSED);
+		}
+		dlci->dead = true;
+	}
+
+	/* Finish outstanding timers, making sure they are done */
+	del_timer_sync(&gsm->t2_timer);
 
 	spin_lock(&gsm_mux_lock);
 	for (i = 0; i < MAX_MUX; i++) {
@@ -2162,13 +2148,7 @@ static void gsm_cleanup_mux(struct gsm_mux *gsm)
 	if (i == MAX_MUX)
 		return;
 
-	del_timer_sync(&gsm->t2_timer);
-	/* Now we are sure T2 has stopped */
-	if (dlci)
-		dlci->dead = true;
-
 	/* Free up any link layer users */
-	mutex_lock(&gsm->mutex);
 	for (i = 0; i < NUM_DLCI; i++)
 		if (gsm->dlci[i])
 			gsm_dlci_release(gsm->dlci[i]);
@@ -2370,19 +2350,11 @@ static int gsm_config(struct gsm_mux *gsm, struct gsm_config *c)
 
 	/*
 	 * Close down what is needed, restart and initiate the new
-	 * configuration
+	 * configuration. On the first time there is no DLCI[0]
+	 * and closing or cleaning up is not necessary.
 	 */
-
-	if (need_close || need_restart) {
-		int ret;
-
-		ret = gsm_disconnect(gsm);
-
-		if (ret)
-			return ret;
-	}
-	if (need_restart)
-		gsm_cleanup_mux(gsm);
+	if (need_close || need_restart)
+		gsm_cleanup_mux(gsm, true);
 
 	gsm->initiator = c->initiator;
 	gsm->mru = c->mru;
@@ -2494,7 +2466,7 @@ static void gsmld_detach_gsm(struct tty_struct *tty, struct gsm_mux *gsm)
 		for (i = 1; i < NUM_DLCI; i++)
 			tty_unregister_device(gsm_tty_driver, base + i);
 	}
-	gsm_cleanup_mux(gsm);
+	gsm_cleanup_mux(gsm, false);
 	tty_kref_put(gsm->tty);
 	gsm->tty = NULL;
 }
@@ -2597,7 +2569,7 @@ static int gsmld_open(struct tty_struct *tty)
 
 	ret = gsmld_attach_gsm(tty, gsm);
 	if (ret != 0) {
-		gsm_cleanup_mux(gsm);
+		gsm_cleanup_mux(gsm, false);
 		mux_put(gsm);
 	}
 	return ret;

