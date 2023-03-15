Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD956BB245
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbjCOMe7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232671AbjCOMeW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:34:22 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B91637E0
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:33:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2208CCE19BE
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:33:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 225E6C4339C;
        Wed, 15 Mar 2023 12:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883580;
        bh=SMSKeoY7EIQLFnWVZAvQCxTdxHh66/3Na1W7rW+5Prc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tyHvF3vtXQPdSsveRDs0Kt7/QitVAPROhqN0H6liGK/62GuZeBHgpw6OSRx4X1Ogj
         uBzwuJnzyvtZ6f8Wzy3DctMdgC2a4g9Vfd9j5sjC7YX12eBuhcwfDelxi1zH5bu349
         7JBCdFEhS7QJClIBpF2UuyBubpPwTM8ffDA9NJgQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Corey Minyard <cminyard@mvista.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 045/143] ipmi:ssif: Remove rtc_us_timer
Date:   Wed, 15 Mar 2023 13:12:11 +0100
Message-Id: <20230315115741.888198129@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
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

[ Upstream commit 9e8b89926fb87e5625bdde6fd5de2c31fb1d83bf ]

It was cruft left over from older handling of run to completion.

Cc: stable@vger.kernel.org
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_ssif.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_ssif.c b/drivers/char/ipmi/ipmi_ssif.c
index 7c606c49cd535..cbd56886f1d2a 100644
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
-- 
2.39.2



