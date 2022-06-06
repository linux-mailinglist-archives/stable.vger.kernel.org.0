Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30D4053E761
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236536AbiFFMMC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 08:12:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236544AbiFFMMA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 08:12:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7D69CF39
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 05:11:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28BA161149
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 12:11:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15FE7C3411D;
        Mon,  6 Jun 2022 12:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654517517;
        bh=WSCSANRt0TbN3pmoANS0Gy8awgwy+lR2it7lvkSGfy4=;
        h=Subject:To:Cc:From:Date:From;
        b=0jPhbOI4gxtyLUnC2xoZacsg9Fc7Gc7APdYwjehuiqi5pcmFYD4xC9QfTMC//JSNF
         DQSkZzz15WwnAi3Ru0jIg819fi6+tM3NxJSxt1vw/nU3BHQSfhLmm/ozYMEsbkIoAW
         f+lTg9P5HNyQE3Uq7k0VhTIXVLNwWb/HBbNbTuWQ=
Subject: FAILED: patch "[PATCH] ext4: fix bug_on in __es_tree_search" failed to apply to 4.19-stable tree
To:     libaokun1@huawei.com, hulkci@huawei.com, jack@suse.cz,
        tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 14:11:52 +0200
Message-ID: <16545175121504@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d36f6ed761b53933b0b4126486c10d3da7751e7f Mon Sep 17 00:00:00 2001
From: Baokun Li <libaokun1@huawei.com>
Date: Wed, 18 May 2022 20:08:16 +0800
Subject: [PATCH] ext4: fix bug_on in __es_tree_search

Hulk Robot reported a BUG_ON:
==================================================================
kernel BUG at fs/ext4/extents_status.c:199!
[...]
RIP: 0010:ext4_es_end fs/ext4/extents_status.c:199 [inline]
RIP: 0010:__es_tree_search+0x1e0/0x260 fs/ext4/extents_status.c:217
[...]
Call Trace:
 ext4_es_cache_extent+0x109/0x340 fs/ext4/extents_status.c:766
 ext4_cache_extents+0x239/0x2e0 fs/ext4/extents.c:561
 ext4_find_extent+0x6b7/0xa20 fs/ext4/extents.c:964
 ext4_ext_map_blocks+0x16b/0x4b70 fs/ext4/extents.c:4384
 ext4_map_blocks+0xe26/0x19f0 fs/ext4/inode.c:567
 ext4_getblk+0x320/0x4c0 fs/ext4/inode.c:980
 ext4_bread+0x2d/0x170 fs/ext4/inode.c:1031
 ext4_quota_read+0x248/0x320 fs/ext4/super.c:6257
 v2_read_header+0x78/0x110 fs/quota/quota_v2.c:63
 v2_check_quota_file+0x76/0x230 fs/quota/quota_v2.c:82
 vfs_load_quota_inode+0x5d1/0x1530 fs/quota/dquot.c:2368
 dquot_enable+0x28a/0x330 fs/quota/dquot.c:2490
 ext4_quota_enable fs/ext4/super.c:6137 [inline]
 ext4_enable_quotas+0x5d7/0x960 fs/ext4/super.c:6163
 ext4_fill_super+0xa7c9/0xdc00 fs/ext4/super.c:4754
 mount_bdev+0x2e9/0x3b0 fs/super.c:1158
 mount_fs+0x4b/0x1e4 fs/super.c:1261
[...]
==================================================================

Above issue may happen as follows:
-------------------------------------
ext4_fill_super
 ext4_enable_quotas
  ext4_quota_enable
   ext4_iget
    __ext4_iget
     ext4_ext_check_inode
      ext4_ext_check
       __ext4_ext_check
        ext4_valid_extent_entries
         Check for overlapping extents does't take effect
   dquot_enable
    vfs_load_quota_inode
     v2_check_quota_file
      v2_read_header
       ext4_quota_read
        ext4_bread
         ext4_getblk
          ext4_map_blocks
           ext4_ext_map_blocks
            ext4_find_extent
             ext4_cache_extents
              ext4_es_cache_extent
               ext4_es_cache_extent
                __es_tree_search
                 ext4_es_end
                  BUG_ON(es->es_lblk + es->es_len < es->es_lblk)

The error ext4 extents is as follows:
0af3 0300 0400 0000 00000000    extent_header
00000000 0100 0000 12000000     extent1
00000000 0100 0000 18000000     extent2
02000000 0400 0000 14000000     extent3

In the ext4_valid_extent_entries function,
if prev is 0, no error is returned even if lblock<=prev.
This was intended to skip the check on the first extent, but
in the error image above, prev=0+1-1=0 when checking the second extent,
so even though lblock<=prev, the function does not return an error.
As a result, bug_ON occurs in __es_tree_search and the system panics.

To solve this problem, we only need to check that:
1. The lblock of the first extent is not less than 0.
2. The lblock of the next extent  is not less than
   the next block of the previous extent.
The same applies to extent_idx.

Cc: stable@kernel.org
Fixes: 5946d089379a ("ext4: check for overlapping extents in ext4_valid_extent_entries()")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220518120816.1541863-1-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 474479ce76e0..c148bb97b527 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -372,7 +372,7 @@ static int ext4_valid_extent_entries(struct inode *inode,
 {
 	unsigned short entries;
 	ext4_lblk_t lblock = 0;
-	ext4_lblk_t prev = 0;
+	ext4_lblk_t cur = 0;
 
 	if (eh->eh_entries == 0)
 		return 1;
@@ -396,11 +396,11 @@ static int ext4_valid_extent_entries(struct inode *inode,
 
 			/* Check for overlapping extents */
 			lblock = le32_to_cpu(ext->ee_block);
-			if ((lblock <= prev) && prev) {
+			if (lblock < cur) {
 				*pblk = ext4_ext_pblock(ext);
 				return 0;
 			}
-			prev = lblock + ext4_ext_get_actual_len(ext) - 1;
+			cur = lblock + ext4_ext_get_actual_len(ext);
 			ext++;
 			entries--;
 		}
@@ -420,13 +420,13 @@ static int ext4_valid_extent_entries(struct inode *inode,
 
 			/* Check for overlapping index extents */
 			lblock = le32_to_cpu(ext_idx->ei_block);
-			if ((lblock <= prev) && prev) {
+			if (lblock < cur) {
 				*pblk = ext4_idx_pblock(ext_idx);
 				return 0;
 			}
 			ext_idx++;
 			entries--;
-			prev = lblock;
+			cur = lblock + 1;
 		}
 	}
 	return 1;

