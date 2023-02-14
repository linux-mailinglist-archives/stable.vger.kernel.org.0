Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A52F7697238
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 00:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232265AbjBNX5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 18:57:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232815AbjBNX5Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 18:57:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE3D83F8;
        Tue, 14 Feb 2023 15:57:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08809B81F6A;
        Tue, 14 Feb 2023 23:57:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A906C433D2;
        Tue, 14 Feb 2023 23:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676419041;
        bh=DCMDDkt6Ar0ODmaEfXdp73d5AsSIPtAfQxa/qcVDYqA=;
        h=From:To:Cc:Subject:Date:From;
        b=Saa/mwlbfMI6YFJ7bkmJBNpeAEwuRbIbLRKUDPmKoc8joVcz/bhPldyDxLcxYmfPE
         +geEldLRALrNwGILqPpBtr7khBh5tIVPbiZUAwk2OcV8Kvn7zj+5oCqPH5ffXz887D
         tyLdoJu7e4vKCeuMfCxxsEQMHGESwQAPDvYQxmm2QYsshDDWrVKMQ/gpHS4m2yvEvB
         NwCPNbBbuiInMbXNkan0B0jjti3ROJ7klOsllOiuQXiQf4DW5SyYM/nqgRbt6c5ahC
         sP296fruob///JdD9REI3wt5GY+mt2wS0WBzLL0T9pahwynVHVNz8jcT1BxQ8vEVSY
         vdhjJJ3PGqTuw==
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] f2fs: Revert "f2fs: truncate blocks in batch in __complete_revoke_list()"
Date:   Tue, 14 Feb 2023 15:57:19 -0800
Message-Id: <20230214235719.799831-1-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We should not truncate replaced blocks, and were supposed to truncate the first
part as well.

This reverts commit 78a99fe6254cad4be310cd84af39f6c46b668c72.

Cc: stable@vger.kernel.org
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/segment.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 719329c1808c..227e25836173 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -265,19 +265,24 @@ static void __complete_revoke_list(struct inode *inode, struct list_head *head,
 					bool revoke)
 {
 	struct revoke_entry *cur, *tmp;
+	pgoff_t start_index = 0;
 	bool truncate = is_inode_flag_set(inode, FI_ATOMIC_REPLACE);
 
 	list_for_each_entry_safe(cur, tmp, head, list) {
-		if (revoke)
+		if (revoke) {
 			__replace_atomic_write_block(inode, cur->index,
 						cur->old_addr, NULL, true);
+		} else if (truncate) {
+			f2fs_truncate_hole(inode, start_index, cur->index);
+			start_index = cur->index + 1;
+		}
 
 		list_del(&cur->list);
 		kmem_cache_free(revoke_entry_slab, cur);
 	}
 
 	if (!revoke && truncate)
-		f2fs_do_truncate_blocks(inode, 0, false);
+		f2fs_do_truncate_blocks(inode, start_index * PAGE_SIZE, false);
 }
 
 static int __f2fs_commit_atomic_write(struct inode *inode)
-- 
2.39.1.581.gbfd45094c4-goog

