Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB1106B41E0
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbjCJN5k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:57:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231347AbjCJN5i (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:57:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC54F112DDC
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:57:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E03EB822BD
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:56:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D5DC433D2;
        Fri, 10 Mar 2023 13:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456615;
        bh=n1qF7fzpWNzZ5zZTD0zbhX1zKEYefHOlgum6rwpaJD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p6256oIdC8ABzCIM6YM8yzsznZOjniD3xJoWI6PLjO/rc67nneH+ZzaqXx/d873xe
         ByjT84aPael6zKfb9qmbTRCWqKnXKBOqNQmxDIpZVOhOMsEPM/hqFjGUnkGlwiQ58m
         /ASxATQYMwHP1I7Z2z7eXNG90F1YDJW35EP44kWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Li Hua <hucool.lihua@huawei.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 064/211] watchdog: pcwd_usb: Fix attempting to access uninitialized memory
Date:   Fri, 10 Mar 2023 14:37:24 +0100
Message-Id: <20230310133720.683151575@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
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
index 1bdaf17c1d38d..8202f0a6b0935 100644
--- a/drivers/watchdog/pcwd_usb.c
+++ b/drivers/watchdog/pcwd_usb.c
@@ -325,7 +325,8 @@ static int usb_pcwd_set_heartbeat(struct usb_pcwd_private *usb_pcwd, int t)
 static int usb_pcwd_get_temperature(struct usb_pcwd_private *usb_pcwd,
 							int *temperature)
 {
-	unsigned char msb, lsb;
+	unsigned char msb = 0x00;
+	unsigned char lsb = 0x00;
 
 	usb_pcwd_send_command(usb_pcwd, CMD_READ_TEMP, &msb, &lsb);
 
@@ -341,7 +342,8 @@ static int usb_pcwd_get_temperature(struct usb_pcwd_private *usb_pcwd,
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



