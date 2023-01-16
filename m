Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE2B366CC2E
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234348AbjAPRWz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:22:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234417AbjAPRWc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:22:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E31A236FC4
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:00:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 392BAB810A2
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EBE9C433F2;
        Mon, 16 Jan 2023 17:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888422;
        bh=eq8Ser823lX6TdBOCAuembbQ6YrZ+BthBxUEArA1Aww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pDkkJA65nI2TptSKujWZzkR7KpNTOonRdsCZOsM8vtJa+sjZG/KH+YnbDSKfo0cyb
         YDvVqsk8oKOMr3Fn517AJFp0vECwZ/c5/Gn0D9ZcM1lsqCJndnDV60bTonQLDPuzEi
         2jJ5GIIGKpVJIgtmNHA+lFEsQhwyXdYb+N4kRVcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, zhengliang <zhengliang6@huawei.com>,
        Andreas Dilger <adilger@dilger.ca>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 493/521] ext4: lost matching-pair of trace in ext4_truncate
Date:   Mon, 16 Jan 2023 16:52:35 +0100
Message-Id: <20230116154909.245916825@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

From: zhengliang <zhengliang6@huawei.com>

[ Upstream commit 9a5d265fed014115f35e598022c956e5d2fb863e ]

It should call trace exit in all return path for ext4_truncate.

Signed-off-by: zhengliang <zhengliang6@huawei.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Reviewed-by: Ritesh Harjani <riteshh@linux.ibm.com>
Link: https://lore.kernel.org/r/20200701083027.45996-1-zhengliang6@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: a71248b1accb ("ext4: fix use-after-free in ext4_orphan_cleanup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b322658ceff1..16d2b88bc66d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4551,7 +4551,7 @@ int ext4_truncate(struct inode *inode)
 	trace_ext4_truncate_enter(inode);
 
 	if (!ext4_can_truncate(inode))
-		return 0;
+		goto out_trace;
 
 	ext4_clear_inode_flag(inode, EXT4_INODE_EOFBLOCKS);
 
@@ -4562,16 +4562,14 @@ int ext4_truncate(struct inode *inode)
 		int has_inline = 1;
 
 		err = ext4_inline_data_truncate(inode, &has_inline);
-		if (err)
-			return err;
-		if (has_inline)
-			return 0;
+		if (err || has_inline)
+			goto out_trace;
 	}
 
 	/* If we zero-out tail of the page, we have to create jinode for jbd2 */
 	if (inode->i_size & (inode->i_sb->s_blocksize - 1)) {
 		if (ext4_inode_attach_jinode(inode) < 0)
-			return 0;
+			goto out_trace;
 	}
 
 	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
@@ -4580,8 +4578,10 @@ int ext4_truncate(struct inode *inode)
 		credits = ext4_blocks_for_truncate(inode);
 
 	handle = ext4_journal_start(inode, EXT4_HT_TRUNCATE, credits);
-	if (IS_ERR(handle))
-		return PTR_ERR(handle);
+	if (IS_ERR(handle)) {
+		err = PTR_ERR(handle);
+		goto out_trace;
+	}
 
 	if (inode->i_size & (inode->i_sb->s_blocksize - 1))
 		ext4_block_truncate_page(handle, mapping, inode->i_size);
@@ -4630,6 +4630,7 @@ int ext4_truncate(struct inode *inode)
 	ext4_mark_inode_dirty(handle, inode);
 	ext4_journal_stop(handle);
 
+out_trace:
 	trace_ext4_truncate_exit(inode);
 	return err;
 }
-- 
2.35.1



