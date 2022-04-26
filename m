Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0A3250F3BB
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344797AbiDZI1a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344677AbiDZI0o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:26:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F804249B;
        Tue, 26 Apr 2022 01:23:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 948C7B81CF3;
        Tue, 26 Apr 2022 08:23:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10D3CC385A0;
        Tue, 26 Apr 2022 08:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961396;
        bh=2ISxZrpT17ZWO7T7HiPFO4wRa/cI71OHRhKfqvSZPG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eb5kiQV1AqMJZ+or2qY1J0SQ76q32SvbKl4R5xhb0NCKDv+ym1TQEQpIFKbLWpHgH
         cgI01y/LRdxj+6r9sCAYS+Wy2P8wdzgIdvnO4IY4fgDN2JpS+bwzkhuShcyynCXlbH
         vHO4Aag8x9BTUWkB+D2ZXincoCe41KJA+7j2yq64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+7a806094edd5d07ba029@syzkaller.appspotmail.com,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 4.9 21/24] ext4: limit length to bitmap_maxbytes - blocksize in punch_hole
Date:   Tue, 26 Apr 2022 10:21:15 +0200
Message-Id: <20220426081731.998414820@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081731.370823950@linuxfoundation.org>
References: <20220426081731.370823950@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tadeusz Struk <tadeusz.struk@linaro.org>

commit 2da376228a2427501feb9d15815a45dbdbdd753e upstream.

Syzbot found an issue [1] in ext4_fallocate().
The C reproducer [2] calls fallocate(), passing size 0xffeffeff000ul,
and offset 0x1000000ul, which, when added together exceed the
bitmap_maxbytes for the inode. This triggers a BUG in
ext4_ind_remove_space(). According to the comments in this function
the 'end' parameter needs to be one block after the last block to be
removed. In the case when the BUG is triggered it points to the last
block. Modify the ext4_punch_hole() function and add constraint that
caps the length to satisfy the one before laster block requirement.

LINK: [1] https://syzkaller.appspot.com/bug?id=b80bd9cf348aac724a4f4dff251800106d721331
LINK: [2] https://syzkaller.appspot.com/text?tag=ReproC&x=14ba0238700000

Fixes: a4bb6b64e39a ("ext4: enable "punch hole" functionality")
Reported-by: syzbot+7a806094edd5d07ba029@syzkaller.appspotmail.com
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
Link: https://lore.kernel.org/r/20220331200515.153214-1-tadeusz.struk@linaro.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3980,7 +3980,8 @@ int ext4_punch_hole(struct inode *inode,
 	struct super_block *sb = inode->i_sb;
 	ext4_lblk_t first_block, stop_block;
 	struct address_space *mapping = inode->i_mapping;
-	loff_t first_block_offset, last_block_offset;
+	loff_t first_block_offset, last_block_offset, max_length;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	handle_t *handle;
 	unsigned int credits;
 	int ret = 0;
@@ -4026,6 +4027,14 @@ int ext4_punch_hole(struct inode *inode,
 		   offset;
 	}
 
+	/*
+	 * For punch hole the length + offset needs to be within one block
+	 * before last range. Adjust the length if it goes beyond that limit.
+	 */
+	max_length = sbi->s_bitmap_maxbytes - inode->i_sb->s_blocksize;
+	if (offset + length > max_length)
+		length = max_length - offset;
+
 	if (offset & (sb->s_blocksize - 1) ||
 	    (offset + length) & (sb->s_blocksize - 1)) {
 		/*


