Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9E85664A7F
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238983AbjAJSdQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:33:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234089AbjAJSca (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:32:30 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E0B8D5DF
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:28:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 32AE9CE18D1
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:28:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27255C433EF;
        Tue, 10 Jan 2023 18:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375285;
        bh=plsvWqq3KzG6QZ2GE/koKpdD/gxOWAx0+3lyWXyqmyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q78Vgl+z3p1CdQxt1IpYQlMQ/Pk9P5AxIrCvTrIlnGNHxuSd8LUyPg4TC0kP/bPLy
         pyK6LBgATaRhJxckQTJkNCNmoW7m46XjbG6m49eRgErv8Flkvwrf/IFQr8cEVkWg7+
         drK+6MgKGPpE65mPpaugMdR28vsKBHxrZ2GJ5JL4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable@kernel.org,
        Baokun Li <libaokun1@huawei.com>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 140/290] ext4: add inode table check in __ext4_get_inode_loc to aovid possible infinite loop
Date:   Tue, 10 Jan 2023 19:03:52 +0100
Message-Id: <20230110180036.679826818@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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

From: Baokun Li <libaokun1@huawei.com>

commit eee22187b53611e173161e38f61de1c7ecbeb876 upstream.

In do_writepages, if the value returned by ext4_writepages is "-ENOMEM"
and "wbc->sync_mode == WB_SYNC_ALL", retry until the condition is not met.

In __ext4_get_inode_loc, if the bh returned by sb_getblk is NULL,
the function returns -ENOMEM.

In __getblk_slow, if the return value of grow_buffers is less than 0,
the function returns NULL.

When the three processes are connected in series like the following stack,
an infinite loop may occur:

do_writepages					<--- keep retrying
 ext4_writepages
  mpage_map_and_submit_extent
   mpage_map_one_extent
    ext4_map_blocks
     ext4_ext_map_blocks
      ext4_ext_handle_unwritten_extents
       ext4_ext_convert_to_initialized
        ext4_split_extent
         ext4_split_extent_at
          __ext4_ext_dirty
           __ext4_mark_inode_dirty
            ext4_reserve_inode_write
             ext4_get_inode_loc
              __ext4_get_inode_loc		<--- return -ENOMEM
               sb_getblk
                __getblk_gfp
                 __getblk_slow			<--- return NULL
                  grow_buffers
                   grow_dev_page		<--- return -ENXIO
                    ret = (block < end_block) ? 1 : -ENXIO;

In this issue, bg_inode_table_hi is overwritten as an incorrect value.
As a result, `block < end_block` cannot be met in grow_dev_page.
Therefore, __ext4_get_inode_loc always returns '-ENOMEM' and do_writepages
keeps retrying. As a result, the writeback process is in the D state due
to an infinite loop.

Add a check on inode table block in the __ext4_get_inode_loc function by
referring to ext4_read_inode_bitmap to avoid this infinite loop.

Cc: stable@kernel.org
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Link: https://lore.kernel.org/r/20220817132701.3015912-3-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4299,9 +4299,17 @@ static int __ext4_get_inode_loc(struct s
 	inodes_per_block = EXT4_SB(sb)->s_inodes_per_block;
 	inode_offset = ((ino - 1) %
 			EXT4_INODES_PER_GROUP(sb));
-	block = ext4_inode_table(sb, gdp) + (inode_offset / inodes_per_block);
 	iloc->offset = (inode_offset % inodes_per_block) * EXT4_INODE_SIZE(sb);
 
+	block = ext4_inode_table(sb, gdp);
+	if ((block <= le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block)) ||
+	    (block >= ext4_blocks_count(EXT4_SB(sb)->s_es))) {
+		ext4_error(sb, "Invalid inode table block %llu in "
+			   "block_group %u", block, iloc->block_group);
+		return -EFSCORRUPTED;
+	}
+	block += (inode_offset / inodes_per_block);
+
 	bh = sb_getblk(sb, block);
 	if (unlikely(!bh))
 		return -ENOMEM;


