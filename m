Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 196F44BE606
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346951AbiBUJFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:05:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346974AbiBUJEn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:04:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC1CF2DD5D;
        Mon, 21 Feb 2022 00:58:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04EEBB80EBE;
        Mon, 21 Feb 2022 08:58:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 228FCC340E9;
        Mon, 21 Feb 2022 08:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433915;
        bh=7q0BDtyRXVNalxa0DqT6OCIOkrN0gIrOxt75iA2zV+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k9jZqAX9k4/4prCvMwA4A+S5sNel5yW1o3xZ+SBfj2TlzJfthqk951mCl9HL+vq8I
         SbDblCqS0ZsJt7WmfaMT/RqvjuFgnoz/XDqjCkRE9mnpri38BhzSjHiFEpzv9P2tTa
         y4/uoDMhJT7bmifU8OQTh9PAy9Zif+JbH+HPZwAw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Yi <yi.zhang@huawei.com>,
        Theodore Tso <tytso@mit.edu>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.4 29/80] ext4: check for out-of-order index extents in ext4_valid_extent_entries()
Date:   Mon, 21 Feb 2022 09:49:09 +0100
Message-Id: <20220221084916.535658304@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084915.554151737@linuxfoundation.org>
References: <20220221084915.554151737@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Zhang Yi <yi.zhang@huawei.com>

commit 8dd27fecede55e8a4e67eef2878040ecad0f0d33 upstream.

After commit 5946d089379a ("ext4: check for overlapping extents in
ext4_valid_extent_entries()"), we can check out the overlapping extent
entry in leaf extent blocks. But the out-of-order extent entry in index
extent blocks could also trigger bad things if the filesystem is
inconsistent. So this patch add a check to figure out the out-of-order
index extents and return error.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Theodore Ts'o <tytso@mit.edu>
Link: https://lore.kernel.org/r/20210908120850.4012324-2-yi.zhang@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -390,9 +390,12 @@ static int ext4_valid_extent_idx(struct
 
 static int ext4_valid_extent_entries(struct inode *inode,
 				struct ext4_extent_header *eh,
-				int depth)
+				ext4_fsblk_t *pblk, int depth)
 {
 	unsigned short entries;
+	ext4_lblk_t lblock = 0;
+	ext4_lblk_t prev = 0;
+
 	if (eh->eh_entries == 0)
 		return 1;
 
@@ -403,32 +406,36 @@ static int ext4_valid_extent_entries(str
 		struct ext4_extent *ext = EXT_FIRST_EXTENT(eh);
 		struct ext4_super_block *es = EXT4_SB(inode->i_sb)->s_es;
 		ext4_fsblk_t pblock = 0;
-		ext4_lblk_t lblock = 0;
-		ext4_lblk_t prev = 0;
-		int len = 0;
 		while (entries) {
 			if (!ext4_valid_extent(inode, ext))
 				return 0;
 
 			/* Check for overlapping extents */
 			lblock = le32_to_cpu(ext->ee_block);
-			len = ext4_ext_get_actual_len(ext);
 			if ((lblock <= prev) && prev) {
 				pblock = ext4_ext_pblock(ext);
 				es->s_last_error_block = cpu_to_le64(pblock);
 				return 0;
 			}
+			prev = lblock + ext4_ext_get_actual_len(ext) - 1;
 			ext++;
 			entries--;
-			prev = lblock + len - 1;
 		}
 	} else {
 		struct ext4_extent_idx *ext_idx = EXT_FIRST_INDEX(eh);
 		while (entries) {
 			if (!ext4_valid_extent_idx(inode, ext_idx))
 				return 0;
+
+			/* Check for overlapping index extents */
+			lblock = le32_to_cpu(ext_idx->ei_block);
+			if ((lblock <= prev) && prev) {
+				*pblk = ext4_idx_pblock(ext_idx);
+				return 0;
+			}
 			ext_idx++;
 			entries--;
+			prev = lblock;
 		}
 	}
 	return 1;
@@ -462,7 +469,7 @@ static int __ext4_ext_check(const char *
 		error_msg = "invalid eh_entries";
 		goto corrupted;
 	}
-	if (!ext4_valid_extent_entries(inode, eh, depth)) {
+	if (!ext4_valid_extent_entries(inode, eh, &pblk, depth)) {
 		error_msg = "invalid extent entries";
 		goto corrupted;
 	}


