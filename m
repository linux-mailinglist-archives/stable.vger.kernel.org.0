Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C991B6B463D
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232766AbjCJOl1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:41:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232762AbjCJOl0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:41:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B055F11F609
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:41:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 176D4B822DA
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:41:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DB1FC433D2;
        Fri, 10 Mar 2023 14:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459281;
        bh=3nnSUJu64yALl54e7NXN/0askP7tTzkb4OppPgDzs1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qBx8QqG+qNFF3Ay65iGZYymqGUdnafg5wzlv4ewpPllDenhNbDriwRyKdB5Ij8EF+
         M2GkQRHGpDTm9lx6p1bgHPL1uOfbLZgiG0KH8PT22IlVx5begpZq0A9dwom0Impbzp
         kRQgzCFTMP3YqEhO8LhhkHYxFGyF3y+W7qHg6LM4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen Jun <chenjun102@huawei.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 309/357] watchdog: Fix kmemleak in watchdog_cdev_register
Date:   Fri, 10 Mar 2023 14:39:58 +0100
Message-Id: <20230310133748.335808167@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,WEIRD_QUOTING autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Jun <chenjun102@huawei.com>

[ Upstream commit 13721a2ac66b246f5802ba1b75ad8637e53eeecc ]

kmemleak reports memory leaks in watchdog_dev_register, as follows:
unreferenced object 0xffff888116233000 (size 2048):
  comm ""modprobe"", pid 28147, jiffies 4353426116 (age 61.741s)
  hex dump (first 32 bytes):
    80 fa b9 05 81 88 ff ff 08 30 23 16 81 88 ff ff  .........0#.....
    08 30 23 16 81 88 ff ff 00 00 00 00 00 00 00 00  .0#.............
  backtrace:
    [<000000007f001ffd>] __kmem_cache_alloc_node+0x157/0x220
    [<000000006a389304>] kmalloc_trace+0x21/0x110
    [<000000008d640eea>] watchdog_dev_register+0x4e/0x780 [watchdog]
    [<0000000053c9f248>] __watchdog_register_device+0x4f0/0x680 [watchdog]
    [<00000000b2979824>] watchdog_register_device+0xd2/0x110 [watchdog]
    [<000000001f730178>] 0xffffffffc10880ae
    [<000000007a1a8bcc>] do_one_initcall+0xcb/0x4d0
    [<00000000b98be325>] do_init_module+0x1ca/0x5f0
    [<0000000046d08e7c>] load_module+0x6133/0x70f0
    ...

unreferenced object 0xffff888105b9fa80 (size 16):
  comm ""modprobe"", pid 28147, jiffies 4353426116 (age 61.741s)
  hex dump (first 16 bytes):
    77 61 74 63 68 64 6f 67 31 00 b9 05 81 88 ff ff  watchdog1.......
  backtrace:
    [<000000007f001ffd>] __kmem_cache_alloc_node+0x157/0x220
    [<00000000486ab89b>] __kmalloc_node_track_caller+0x44/0x1b0
    [<000000005a39aab0>] kvasprintf+0xb5/0x140
    [<0000000024806f85>] kvasprintf_const+0x55/0x180
    [<000000009276cb7f>] kobject_set_name_vargs+0x56/0x150
    [<00000000a92e820b>] dev_set_name+0xab/0xe0
    [<00000000cec812c6>] watchdog_dev_register+0x285/0x780 [watchdog]
    [<0000000053c9f248>] __watchdog_register_device+0x4f0/0x680 [watchdog]
    [<00000000b2979824>] watchdog_register_device+0xd2/0x110 [watchdog]
    [<000000001f730178>] 0xffffffffc10880ae
    [<000000007a1a8bcc>] do_one_initcall+0xcb/0x4d0
    [<00000000b98be325>] do_init_module+0x1ca/0x5f0
    [<0000000046d08e7c>] load_module+0x6133/0x70f0
    ...

The reason is that put_device is not be called if cdev_device_add fails
and wdd->id != 0.

watchdog_cdev_register
  wd_data = kzalloc                             [1]
  err = dev_set_name                            [2]
  ..
  err = cdev_device_add
  if (err) {
    if (wdd->id == 0) {  // wdd->id != 0
      ..
    }
    return err;  // [1],[2] would be leaked

To fix it, call put_device in all wdd->id cases.

Fixes: 72139dfa2464 ("watchdog: Fix the race between the release of watchdog_core_data and cdev")
Signed-off-by: Chen Jun <chenjun102@huawei.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20221116012714.102066-1-chenjun102@huawei.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/watchdog_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index 8494846ccdc5f..c670d13ab3d98 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -1016,8 +1016,8 @@ static int watchdog_cdev_register(struct watchdog_device *wdd)
 		if (wdd->id == 0) {
 			misc_deregister(&watchdog_miscdev);
 			old_wd_data = NULL;
-			put_device(&wd_data->dev);
 		}
+		put_device(&wd_data->dev);
 		return err;
 	}
 
-- 
2.39.2



