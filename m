Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6864F6AF520
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbjCGTWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:22:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbjCGTWJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:22:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0641F20D0D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:07:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B536CB818C4
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:07:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11159C433D2;
        Tue,  7 Mar 2023 19:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678216024;
        bh=79FmrR3Q82FQL0xE0nOcZGIdgYLCYeHQcd09R0tUx0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZYstl8Xuj56QTuBi8xW/UK/L8Dn7VbkAjJ4+auuhGZiN3EZCkl9+zsXlZJRz3PQ97
         HoXI2jF8H2lKJ4L9Dw2O5wmpLqyY8JDskHD0FTBzSkkGwi31+npG1jYYfwBBTsXJWq
         XXnKs9+5mGIFJYJ2U62+Bq3zRxBYiRk9jij4IstA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 5.15 433/567] ipmi_ssif: Rename idle state and check
Date:   Tue,  7 Mar 2023 18:02:49 +0100
Message-Id: <20230307165924.673186395@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

commit 8230831c43a328c2be6d28c65d3f77e14c59986b upstream.

Rename the SSIF_IDLE() to IS_SSIF_IDLE(), since that is more clear, and
rename SSIF_NORMAL to SSIF_IDLE, since that's more accurate.

Cc: stable@vger.kernel.org
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_ssif.c |   46 +++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -92,7 +92,7 @@
 #define SSIF_WATCH_WATCHDOG_TIMEOUT	msecs_to_jiffies(250)
 
 enum ssif_intf_state {
-	SSIF_NORMAL,
+	SSIF_IDLE,
 	SSIF_GETTING_FLAGS,
 	SSIF_GETTING_EVENTS,
 	SSIF_CLEARING_FLAGS,
@@ -100,8 +100,8 @@ enum ssif_intf_state {
 	/* FIXME - add watchdog stuff. */
 };
 
-#define SSIF_IDLE(ssif)	 ((ssif)->ssif_state == SSIF_NORMAL \
-			  && (ssif)->curr_msg == NULL)
+#define IS_SSIF_IDLE(ssif) ((ssif)->ssif_state == SSIF_IDLE \
+			    && (ssif)->curr_msg == NULL)
 
 /*
  * Indexes into stats[] in ssif_info below.
@@ -348,9 +348,9 @@ static void return_hosed_msg(struct ssif
 
 /*
  * Must be called with the message lock held.  This will release the
- * message lock.  Note that the caller will check SSIF_IDLE and start a
- * new operation, so there is no need to check for new messages to
- * start in here.
+ * message lock.  Note that the caller will check IS_SSIF_IDLE and
+ * start a new operation, so there is no need to check for new
+ * messages to start in here.
  */
 static void start_clear_flags(struct ssif_info *ssif_info, unsigned long *flags)
 {
@@ -367,7 +367,7 @@ static void start_clear_flags(struct ssi
 
 	if (start_send(ssif_info, msg, 3) != 0) {
 		/* Error, just go to normal state. */
-		ssif_info->ssif_state = SSIF_NORMAL;
+		ssif_info->ssif_state = SSIF_IDLE;
 	}
 }
 
@@ -382,7 +382,7 @@ static void start_flag_fetch(struct ssif
 	mb[0] = (IPMI_NETFN_APP_REQUEST << 2);
 	mb[1] = IPMI_GET_MSG_FLAGS_CMD;
 	if (start_send(ssif_info, mb, 2) != 0)
-		ssif_info->ssif_state = SSIF_NORMAL;
+		ssif_info->ssif_state = SSIF_IDLE;
 }
 
 static void check_start_send(struct ssif_info *ssif_info, unsigned long *flags,
@@ -393,7 +393,7 @@ static void check_start_send(struct ssif
 
 		flags = ipmi_ssif_lock_cond(ssif_info, &oflags);
 		ssif_info->curr_msg = NULL;
-		ssif_info->ssif_state = SSIF_NORMAL;
+		ssif_info->ssif_state = SSIF_IDLE;
 		ipmi_ssif_unlock_cond(ssif_info, flags);
 		ipmi_free_smi_msg(msg);
 	}
@@ -407,7 +407,7 @@ static void start_event_fetch(struct ssi
 
 	msg = ipmi_alloc_smi_msg();
 	if (!msg) {
-		ssif_info->ssif_state = SSIF_NORMAL;
+		ssif_info->ssif_state = SSIF_IDLE;
 		ipmi_ssif_unlock_cond(ssif_info, flags);
 		return;
 	}
@@ -430,7 +430,7 @@ static void start_recv_msg_fetch(struct
 
 	msg = ipmi_alloc_smi_msg();
 	if (!msg) {
-		ssif_info->ssif_state = SSIF_NORMAL;
+		ssif_info->ssif_state = SSIF_IDLE;
 		ipmi_ssif_unlock_cond(ssif_info, flags);
 		return;
 	}
@@ -448,9 +448,9 @@ static void start_recv_msg_fetch(struct
 
 /*
  * Must be called with the message lock held.  This will release the
- * message lock.  Note that the caller will check SSIF_IDLE and start a
- * new operation, so there is no need to check for new messages to
- * start in here.
+ * message lock.  Note that the caller will check IS_SSIF_IDLE and
+ * start a new operation, so there is no need to check for new
+ * messages to start in here.
  */
 static void handle_flags(struct ssif_info *ssif_info, unsigned long *flags)
 {
@@ -466,7 +466,7 @@ static void handle_flags(struct ssif_inf
 		/* Events available. */
 		start_event_fetch(ssif_info, flags);
 	else {
-		ssif_info->ssif_state = SSIF_NORMAL;
+		ssif_info->ssif_state = SSIF_IDLE;
 		ipmi_ssif_unlock_cond(ssif_info, flags);
 	}
 }
@@ -568,7 +568,7 @@ static void watch_timeout(struct timer_l
 	if (ssif_info->watch_timeout) {
 		mod_timer(&ssif_info->watch_timer,
 			  jiffies + ssif_info->watch_timeout);
-		if (SSIF_IDLE(ssif_info)) {
+		if (IS_SSIF_IDLE(ssif_info)) {
 			start_flag_fetch(ssif_info, flags); /* Releases lock */
 			return;
 		}
@@ -756,7 +756,7 @@ static void msg_done_handler(struct ssif
 	}
 
 	switch (ssif_info->ssif_state) {
-	case SSIF_NORMAL:
+	case SSIF_IDLE:
 		ipmi_ssif_unlock_cond(ssif_info, flags);
 		if (!msg)
 			break;
@@ -774,7 +774,7 @@ static void msg_done_handler(struct ssif
 			 * Error fetching flags, or invalid length,
 			 * just give up for now.
 			 */
-			ssif_info->ssif_state = SSIF_NORMAL;
+			ssif_info->ssif_state = SSIF_IDLE;
 			ipmi_ssif_unlock_cond(ssif_info, flags);
 			dev_warn(&ssif_info->client->dev,
 				 "Error getting flags: %d %d, %x\n",
@@ -809,7 +809,7 @@ static void msg_done_handler(struct ssif
 				 "Invalid response clearing flags: %x %x\n",
 				 data[0], data[1]);
 		}
-		ssif_info->ssif_state = SSIF_NORMAL;
+		ssif_info->ssif_state = SSIF_IDLE;
 		ipmi_ssif_unlock_cond(ssif_info, flags);
 		break;
 
@@ -887,7 +887,7 @@ static void msg_done_handler(struct ssif
 	}
 
 	flags = ipmi_ssif_lock_cond(ssif_info, &oflags);
-	if (SSIF_IDLE(ssif_info) && !ssif_info->stopping) {
+	if (IS_SSIF_IDLE(ssif_info) && !ssif_info->stopping) {
 		if (ssif_info->req_events)
 			start_event_fetch(ssif_info, flags);
 		else if (ssif_info->req_flags)
@@ -1032,7 +1032,7 @@ static void start_next_msg(struct ssif_i
 	unsigned long oflags;
 
  restart:
-	if (!SSIF_IDLE(ssif_info)) {
+	if (!IS_SSIF_IDLE(ssif_info)) {
 		ipmi_ssif_unlock_cond(ssif_info, flags);
 		return;
 	}
@@ -1255,7 +1255,7 @@ static void shutdown_ssif(void *send_inf
 	dev_set_drvdata(&ssif_info->client->dev, NULL);
 
 	/* make sure the driver is not looking for flags any more. */
-	while (ssif_info->ssif_state != SSIF_NORMAL)
+	while (ssif_info->ssif_state != SSIF_IDLE)
 		schedule_timeout(1);
 
 	ssif_info->stopping = true;
@@ -1827,7 +1827,7 @@ static int ssif_probe(struct i2c_client
 	}
 
 	spin_lock_init(&ssif_info->lock);
-	ssif_info->ssif_state = SSIF_NORMAL;
+	ssif_info->ssif_state = SSIF_IDLE;
 	timer_setup(&ssif_info->retry_timer, retry_timeout, 0);
 	timer_setup(&ssif_info->watch_timer, watch_timeout, 0);
 


