Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EECA667418
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbjALOC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:02:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232248AbjALOCY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:02:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08BEBAD
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:02:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 726A5B81E69
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:02:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B90E4C433EF;
        Thu, 12 Jan 2023 14:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532141;
        bh=Z7szx7nv9/ZhYqW5Xx7P07tPxKNPHxi/eckVveVCHTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yd7U95U3CNk0OocSKKXcQe24neotwLS7rvwfALFct6l4S8N2OqTKhEpkTh0DrvKKN
         FqQQ/NNGqPH4CDe4f/0R2hD4K8qQFD/w/dYjUiOifO3EfvgzMQdwnynSDSVarEpAz2
         XzQjhj2Y3KYv4ZN2DIkyl+HBtjgXfG2oZ+WAKPtw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Brian Norris <briannorris@chromium.org>,
        Prashant Malani <pmalani@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 065/783] platform/chrome: cros_usbpd_notify: Fix error handling in cros_usbpd_notify_init()
Date:   Thu, 12 Jan 2023 14:46:21 +0100
Message-Id: <20230112135527.156403299@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index 7f36142ab12a..19390147ac9d 100644
--- a/drivers/platform/chrome/cros_usbpd_notify.c
+++ b/drivers/platform/chrome/cros_usbpd_notify.c
@@ -284,7 +284,11 @@ static int __init cros_usbpd_notify_init(void)
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



