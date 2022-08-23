Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD7259D655
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241305AbiHWImb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346629AbiHWIk1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:40:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D115F9BD;
        Tue, 23 Aug 2022 01:18:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1476061367;
        Tue, 23 Aug 2022 08:17:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EBDFC433C1;
        Tue, 23 Aug 2022 08:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242676;
        bh=g0ljEhDQMy0x7RlhJ7S6O9duSphc00Lp5+QaDZm3Jek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CiooeHt8h8MixqlG/UtXqhVo8im7C792c1uAshkvUXOeMlotT2ppsQnR0ckY+HqsW
         nQ5Pnn8Ak+EhlF4z0HB70G/4Znb2qu1zZptFb05YToWF2kkqzMdkSIPNA9HZH+jXON
         PK4oQpcxjD6gqntR/GT9ULBDoUA7Ucxe8KhFCs5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        syzbot+c95173762127ad76a824@syzkaller.appspotmail.com
Subject: [PATCH 5.19 161/365] fs/ntfs3: Fix NULL deref in ntfs_update_mftmirr
Date:   Tue, 23 Aug 2022 10:01:02 +0200
Message-Id: <20220823080124.951238235@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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
 


