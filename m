Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13FC7657B9F
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233680AbiL1PXp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:23:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233704AbiL1PXj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:23:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13FA413FB7
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:23:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BF4D6154D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:23:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0521C433D2;
        Wed, 28 Dec 2022 15:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241018;
        bh=rLgqm8AkjtP/pV7MG2SgnIVdxklTuEQ4QmDrLwU8k/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p8BpMW7I5Z03Rv+as2C2mmWVVZgCTVHrQXkNL9KZED9NY2oyoXy22l8be7RPEQrJe
         XoHast8QsJtHjKnhZ/yN7WW5VPaXGjclnu179+QdMWP0u2o8vhV5ZHk8lTrRF7VGr+
         Pz9rgitExlvnhSktRrXE+KkIxvYGl3q5rWsywnuQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Mike Marshall <hubcap@omnibond.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 428/731] orangefs: Fix sysfs not cleanup when dev init failed
Date:   Wed, 28 Dec 2022 15:38:55 +0100
Message-Id: <20221228144308.971890979@linuxfoundation.org>
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
index cd7297815f91..5ab741c60b7e 100644
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



