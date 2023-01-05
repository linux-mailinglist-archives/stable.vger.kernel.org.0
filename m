Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A41E965EBCE
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 14:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233936AbjAENC5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 08:02:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234045AbjAENCh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 08:02:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 536125C1E5
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 05:02:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE379B81ABD
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 13:02:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 482D7C433A0;
        Thu,  5 Jan 2023 13:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672923752;
        bh=1zy/BPmX50DOg23jDiFX3vgNiuQxu2tpl8MGQsJcfBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wJHbGuELkgeWDBQJorLMjts3TOB16f4VjHy5w8u5FMin8kC4O/e3B5hfS/XUongAv
         JUjIDqXoBt3b8QXJZatTG5cDhUW2pewzQnu46DsVjKFFKYGyuj0kIPcNP9JLCdh/WS
         jFziouHbwG3XiUy8/JuhiIB2XdCZ2FHsjn8ATeBM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Mike Marshall <hubcap@omnibond.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 121/251] orangefs: Fix sysfs not cleanup when dev init failed
Date:   Thu,  5 Jan 2023 13:54:18 +0100
Message-Id: <20230105125340.368226148@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
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
index 4113eb0495bf..74b8ee19e167 100644
--- a/fs/orangefs/orangefs-mod.c
+++ b/fs/orangefs/orangefs-mod.c
@@ -147,7 +147,7 @@ static int __init orangefs_init(void)
 		gossip_err("%s: could not initialize device subsystem %d!\n",
 			   __func__,
 			   ret);
-		goto cleanup_device;
+		goto cleanup_sysfs;
 	}
 
 	ret = register_filesystem(&orangefs_fs_type);
@@ -159,11 +159,11 @@ static int __init orangefs_init(void)
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
 
 debugfs_init_failed:
-- 
2.35.1



