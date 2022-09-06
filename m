Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27C5F5AEC3D
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241370AbiIFOU0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241803AbiIFOSv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:18:51 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A22237D4;
        Tue,  6 Sep 2022 06:49:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9ADAACE1777;
        Tue,  6 Sep 2022 13:48:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83EBFC433D6;
        Tue,  6 Sep 2022 13:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662472118;
        bh=jhZCgpOm81ONx7ihZCeABhpjGQ/SiNcxsprRM9U+lFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vTlddiaXK04Tn/HnJNatGzAqGJ7ANfmcsWRaPwMfS/VAAoESRXtqk8KISq0Spuh7f
         mnb1HsZfRxfkpM+HKmNZKPOLlCs3GlKSq7DwGbs4VeC3hKn3z74SKfbTdEwLqSb5/J
         OEOut/5Eh6DFkBW/+zAw8z8tjh4EfhxFCkC8gnE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Hillf Danton <hdanton@sina.com>,
        Fedor Pchelkin <pchelkin@ispras.ru>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: [PATCH 5.19 154/155] tty: n_gsm: replace kicktimer with delayed_work
Date:   Tue,  6 Sep 2022 15:31:42 +0200
Message-Id: <20220906132835.895013882@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
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

From: Fedor Pchelkin <pchelkin@ispras.ru>

commit c9ab053e56ce13a949977398c8edc12e6c02fc95 upstream.

A kick_timer timer_list is replaced with kick_timeout delayed_work to be
able to synchronize with mutexes as a prerequisite for the introduction
of tx_mutex.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: c568f7086c6e ("tty: n_gsm: fix missing timer to handle stalled links")
Cc: stable <stable@kernel.org>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Suggested-by: Hillf Danton <hdanton@sina.com>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Link: https://lore.kernel.org/r/20220829131640.69254-2-pchelkin@ispras.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_gsm.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index d6598ca3640f..e23225aff5d9 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -256,7 +256,7 @@ struct gsm_mux {
 	struct list_head tx_data_list;	/* Pending data packets */
 
 	/* Control messages */
-	struct timer_list kick_timer;	/* Kick TX queuing on timeout */
+	struct delayed_work kick_timeout;	/* Kick TX queuing on timeout */
 	struct timer_list t2_timer;	/* Retransmit timer for commands */
 	int cretries;			/* Command retry counter */
 	struct gsm_control *pending_cmd;/* Our current pending command */
@@ -1009,7 +1009,7 @@ static void __gsm_data_queue(struct gsm_dlci *dlci, struct gsm_msg *msg)
 	gsm->tx_bytes += msg->len;
 
 	gsmld_write_trigger(gsm);
-	mod_timer(&gsm->kick_timer, jiffies + 10 * gsm->t1 * HZ / 100);
+	schedule_delayed_work(&gsm->kick_timeout, 10 * gsm->t1 * HZ / 100);
 }
 
 /**
@@ -1984,16 +1984,16 @@ static void gsm_dlci_command(struct gsm_dlci *dlci, const u8 *data, int len)
 }
 
 /**
- *	gsm_kick_timer	-	transmit if possible
- *	@t: timer contained in our gsm object
+ *	gsm_kick_timeout	-	transmit if possible
+ *	@work: work contained in our gsm object
  *
  *	Transmit data from DLCIs if the queue is empty. We can't rely on
  *	a tty wakeup except when we filled the pipe so we need to fire off
  *	new data ourselves in other cases.
  */
-static void gsm_kick_timer(struct timer_list *t)
+static void gsm_kick_timeout(struct work_struct *work)
 {
-	struct gsm_mux *gsm = from_timer(gsm, t, kick_timer);
+	struct gsm_mux *gsm = container_of(work, struct gsm_mux, kick_timeout.work);
 	unsigned long flags;
 	int sent = 0;
 
@@ -2458,7 +2458,7 @@ static void gsm_cleanup_mux(struct gsm_mux *gsm, bool disc)
 	}
 
 	/* Finish outstanding timers, making sure they are done */
-	del_timer_sync(&gsm->kick_timer);
+	cancel_delayed_work_sync(&gsm->kick_timeout);
 	del_timer_sync(&gsm->t2_timer);
 
 	/* Finish writing to ldisc */
@@ -2605,7 +2605,7 @@ static struct gsm_mux *gsm_alloc_mux(void)
 	kref_init(&gsm->ref);
 	INIT_LIST_HEAD(&gsm->tx_ctrl_list);
 	INIT_LIST_HEAD(&gsm->tx_data_list);
-	timer_setup(&gsm->kick_timer, gsm_kick_timer, 0);
+	INIT_DELAYED_WORK(&gsm->kick_timeout, gsm_kick_timeout);
 	timer_setup(&gsm->t2_timer, gsm_control_retransmit, 0);
 	INIT_WORK(&gsm->tx_work, gsmld_write_task);
 	init_waitqueue_head(&gsm->event);
-- 
2.37.3



