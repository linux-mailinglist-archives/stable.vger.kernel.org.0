Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FEFA65786B
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233139AbiL1Ou3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:50:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233117AbiL1OuU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:50:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12FB11C14
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C93761365
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F48CC433EF;
        Wed, 28 Dec 2022 14:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239016;
        bh=rMCigio10321HoUB6g+Ix0Omaua0lh61YivxJcqtbdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tJ2uOMJhzvaORJg9RTUHzK9qs+kL/ih1XHLoW6vA3Og0Oz2MHodaEYiNDsV+3kk5k
         9ey16tvyCDFe2JmFSmYP5u9B5z5kcxD1H+twXmXI3vJWEYfktrTtGgU+Ph2k27vFh4
         YQSuMR2QLb3olm0WHfkIgXif1Pm2vyd2n5tq3So8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Brian Norris <briannorris@chromium.org>,
        Prashant Malani <pmalani@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 097/731] platform/chrome: cros_usbpd_notify: Fix error handling in cros_usbpd_notify_init()
Date:   Wed, 28 Dec 2022 15:33:24 +0100
Message-Id: <20221228144259.362228815@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 5a2d96623670155d94aca72c320c0ac27bdc6bd2 ]

The following WARNING message was given when rmmod cros_usbpd_notify:

 Unexpected driver unregister!
 WARNING: CPU: 0 PID: 253 at drivers/base/driver.c:270 driver_unregister+0x8a/0xb0
 Modules linked in: cros_usbpd_notify(-)
 CPU: 0 PID: 253 Comm: rmmod Not tainted 6.1.0-rc3 #24
 ...
 Call Trace:
  <TASK>
  cros_usbpd_notify_exit+0x11/0x1e [cros_usbpd_notify]
  __x64_sys_delete_module+0x3c7/0x570
  ? __ia32_sys_delete_module+0x570/0x570
  ? lock_is_held_type+0xe3/0x140
  ? syscall_enter_from_user_mode+0x17/0x50
  ? rcu_read_lock_sched_held+0xa0/0xd0
  ? syscall_enter_from_user_mode+0x1c/0x50
  do_syscall_64+0x37/0x90
  entry_SYSCALL_64_after_hwframe+0x63/0xcd
 RIP: 0033:0x7f333fe9b1b7

The reason is that the cros_usbpd_notify_init() does not check the return
value of platform_driver_register(), and the cros_usbpd_notify can
install successfully even if platform_driver_register() failed.

Fix by checking the return value of platform_driver_register() and
unregister cros_usbpd_notify_plat_driver when it failed.

Fixes: ec2daf6e33f9 ("platform: chrome: Add cros-usbpd-notify driver")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Reviewed-by: Brian Norris <briannorris@chromium.org>
Link: https://lore.kernel.org/r/20221117080823.77549-1-yuancan@huawei.com
Signed-off-by: Prashant Malani <pmalani@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_usbpd_notify.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/chrome/cros_usbpd_notify.c b/drivers/platform/chrome/cros_usbpd_notify.c
index 48a6617aa12f..de76de6f5090 100644
--- a/drivers/platform/chrome/cros_usbpd_notify.c
+++ b/drivers/platform/chrome/cros_usbpd_notify.c
@@ -285,7 +285,11 @@ static int __init cros_usbpd_notify_init(void)
 		return ret;
 
 #ifdef CONFIG_ACPI
-	platform_driver_register(&cros_usbpd_notify_acpi_driver);
+	ret = platform_driver_register(&cros_usbpd_notify_acpi_driver);
+	if (ret) {
+		platform_driver_unregister(&cros_usbpd_notify_plat_driver);
+		return ret;
+	}
 #endif
 	return 0;
 }
-- 
2.35.1



