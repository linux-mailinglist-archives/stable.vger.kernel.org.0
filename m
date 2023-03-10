Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 395C26B4173
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbjCJNxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:53:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbjCJNxG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:53:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD187115B56
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:52:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 499FDB822BC
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:52:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C98C4339B;
        Fri, 10 Mar 2023 13:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456372;
        bh=29jfQwKbDaUrriBuAjiATQoD9L4W9jjCH5WVLdDXLMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GBcmeVMweN1/Xh9jLfjAiLLvURmpf2hA8pVCfnhu+12W1SkwSl4UcZMwCPGJMY4/w
         /2iASgnsGdc1tKfwB+BxRXl6GBSbb/3X8ND9XVl6WpnDB3ev0sKJhVNQaQMFYrCqcv
         L98jmpPrRYW+1FBDlwKgeMhNHSiu4pOV7qXH102Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Li Hua <hucool.lihua@huawei.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 167/193] watchdog: pcwd_usb: Fix attempting to access uninitialized memory
Date:   Fri, 10 Mar 2023 14:39:09 +0100
Message-Id: <20230310133716.698382879@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
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

From: Li Hua <hucool.lihua@huawei.com>

[ Upstream commit 7d06c07c67100fd0f8e6b3ab7145ce789f788117 ]

The stack variable msb and lsb may be used uninitialized in function
usb_pcwd_get_temperature and usb_pcwd_get_timeleft when usb card no response.

The build waring is:
drivers/watchdog/pcwd_usb.c:336:22: error: ‘lsb’ is used uninitialized in this function [-Werror=uninitialized]
  *temperature = (lsb * 9 / 5) + 32;
                  ~~~~^~~
drivers/watchdog/pcwd_usb.c:328:21: note: ‘lsb’ was declared here
  unsigned char msb, lsb;
                     ^~~
cc1: all warnings being treated as errors
scripts/Makefile.build:250: recipe for target 'drivers/watchdog/pcwd_usb.o' failed
make[3]: *** [drivers/watchdog/pcwd_usb.o] Error 1

Fixes: b7e04f8c61a4 ("mv watchdog tree under drivers")
Signed-off-by: Li Hua <hucool.lihua@huawei.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20221116020706.70847-1-hucool.lihua@huawei.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/pcwd_usb.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/pcwd_usb.c b/drivers/watchdog/pcwd_usb.c
index b9e376c8e2e36..277ecfdf09c09 100644
--- a/drivers/watchdog/pcwd_usb.c
+++ b/drivers/watchdog/pcwd_usb.c
@@ -330,7 +330,8 @@ static int usb_pcwd_set_heartbeat(struct usb_pcwd_private *usb_pcwd, int t)
 static int usb_pcwd_get_temperature(struct usb_pcwd_private *usb_pcwd,
 							int *temperature)
 {
-	unsigned char msb, lsb;
+	unsigned char msb = 0x00;
+	unsigned char lsb = 0x00;
 
 	usb_pcwd_send_command(usb_pcwd, CMD_READ_TEMP, &msb, &lsb);
 
@@ -346,7 +347,8 @@ static int usb_pcwd_get_temperature(struct usb_pcwd_private *usb_pcwd,
 static int usb_pcwd_get_timeleft(struct usb_pcwd_private *usb_pcwd,
 								int *time_left)
 {
-	unsigned char msb, lsb;
+	unsigned char msb = 0x00;
+	unsigned char lsb = 0x00;
 
 	/* Read the time that's left before rebooting */
 	/* Note: if the board is not yet armed then we will read 0xFFFF */
-- 
2.39.2



