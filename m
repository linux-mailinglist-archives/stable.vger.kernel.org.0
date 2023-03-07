Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D32C6AF147
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232807AbjCGSl7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:41:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232981AbjCGSlh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:41:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A90809966C
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:32:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3AE8B819D2
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:31:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C938C4339B;
        Tue,  7 Mar 2023 18:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213899;
        bh=pk1fJ71Ws6Sna2RKK2QmJ6j3WF2xsqDP4/Xz52YcsH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yI18HVyaaXWuRrhoZ/YdEn77+MbI+KYmQ/+Iq5bNFo0WDsWhDytwumx+ASzdgUGsf
         S3aMUIJddv555LWziPL7JGaWgETjfa6rU7pJZmBlr+wJ5ZWaYuTRa2Vqb7qZNQxNsh
         /5NGfruuY0x6nXpUyG3o6XuKIIMd0uig+httu9js=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 6.1 655/885] ipmi:ssif: resend_msg() cannot fail
Date:   Tue,  7 Mar 2023 17:59:49 +0100
Message-Id: <20230307170030.604679519@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

commit 95767ed78a181d5404202627499f9cde56053b96 upstream.

The resend_msg() function cannot fail, but there was error handling
around using it.  Rework the handling of the error, and fix the out of
retries debug reporting that was wrong around this, too.

Cc: stable@vger.kernel.org
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_ssif.c |   28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -602,7 +602,7 @@ static void ssif_alert(struct i2c_client
 		start_get(ssif_info);
 }
 
-static int start_resend(struct ssif_info *ssif_info);
+static void start_resend(struct ssif_info *ssif_info);
 
 static void msg_done_handler(struct ssif_info *ssif_info, int result,
 			     unsigned char *data, unsigned int len)
@@ -909,31 +909,17 @@ static void msg_written_handler(struct s
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
 
@@ -996,7 +982,7 @@ static void msg_written_handler(struct s
 	}
 }
 
-static int start_resend(struct ssif_info *ssif_info)
+static void start_resend(struct ssif_info *ssif_info)
 {
 	int command;
 
@@ -1021,7 +1007,6 @@ static int start_resend(struct ssif_info
 
 	ssif_i2c_send(ssif_info, msg_written_handler, I2C_SMBUS_WRITE,
 		   command, ssif_info->data, I2C_SMBUS_BLOCK_DATA);
-	return 0;
 }
 
 static int start_send(struct ssif_info *ssif_info,
@@ -1036,7 +1021,8 @@ static int start_send(struct ssif_info *
 	ssif_info->retries_left = SSIF_SEND_RETRIES;
 	memcpy(ssif_info->data + 1, data, len);
 	ssif_info->data_len = len;
-	return start_resend(ssif_info);
+	start_resend(ssif_info);
+	return 0;
 }
 
 /* Must be called with the message lock held. */


