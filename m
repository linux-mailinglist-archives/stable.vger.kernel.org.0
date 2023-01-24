Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2BB6799C7
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 14:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234020AbjAXNmI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 08:42:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234191AbjAXNmD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 08:42:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14F134588E;
        Tue, 24 Jan 2023 05:41:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80A2A611F2;
        Tue, 24 Jan 2023 13:41:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10256C4339B;
        Tue, 24 Jan 2023 13:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674567711;
        bh=0+jcL0cpGh18gP3DGO0pTxKbweqX1ksJ6xgS3QQQsZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KRaTzgp9xm1yNEZHc/2lOZvfx3tYZvq3w5UzLLK+QvEZqogIfUwzZbhJAuBGoxnSH
         2Xt7FsJSn0MalBiTl6H9vN1gGS6L9JahPjJKi7kfjfiMgH5n6M3q+KsSwHjP/ZjqAA
         TXDiYz9Hb8tYI+p47a8S4j/7FnxiKIJuwi4BC+pPTyOfe8YhZFAYnTCfj0NLTOuNpK
         SJvQeM6ViaBTsPpp4hUtjWRXzQo1U6I6HaY8B8S1uy9RN8XQqGX0egZMDXM8FT9lk/
         NRCnBsK/ILj7PDHe+81JmlDCmDmls7Q01khsmafGDNlr2hjbhm9SxAJU1zo6XUXJ5h
         c+nnsQ78fY4wA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Siddh Raman Pant <code@siddh.me>,
        syzbot+a8e049cd3abd342936b6@syzkaller.appspotmail.com,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Chao Yu <chao@kernel.org>, Sasha Levin <sashal@kernel.org>,
        xiang@kernel.org, linux-erofs@lists.ozlabs.org
Subject: [PATCH AUTOSEL 6.1 07/35] erofs/zmap.c: Fix incorrect offset calculation
Date:   Tue, 24 Jan 2023 08:41:03 -0500
Message-Id: <20230124134131.637036-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230124134131.637036-1-sashal@kernel.org>
References: <20230124134131.637036-1-sashal@kernel.org>
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

From: Siddh Raman Pant <code@siddh.me>

[ Upstream commit 6acd87d50998ef0afafc441613aeaf5a8f5c9eff ]

Effective offset to add to length was being incorrectly calculated,
which resulted in iomap->length being set to 0, triggering a WARN_ON
in iomap_iter_done().

Fix that, and describe it in comments.

This was reported as a crash by syzbot under an issue about a warning
encountered in iomap_iter_done(), but unrelated to erofs.

C reproducer: https://syzkaller.appspot.com/text?tag=ReproC&x=1037a6b2880000
Kernel config: https://syzkaller.appspot.com/text?tag=KernelConfig&x=e2021a61197ebe02
Dashboard link: https://syzkaller.appspot.com/bug?extid=a8e049cd3abd342936b6

Reported-by: syzbot+a8e049cd3abd342936b6@syzkaller.appspotmail.com
Suggested-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Siddh Raman Pant <code@siddh.me>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Link: https://lore.kernel.org/r/20221209102151.311049-1-code@siddh.me
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zmap.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index e6d5d7a18fb0..39cc014dba40 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -793,12 +793,16 @@ static int z_erofs_iomap_begin_report(struct inode *inode, loff_t offset,
 		iomap->type = IOMAP_HOLE;
 		iomap->addr = IOMAP_NULL_ADDR;
 		/*
-		 * No strict rule how to describe extents for post EOF, yet
-		 * we need do like below. Otherwise, iomap itself will get
+		 * No strict rule on how to describe extents for post EOF, yet
+		 * we need to do like below. Otherwise, iomap itself will get
 		 * into an endless loop on post EOF.
+		 *
+		 * Calculate the effective offset by subtracting extent start
+		 * (map.m_la) from the requested offset, and add it to length.
+		 * (NB: offset >= map.m_la always)
 		 */
 		if (iomap->offset >= inode->i_size)
-			iomap->length = length + map.m_la - offset;
+			iomap->length = length + offset - map.m_la;
 	}
 	iomap->flags = 0;
 	return 0;
-- 
2.39.0

