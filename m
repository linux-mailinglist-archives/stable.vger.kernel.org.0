Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36F7E551C9B
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345146AbiFTN0c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:26:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344474AbiFTNY7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:24:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 133911ADBF;
        Mon, 20 Jun 2022 06:10:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5BFD6159A;
        Mon, 20 Jun 2022 13:03:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B95C0C3411B;
        Mon, 20 Jun 2022 13:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730220;
        bh=M5BxGuOiFhn763Qj9N9TzXjE+SuVmhx9Bl0zZM86ejY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KDoJO4rHSmy4Kq9ZgI3pzFS0/Ao8W8eAyFq98+dLd1+yqfVBaQojMevGEzsx9joct
         2D3aby5JvOCJxvzLQ8fu2NOXwINpabStZVLC5cDoKH6k/76MTm1LManx7jZWtqxVsM
         T48Fr//T+9ylwt8YrH5Y2NKaK3RO+bCXo0h5boHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Hulk Robot <hulkci@huawei.com>,
        Baokun Li <libaokun1@huawei.com>,
        Ritesh Harjani <ritesh.list@gmail.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 70/84] ext4: fix bug_on ext4_mb_use_inode_pa
Date:   Mon, 20 Jun 2022 14:51:33 +0200
Message-Id: <20220620124722.961294648@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124720.882450983@linuxfoundation.org>
References: <20220620124720.882450983@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baokun Li <libaokun1@huawei.com>

commit a08f789d2ab5242c07e716baf9a835725046be89 upstream.

Hulk Robot reported a BUG_ON:
==================================================================
kernel BUG at fs/ext4/mballoc.c:3211!
[...]
RIP: 0010:ext4_mb_mark_diskspace_used.cold+0x85/0x136f
[...]
Call Trace:
 ext4_mb_new_blocks+0x9df/0x5d30
 ext4_ext_map_blocks+0x1803/0x4d80
 ext4_map_blocks+0x3a4/0x1a10
 ext4_writepages+0x126d/0x2c30
 do_writepages+0x7f/0x1b0
 __filemap_fdatawrite_range+0x285/0x3b0
 file_write_and_wait_range+0xb1/0x140
 ext4_sync_file+0x1aa/0xca0
 vfs_fsync_range+0xfb/0x260
 do_fsync+0x48/0xa0
[...]
==================================================================

Above issue may happen as follows:
-------------------------------------
do_fsync
 vfs_fsync_range
  ext4_sync_file
   file_write_and_wait_range
    __filemap_fdatawrite_range
     do_writepages
      ext4_writepages
       mpage_map_and_submit_extent
        mpage_map_one_extent
         ext4_map_blocks
          ext4_mb_new_blocks
           ext4_mb_normalize_request
            >>> start + size <= ac->ac_o_ex.fe_logical
           ext4_mb_regular_allocator
            ext4_mb_simple_scan_group
             ext4_mb_use_best_found
              ext4_mb_new_preallocation
               ext4_mb_new_inode_pa
                ext4_mb_use_inode_pa
                 >>> set ac->ac_b_ex.fe_len <= 0
           ext4_mb_mark_diskspace_used
            >>> BUG_ON(ac->ac_b_ex.fe_len <= 0);

we can easily reproduce this problem with the following commands:
	`fallocate -l100M disk`
	`mkfs.ext4 -b 1024 -g 256 disk`
	`mount disk /mnt`
	`fsstress -d /mnt -l 0 -n 1000 -p 1`

The size must be smaller than or equal to EXT4_BLOCKS_PER_GROUP.
Therefore, "start + size <= ac->ac_o_ex.fe_logical" may occur
when the size is truncated. So start should be the start position of
the group where ac_o_ex.fe_logical is located after alignment.
In addition, when the value of fe_logical or EXT4_BLOCKS_PER_GROUP
is very large, the value calculated by start_off is more accurate.

Cc: stable@kernel.org
Fixes: cd648b8a8fd5 ("ext4: trim allocation requests to group size")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Ritesh Harjani <ritesh.list@gmail.com>
Link: https://lore.kernel.org/r/20220528110017.354175-2-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3520,6 +3520,15 @@ ext4_mb_normalize_request(struct ext4_al
 	size = size >> bsbits;
 	start = start_off >> bsbits;
 
+	/*
+	 * For tiny groups (smaller than 8MB) the chosen allocation
+	 * alignment may be larger than group size. Make sure the
+	 * alignment does not move allocation to a different group which
+	 * makes mballoc fail assertions later.
+	 */
+	start = max(start, rounddown(ac->ac_o_ex.fe_logical,
+			(ext4_lblk_t)EXT4_BLOCKS_PER_GROUP(ac->ac_sb)));
+
 	/* don't cover already allocated blocks in selected range */
 	if (ar->pleft && start <= ar->lleft) {
 		size -= ar->lleft + 1 - start;


