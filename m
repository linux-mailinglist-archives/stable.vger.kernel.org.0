Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3276C6AEBEF
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbjCGRuf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:50:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232183AbjCGRuL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:50:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E0BC95442
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:44:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF055614B5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:44:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E82A0C433EF;
        Tue,  7 Mar 2023 17:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211095;
        bh=pk1fJ71Ws6Sna2RKK2QmJ6j3WF2xsqDP4/Xz52YcsH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0SuHCQcQ8urOEAy8e5lg7ksoEhE/X0TmloBG9Syw+hoZQ1N7IMCgKsVQlxA19Zqa5
         nEKdcfXMdJmvbwpGs1uHyc0s/Gn24yHAMDo+TaYpDmr74lKihM1vKL/7TtTPYbyMWc
         eXiEksIzAL4xG1Kg0nGAHhti328yElO4Ff+RAflA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 6.2 0751/1001] ipmi:ssif: resend_msg() cannot fail
Date:   Tue,  7 Mar 2023 17:58:43 +0100
Message-Id: <20230307170054.304684749@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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


