Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5924559D468
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242985AbiHWIWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243815AbiHWIVp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:21:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 142C571710;
        Tue, 23 Aug 2022 01:12:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7D4D61257;
        Tue, 23 Aug 2022 08:12:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 958B7C433C1;
        Tue, 23 Aug 2022 08:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242376;
        bh=GFnhoxaTGoTm1J3lmH2NGiDtxJLMkYd3wy08OGGiKXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R1t7+qWbtVosd55pTWR9kXtw6aenYmzsUU2gTLrlomRLOE17PFxAjIbmPW2XJ1NyH
         aUpokut1SYKtqn22YA1g3sGvA4ILzv0g/PX4IyKYV/gjgF4JPtEMBjbEyAx2qORHrX
         Fa/ZMry+EB6Ekg/rpF0TJ7UQ4x2beOng80ujQSik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff LaBundy <jeff@labundy.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.19 106/365] Input: iqs7222 - protect volatile registers
Date:   Tue, 23 Aug 2022 10:00:07 +0200
Message-Id: <20220823080122.627203716@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff LaBundy <jeff@labundy.com>

commit 1e4189d8af2749e2db406f92bdc4abccbab63138 upstream.

Select variants of silicon silently mirror part of the event mask
register to the system setup register (0xD0), and vice versa. For
the following sequence:

1. Read registers 0xD0 onward and store their contents.
2. Modify the contents, including event mask fields.
3. Write registers 0xD0 onward with the modified contents.
4. Write register 0xD0 on its own again later, using the contents
   from step 1 to populate any reserved fields.

...the event mask register (e.g. address 0xDA) has been corrupted
by writing register 0xD0 with contents that were made stale after
step 3.

To solve this problem, read register 0xD0 once more between steps
3 and 4. When register 0xD0 is written during step 4, the portion
which is mirrored to the event mask register already matches what
was written in step 3.

Fixes: e505edaedcb9 ("Input: add support for Azoteq IQS7222A/B/C")
Signed-off-by: Jeff LaBundy <jeff@labundy.com>
Link: https://lore.kernel.org/r/20220626072412.475211-4-jeff@labundy.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/iqs7222.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/input/misc/iqs7222.c b/drivers/input/misc/iqs7222.c
index 57616a7ebeae..c46d3c8f0230 100644
--- a/drivers/input/misc/iqs7222.c
+++ b/drivers/input/misc/iqs7222.c
@@ -1274,9 +1274,22 @@ static int iqs7222_ati_trigger(struct iqs7222_private *iqs7222)
 	struct i2c_client *client = iqs7222->client;
 	ktime_t ati_timeout;
 	u16 sys_status = 0;
-	u16 sys_setup = iqs7222->sys_setup[0] & ~IQS7222_SYS_SETUP_ACK_RESET;
+	u16 sys_setup;
 	int error, i;
 
+	/*
+	 * The reserved fields of the system setup register may have changed
+	 * as a result of other registers having been written. As such, read
+	 * the register's latest value to avoid unexpected behavior when the
+	 * register is written in the loop that follows.
+	 */
+	error = iqs7222_read_word(iqs7222, IQS7222_SYS_SETUP, &sys_setup);
+	if (error)
+		return error;
+
+	sys_setup &= ~IQS7222_SYS_SETUP_INTF_MODE_MASK;
+	sys_setup &= ~IQS7222_SYS_SETUP_PWR_MODE_MASK;
+
 	for (i = 0; i < IQS7222_NUM_RETRIES; i++) {
 		/*
 		 * Trigger ATI from streaming and normal-power modes so that
@@ -2241,9 +2254,6 @@ static int iqs7222_parse_all(struct iqs7222_private *iqs7222)
 			return error;
 	}
 
-	sys_setup[0] &= ~IQS7222_SYS_SETUP_INTF_MODE_MASK;
-	sys_setup[0] &= ~IQS7222_SYS_SETUP_PWR_MODE_MASK;
-
 	sys_setup[0] |= IQS7222_SYS_SETUP_ACK_RESET;
 
 	return iqs7222_parse_props(iqs7222, NULL, 0, IQS7222_REG_GRP_SYS,
-- 
2.37.2



