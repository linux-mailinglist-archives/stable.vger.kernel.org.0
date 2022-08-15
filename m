Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98199594C30
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244382AbiHPAmd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349973AbiHPAlj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:41:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A80BACA24;
        Mon, 15 Aug 2022 13:39:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DC086122B;
        Mon, 15 Aug 2022 20:39:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A537C433B5;
        Mon, 15 Aug 2022 20:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595960;
        bh=U76y3Rv3ep988f+n4BPNFIOh+pQ6ZOtqlLZcSVvFxDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dpVKLhvV6rOB3Cmys5zaxETfd3QzG1mlvLGyqHzn3VPGWsMUPQ7QmA6Zs9GEI0TCX
         ZAClr8ORNZ8RRN56BTtMo6+EBDw+fMInN2BRBlPATInez2RP3y2Zp/U9GQ2ArFIm5F
         Ee1f1L5NthE51zvWrJR5/f76rzJ5b4A1wbYEZkLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0928/1157] tty: n_gsm: fix missing timer to handle stalled links
Date:   Mon, 15 Aug 2022 20:04:44 +0200
Message-Id: <20220815180516.589107632@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Starke <daniel.starke@siemens.com>

[ Upstream commit c568f7086c6e771c77aad13d727c70ef70e07243 ]

The current implementation does not handle the situation that no data is in
the internal queue and needs to be sent out while the user tty fifo is
full.
Add a timer that moves more data from user tty down to the internal queue
which is then serialized on the ldisc. This timer is triggered if no data
was moved from a user tty to the internal queue within 10 * T1.

Fixes: e1eaea46bb40 ("tty: n_gsm line discipline")
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220701061652.39604-4-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/n_gsm.c | 43 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 35 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index d056b15b4d61..a01225819b92 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -244,6 +244,7 @@ struct gsm_mux {
 	struct list_head tx_list;	/* Pending data packets */
 
 	/* Control messages */
+	struct timer_list kick_timer;	/* Kick TX queuing on timeout */
 	struct timer_list t2_timer;	/* Retransmit timer for commands */
 	int cretries;			/* Command retry counter */
 	struct gsm_control *pending_cmd;/* Our current pending command */
@@ -850,6 +851,7 @@ static void __gsm_data_queue(struct gsm_dlci *dlci, struct gsm_msg *msg)
 	list_add_tail(&msg->list, &gsm->tx_list);
 	gsm->tx_bytes += msg->len;
 	gsm_data_kick(gsm, dlci);
+	mod_timer(&gsm->kick_timer, jiffies + 10 * gsm->t1 * HZ / 100);
 }
 
 /**
@@ -902,9 +904,6 @@ static int gsm_dlci_data_output(struct gsm_mux *gsm, struct gsm_dlci *dlci)
 	size = len + h;
 
 	msg = gsm_data_alloc(gsm, dlci->addr, size, gsm->ftype);
-	/* FIXME: need a timer or something to kick this so it can't
-	 * get stuck with no work outstanding and no buffer free
-	 */
 	if (!msg)
 		return -ENOMEM;
 	dp = msg->data;
@@ -981,9 +980,6 @@ static int gsm_dlci_data_output_framed(struct gsm_mux *gsm,
 
 	size = len + overhead;
 	msg = gsm_data_alloc(gsm, dlci->addr, size, gsm->ftype);
-
-	/* FIXME: need a timer or something to kick this so it can't
-	   get stuck with no work outstanding and no buffer free */
 	if (msg == NULL) {
 		skb_queue_tail(&dlci->skb_list, dlci->skb);
 		dlci->skb = NULL;
@@ -1079,9 +1075,9 @@ static int gsm_dlci_modem_output(struct gsm_mux *gsm, struct gsm_dlci *dlci,
  *	renegotiate DLCI priorities with optional stuff. Needs optimising.
  */
 
-static void gsm_dlci_data_sweep(struct gsm_mux *gsm)
+static int gsm_dlci_data_sweep(struct gsm_mux *gsm)
 {
-	int len;
+	int len, ret = 0;
 	/* Priority ordering: We should do priority with RR of the groups */
 	int i = 1;
 
@@ -1104,7 +1100,11 @@ static void gsm_dlci_data_sweep(struct gsm_mux *gsm)
 		/* DLCI empty - try the next */
 		if (len == 0)
 			i++;
+		else
+			ret++;
 	}
+
+	return ret;
 }
 
 /**
@@ -1823,6 +1823,30 @@ static void gsm_dlci_command(struct gsm_dlci *dlci, const u8 *data, int len)
 	}
 }
 
+/**
+ *	gsm_kick_timer	-	transmit if possible
+ *	@t: timer contained in our gsm object
+ *
+ *	Transmit data from DLCIs if the queue is empty. We can't rely on
+ *	a tty wakeup except when we filled the pipe so we need to fire off
+ *	new data ourselves in other cases.
+ */
+static void gsm_kick_timer(struct timer_list *t)
+{
+	struct gsm_mux *gsm = from_timer(gsm, t, kick_timer);
+	unsigned long flags;
+	int sent = 0;
+
+	spin_lock_irqsave(&gsm->tx_lock, flags);
+	/* If we have nothing running then we need to fire up */
+	if (gsm->tx_bytes < TX_THRESH_LO)
+		sent = gsm_dlci_data_sweep(gsm);
+	spin_unlock_irqrestore(&gsm->tx_lock, flags);
+
+	if (sent && debug & 4)
+		pr_info("%s TX queue stalled\n", __func__);
+}
+
 /*
  *	Allocate/Free DLCI channels
  */
@@ -2274,6 +2298,7 @@ static void gsm_cleanup_mux(struct gsm_mux *gsm, bool disc)
 	}
 
 	/* Finish outstanding timers, making sure they are done */
+	del_timer_sync(&gsm->kick_timer);
 	del_timer_sync(&gsm->t2_timer);
 
 	/* Free up any link layer users and finally the control channel */
@@ -2306,6 +2331,7 @@ static int gsm_activate_mux(struct gsm_mux *gsm)
 	struct gsm_dlci *dlci;
 	int ret;
 
+	timer_setup(&gsm->kick_timer, gsm_kick_timer, 0);
 	timer_setup(&gsm->t2_timer, gsm_control_retransmit, 0);
 	init_waitqueue_head(&gsm->event);
 	spin_lock_init(&gsm->control_lock);
@@ -2710,6 +2736,7 @@ static int gsmld_open(struct tty_struct *tty)
 
 	gsmld_attach_gsm(tty, gsm);
 
+	timer_setup(&gsm->kick_timer, gsm_kick_timer, 0);
 	timer_setup(&gsm->t2_timer, gsm_control_retransmit, 0);
 
 	return 0;
-- 
2.35.1



