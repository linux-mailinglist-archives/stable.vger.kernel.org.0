Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6726D47D6
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233163AbjDCOXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233168AbjDCOXs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:23:48 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAAA510430
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:23:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BEDEACE12C3
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:23:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7381C433EF;
        Mon,  3 Apr 2023 14:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531816;
        bh=NJX8/sgQ0hT/K5I8wC0WccGkOUfXcYnc7UL9KtXgoGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LwNM0CnCbluVQ4WI9hwdJxB6rYgK/49X0aunI0abg1fp71QlhT/BOVU7kESC13MRv
         +cEPjkfWWJYVOzFAbCCm2PDyFWfKW8YYVnK60L5XMH3lhFnKEP7D42nvpPljcy0sF1
         naO/+b9CYjvjbMjYFgZkyJOjEmh4SLI9+/Jr5DGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Corey Minyard <cminyard@mvista.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 007/173] ipmi:ssif: Add a timer between request retries
Date:   Mon,  3 Apr 2023 16:07:02 +0200
Message-Id: <20230403140414.465686479@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

[ Upstream commit 00bb7e763ec9f384cb382455cb6ba5588b5375cf ]

The IPMI spec has a time (T6) specified between request retries.  Add
the handling for that.

Reported by: Tony Camuso <tcamuso@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_ssif.c | 34 +++++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_ssif.c b/drivers/char/ipmi/ipmi_ssif.c
index cae21632cf079..20dc2452815c7 100644
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
@@ -538,22 +544,28 @@ static void start_get(struct ssif_info *ssif_info)
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
@@ -602,8 +614,6 @@ static void ssif_alert(struct i2c_client *client, enum i2c_alert_protocol type,
 		start_get(ssif_info);
 }
 
-static void start_resend(struct ssif_info *ssif_info);
-
 static void msg_done_handler(struct ssif_info *ssif_info, int result,
 			     unsigned char *data, unsigned int len)
 {
@@ -909,7 +919,13 @@ static void msg_written_handler(struct ssif_info *ssif_info, int result,
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
 
@@ -1322,8 +1338,10 @@ static int do_cmd(struct i2c_client *client, int len, unsigned char *msg,
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
 
@@ -1464,8 +1482,10 @@ static int start_multipart_test(struct i2c_client *client,
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
-- 
2.39.2



