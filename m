Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD0D59D9CD
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245621AbiHWKCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351963AbiHWKA6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:00:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE291B784;
        Tue, 23 Aug 2022 01:48:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE0216123D;
        Tue, 23 Aug 2022 08:48:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7093C433C1;
        Tue, 23 Aug 2022 08:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244509;
        bh=g0ljEhDQMy0x7RlhJ7S6O9duSphc00Lp5+QaDZm3Jek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b5nSsVTinDobDE0+E/4vI11RU9fyrp79eiIz0u71IHIHQscEsD7aCyeJab4YdfR+K
         WaQjBCj1XSVIOZE8/Okj1CRh51tzAcxKJFBBglNkFgPGu8750bR5Outv3dOJNGwxp4
         uO4t/fQdIHRWPhqVuKJr5j+HRrl3d4t8J2/SnqCU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        syzbot+c95173762127ad76a824@syzkaller.appspotmail.com
Subject: [PATCH 5.15 104/244] fs/ntfs3: Fix NULL deref in ntfs_update_mftmirr
Date:   Tue, 23 Aug 2022 10:24:23 +0200
Message-Id: <20220823080102.493257230@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

commit 321460ca3b55f48b3ba6008248264ab2bd6407d9 upstream.

If ntfs_fill_super() wasn't called then sbi->sb will be equal to NULL.
Code should check this ptr before dereferencing. Syzbot hit this issue
via passing wrong mount param as can be seen from log below

Fail log:
ntfs3: Unknown parameter 'iochvrset'
general protection fault, probably for non-canonical address 0xdffffc0000000003: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
CPU: 1 PID: 3589 Comm: syz-executor210 Not tainted 5.18.0-rc3-syzkaller-00016-gb253435746d9 #0
...
Call Trace:
 <TASK>
 put_ntfs+0x1ed/0x2a0 fs/ntfs3/super.c:463
 ntfs_fs_free+0x6a/0xe0 fs/ntfs3/super.c:1363
 put_fs_context+0x119/0x7a0 fs/fs_context.c:469
 do_new_mount+0x2b4/0xad0 fs/namespace.c:3044
 do_mount fs/namespace.c:3383 [inline]
 __do_sys_mount fs/namespace.c:3591 [inline]

Fixes: 82cae269cfa9 ("fs/ntfs3: Add initialization of super block")
Reported-and-tested-by: syzbot+c95173762127ad76a824@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/fsntfs.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -831,10 +831,15 @@ int ntfs_update_mftmirr(struct ntfs_sb_i
 {
 	int err;
 	struct super_block *sb = sbi->sb;
-	u32 blocksize = sb->s_blocksize;
+	u32 blocksize;
 	sector_t block1, block2;
 	u32 bytes;
 
+	if (!sb)
+		return -EINVAL;
+
+	blocksize = sb->s_blocksize;
+
 	if (!(sbi->flags & NTFS_FLAGS_MFTMIRR))
 		return 0;
 


