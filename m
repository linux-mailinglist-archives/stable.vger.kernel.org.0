Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19816517A85
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 01:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbiEBXPX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 19:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbiEBXPW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 19:15:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C225D2F01C
        for <stable@vger.kernel.org>; Mon,  2 May 2022 16:11:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 690D3B81A97
        for <stable@vger.kernel.org>; Mon,  2 May 2022 23:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06AE2C385AE;
        Mon,  2 May 2022 23:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651533105;
        bh=IoO8wHnQwKDb6pfpsJA7Hw7aOOYkARA1Euf3qEYZa7A=;
        h=Subject:To:Cc:From:Date:From;
        b=elXvrRclfucZOGt7Ghp3mi3rABl2bB4Tbow3Wvpc3in4n1bjc/gC0QAgUFvYRpiym
         SyW1PHfLC944hRwWGhKde4NJRprcxaoG5O74wUb4gUcmi83b8X8cG0k5zU/bGovj5Z
         GUhPPUWg3kH6QUnbFnbOJl/sAagke69U2z4msxAI=
Subject: FAILED: patch "[PATCH] tty: n_gsm: fix decoupled mux resource" failed to apply to 4.19-stable tree
To:     daniel.starke@siemens.com, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 May 2022 01:11:43 +0200
Message-ID: <165153310325211@kroah.com>
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


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1ec92e9742774bf42614fceea3bf6b50c9409225 Mon Sep 17 00:00:00 2001
From: Daniel Starke <daniel.starke@siemens.com>
Date: Thu, 14 Apr 2022 02:42:08 -0700
Subject: [PATCH] tty: n_gsm: fix decoupled mux resource

The active mux instances are managed in the gsm_mux array and via mux_get()
and mux_put() functions separately. This gives a very loose coupling
between the actual instance and the gsm_mux array which manages it. It also
results in unnecessary lockings which makes it prone to failures. And it
creates a race condition if more than the maximum number of mux instances
are requested while the user changes the parameters of an active instance.
The user may loose ownership of the current mux instance in this case.
Fix this by moving the gsm_mux array handling to the mux allocation and
deallocation functions.

Fixes: e1eaea46bb40 ("tty: n_gsm line discipline")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220414094225.4527-3-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index daaffcfadaae..f546dfe03d29 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2136,18 +2136,6 @@ static void gsm_cleanup_mux(struct gsm_mux *gsm, bool disc)
 	/* Finish outstanding timers, making sure they are done */
 	del_timer_sync(&gsm->t2_timer);
 
-	spin_lock(&gsm_mux_lock);
-	for (i = 0; i < MAX_MUX; i++) {
-		if (gsm_mux[i] == gsm) {
-			gsm_mux[i] = NULL;
-			break;
-		}
-	}
-	spin_unlock(&gsm_mux_lock);
-	/* open failed before registering => nothing to do */
-	if (i == MAX_MUX)
-		return;
-
 	/* Free up any link layer users */
 	for (i = 0; i < NUM_DLCI; i++)
 		if (gsm->dlci[i])
@@ -2171,7 +2159,6 @@ static void gsm_cleanup_mux(struct gsm_mux *gsm, bool disc)
 static int gsm_activate_mux(struct gsm_mux *gsm)
 {
 	struct gsm_dlci *dlci;
-	int i = 0;
 
 	timer_setup(&gsm->t2_timer, gsm_control_retransmit, 0);
 	init_waitqueue_head(&gsm->event);
@@ -2183,18 +2170,6 @@ static int gsm_activate_mux(struct gsm_mux *gsm)
 	else
 		gsm->receive = gsm1_receive;
 
-	spin_lock(&gsm_mux_lock);
-	for (i = 0; i < MAX_MUX; i++) {
-		if (gsm_mux[i] == NULL) {
-			gsm->num = i;
-			gsm_mux[i] = gsm;
-			break;
-		}
-	}
-	spin_unlock(&gsm_mux_lock);
-	if (i == MAX_MUX)
-		return -EBUSY;
-
 	dlci = gsm_dlci_alloc(gsm, 0);
 	if (dlci == NULL)
 		return -ENOMEM;
@@ -2210,6 +2185,15 @@ static int gsm_activate_mux(struct gsm_mux *gsm)
  */
 static void gsm_free_mux(struct gsm_mux *gsm)
 {
+	int i;
+
+	for (i = 0; i < MAX_MUX; i++) {
+		if (gsm == gsm_mux[i]) {
+			gsm_mux[i] = NULL;
+			break;
+		}
+	}
+	mutex_destroy(&gsm->mutex);
 	kfree(gsm->txframe);
 	kfree(gsm->buf);
 	kfree(gsm);
@@ -2229,12 +2213,20 @@ static void gsm_free_muxr(struct kref *ref)
 
 static inline void mux_get(struct gsm_mux *gsm)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&gsm_mux_lock, flags);
 	kref_get(&gsm->ref);
+	spin_unlock_irqrestore(&gsm_mux_lock, flags);
 }
 
 static inline void mux_put(struct gsm_mux *gsm)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&gsm_mux_lock, flags);
 	kref_put(&gsm->ref, gsm_free_muxr);
+	spin_unlock_irqrestore(&gsm_mux_lock, flags);
 }
 
 static inline unsigned int mux_num_to_base(struct gsm_mux *gsm)
@@ -2255,6 +2247,7 @@ static inline unsigned int mux_line_to_num(unsigned int line)
 
 static struct gsm_mux *gsm_alloc_mux(void)
 {
+	int i;
 	struct gsm_mux *gsm = kzalloc(sizeof(struct gsm_mux), GFP_KERNEL);
 	if (gsm == NULL)
 		return NULL;
@@ -2284,6 +2277,26 @@ static struct gsm_mux *gsm_alloc_mux(void)
 	gsm->mtu = 64;
 	gsm->dead = true;	/* Avoid early tty opens */
 
+	/* Store the instance to the mux array or abort if no space is
+	 * available.
+	 */
+	spin_lock(&gsm_mux_lock);
+	for (i = 0; i < MAX_MUX; i++) {
+		if (!gsm_mux[i]) {
+			gsm_mux[i] = gsm;
+			gsm->num = i;
+			break;
+		}
+	}
+	spin_unlock(&gsm_mux_lock);
+	if (i == MAX_MUX) {
+		mutex_destroy(&gsm->mutex);
+		kfree(gsm->txframe);
+		kfree(gsm->buf);
+		kfree(gsm);
+		return NULL;
+	}
+
 	return gsm;
 }
 

