Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A118E6D47D3
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233185AbjDCOXp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233188AbjDCOXm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:23:42 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B821E2D7E5
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:23:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0E9DFCE12AE
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:23:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11381C433D2;
        Mon,  3 Apr 2023 14:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531808;
        bh=W2Qi3UuccaHUu2AXbJuG1XabTtlskZrReI9EADIScAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bI1Wv+NpuSj66xFVcYmSNBymbQM/wOrBqJVxjoKiJ02lVl+06xn/nw8AuQH/0SxDC
         GYDtrdvfJiDM7coHmUFE9PmARpKZp2Dw5G84RvsE63Vmc1qKgjWOIfOkxkW4IVD8Dy
         dSdpoFZjSWe5/uFaZm7kQ65RMnBI70eOTX6ubf7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Liguang Zhang <zhangliguang@linux.alibaba.com>,
        Corey Minyard <cminyard@mvista.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 004/173] ipmi:ssif: make ssif_i2c_send() void
Date:   Mon,  3 Apr 2023 16:06:59 +0200
Message-Id: <20230403140414.354868730@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liguang Zhang <zhangliguang@linux.alibaba.com>

[ Upstream commit dcd10526ac5a0d6cc94ce60b9acfca458163277b ]

This function actually needs no return value. So remove the unneeded
check and make it void.

Signed-off-by: Liguang Zhang <zhangliguang@linux.alibaba.com>
Message-Id: <20210301140515.18951-1-zhangliguang@linux.alibaba.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Stable-dep-of: 00bb7e763ec9 ("ipmi:ssif: Add a timer between request retries")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_ssif.c | 81 +++++++++--------------------------
 1 file changed, 20 insertions(+), 61 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_ssif.c b/drivers/char/ipmi/ipmi_ssif.c
index 0f2bac24e564d..e9775b17dc92e 100644
--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -510,7 +510,7 @@ static int ipmi_ssif_thread(void *data)
 	return 0;
 }
 
-static int ssif_i2c_send(struct ssif_info *ssif_info,
+static void ssif_i2c_send(struct ssif_info *ssif_info,
 			ssif_i2c_done handler,
 			int read_write, int command,
 			unsigned char *data, unsigned int size)
@@ -522,7 +522,6 @@ static int ssif_i2c_send(struct ssif_info *ssif_info,
 	ssif_info->i2c_data = data;
 	ssif_info->i2c_size = size;
 	complete(&ssif_info->wake_thread);
-	return 0;
 }
 
 
@@ -531,22 +530,12 @@ static void msg_done_handler(struct ssif_info *ssif_info, int result,
 
 static void start_get(struct ssif_info *ssif_info)
 {
-	int rv;
-
 	ssif_info->rtc_us_timer = 0;
 	ssif_info->multi_pos = 0;
 
-	rv = ssif_i2c_send(ssif_info, msg_done_handler, I2C_SMBUS_READ,
-			  SSIF_IPMI_RESPONSE,
-			  ssif_info->recv, I2C_SMBUS_BLOCK_DATA);
-	if (rv < 0) {
-		/* request failed, just return the error. */
-		if (ssif_info->ssif_debug & SSIF_DEBUG_MSG)
-			dev_dbg(&ssif_info->client->dev,
-				"Error from i2c_non_blocking_op(5)\n");
-
-		msg_done_handler(ssif_info, -EIO, NULL, 0);
-	}
+	ssif_i2c_send(ssif_info, msg_done_handler, I2C_SMBUS_READ,
+		  SSIF_IPMI_RESPONSE,
+		  ssif_info->recv, I2C_SMBUS_BLOCK_DATA);
 }
 
 static void retry_timeout(struct timer_list *t)
@@ -620,7 +609,6 @@ static void msg_done_handler(struct ssif_info *ssif_info, int result,
 {
 	struct ipmi_smi_msg *msg;
 	unsigned long oflags, *flags;
-	int rv;
 
 	/*
 	 * We are single-threaded here, so no need for a lock until we
@@ -666,17 +654,10 @@ static void msg_done_handler(struct ssif_info *ssif_info, int result,
 		ssif_info->multi_len = len;
 		ssif_info->multi_pos = 1;
 
-		rv = ssif_i2c_send(ssif_info, msg_done_handler, I2C_SMBUS_READ,
-				  SSIF_IPMI_MULTI_PART_RESPONSE_MIDDLE,
-				  ssif_info->recv, I2C_SMBUS_BLOCK_DATA);
-		if (rv < 0) {
-			if (ssif_info->ssif_debug & SSIF_DEBUG_MSG)
-				dev_dbg(&ssif_info->client->dev,
-					"Error from i2c_non_blocking_op(1)\n");
-
-			result = -EIO;
-		} else
-			return;
+		ssif_i2c_send(ssif_info, msg_done_handler, I2C_SMBUS_READ,
+			 SSIF_IPMI_MULTI_PART_RESPONSE_MIDDLE,
+			 ssif_info->recv, I2C_SMBUS_BLOCK_DATA);
+		return;
 	} else if (ssif_info->multi_pos) {
 		/* Middle of multi-part read.  Start the next transaction. */
 		int i;
@@ -738,19 +719,12 @@ static void msg_done_handler(struct ssif_info *ssif_info, int result,
 
 			ssif_info->multi_pos++;
 
-			rv = ssif_i2c_send(ssif_info, msg_done_handler,
-					   I2C_SMBUS_READ,
-					   SSIF_IPMI_MULTI_PART_RESPONSE_MIDDLE,
-					   ssif_info->recv,
-					   I2C_SMBUS_BLOCK_DATA);
-			if (rv < 0) {
-				if (ssif_info->ssif_debug & SSIF_DEBUG_MSG)
-					dev_dbg(&ssif_info->client->dev,
-						"Error from ssif_i2c_send\n");
-
-				result = -EIO;
-			} else
-				return;
+			ssif_i2c_send(ssif_info, msg_done_handler,
+				  I2C_SMBUS_READ,
+				  SSIF_IPMI_MULTI_PART_RESPONSE_MIDDLE,
+				  ssif_info->recv,
+				  I2C_SMBUS_BLOCK_DATA);
+			return;
 		}
 	}
 
@@ -931,8 +905,6 @@ static void msg_done_handler(struct ssif_info *ssif_info, int result,
 static void msg_written_handler(struct ssif_info *ssif_info, int result,
 				unsigned char *data, unsigned int len)
 {
-	int rv;
-
 	/* We are single-threaded here, so no need for a lock. */
 	if (result < 0) {
 		ssif_info->retries_left--;
@@ -995,18 +967,9 @@ static void msg_written_handler(struct ssif_info *ssif_info, int result,
 			ssif_info->multi_data = NULL;
 		}
 
-		rv = ssif_i2c_send(ssif_info, msg_written_handler,
-				   I2C_SMBUS_WRITE, cmd,
-				   data_to_send, I2C_SMBUS_BLOCK_DATA);
-		if (rv < 0) {
-			/* request failed, just return the error. */
-			ssif_inc_stat(ssif_info, send_errors);
-
-			if (ssif_info->ssif_debug & SSIF_DEBUG_MSG)
-				dev_dbg(&ssif_info->client->dev,
-					"Error from i2c_non_blocking_op(3)\n");
-			msg_done_handler(ssif_info, -EIO, NULL, 0);
-		}
+		ssif_i2c_send(ssif_info, msg_written_handler,
+			  I2C_SMBUS_WRITE, cmd,
+			  data_to_send, I2C_SMBUS_BLOCK_DATA);
 	} else {
 		/* Ready to request the result. */
 		unsigned long oflags, *flags;
@@ -1035,7 +998,6 @@ static void msg_written_handler(struct ssif_info *ssif_info, int result,
 
 static int start_resend(struct ssif_info *ssif_info)
 {
-	int rv;
 	int command;
 
 	ssif_info->got_alert = false;
@@ -1057,12 +1019,9 @@ static int start_resend(struct ssif_info *ssif_info)
 		ssif_info->data[0] = ssif_info->data_len;
 	}
 
-	rv = ssif_i2c_send(ssif_info, msg_written_handler, I2C_SMBUS_WRITE,
-			  command, ssif_info->data, I2C_SMBUS_BLOCK_DATA);
-	if (rv && (ssif_info->ssif_debug & SSIF_DEBUG_MSG))
-		dev_dbg(&ssif_info->client->dev,
-			"Error from i2c_non_blocking_op(4)\n");
-	return rv;
+	ssif_i2c_send(ssif_info, msg_written_handler, I2C_SMBUS_WRITE,
+		   command, ssif_info->data, I2C_SMBUS_BLOCK_DATA);
+	return 0;
 }
 
 static int start_send(struct ssif_info *ssif_info,
-- 
2.39.2



