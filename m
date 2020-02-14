Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1758A15EB1D
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387736AbgBNRSg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:18:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:37458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389088AbgBNQLE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:11:04 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E6132469F;
        Fri, 14 Feb 2020 16:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696664;
        bh=X+eG9iyexQDwe4U+7lu+mRy9Zg8j10lWrXnxXR+W9FU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YHbr0kKtUl63aXYnONhSVGS5QSTtYo1+dceq0LT6CoryEhVAotfcp0OhVoBiu2rA/
         CDhbHjqEOv/+70lwRI1JZaGctyXwyqoGaU4m400UTUYWeFMZtotSP76h1KD5x6GYiD
         c9gwaeRR2y2yAmpu61MgFVCgOOTb82jS4cy5ZIAY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yunfeng Ye <yeyunfeng@huawei.com>,
        zhengbin <zhengbin13@huawei.com>,
        Hu Shiyuan <hushiyuan@huawei.com>,
        Feilong Lin <linfeilong@huawei.com>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, reiserfs-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 435/459] reiserfs: prevent NULL pointer dereference in reiserfs_insert_item()
Date:   Fri, 14 Feb 2020 11:01:25 -0500
Message-Id: <20200214160149.11681-435-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunfeng Ye <yeyunfeng@huawei.com>

[ Upstream commit aacee5446a2a1aa35d0a49dab289552578657fb4 ]

The variable inode may be NULL in reiserfs_insert_item(), but there is
no check before accessing the member of inode.

Fix this by adding NULL pointer check before calling reiserfs_debug().

Link: http://lkml.kernel.org/r/79c5135d-ff25-1cc9-4e99-9f572b88cc00@huawei.com
Signed-off-by: Yunfeng Ye <yeyunfeng@huawei.com>
Cc: zhengbin <zhengbin13@huawei.com>
Cc: Hu Shiyuan <hushiyuan@huawei.com>
Cc: Feilong Lin <linfeilong@huawei.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/reiserfs/stree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/reiserfs/stree.c b/fs/reiserfs/stree.c
index da9ebe33882b7..bb4973aefbb18 100644
--- a/fs/reiserfs/stree.c
+++ b/fs/reiserfs/stree.c
@@ -2246,7 +2246,8 @@ int reiserfs_insert_item(struct reiserfs_transaction_handle *th,
 	/* also releases the path */
 	unfix_nodes(&s_ins_balance);
 #ifdef REISERQUOTA_DEBUG
-	reiserfs_debug(th->t_super, REISERFS_DEBUG_CODE,
+	if (inode)
+		reiserfs_debug(th->t_super, REISERFS_DEBUG_CODE,
 		       "reiserquota insert_item(): freeing %u id=%u type=%c",
 		       quota_bytes, inode->i_uid, head2type(ih));
 #endif
-- 
2.20.1

