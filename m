Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7C251A761
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354277AbiEDRDU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354328AbiEDRA3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:00:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C96D04C795;
        Wed,  4 May 2022 09:52:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55B7B617A6;
        Wed,  4 May 2022 16:52:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC66C385AA;
        Wed,  4 May 2022 16:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683133;
        bh=7/Vx+R0dJUPhokOvKQ8yLZNNSGISyIWK0qTfgSU1yeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S2lt7zMHR6ppWmaPVkeAWkL9b9n9UsgbUdmMHtpGsZficMs9ob5zsdYTXFJF31+Sf
         17+qo2p3q2OJc4/SDmyfhIwpwUSN9ttqQ2oTdKn1MDuZgQqoKcp/fCXBzfv/jTrfyw
         TXv7K1BgZjdy3BUY+1NP6OJt4rltpWD3g1p0NeDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>
Subject: [PATCH 5.10 116/129] tty: n_gsm: fix decoupled mux resource
Date:   Wed,  4 May 2022 18:45:08 +0200
Message-Id: <20220504153030.561668678@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153021.299025455@linuxfoundation.org>
References: <20220504153021.299025455@linuxfoundation.org>
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

commit 1ec92e9742774bf42614fceea3bf6b50c9409225 upstream.

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
---
 drivers/tty/n_gsm.c |   63 +++++++++++++++++++++++++++++++---------------------
 1 file changed, 38 insertions(+), 25 deletions(-)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2070,18 +2070,6 @@ static void gsm_cleanup_mux(struct gsm_m
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
@@ -2105,7 +2093,6 @@ static void gsm_cleanup_mux(struct gsm_m
 static int gsm_activate_mux(struct gsm_mux *gsm)
 {
 	struct gsm_dlci *dlci;
-	int i = 0;
 
 	timer_setup(&gsm->t2_timer, gsm_control_retransmit, 0);
 	init_waitqueue_head(&gsm->event);
@@ -2117,18 +2104,6 @@ static int gsm_activate_mux(struct gsm_m
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
@@ -2144,6 +2119,15 @@ static int gsm_activate_mux(struct gsm_m
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
@@ -2163,12 +2147,20 @@ static void gsm_free_muxr(struct kref *r
 
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
@@ -2189,6 +2181,7 @@ static inline unsigned int mux_line_to_n
 
 static struct gsm_mux *gsm_alloc_mux(void)
 {
+	int i;
 	struct gsm_mux *gsm = kzalloc(sizeof(struct gsm_mux), GFP_KERNEL);
 	if (gsm == NULL)
 		return NULL;
@@ -2218,6 +2211,26 @@ static struct gsm_mux *gsm_alloc_mux(voi
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
 


