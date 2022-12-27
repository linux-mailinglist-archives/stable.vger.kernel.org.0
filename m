Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A06DA656EED
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 21:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbiL0UgQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 15:36:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232206AbiL0UeP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 15:34:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A8A8D10F;
        Tue, 27 Dec 2022 12:33:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5BF7B811FB;
        Tue, 27 Dec 2022 20:33:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD06FC433F1;
        Tue, 27 Dec 2022 20:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672173229;
        bh=vMPndmgsz6Za5oPVT+44B1SsH4OmPfSUTl4HrUrDjwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a+1/3KUDRS9d32JYtafT2UhD+5xLWeal4KahJw8PKLb+PDr0qkDIQVVSmQBUDKDsA
         uDCMlVgKtLe4abpbITDf1zMPRhOzY0bt7GtcGTyu/c01SoN99/iurlwtZZQwQdh3V9
         y0l0T/DskgO85uPaESEl/zkKZXybS/n5TC4mbAWik11PSCxL7NAvAVrfQPubMgkUHp
         meuc2IrZLfdB1/T30d5QBruzUduGpEATXKSqch0ZN57N8H/+YxSxyJ/K1IjDtWpNi+
         vIAS1+eUSxrIysCmiE14IP8q5MAuJPxXy8KuIXj1rLErMerjVrLTZALRGgMySwt9lz
         mfdjP8h7e6DuQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shigeru Yoshida <syoshida@redhat.com>,
        syzbot+9d67170b20e8f94351c8@syzkaller.appspotmail.com,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Sasha Levin <sashal@kernel.org>, ntfs3@lists.linux.dev
Subject: [PATCH AUTOSEL 6.0 05/27] fs/ntfs3: Fix memory leak on ntfs_fill_super() error path
Date:   Tue, 27 Dec 2022 15:33:20 -0500
Message-Id: <20221227203342.1213918-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221227203342.1213918-1-sashal@kernel.org>
References: <20221227203342.1213918-1-sashal@kernel.org>
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
index d998cb083d95..0118c28d8ccb 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -1281,6 +1281,7 @@ static int ntfs_fill_super(struct super_block *sb, struct fs_context *fc)
 	 * Free resources here.
 	 * ntfs_fs_free will be called with fc->s_fs_info = NULL
 	 */
+	put_mount_options(sbi->options);
 	put_ntfs(sbi);
 	sb->s_fs_info = NULL;
 
-- 
2.35.1

