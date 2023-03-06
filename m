Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6C016AB715
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 08:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbjCFH3F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 02:29:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbjCFH3E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 02:29:04 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9108B1C593
        for <stable@vger.kernel.org>; Sun,  5 Mar 2023 23:29:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BB5FACE0F02
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 07:28:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDAF5C433D2;
        Mon,  6 Mar 2023 07:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678087737;
        bh=PYGEvhEaUMO4BrlaB8Spa6QA1e7mLCo/N/nzRmdYTMc=;
        h=Subject:To:Cc:From:Date:From;
        b=xT4GMP4sO4I/zli6dypm3PV85x9QtIiS3zTA+PLEam1bM97d9uF7qlyk1xwkki5VC
         PHNxWJ9IL1BpGEbAoy8kth+QvUOzWXKosTqTtAqH/o2C026cfd5debWdh0efu2sv0c
         Yqj1CDWAvtdmGN2xkxU2JCVpaIg9XMaBdTsAIVeY=
Subject: WTF: patch "[PATCH] ipmi:ssif: Remove rtc_us_timer" was seriously submitted to be applied to the 5.15-stable tree?
To:     cminyard@mvista.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Mar 2023 08:28:54 +0100
Message-ID: <16780877348076@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below was submitted to be applied to the 5.15-stable tree.

I fail to see how this patch meets the stable kernel rules as found at
Documentation/process/stable-kernel-rules.rst.

I could be totally wrong, and if so, please respond to 
<stable@vger.kernel.org> and let me know why this patch should be
applied.  Otherwise, it is now dropped from my patch queues, never to be
seen again.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9e8b89926fb87e5625bdde6fd5de2c31fb1d83bf Mon Sep 17 00:00:00 2001
From: Corey Minyard <cminyard@mvista.com>
Date: Wed, 25 Jan 2023 10:41:48 -0600
Subject: [PATCH] ipmi:ssif: Remove rtc_us_timer

It was cruft left over from older handling of run to completion.

Cc: stable@vger.kernel.org
Signed-off-by: Corey Minyard <cminyard@mvista.com>

diff --git a/drivers/char/ipmi/ipmi_ssif.c b/drivers/char/ipmi/ipmi_ssif.c
index 5a377e86dade..c25c4b1a03ae 100644
--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -241,12 +241,6 @@ struct ssif_info {
 	 */
 	bool                req_flags;
 
-	/*
-	 * Used to perform timer operations when run-to-completion
-	 * mode is on.  This is a countdown timer.
-	 */
-	int                 rtc_us_timer;
-
 	/* Used for sending/receiving data.  +1 for the length. */
 	unsigned char data[IPMI_MAX_MSG_LENGTH + 1];
 	unsigned int  data_len;
@@ -530,7 +524,6 @@ static void msg_done_handler(struct ssif_info *ssif_info, int result,
 
 static void start_get(struct ssif_info *ssif_info)
 {
-	ssif_info->rtc_us_timer = 0;
 	ssif_info->multi_pos = 0;
 
 	ssif_i2c_send(ssif_info, msg_done_handler, I2C_SMBUS_READ,
@@ -622,7 +615,6 @@ static void msg_done_handler(struct ssif_info *ssif_info, int result,
 
 			flags = ipmi_ssif_lock_cond(ssif_info, &oflags);
 			ssif_info->waiting_alert = true;
-			ssif_info->rtc_us_timer = SSIF_MSG_USEC;
 			if (!ssif_info->stopping)
 				mod_timer(&ssif_info->retry_timer,
 					  jiffies + SSIF_MSG_JIFFIES);
@@ -973,7 +965,6 @@ static void msg_written_handler(struct ssif_info *ssif_info, int result,
 			/* Wait a jiffie then request the next message */
 			ssif_info->waiting_alert = true;
 			ssif_info->retries_left = SSIF_RECV_RETRIES;
-			ssif_info->rtc_us_timer = SSIF_MSG_PART_USEC;
 			if (!ssif_info->stopping)
 				mod_timer(&ssif_info->retry_timer,
 					  jiffies + SSIF_MSG_PART_JIFFIES);

