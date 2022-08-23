Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6470C59D50E
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243083AbiHWIYo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243076AbiHWIWz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:22:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C03A719AD;
        Tue, 23 Aug 2022 01:13:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AFC7B61238;
        Tue, 23 Aug 2022 08:13:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB957C433D6;
        Tue, 23 Aug 2022 08:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242391;
        bh=38S++nijNcpJ8tbAFDQxNdFyX10pEPM5Z89mcFblEh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MAn59yQ/hnCRQdKBQCvgKPiIwVmjItI9aAHca88nix4/nZ/DHCeR4oJTg6f4TCsBh
         c3/XMhYQNfwxa3d6AaITM8xpeaX1ARDqodXlhhysH3tLLKqScNUGDERVSsdzOUYyYl
         to99PEXL3gCDdw11k514dtTBuxKf5jEJzS0g1e3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff LaBundy <jeff@labundy.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.19 108/365] Input: iqs7222 - handle reset during ATI
Date:   Tue, 23 Aug 2022 10:00:09 +0200
Message-Id: <20220823080122.709568867@linuxfoundation.org>
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

commit 8635c68891c6d786d644747d599c41bdf512fbbf upstream.

If the device suffers a spurious reset during ATI, there is no point
in enduring any further retries. Instead, simply return successfully
from the polling loop.

In this case, the interrupt handler will intervene and recognize the
device has been reset. It then proceeds to initialize the device and
trigger ATI once more.

As part of this change, swap the order of status field evaluation to
match that of the interrupt handler, and correct a nearby off-by-one
error that causes an error message to suggest the final attempt will
be retried.

Fixes: e505edaedcb9 ("Input: add support for Azoteq IQS7222A/B/C")
Signed-off-by: Jeff LaBundy <jeff@labundy.com>
Link: https://lore.kernel.org/r/20220626072412.475211-6-jeff@labundy.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/iqs7222.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/input/misc/iqs7222.c b/drivers/input/misc/iqs7222.c
index aa46f2cd4d34..e65260d290cc 100644
--- a/drivers/input/misc/iqs7222.c
+++ b/drivers/input/misc/iqs7222.c
@@ -1314,12 +1314,15 @@ static int iqs7222_ati_trigger(struct iqs7222_private *iqs7222)
 			if (error)
 				return error;
 
-			if (sys_status & IQS7222_SYS_STATUS_ATI_ACTIVE)
-				continue;
+			if (sys_status & IQS7222_SYS_STATUS_RESET)
+				return 0;
 
 			if (sys_status & IQS7222_SYS_STATUS_ATI_ERROR)
 				break;
 
+			if (sys_status & IQS7222_SYS_STATUS_ATI_ACTIVE)
+				continue;
+
 			/*
 			 * Use stream-in-touch mode if either slider reports
 			 * absolute position.
@@ -1336,7 +1339,7 @@ static int iqs7222_ati_trigger(struct iqs7222_private *iqs7222)
 		dev_err(&client->dev,
 			"ATI attempt %d of %d failed with status 0x%02X, %s\n",
 			i + 1, IQS7222_NUM_RETRIES, (u8)sys_status,
-			i < IQS7222_NUM_RETRIES ? "retrying..." : "stopping");
+			i + 1 < IQS7222_NUM_RETRIES ? "retrying" : "stopping");
 	}
 
 	return -ETIMEDOUT;
-- 
2.37.2



