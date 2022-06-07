Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A40B5422D7
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 08:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350675AbiFHBOC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 21:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386262AbiFHAWO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 20:22:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB1E2534E5;
        Tue,  7 Jun 2022 12:18:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C19061946;
        Tue,  7 Jun 2022 19:18:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 171DEC3411F;
        Tue,  7 Jun 2022 19:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629499;
        bh=TfVAttrvXj6xBoZbyo1DigeleGJtip5LNnK90MflEYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lBtXNos8hhBq+h4wqChYMps40EfWw7dlxH4P6vs6IaYgOwDtMIC13BnxU90BQkz62
         PikE7ZUm19TnMywF/b8N2AVXo9xsH5g2bE8g0AM/qjg0xmg5EXCuVLQFOVzk+cFlb7
         iWqLY0sF0rTSSZK8Od8EklPKqLmtczHfQ1Ixg3Jg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.18 712/879] f2fs: dont need inode lock for system hidden quota
Date:   Tue,  7 Jun 2022 19:03:50 +0200
Message-Id: <20220607165023.520675180@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

commit 6213f5d4d23c50d393a31dc8e351e63a1fd10dbe upstream.

Let's avoid false-alarmed lockdep warning.

[   58.914674] [T1501146] -> #2 (&sb->s_type->i_mutex_key#20){+.+.}-{3:3}:
[   58.915975] [T1501146] system_server:        down_write+0x7c/0xe0
[   58.916738] [T1501146] system_server:        f2fs_quota_sync+0x60/0x1a8
[   58.917563] [T1501146] system_server:        block_operations+0x16c/0x43c
[   58.918410] [T1501146] system_server:        f2fs_write_checkpoint+0x114/0x318
[   58.919312] [T1501146] system_server:        f2fs_issue_checkpoint+0x178/0x21c
[   58.920214] [T1501146] system_server:        f2fs_sync_fs+0x48/0x6c
[   58.920999] [T1501146] system_server:        f2fs_do_sync_file+0x334/0x738
[   58.921862] [T1501146] system_server:        f2fs_sync_file+0x30/0x48
[   58.922667] [T1501146] system_server:        __arm64_sys_fsync+0x84/0xf8
[   58.923506] [T1501146] system_server:        el0_svc_common.llvm.12821150825140585682+0xd8/0x20c
[   58.924604] [T1501146] system_server:        do_el0_svc+0x28/0xa0
[   58.925366] [T1501146] system_server:        el0_svc+0x24/0x38
[   58.926094] [T1501146] system_server:        el0_sync_handler+0x88/0xec
[   58.926920] [T1501146] system_server:        el0_sync+0x1b4/0x1c0

[   58.927681] [T1501146] -> #1 (&sbi->cp_global_sem){+.+.}-{3:3}:
[   58.928889] [T1501146] system_server:        down_write+0x7c/0xe0
[   58.929650] [T1501146] system_server:        f2fs_write_checkpoint+0xbc/0x318
[   58.930541] [T1501146] system_server:        f2fs_issue_checkpoint+0x178/0x21c
[   58.931443] [T1501146] system_server:        f2fs_sync_fs+0x48/0x6c
[   58.932226] [T1501146] system_server:        sync_filesystem+0xac/0x130
[   58.933053] [T1501146] system_server:        generic_shutdown_super+0x38/0x150
[   58.933958] [T1501146] system_server:        kill_block_super+0x24/0x58
[   58.934791] [T1501146] system_server:        kill_f2fs_super+0xcc/0x124
[   58.935618] [T1501146] system_server:        deactivate_locked_super+0x90/0x120
[   58.936529] [T1501146] system_server:        deactivate_super+0x74/0xac
[   58.937356] [T1501146] system_server:        cleanup_mnt+0x128/0x168
[   58.938150] [T1501146] system_server:        __cleanup_mnt+0x18/0x28
[   58.938944] [T1501146] system_server:        task_work_run+0xb8/0x14c
[   58.939749] [T1501146] system_server:        do_notify_resume+0x114/0x1e8
[   58.940595] [T1501146] system_server:        work_pending+0xc/0x5f0

[   58.941375] [T1501146] -> #0 (&sbi->gc_lock){+.+.}-{3:3}:
[   58.942519] [T1501146] system_server:        __lock_acquire+0x1270/0x2868
[   58.943366] [T1501146] system_server:        lock_acquire+0x114/0x294
[   58.944169] [T1501146] system_server:        down_write+0x7c/0xe0
[   58.944930] [T1501146] system_server:        f2fs_issue_checkpoint+0x13c/0x21c
[   58.945831] [T1501146] system_server:        f2fs_sync_fs+0x48/0x6c
[   58.946614] [T1501146] system_server:        f2fs_do_sync_file+0x334/0x738
[   58.947472] [T1501146] system_server:        f2fs_ioc_commit_atomic_write+0xc8/0x14c
[   58.948439] [T1501146] system_server:        __f2fs_ioctl+0x674/0x154c
[   58.949253] [T1501146] system_server:        f2fs_ioctl+0x54/0x88
[   58.950018] [T1501146] system_server:        __arm64_sys_ioctl+0xa8/0x110
[   58.950865] [T1501146] system_server:        el0_svc_common.llvm.12821150825140585682+0xd8/0x20c
[   58.951965] [T1501146] system_server:        do_el0_svc+0x28/0xa0
[   58.952727] [T1501146] system_server:        el0_svc+0x24/0x38
[   58.953454] [T1501146] system_server:        el0_sync_handler+0x88/0xec
[   58.954279] [T1501146] system_server:        el0_sync+0x1b4/0x1c0

Cc: stable@vger.kernel.org
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/super.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2684,7 +2684,8 @@ int f2fs_quota_sync(struct super_block *
 		if (!sb_has_quota_active(sb, cnt))
 			continue;
 
-		inode_lock(dqopt->files[cnt]);
+		if (!f2fs_sb_has_quota_ino(sbi))
+			inode_lock(dqopt->files[cnt]);
 
 		/*
 		 * do_quotactl
@@ -2703,7 +2704,8 @@ int f2fs_quota_sync(struct super_block *
 		f2fs_up_read(&sbi->quota_sem);
 		f2fs_unlock_op(sbi);
 
-		inode_unlock(dqopt->files[cnt]);
+		if (!f2fs_sb_has_quota_ino(sbi))
+			inode_unlock(dqopt->files[cnt]);
 
 		if (ret)
 			break;


