Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF3CF641982
	for <lists+stable@lfdr.de>; Sat,  3 Dec 2022 23:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiLCWgT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Dec 2022 17:36:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiLCWgQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Dec 2022 17:36:16 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDA7E1C900;
        Sat,  3 Dec 2022 14:36:15 -0800 (PST)
Received: from localhost.localdomain (unknown [46.242.14.200])
        by mail.ispras.ru (Postfix) with ESMTPSA id 3E811419E9D7;
        Sat,  3 Dec 2022 22:36:14 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 3E811419E9D7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1670106974;
        bh=iGsZYF50oJkEiDocUts/Xj2Xr2RqP3yzlAgG1a+U8Gw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OfkkZ3/V761E3nha5eBtbjiMRqUh9uyz5jqnNxsYaDwDB5eQ0GXLMTBbRiS10gR5j
         GuR3+1QDCYZy9j9uCie+GVWy5K+8u31rfmYNNJIxg9bXkiIigCCIGlvNaWHG8ZOGct
         It6SlThcbxhTrhITC/abnJ+OwRig6In+uRcmNrsA=
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>, linux-kernel@vger.kernel.org,
        Daniel Starke <daniel.starke@siemens.com>,
        jirislaby@kernel.org, Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org, Pavel Machek <pavel@denx.de>
Subject: [PATCH 5.19 2/2] Revert "tty: n_gsm: replace kicktimer with delayed_work"
Date:   Sun,  4 Dec 2022 01:35:26 +0300
Message-Id: <20221203223526.11185-3-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221203223526.11185-1-pchelkin@ispras.ru>
References: <20221203223526.11185-1-pchelkin@ispras.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit 15743ae50e04aa907131e3ae8d66e9a2964ea232 ]

This reverts commit 2af54fe4f713d5f29e1520d7780112ff9b6121be.

The above commit is reverted as it was a prerequisite for tx_mutex
introduction and tx_mutex has been removed as it does not correctly
work in order to protect tx data.

Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Reviewed-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20221008110221.13645-3-pchelkin@ispras.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_gsm.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index e23225aff5d9..d6598ca3640f 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -256,7 +256,7 @@ struct gsm_mux {
 	struct list_head tx_data_list;	/* Pending data packets */
 
 	/* Control messages */
-	struct delayed_work kick_timeout;	/* Kick TX queuing on timeout */
+	struct timer_list kick_timer;	/* Kick TX queuing on timeout */
 	struct timer_list t2_timer;	/* Retransmit timer for commands */
 	int cretries;			/* Command retry counter */
 	struct gsm_control *pending_cmd;/* Our current pending command */
@@ -1009,7 +1009,7 @@ static void __gsm_data_queue(struct gsm_dlci *dlci, struct gsm_msg *msg)
 	gsm->tx_bytes += msg->len;
 
 	gsmld_write_trigger(gsm);
-	schedule_delayed_work(&gsm->kick_timeout, 10 * gsm->t1 * HZ / 100);
+	mod_timer(&gsm->kick_timer, jiffies + 10 * gsm->t1 * HZ / 100);
 }
 
 /**
@@ -1984,16 +1984,16 @@ static void gsm_dlci_command(struct gsm_dlci *dlci, const u8 *data, int len)
 }
 
 /**
- *	gsm_kick_timeout	-	transmit if possible
- *	@work: work contained in our gsm object
+ *	gsm_kick_timer	-	transmit if possible
+ *	@t: timer contained in our gsm object
  *
  *	Transmit data from DLCIs if the queue is empty. We can't rely on
  *	a tty wakeup except when we filled the pipe so we need to fire off
  *	new data ourselves in other cases.
  */
-static void gsm_kick_timeout(struct work_struct *work)
+static void gsm_kick_timer(struct timer_list *t)
 {
-	struct gsm_mux *gsm = container_of(work, struct gsm_mux, kick_timeout.work);
+	struct gsm_mux *gsm = from_timer(gsm, t, kick_timer);
 	unsigned long flags;
 	int sent = 0;
 
@@ -2458,7 +2458,7 @@ static void gsm_cleanup_mux(struct gsm_mux *gsm, bool disc)
 	}
 
 	/* Finish outstanding timers, making sure they are done */
-	cancel_delayed_work_sync(&gsm->kick_timeout);
+	del_timer_sync(&gsm->kick_timer);
 	del_timer_sync(&gsm->t2_timer);
 
 	/* Finish writing to ldisc */
@@ -2605,7 +2605,7 @@ static struct gsm_mux *gsm_alloc_mux(void)
 	kref_init(&gsm->ref);
 	INIT_LIST_HEAD(&gsm->tx_ctrl_list);
 	INIT_LIST_HEAD(&gsm->tx_data_list);
-	INIT_DELAYED_WORK(&gsm->kick_timeout, gsm_kick_timeout);
+	timer_setup(&gsm->kick_timer, gsm_kick_timer, 0);
 	timer_setup(&gsm->t2_timer, gsm_control_retransmit, 0);
 	INIT_WORK(&gsm->tx_work, gsmld_write_task);
 	init_waitqueue_head(&gsm->event);
-- 
2.38.1

