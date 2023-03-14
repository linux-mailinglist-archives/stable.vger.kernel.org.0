Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5586B946D
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 13:45:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbjCNMpn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 08:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbjCNMpF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 08:45:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E071C7C1;
        Tue, 14 Mar 2023 05:44:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F077261767;
        Tue, 14 Mar 2023 12:43:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F693C4339C;
        Tue, 14 Mar 2023 12:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678797810;
        bh=xAJv3dvpOU7NVoRdTyls/Nrdb8fz5MdGxiW/Rt9jAno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eNrhZG8ch9lb/lr/XnlKOXmggxBiFNevpKnU6tNO7wM0E4gQn2wzy2hSJsbcfZ+YC
         x+LwbYEyBYNsrcjIw/wVrC8fn3zpaKjVmn04+WOxFRE4aLbROUwnnITFOId08l1FXI
         tAX6TVfygs5XBM5FmnNo2TrhS4UGkbAITPhhqeuzOXNApCY7oEKz6UTd5LAot03wE2
         1xRNz1ScwquHGHS70BfZoewQ2wytcGCdpKYFpuhKssAI4kx8YKdblRozGj2NEhVsei
         CqRsgGy5FJQoXkyfYpPW0Kk2k1vfdnj0fFL79J0eoj9+ufOCmoDq8k+UP8MaB9YDBK
         5crQ5eaqIZHVA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yifei Liu <yifeliu@cs.stonybrook.edu>,
        Erez Zadok <ezk@cs.stonybrook.edu>,
        Manish Adkar <madkar@cs.stonybrook.edu>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org
Subject: [PATCH AUTOSEL 6.1 03/13] jffs2: correct logic when creating a hole in jffs2_write_begin
Date:   Tue, 14 Mar 2023 08:43:15 -0400
Message-Id: <20230314124325.470931-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314124325.470931-1-sashal@kernel.org>
References: <20230314124325.470931-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yifei Liu <yifeliu@cs.stonybrook.edu>

[ Upstream commit 23892d383bee15b64f5463bd7195615734bb2415 ]

Bug description and fix:

1. Write data to a file, say all 1s from offset 0 to 16.

2. Truncate the file to a smaller size, say 8 bytes.

3. Write new bytes (say 2s) from an offset past the original size of the
file, say at offset 20, for 4 bytes.  This is supposed to create a "hole"
in the file, meaning that the bytes from offset 8 (where it was truncated
above) up to the new write at offset 20, should all be 0s (zeros).

4. Flush all caches using "echo 3 > /proc/sys/vm/drop_caches" (or unmount
and remount) the f/s.

5. Check the content of the file.  It is wrong.  The 1s that used to be
between bytes 9 and 16, before the truncation, have REAPPEARED (they should
be 0s).

We wrote a script and helper C program to reproduce the bug
(reproduce_jffs2_write_begin_issue.sh, write_file.c, and Makefile).  We can
make them available to anyone.

The above example is shown when writing a small file within the same first
page.  But the bug happens for larger files, as long as steps 1, 2, and 3
above all happen within the same page.

The problem was traced to the jffs2_write_begin code, where it goes into an
'if' statement intended to handle writes past the current EOF (i.e., writes
that may create a hole).  The code computes a 'pageofs' that is the floor
of the write position (pos), aligned to the page size boundary.  In other
words, 'pageofs' will never be larger than 'pos'.  The code then sets the
internal jffs2_raw_inode->isize to the size of max(current inode size,
pageofs) but that is wrong: the new file size should be the 'pos', which is
larger than both the current inode size and pageofs.

Similarly, the code incorrectly sets the internal jffs2_raw_inode->dsize to
the difference between the pageofs minus current inode size; instead it
should be the current pos minus the current inode size.  Finally,
inode->i_size was also set incorrectly.

The patch below fixes this bug.  The bug was discovered using a new tool
for finding f/s bugs using model checking, called MCFS (Model Checking File
Systems).

Signed-off-by: Yifei Liu <yifeliu@cs.stonybrook.edu>
Signed-off-by: Erez Zadok <ezk@cs.stonybrook.edu>
Signed-off-by: Manish Adkar <madkar@cs.stonybrook.edu>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jffs2/file.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/jffs2/file.c b/fs/jffs2/file.c
index ba86acbe12d3f..0479096b96e4c 100644
--- a/fs/jffs2/file.c
+++ b/fs/jffs2/file.c
@@ -137,19 +137,18 @@ static int jffs2_write_begin(struct file *filp, struct address_space *mapping,
 	struct jffs2_inode_info *f = JFFS2_INODE_INFO(inode);
 	struct jffs2_sb_info *c = JFFS2_SB_INFO(inode->i_sb);
 	pgoff_t index = pos >> PAGE_SHIFT;
-	uint32_t pageofs = index << PAGE_SHIFT;
 	int ret = 0;
 
 	jffs2_dbg(1, "%s()\n", __func__);
 
-	if (pageofs > inode->i_size) {
-		/* Make new hole frag from old EOF to new page */
+	if (pos > inode->i_size) {
+		/* Make new hole frag from old EOF to new position */
 		struct jffs2_raw_inode ri;
 		struct jffs2_full_dnode *fn;
 		uint32_t alloc_len;
 
-		jffs2_dbg(1, "Writing new hole frag 0x%x-0x%x between current EOF and new page\n",
-			  (unsigned int)inode->i_size, pageofs);
+		jffs2_dbg(1, "Writing new hole frag 0x%x-0x%x between current EOF and new position\n",
+			  (unsigned int)inode->i_size, (uint32_t)pos);
 
 		ret = jffs2_reserve_space(c, sizeof(ri), &alloc_len,
 					  ALLOC_NORMAL, JFFS2_SUMMARY_INODE_SIZE);
@@ -169,10 +168,10 @@ static int jffs2_write_begin(struct file *filp, struct address_space *mapping,
 		ri.mode = cpu_to_jemode(inode->i_mode);
 		ri.uid = cpu_to_je16(i_uid_read(inode));
 		ri.gid = cpu_to_je16(i_gid_read(inode));
-		ri.isize = cpu_to_je32(max((uint32_t)inode->i_size, pageofs));
+		ri.isize = cpu_to_je32((uint32_t)pos);
 		ri.atime = ri.ctime = ri.mtime = cpu_to_je32(JFFS2_NOW());
 		ri.offset = cpu_to_je32(inode->i_size);
-		ri.dsize = cpu_to_je32(pageofs - inode->i_size);
+		ri.dsize = cpu_to_je32((uint32_t)pos - inode->i_size);
 		ri.csize = cpu_to_je32(0);
 		ri.compr = JFFS2_COMPR_ZERO;
 		ri.node_crc = cpu_to_je32(crc32(0, &ri, sizeof(ri)-8));
@@ -202,7 +201,7 @@ static int jffs2_write_begin(struct file *filp, struct address_space *mapping,
 			goto out_err;
 		}
 		jffs2_complete_reservation(c);
-		inode->i_size = pageofs;
+		inode->i_size = pos;
 		mutex_unlock(&f->sem);
 	}
 
-- 
2.39.2

