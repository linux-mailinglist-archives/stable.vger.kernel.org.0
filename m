Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9AF7656F21
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 21:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbiL0UjR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 15:39:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232682AbiL0Uii (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 15:38:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82CF4E0B8;
        Tue, 27 Dec 2022 12:34:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B0AD6123F;
        Tue, 27 Dec 2022 20:34:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A16C43392;
        Tue, 27 Dec 2022 20:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672173280;
        bh=YQhg182uYpGCBsVQ3a/3AtAc0htyKC1l3moVvFwn7N0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FtmhXpXski+GH+NTkbYpqj17TRzbhhFbw2kgxPFTn7w41MWiqiaqPu8tDu9x18ORe
         QLJfawwS/77eTSB+1CA5tfRjTUFWeq3K9BF5rBv25KUmKjEpO+dGsx4PXlym/m35xX
         Un9js5erU64OB47OWESmQ94isjUnUZRnfdjTVmIjgz+Wq4b05Bo0vzEG+07A5WghQg
         3FkBuZSYTuUk5aofoDWf+F92YsqUNUNIWks7vOOGwisX1hPpLSurD2+uQvZmcGIGG8
         6zXU6BtLw+CNS6+Fe7eHVMI1M1HFjWTQnEFNoUOse1O5dumgop127VE7TwICIfAm/v
         9jOnGa2lIhtag==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shigeru Yoshida <syoshida@redhat.com>,
        syzbot+9d67170b20e8f94351c8@syzkaller.appspotmail.com,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Sasha Levin <sashal@kernel.org>, ntfs3@lists.linux.dev
Subject: [PATCH AUTOSEL 5.15 05/22] fs/ntfs3: Fix memory leak on ntfs_fill_super() error path
Date:   Tue, 27 Dec 2022 15:34:15 -0500
Message-Id: <20221227203433.1214255-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221227203433.1214255-1-sashal@kernel.org>
References: <20221227203433.1214255-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shigeru Yoshida <syoshida@redhat.com>

[ Upstream commit 51e76a232f8c037f1d9e9922edc25b003d5f3414 ]

syzbot reported kmemleak as below:

BUG: memory leak
unreferenced object 0xffff8880122f1540 (size 32):
  comm "a.out", pid 6664, jiffies 4294939771 (age 25.500s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 ed ff ed ff 00 00 00 00  ................
  backtrace:
    [<ffffffff81b16052>] ntfs_init_fs_context+0x22/0x1c0
    [<ffffffff8164aaa7>] alloc_fs_context+0x217/0x430
    [<ffffffff81626dd4>] path_mount+0x704/0x1080
    [<ffffffff81627e7c>] __x64_sys_mount+0x18c/0x1d0
    [<ffffffff84593e14>] do_syscall_64+0x34/0xb0
    [<ffffffff84600087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

This patch fixes this issue by freeing mount options on error path of
ntfs_fill_super().

Reported-by: syzbot+9d67170b20e8f94351c8@syzkaller.appspotmail.com
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index 4b8fa5299e26..8c2a93e39fe2 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -1276,6 +1276,7 @@ static int ntfs_fill_super(struct super_block *sb, struct fs_context *fc)
 	 * Free resources here.
 	 * ntfs_fs_free will be called with fc->s_fs_info = NULL
 	 */
+	put_mount_options(sbi->options);
 	put_ntfs(sbi);
 	sb->s_fs_info = NULL;
 
-- 
2.35.1

