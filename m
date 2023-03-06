Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7E166AB70D
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 08:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjCFH2h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 02:28:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbjCFH2d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 02:28:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E9C3C651
        for <stable@vger.kernel.org>; Sun,  5 Mar 2023 23:28:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46B47B80CA4
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 07:28:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEDC7C433EF;
        Mon,  6 Mar 2023 07:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678087709;
        bh=ycYy0nyErrqIHg6G+sR2xMvAM/IX8S4MM1aGq1exFTs=;
        h=Subject:To:Cc:From:Date:From;
        b=s+Opveh0WNTzQw1Hywx1a+9y466TTmnHVE+yiRb6be9RVw/yEKfOKLwnWFoD8HauA
         tb9A/jjF4oSb0F9+QHnABjISBy2JklyXJo7B6K/LDjGTbBE+45J7aLPMIMBO1fRaBs
         Uwdks3lz0fg0LvNRQqwjJmuzALqgmuSV910DXSWI=
Subject: FAILED: patch "[PATCH] ipmi:ssif: Add a timer between request retries" failed to apply to 6.1-stable tree
To:     cminyard@mvista.com, tcamuso@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Mar 2023 08:28:18 +0100
Message-ID: <1678087698189148@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.1.y
git checkout FETCH_HEAD
git cherry-pick -x 00bb7e763ec9f384cb382455cb6ba5588b5375cf
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1678087698189148@kroah.com' --subject-prefix 'PATCH 6.1.y' HEAD^..

Possible dependencies:

00bb7e763ec9 ("ipmi:ssif: Add a timer between request retries")
95767ed78a18 ("ipmi:ssif: resend_msg() cannot fail")
39721d62bbc1 ("ipmi:ssif: Increase the message retry time")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 00bb7e763ec9f384cb382455cb6ba5588b5375cf Mon Sep 17 00:00:00 2001
From: Corey Minyard <cminyard@mvista.com>
Date: Wed, 25 Jan 2023 10:34:47 -0600
Subject: [PATCH] ipmi:ssif: Add a timer between request retries

The IPMI spec has a time (T6) specified between request retries.  Add
the handling for that.

Reported by: Tony Camuso <tcamuso@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Corey Minyard <cminyard@mvista.com>

diff --git a/drivers/char/ipmi/ipmi_ssif.c b/drivers/char/ipmi/ipmi_ssif.c
index c25c4b1a03ae..a5ddebb1edea 100644
--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -74,7 +74,8 @@
 /*
  * Timer values
  */
-#define SSIF_MSG_USEC		60000	/* 60ms between message tries. */
+#define SSIF_MSG_USEC		60000	/* 60ms between message tries (T3). */
+#define SSIF_REQ_RETRY_USEC	60000	/* 60ms between send retries (T6). */
 #define SSIF_MSG_PART_USEC	5000	/* 5ms for a message part */
 
 /* How many times to we retry sending/receiving the message. */
@@ -82,7 +83,9 @@
 #define	SSIF_RECV_RETRIES	250
 
 #define SSIF_MSG_MSEC		(SSIF_MSG_USEC / 1000)
+#define SSIF_REQ_RETRY_MSEC	(SSIF_REQ_RETRY_USEC / 1000)
 #define SSIF_MSG_JIFFIES	((SSIF_MSG_USEC * 1000) / TICK_NSEC)
+#define SSIF_REQ_RETRY_JIFFIES	((SSIF_REQ_RETRY_USEC * 1000) / TICK_NSEC)
 #define SSIF_MSG_PART_JIFFIES	((SSIF_MSG_PART_USEC * 1000) / TICK_NSEC)
 
 /*
@@ -229,6 +232,9 @@ struct ssif_info {
 	bool		    got_alert;
 	bool		    waiting_alert;
 
+	/* Used to inform the timeout that it should do a resend. */
+	bool		    do_resend;
+
 	/*
 	 * If set to true, this will request events the next time the
 	 * state machine is idle.
@@ -531,22 +537,28 @@ static void start_get(struct ssif_info *ssif_info)
 		  ssif_info->recv, I2C_SMBUS_BLOCK_DATA);
 }
 
+static void start_resend(struct ssif_info *ssif_info);
+
 static void retry_timeout(struct timer_list *t)
 {
 	struct ssif_info *ssif_info = from_timer(ssif_info, t, retry_timer);
 	unsigned long oflags, *flags;
-	bool waiting;
+	bool waiting, resend;
 
 	if (ssif_info->stopping)
 		return;
 
 	flags = ipmi_ssif_lock_cond(ssif_info, &oflags);
+	resend = ssif_info->do_resend;
+	ssif_info->do_resend = false;
 	waiting = ssif_info->waiting_alert;
 	ssif_info->waiting_alert = false;
 	ipmi_ssif_unlock_cond(ssif_info, flags);
 
 	if (waiting)
 		start_get(ssif_info);
+	if (resend)
+		start_resend(ssif_info);
 }
 
 static void watch_timeout(struct timer_list *t)
@@ -595,8 +607,6 @@ static void ssif_alert(struct i2c_client *client, enum i2c_alert_protocol type,
 		start_get(ssif_info);
 }
 
-static void start_resend(struct ssif_info *ssif_info);
-
 static void msg_done_handler(struct ssif_info *ssif_info, int result,
 			     unsigned char *data, unsigned int len)
 {
@@ -901,7 +911,13 @@ static void msg_written_handler(struct ssif_info *ssif_info, int result,
 	if (result < 0) {
 		ssif_info->retries_left--;
 		if (ssif_info->retries_left > 0) {
-			start_resend(ssif_info);
+			/*
+			 * Wait the retry timeout time per the spec,
+			 * then redo the send.
+			 */
+			ssif_info->do_resend = true;
+			mod_timer(&ssif_info->retry_timer,
+				  jiffies + SSIF_REQ_RETRY_JIFFIES);
 			return;
 		}
 
@@ -1311,8 +1327,10 @@ static int do_cmd(struct i2c_client *client, int len, unsigned char *msg,
 	ret = i2c_smbus_write_block_data(client, SSIF_IPMI_REQUEST, len, msg);
 	if (ret) {
 		retry_cnt--;
-		if (retry_cnt > 0)
+		if (retry_cnt > 0) {
+			msleep(SSIF_REQ_RETRY_MSEC);
 			goto retry1;
+		}
 		return -ENODEV;
 	}
 
@@ -1453,8 +1471,10 @@ static int start_multipart_test(struct i2c_client *client,
 					 32, msg);
 	if (ret) {
 		retry_cnt--;
-		if (retry_cnt > 0)
+		if (retry_cnt > 0) {
+			msleep(SSIF_REQ_RETRY_MSEC);
 			goto retry_write;
+		}
 		dev_err(&client->dev, "Could not write multi-part start, though the BMC said it could handle it.  Just limit sends to one part.\n");
 		return ret;
 	}

