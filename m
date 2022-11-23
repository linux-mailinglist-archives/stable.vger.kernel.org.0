Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE24635D43
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236616AbiKWMmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:42:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236031AbiKWMlv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:41:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F6F64542;
        Wed, 23 Nov 2022 04:41:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14C6A61C65;
        Wed, 23 Nov 2022 12:41:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A4F3C433D7;
        Wed, 23 Nov 2022 12:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207286;
        bh=sVcslbLzoSS5ti8x1rnxONtrGGaUGz6ixtVrrBY1Nsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FdsNcsZQ6oAmWVAQ8KsMXCPEQhV0OiF01O+rxcqZRimHIjZG0pgFPMtffkrcjk0Vz
         JzIqa/AiP+oOinIzXGLyRwiZl222QedvhaOSAGplgFfWA1vmRjIuMPlXUc4a/4ecHg
         b1ZH1LRxdBpWRQ/Vy9pz5Dk1xcdWgI1W9Dpfuff4Me2e9JxwD5yKrgQMXdEEdyljDx
         hoavmEne99ob2pSkt7FkzoJBifrPC0iLo66t+BJAL0J8INBRBIQhgj/5jbLA1mXzRj
         NmK0WeAQoEEhrenWxD3PNSYp/KjII2YA0sB7ZG+7MooDFYEHDPmgOtDtZL7DT1qib3
         BBUFAw/7Rp7Mg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Daniel Starke <daniel.starke@siemens.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, jirislaby@kernel.org
Subject: [PATCH AUTOSEL 6.0 11/44] Revert "tty: n_gsm: replace kicktimer with delayed_work"
Date:   Wed, 23 Nov 2022 07:40:20 -0500
Message-Id: <20221123124057.264822-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124057.264822-1-sashal@kernel.org>
References: <20221123124057.264822-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit 15743ae50e04aa907131e3ae8d66e9a2964ea232 ]

This reverts commit c9ab053e56ce13a949977398c8edc12e6c02fc95.

The above commit is reverted as it was a prerequisite for tx_mutex
introduction and tx_mutex has been removed as it does not correctly
work in order to protect tx data.

Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Reviewed-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20221008110221.13645-3-pchelkin@ispras.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
2.35.1

