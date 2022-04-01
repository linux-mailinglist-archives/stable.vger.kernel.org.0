Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27CE94EF0C6
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 16:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348034AbiDAOg7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348558AbiDAOeo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:34:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73088BC7;
        Fri,  1 Apr 2022 07:32:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1257261C3C;
        Fri,  1 Apr 2022 14:32:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10F6AC2BBE4;
        Fri,  1 Apr 2022 14:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823574;
        bh=vANaOh00GfqQBTcK5sP1BvrXEFApLiocXg4m5Mdy1BU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=avyiPNPtNwM5q3rwK7aVdsbpygz442s+ak3xJanvoMbfUDiAUvMGKxYMfTiTuWbom
         PaGbPZ9ETIZI86yQFujZVg2TrItk23Jqu9g+Jcz50hMab9KUQUI0FiiMvGZZwmD1lJ
         fTZ8xgJFP+dQLgWEUu/tSUCMcyT2mASd6iC82tu5emkDJ1ih/NYs4zZ4ERk7r4pJ0E
         6saewXyf/aSFV0eqhgr9qDPivk7sXbp4cR0mBWQ7wlNlgrDBKI/LFbSPmUIeul5YW3
         m6tVuXgJrJtMf3/dVKtdQEH92zvTqC6sQSCiexbmHlgqRhR6f0RunLIppEGxgH94I8
         1zeLfJ9TQackg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qinghua Jin <qhjin.dev@gmail.com>,
        Colin Ian King <colin.king@intel.com>,
        Jan Kara <jack@suse.cz>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, willy@infradead.org,
        damien.lemoal@opensource.wdc.com, roman.gushchin@linux.dev,
        songmuchun@bytedance.com
Subject: [PATCH AUTOSEL 5.17 149/149] minix: fix bug when opening a file with O_DIRECT
Date:   Fri,  1 Apr 2022 10:25:36 -0400
Message-Id: <20220401142536.1948161-149-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
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

From: Qinghua Jin <qhjin.dev@gmail.com>

[ Upstream commit 9ce3c0d26c42d279b6c378a03cd6a61d828f19ca ]

Testcase:
1. create a minix file system and mount it
2. open a file on the file system with O_RDWR|O_CREAT|O_TRUNC|O_DIRECT
3. open fails with -EINVAL but leaves an empty file behind. All other
   open() failures don't leave the failed open files behind.

It is hard to check the direct_IO op before creating the inode.  Just as
ext4 and btrfs do, this patch will resolve the issue by allowing to
create the file with O_DIRECT but returning error when writing the file.

Link: https://lkml.kernel.org/r/20220107133626.413379-1-qhjin.dev@gmail.com
Signed-off-by: Qinghua Jin <qhjin.dev@gmail.com>
Reported-by: Colin Ian King <colin.king@intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/minix/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index a71f1cf894b9..d4bd94234ef7 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -447,7 +447,8 @@ static const struct address_space_operations minix_aops = {
 	.writepage = minix_writepage,
 	.write_begin = minix_write_begin,
 	.write_end = generic_write_end,
-	.bmap = minix_bmap
+	.bmap = minix_bmap,
+	.direct_IO = noop_direct_IO
 };
 
 static const struct inode_operations minix_symlink_inode_operations = {
-- 
2.34.1

