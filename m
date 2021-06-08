Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9413239FF5A
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232905AbhFHSc0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:32:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:56878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234124AbhFHSbt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:31:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B74F61352;
        Tue,  8 Jun 2021 18:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623176995;
        bh=VflrBC4eeexjlERvv1bC2/3Ncwtj0N2AwS8rE4uQ2ek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jisRT0cPAmyr/dbq8VU/EpPK1ohRj++JK/rHF+YnF2eSeBQTGAbinQa0uc+K1K6lK
         +dOi60v/13lfaLuLND6yjByO9Gtmbe8qzg3LzYSu/7H2/PnwkUnq7kKPo7vAOqKrbN
         Xro5J9rQwEFWTf8PVJkuF1SjCB5WYZ5UeV9Fk56k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Ye Bin <yebin10@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.9 20/29] ext4: fix bug on in ext4_es_cache_extent as ext4_split_extent_at failed
Date:   Tue,  8 Jun 2021 20:27:14 +0200
Message-Id: <20210608175928.473651477@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175927.821075974@linuxfoundation.org>
References: <20210608175927.821075974@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Bin <yebin10@huawei.com>

commit 082cd4ec240b8734a82a89ffb890216ac98fec68 upstream.

We got follow bug_on when run fsstress with injecting IO fault:
[130747.323114] kernel BUG at fs/ext4/extents_status.c:762!
[130747.323117] Internal error: Oops - BUG: 0 [#1] SMP
......
[130747.334329] Call trace:
[130747.334553]  ext4_es_cache_extent+0x150/0x168 [ext4]
[130747.334975]  ext4_cache_extents+0x64/0xe8 [ext4]
[130747.335368]  ext4_find_extent+0x300/0x330 [ext4]
[130747.335759]  ext4_ext_map_blocks+0x74/0x1178 [ext4]
[130747.336179]  ext4_map_blocks+0x2f4/0x5f0 [ext4]
[130747.336567]  ext4_mpage_readpages+0x4a8/0x7a8 [ext4]
[130747.336995]  ext4_readpage+0x54/0x100 [ext4]
[130747.337359]  generic_file_buffered_read+0x410/0xae8
[130747.337767]  generic_file_read_iter+0x114/0x190
[130747.338152]  ext4_file_read_iter+0x5c/0x140 [ext4]
[130747.338556]  __vfs_read+0x11c/0x188
[130747.338851]  vfs_read+0x94/0x150
[130747.339110]  ksys_read+0x74/0xf0

This patch's modification is according to Jan Kara's suggestion in:
https://patchwork.ozlabs.org/project/linux-ext4/patch/20210428085158.3728201-1-yebin10@huawei.com/
"I see. Now I understand your patch. Honestly, seeing how fragile is trying
to fix extent tree after split has failed in the middle, I would probably
go even further and make sure we fix the tree properly in case of ENOSPC
and EDQUOT (those are easily user triggerable).  Anything else indicates a
HW problem or fs corruption so I'd rather leave the extent tree as is and
don't try to fix it (which also means we will not create overlapping
extents)."

Cc: stable@kernel.org
Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20210506141042.3298679-1-yebin10@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c |   43 +++++++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 20 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3274,7 +3274,10 @@ static int ext4_split_extent_at(handle_t
 		ext4_ext_mark_unwritten(ex2);
 
 	err = ext4_ext_insert_extent(handle, inode, ppath, &newex, flags);
-	if (err == -ENOSPC && (EXT4_EXT_MAY_ZEROOUT & split_flag)) {
+	if (err != -ENOSPC && err != -EDQUOT)
+		goto out;
+
+	if (EXT4_EXT_MAY_ZEROOUT & split_flag) {
 		if (split_flag & (EXT4_EXT_DATA_VALID1|EXT4_EXT_DATA_VALID2)) {
 			if (split_flag & EXT4_EXT_DATA_VALID1) {
 				err = ext4_ext_zeroout(inode, ex2);
@@ -3300,30 +3303,30 @@ static int ext4_split_extent_at(handle_t
 					      ext4_ext_pblock(&orig_ex));
 		}
 
-		if (err)
-			goto fix_extent_len;
-		/* update the extent length and mark as initialized */
-		ex->ee_len = cpu_to_le16(ee_len);
-		ext4_ext_try_to_merge(handle, inode, path, ex);
-		err = ext4_ext_dirty(handle, inode, path + path->p_depth);
-		if (err)
-			goto fix_extent_len;
-
-		/* update extent status tree */
-		err = ext4_zeroout_es(inode, &zero_ex);
-
-		goto out;
-	} else if (err)
-		goto fix_extent_len;
-
-out:
-	ext4_ext_show_leaf(inode, path);
-	return err;
+		if (!err) {
+			/* update the extent length and mark as initialized */
+			ex->ee_len = cpu_to_le16(ee_len);
+			ext4_ext_try_to_merge(handle, inode, path, ex);
+			err = ext4_ext_dirty(handle, inode, path + path->p_depth);
+			if (!err)
+				/* update extent status tree */
+				err = ext4_zeroout_es(inode, &zero_ex);
+			/* If we failed at this point, we don't know in which
+			 * state the extent tree exactly is so don't try to fix
+			 * length of the original extent as it may do even more
+			 * damage.
+			 */
+			goto out;
+		}
+	}
 
 fix_extent_len:
 	ex->ee_len = orig_ex.ee_len;
 	ext4_ext_dirty(handle, inode, path + path->p_depth);
 	return err;
+out:
+	ext4_ext_show_leaf(inode, path);
+	return err;
 }
 
 /*


