Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6788A6BB060
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbjCOMRt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231971AbjCOMRn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:17:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B8688890
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:17:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64AA4B81DFF
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:17:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC058C433D2;
        Wed, 15 Mar 2023 12:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882649;
        bh=yyofiCsIBWvTe6TugVvwGF+8HcVhwLr8N1pWzQxrB9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cK5eqet7hjqN/4GXYmbblE4NDWpnm+Pu/wMB/77GHwevL+4VAB4mW3wLDJnbNC8K2
         ycXdKuN9KilGH/ZC6MM74CzusjbeCA6FphO4dytwZ0NOYRqSO5z9aneDUA/zD4xEGs
         rdH0xnTp8JoA/rDSXzQO+fogGCmnvss3kSe8CHLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Corey Minyard <cminyard@mvista.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 18/68] ipmi:ssif: resend_msg() cannot fail
Date:   Wed, 15 Mar 2023 13:12:12 +0100
Message-Id: <20230315115726.811691254@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115726.103942885@linuxfoundation.org>
References: <20230315115726.103942885@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

[ Upstream commit 95767ed78a181d5404202627499f9cde56053b96 ]

The resend_msg() function cannot fail, but there was error handling
around using it.  Rework the handling of the error, and fix the out of
retries debug reporting that was wrong around this, too.

Cc: stable@vger.kernel.org
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_ssif.c | 28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_ssif.c b/drivers/char/ipmi/ipmi_ssif.c
index 5ead5e7f0ce16..ff93009583ab1 100644
--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -607,7 +607,7 @@ static void ssif_alert(struct i2c_client *client, enum i2c_alert_protocol type,
 		start_get(ssif_info);
 }
 
-static int start_resend(struct ssif_info *ssif_info);
+static void start_resend(struct ssif_info *ssif_info);
 
 static void msg_done_handler(struct ssif_info *ssif_info, int result,
 			     unsigned char *data, unsigned int len)
@@ -914,31 +914,17 @@ static void msg_written_handler(struct ssif_info *ssif_info, int result,
 	if (result < 0) {
 		ssif_info->retries_left--;
 		if (ssif_info->retries_left > 0) {
-			if (!start_resend(ssif_info)) {
-				ssif_inc_stat(ssif_info, send_retries);
-				return;
-			}
-			/* request failed, just return the error. */
-			ssif_inc_stat(ssif_info, send_errors);
-
-			if (ssif_info->ssif_debug & SSIF_DEBUG_MSG)
-				dev_dbg(&ssif_info->client->dev,
-					"%s: Out of retries\n", __func__);
-			msg_done_handler(ssif_info, -EIO, NULL, 0);
+			start_resend(ssif_info);
 			return;
 		}
 
 		ssif_inc_stat(ssif_info, send_errors);
 
-		/*
-		 * Got an error on transmit, let the done routine
-		 * handle it.
-		 */
 		if (ssif_info->ssif_debug & SSIF_DEBUG_MSG)
 			dev_dbg(&ssif_info->client->dev,
-				"%s: Error  %d\n", __func__, result);
+				"%s: Out of retries\n", __func__);
 
-		msg_done_handler(ssif_info, result, NULL, 0);
+		msg_done_handler(ssif_info, -EIO, NULL, 0);
 		return;
 	}
 
@@ -1001,7 +987,7 @@ static void msg_written_handler(struct ssif_info *ssif_info, int result,
 	}
 }
 
-static int start_resend(struct ssif_info *ssif_info)
+static void start_resend(struct ssif_info *ssif_info)
 {
 	int command;
 
@@ -1026,7 +1012,6 @@ static int start_resend(struct ssif_info *ssif_info)
 
 	ssif_i2c_send(ssif_info, msg_written_handler, I2C_SMBUS_WRITE,
 		   command, ssif_info->data, I2C_SMBUS_BLOCK_DATA);
-	return 0;
 }
 
 static int start_send(struct ssif_info *ssif_info,
@@ -1041,7 +1026,8 @@ static int start_send(struct ssif_info *ssif_info,
 	ssif_info->retries_left = SSIF_SEND_RETRIES;
 	memcpy(ssif_info->data + 1, data, len);
 	ssif_info->data_len = len;
-	return start_resend(ssif_info);
+	start_resend(ssif_info);
+	return 0;
 }
 
 /* Must be called with the message lock held. */
-- 
2.39.2



