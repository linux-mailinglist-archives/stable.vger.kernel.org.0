Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD86B6675D0
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236667AbjALOZu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:25:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236717AbjALOY7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:24:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 294F25B4AE
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:16:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8481B62030
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:16:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9758EC433F0;
        Thu, 12 Jan 2023 14:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532992;
        bh=rPXhFW3iP8wcv33J8I94N8ji7gBHiigbT00HJz5d5so=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cn/tlzNfwPod3414x87ZA7+W24TKXIG5Ppsg8wO2ada2leX9xSdk8QCF4sCiXWDzj
         Mr7pv31jsEkov58cfyqs+/qEBE010MGH0IptFDmkNwsHl1nIDhmWQTp7k+g5ZL8fmU
         1fMt2AsV7TzLARyNiObl5eylzojebMCXWkyHUd8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Mike Marshall <hubcap@omnibond.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 334/783] orangefs: Fix sysfs not cleanup when dev init failed
Date:   Thu, 12 Jan 2023 14:50:50 +0100
Message-Id: <20230112135539.786015427@linuxfoundation.org>
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

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

[ Upstream commit ea60a4ad0cf88b411cde6888b8c890935686ecd7 ]

When the dev init failed, should cleanup the sysfs, otherwise, the
module will never be loaded since can not create duplicate sysfs
directory:

  sysfs: cannot create duplicate filename '/fs/orangefs'

  CPU: 1 PID: 6549 Comm: insmod Tainted: G        W          6.0.0+ #44
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-1.fc33 04/01/2014
  Call Trace:
   <TASK>
   dump_stack_lvl+0x34/0x44
   sysfs_warn_dup.cold+0x17/0x24
   sysfs_create_dir_ns+0x16d/0x180
   kobject_add_internal+0x156/0x3a0
   kobject_init_and_add+0xcf/0x120
   orangefs_sysfs_init+0x7e/0x3a0 [orangefs]
   orangefs_init+0xfe/0x1000 [orangefs]
   do_one_initcall+0x87/0x2a0
   do_init_module+0xdf/0x320
   load_module+0x2f98/0x3330
   __do_sys_finit_module+0x113/0x1b0
   do_syscall_64+0x35/0x80
   entry_SYSCALL_64_after_hwframe+0x46/0xb0

  kobject_add_internal failed for orangefs with -EEXIST, don't try to register things with the same name in the same directory.

Fixes: 2f83ace37181 ("orangefs: put register_chrdev immediately before register_filesystem")
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Mike Marshall <hubcap@omnibond.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/orangefs/orangefs-mod.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/orangefs/orangefs-mod.c b/fs/orangefs/orangefs-mod.c
index 74a3d6337ef4..ac9c91b83868 100644
--- a/fs/orangefs/orangefs-mod.c
+++ b/fs/orangefs/orangefs-mod.c
@@ -141,7 +141,7 @@ static int __init orangefs_init(void)
 		gossip_err("%s: could not initialize device subsystem %d!\n",
 			   __func__,
 			   ret);
-		goto cleanup_device;
+		goto cleanup_sysfs;
 	}
 
 	ret = register_filesystem(&orangefs_fs_type);
@@ -152,11 +152,11 @@ static int __init orangefs_init(void)
 		goto out;
 	}
 
-	orangefs_sysfs_exit();
-
-cleanup_device:
 	orangefs_dev_cleanup();
 
+cleanup_sysfs:
+	orangefs_sysfs_exit();
+
 sysfs_init_failed:
 	orangefs_debugfs_cleanup();
 
-- 
2.35.1



