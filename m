Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D61A76B45C8
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232649AbjCJOhH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:37:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232660AbjCJOhC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:37:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6670B11EEB8
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:36:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DE9F617B4
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:36:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47A4C4339B;
        Fri, 10 Mar 2023 14:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459001;
        bh=UUT6GtblmvQS8T1D7aoSgDIoIhByjR3MomUlVc8JYfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zEBeBX6z4Ok4O/KPLTkDUZsAuConA3mKVklPHt0+NMIUf1k4U8yqM9FoJSh+m0yud
         pXezpvqoQ4nvfPLlQX2YHE9uwbz68grMLgmmqJUQKYFCv4gS2vVJMK0wyV3JkQ4c8T
         1poSK7AMUT1I9GD3oRwGpWbJz48UKNjMu4YMkywQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 5.4 214/357] ipmi_ssif: Rename idle state and check
Date:   Fri, 10 Mar 2023 14:38:23 +0100
Message-Id: <20230310133744.153142431@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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
@@ -97,7 +97,7 @@
 #define SSIF_WATCH_WATCHDOG_TIMEOUT	msecs_to_jiffies(250)
 
 enum ssif_intf_state {
-	SSIF_NORMAL,
+	SSIF_IDLE,
 	SSIF_GETTING_FLAGS,
 	SSIF_GETTING_EVENTS,
 	SSIF_CLEARING_FLAGS,
@@ -105,8 +105,8 @@ enum ssif_intf_state {
 	/* FIXME - add watchdog stuff. */
 };
 
-#define SSIF_IDLE(ssif)	 ((ssif)->ssif_state == SSIF_NORMAL \
-			  && (ssif)->curr_msg == NULL)
+#define IS_SSIF_IDLE(ssif) ((ssif)->ssif_state == SSIF_IDLE \
+			    && (ssif)->curr_msg == NULL)
 
 /*
  * Indexes into stats[] in ssif_info below.
@@ -353,9 +353,9 @@ static void return_hosed_msg(struct ssif
 
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
@@ -372,7 +372,7 @@ static void start_clear_flags(struct ssi
 
 	if (start_send(ssif_info, msg, 3) != 0) {
 		/* Error, just go to normal state. */
-		ssif_info->ssif_state = SSIF_NORMAL;
+		ssif_info->ssif_state = SSIF_IDLE;
 	}
 }
 
@@ -387,7 +387,7 @@ static void start_flag_fetch(struct ssif
 	mb[0] = (IPMI_NETFN_APP_REQUEST << 2);
 	mb[1] = IPMI_GET_MSG_FLAGS_CMD;
 	if (start_send(ssif_info, mb, 2) != 0)
-		ssif_info->ssif_state = SSIF_NORMAL;
+		ssif_info->ssif_state = SSIF_IDLE;
 }
 
 static void check_start_send(struct ssif_info *ssif_info, unsigned long *flags,
@@ -398,7 +398,7 @@ static void check_start_send(struct ssif
 
 		flags = ipmi_ssif_lock_cond(ssif_info, &oflags);
 		ssif_info->curr_msg = NULL;
-		ssif_info->ssif_state = SSIF_NORMAL;
+		ssif_info->ssif_state = SSIF_IDLE;
 		ipmi_ssif_unlock_cond(ssif_info, flags);
 		ipmi_free_smi_msg(msg);
 	}
@@ -412,7 +412,7 @@ static void start_event_fetch(struct ssi
 
 	msg = ipmi_alloc_smi_msg();
 	if (!msg) {
-		ssif_info->ssif_state = SSIF_NORMAL;
+		ssif_info->ssif_state = SSIF_IDLE;
 		ipmi_ssif_unlock_cond(ssif_info, flags);
 		return;
 	}
@@ -435,7 +435,7 @@ static void start_recv_msg_fetch(struct
 
 	msg = ipmi_alloc_smi_msg();
 	if (!msg) {
-		ssif_info->ssif_state = SSIF_NORMAL;
+		ssif_info->ssif_state = SSIF_IDLE;
 		ipmi_ssif_unlock_cond(ssif_info, flags);
 		return;
 	}
@@ -453,9 +453,9 @@ static void start_recv_msg_fetch(struct
 
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
@@ -471,7 +471,7 @@ static void handle_flags(struct ssif_inf
 		/* Events available. */
 		start_event_fetch(ssif_info, flags);
 	else {
-		ssif_info->ssif_state = SSIF_NORMAL;
+		ssif_info->ssif_state = SSIF_IDLE;
 		ipmi_ssif_unlock_cond(ssif_info, flags);
 	}
 }
@@ -584,7 +584,7 @@ static void watch_timeout(struct timer_l
 	if (ssif_info->watch_timeout) {
 		mod_timer(&ssif_info->watch_timer,
 			  jiffies + ssif_info->watch_timeout);
-		if (SSIF_IDLE(ssif_info)) {
+		if (IS_SSIF_IDLE(ssif_info)) {
 			start_flag_fetch(ssif_info, flags); /* Releases lock */
 			return;
 		}
@@ -787,7 +787,7 @@ static void msg_done_handler(struct ssif
 	}
 
 	switch (ssif_info->ssif_state) {
-	case SSIF_NORMAL:
+	case SSIF_IDLE:
 		ipmi_ssif_unlock_cond(ssif_info, flags);
 		if (!msg)
 			break;
@@ -805,7 +805,7 @@ static void msg_done_handler(struct ssif
 			 * Error fetching flags, or invalid length,
 			 * just give up for now.
 			 */
-			ssif_info->ssif_state = SSIF_NORMAL;
+			ssif_info->ssif_state = SSIF_IDLE;
 			ipmi_ssif_unlock_cond(ssif_info, flags);
 			dev_warn(&ssif_info->client->dev,
 				 "Error getting flags: %d %d, %x\n",
@@ -840,7 +840,7 @@ static void msg_done_handler(struct ssif
 				 "Invalid response clearing flags: %x %x\n",
 				 data[0], data[1]);
 		}
-		ssif_info->ssif_state = SSIF_NORMAL;
+		ssif_info->ssif_state = SSIF_IDLE;
 		ipmi_ssif_unlock_cond(ssif_info, flags);
 		break;
 
@@ -918,7 +918,7 @@ static void msg_done_handler(struct ssif
 	}
 
 	flags = ipmi_ssif_lock_cond(ssif_info, &oflags);
-	if (SSIF_IDLE(ssif_info) && !ssif_info->stopping) {
+	if (IS_SSIF_IDLE(ssif_info) && !ssif_info->stopping) {
 		if (ssif_info->req_events)
 			start_event_fetch(ssif_info, flags);
 		else if (ssif_info->req_flags)
@@ -1092,7 +1092,7 @@ static void start_next_msg(struct ssif_i
 	unsigned long oflags;
 
  restart:
-	if (!SSIF_IDLE(ssif_info)) {
+	if (!IS_SSIF_IDLE(ssif_info)) {
 		ipmi_ssif_unlock_cond(ssif_info, flags);
 		return;
 	}
@@ -1315,7 +1315,7 @@ static void shutdown_ssif(void *send_inf
 	dev_set_drvdata(&ssif_info->client->dev, NULL);
 
 	/* make sure the driver is not looking for flags any more. */
-	while (ssif_info->ssif_state != SSIF_NORMAL)
+	while (ssif_info->ssif_state != SSIF_IDLE)
 		schedule_timeout(1);
 
 	ssif_info->stopping = true;
@@ -1886,7 +1886,7 @@ static int ssif_probe(struct i2c_client
 	}
 
 	spin_lock_init(&ssif_info->lock);
-	ssif_info->ssif_state = SSIF_NORMAL;
+	ssif_info->ssif_state = SSIF_IDLE;
 	timer_setup(&ssif_info->retry_timer, retry_timeout, 0);
 	timer_setup(&ssif_info->watch_timer, watch_timeout, 0);
 


