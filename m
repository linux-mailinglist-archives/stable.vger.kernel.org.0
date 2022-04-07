Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A93794F6FB6
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 03:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234660AbiDGBPF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 21:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234590AbiDGBOd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 21:14:33 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B95818649C;
        Wed,  6 Apr 2022 18:11:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5D5E8CE2684;
        Thu,  7 Apr 2022 01:11:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA948C385A3;
        Thu,  7 Apr 2022 01:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649293882;
        bh=zeyKZE8740RxC0fLVa0ngmzOPV4kdSKGulQZT2SyRhU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QRImdtlKzCkcxpHCXJMnxLQV9oK+iiKN8MDv6qkCH+fx7BDGoc6IeG4KWOHNzXd4R
         9xFzZaSHA4CMU707HMqNywJaCi8YvTnXhFH4a1P4t3nVNkqM49hCPO8fl598QMEVSS
         GTAtaN59qsd8iZhxRl2H+XkXsEI0UwFH4gbUUH3U5I3XuSgk6w0bRnD9vfEOsgLsxc
         z2wrBbbFOXwAsZ3nS0gkIA/FRT1CvoI/yCLG64LA+6O865TRTq+jX3K8DnfuVayZdv
         2SUcs5GxsJfvdQZnmrprrLEKbA6m+08Jn42WESg8C6EtwkpniU7OFnUvmXPmUmoU6/
         ruUMdzCOGv3rA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guo Xuenan <guoxuenan@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Sasha Levin <sashal@kernel.org>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 25/31] fs: fix an infinite loop in iomap_fiemap
Date:   Wed,  6 Apr 2022 21:10:23 -0400
Message-Id: <20220407011029.113321-25-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407011029.113321-1-sashal@kernel.org>
References: <20220407011029.113321-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Guo Xuenan <guoxuenan@huawei.com>

[ Upstream commit 49df34221804cfd6384135b28b03c9461a31d024 ]

when get fiemap starting from MAX_LFS_FILESIZE, (maxbytes - *len) < start
will always true , then *len set zero. because of start offset is beyond
file size, for erofs filesystem it will always return iomap.length with
zero,iomap iterate will enter infinite loop. it is necessary cover this
corner case to avoid this situation.

------------[ cut here ]------------
WARNING: CPU: 7 PID: 905 at fs/iomap/iter.c:35 iomap_iter+0x97f/0xc70
Modules linked in: xfs erofs
CPU: 7 PID: 905 Comm: iomap Tainted: G        W         5.17.0-rc8 #27
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:iomap_iter+0x97f/0xc70
Code: 85 a1 fc ff ff e8 71 be 9c ff 0f 1f 44 00 00 e9 92 fc ff ff e8 62 be 9c ff 0f 0b b8 fb ff ff ff e9 fc f8 ff ff e8 51 be 9c ff <0f> 0b e9 2b fc ff ff e8 45 be 9c ff 0f 0b e9 e1 fb ff ff e8 39 be
RSP: 0018:ffff888060a37ab0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff888060a37bb0 RCX: 0000000000000000
RDX: ffff88807e19a900 RSI: ffffffff81a7da7f RDI: ffff888060a37be0
RBP: 7fffffffffffffff R08: 0000000000000000 R09: ffff888060a37c20
R10: ffff888060a37c67 R11: ffffed100c146f8c R12: 7fffffffffffffff
R13: 0000000000000000 R14: ffff888060a37bd8 R15: ffff888060a37c20
FS:  00007fd3cca01540(0000) GS:ffff888108780000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020010820 CR3: 0000000054b92000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 iomap_fiemap+0x1c9/0x2f0
 erofs_fiemap+0x64/0x90 [erofs]
 do_vfs_ioctl+0x40d/0x12e0
 __x64_sys_ioctl+0xaa/0x1c0
 do_syscall_64+0x35/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
 </TASK>
---[ end trace 0000000000000000 ]---
watchdog: BUG: soft lockup - CPU#7 stuck for 26s! [iomap:905]

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
[djwong: fix some typos]
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ioctl.c b/fs/ioctl.c
index 1ed097e94af2..85f7e4ee6924 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -173,7 +173,7 @@ int fiemap_prep(struct inode *inode, struct fiemap_extent_info *fieinfo,
 
 	if (*len == 0)
 		return -EINVAL;
-	if (start > maxbytes)
+	if (start >= maxbytes)
 		return -EFBIG;
 
 	/*
-- 
2.35.1

