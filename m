Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51D0054169D
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377327AbiFGUx5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376929AbiFGUsb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:48:31 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E001F6B4B;
        Tue,  7 Jun 2022 11:39:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 314A0CE2466;
        Tue,  7 Jun 2022 18:39:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB866C385A2;
        Tue,  7 Jun 2022 18:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627154;
        bh=0Yn6vB/GHqli297lTqLuVOoTzRxqTD9SRGLmLJy8iSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZOvhnDE8U3IAS1judngmB1FSDgYEWW2aObk4CMwX7eBDq2yJIqHYajzxAb8kb9Afj
         afV9UQqeaix7YNbbq+/Z2/Q1+/+vn19zA2akcynAPq0MG0zOQbClSdEK4q3Z/6QGYq
         D2bi/XfjbYK2Bu1v+xalwJJU5xi3vnBBnQtp+/P8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 5.17 636/772] ext4: mark group as trimmed only if it was fully scanned
Date:   Tue,  7 Jun 2022 19:03:48 +0200
Message-Id: <20220607165007.675998667@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>

commit d63c00ea435a5352f486c259665a4ced60399421 upstream.

Otherwise nonaligned fstrim calls will works inconveniently for iterative
scanners, for example:

// trim [0,16MB] for group-1, but mark full group as trimmed
fstrim  -o $((1024*1024*128)) -l $((1024*1024*16)) ./m
// handle [16MB,16MB] for group-1, do nothing because group already has the flag.
fstrim  -o $((1024*1024*144)) -l $((1024*1024*16)) ./m

[ Update function documentation for ext4_trim_all_free -- TYT ]

Signed-off-by: Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
Link: https://lore.kernel.org/r/1650214995-860245-1-git-send-email-dmtrmonakhov@yandex-team.ru
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -6377,6 +6377,7 @@ __releases(ext4_group_lock_ptr(sb, e4b->
  * @start:		first group block to examine
  * @max:		last group block to examine
  * @minblocks:		minimum extent block count
+ * @set_trimmed:	set the trimmed flag if at least one block is trimmed
  *
  * ext4_trim_all_free walks through group's block bitmap searching for free
  * extents. When the free extent is found, mark it as used in group buddy
@@ -6386,7 +6387,7 @@ __releases(ext4_group_lock_ptr(sb, e4b->
 static ext4_grpblk_t
 ext4_trim_all_free(struct super_block *sb, ext4_group_t group,
 		   ext4_grpblk_t start, ext4_grpblk_t max,
-		   ext4_grpblk_t minblocks)
+		   ext4_grpblk_t minblocks, bool set_trimmed)
 {
 	struct ext4_buddy e4b;
 	int ret;
@@ -6405,7 +6406,7 @@ ext4_trim_all_free(struct super_block *s
 	if (!EXT4_MB_GRP_WAS_TRIMMED(e4b.bd_info) ||
 	    minblocks < EXT4_SB(sb)->s_last_trim_minblks) {
 		ret = ext4_try_to_trim_range(sb, &e4b, start, max, minblocks);
-		if (ret >= 0)
+		if (ret >= 0 && set_trimmed)
 			EXT4_MB_GRP_SET_TRIMMED(e4b.bd_info);
 	} else {
 		ret = 0;
@@ -6442,6 +6443,7 @@ int ext4_trim_fs(struct super_block *sb,
 	ext4_fsblk_t first_data_blk =
 			le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block);
 	ext4_fsblk_t max_blks = ext4_blocks_count(EXT4_SB(sb)->s_es);
+	bool whole_group, eof = false;
 	int ret = 0;
 
 	start = range->start >> sb->s_blocksize_bits;
@@ -6460,8 +6462,10 @@ int ext4_trim_fs(struct super_block *sb,
 		if (minlen > EXT4_CLUSTERS_PER_GROUP(sb))
 			goto out;
 	}
-	if (end >= max_blks)
+	if (end >= max_blks - 1) {
 		end = max_blks - 1;
+		eof = true;
+	}
 	if (end <= first_data_blk)
 		goto out;
 	if (start < first_data_blk)
@@ -6475,6 +6479,7 @@ int ext4_trim_fs(struct super_block *sb,
 
 	/* end now represents the last cluster to discard in this group */
 	end = EXT4_CLUSTERS_PER_GROUP(sb) - 1;
+	whole_group = true;
 
 	for (group = first_group; group <= last_group; group++) {
 		grp = ext4_get_group_info(sb, group);
@@ -6491,12 +6496,13 @@ int ext4_trim_fs(struct super_block *sb,
 		 * change it for the last group, note that last_cluster is
 		 * already computed earlier by ext4_get_group_no_and_offset()
 		 */
-		if (group == last_group)
+		if (group == last_group) {
 			end = last_cluster;
-
+			whole_group = eof ? true : end == EXT4_CLUSTERS_PER_GROUP(sb) - 1;
+		}
 		if (grp->bb_free >= minlen) {
 			cnt = ext4_trim_all_free(sb, group, first_cluster,
-						end, minlen);
+						 end, minlen, whole_group);
 			if (cnt < 0) {
 				ret = cnt;
 				break;


