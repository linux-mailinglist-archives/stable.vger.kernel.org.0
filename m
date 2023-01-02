Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9A365B0E3
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236081AbjABL3C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:29:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232791AbjABL2h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 06:28:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4A46415
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 03:27:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9990BB80D1C
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 11:27:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F30F9C433EF;
        Mon,  2 Jan 2023 11:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672658862;
        bh=2/sFbHrCj3NlH5vF336h/jLVbSPWzPw+XeJo6x2lkzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fPtpL8AeXAbVLd98PTLr+nfNSqMTl16nTR6qR1W96qvF9IfHjsp3DIijXMX3i6p0W
         6jXfJKN8iLvbpaqi1VfbzbeBlPBx/Tj+HlbA4BWhfL3l4DRsgvXogmDrcB6zWGokar
         72TtKyPRKLS6QOeCnahxY2Rs/r3Pu7upl4EXiRJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+9d67170b20e8f94351c8@syzkaller.appspotmail.com,
        Shigeru Yoshida <syoshida@redhat.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 27/74] fs/ntfs3: Fix memory leak on ntfs_fill_super() error path
Date:   Mon,  2 Jan 2023 12:22:00 +0100
Message-Id: <20230102110553.228063969@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
References: <20230102110552.061937047@linuxfoundation.org>
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
index a0cea3b7526e..170682c2bf67 100644
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



