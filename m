Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92EEE6677A7
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239866AbjALOqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:46:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239963AbjALOpw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:45:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A2E5E678
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:34:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83A8C60AB3
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:34:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79CE4C433D2;
        Thu, 12 Jan 2023 14:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673534041;
        bh=YXsvVkbz4VetYhwqccxBJRYFNckHVXQjcLQThVKAgvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HyJ63M4PTEv9aLxotKfb8KIY6tjxERL62GNerd51av/nMIXAL5uFv3ajsr4VZm7RA
         mEdJhJwZUH5TsIZi1bQ1xKVgrOq916ohuwRkl469AdgxyLipCXPbGZd7aza1r1EkHi
         OAkRyR8i29Wb980CxlxPAPFRO7sjAlNB/c6wOZik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+05a0f0ccab4a25626e38@syzkaller.appspotmail.com,
        Ye Bin <yebin10@huawei.com>, Eric Whitney <enwlinux@gmail.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 5.10 676/783] ext4: fix reserved cluster accounting in __es_remove_extent()
Date:   Thu, 12 Jan 2023 14:56:32 +0100
Message-Id: <20230112135555.662769181@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Ye Bin <yebin10@huawei.com>

commit 1da18e38cb97e9521e93d63034521a9649524f64 upstream.

When bigalloc is enabled, reserved cluster accounting for delayed
allocation is handled in extent_status.c.  With a corrupted file
system, it's possible for this accounting to be incorrect,
dsicovered by Syzbot:

EXT4-fs error (device loop0): ext4_validate_block_bitmap:398: comm rep:
	bg 0: block 5: invalid block bitmap
EXT4-fs (loop0): Delayed block allocation failed for inode 18 at logical
	offset 0 with max blocks 32 with error 28
EXT4-fs (loop0): This should not happen!! Data will be lost

EXT4-fs (loop0): Total free blocks count 0
EXT4-fs (loop0): Free/Dirty block details
EXT4-fs (loop0): free_blocks=0
EXT4-fs (loop0): dirty_blocks=32
EXT4-fs (loop0): Block reservation details
EXT4-fs (loop0): i_reserved_data_blocks=2
EXT4-fs (loop0): Inode 18 (00000000845cd634):
	i_reserved_data_blocks (1) not cleared!

Above issue happens as follows:
Assume:
sbi->s_cluster_ratio = 16
Step1:
Insert delay block [0, 31] -> ei->i_reserved_data_blocks=2
Step2:
ext4_writepages
  mpage_map_and_submit_extent -> return failed
  mpage_release_unused_pages -> to release [0, 30]
    ext4_es_remove_extent -> remove lblk=0 end=30
      __es_remove_extent -> len1=0 len2=31-30=1
 __es_remove_extent:
 ...
 if (len2 > 0) {
  ...
	  if (len1 > 0) {
		  ...
	  } else {
		es->es_lblk = end + 1;
		es->es_len = len2;
		...
	  }
  	if (count_reserved)
		count_rsvd(inode, lblk, ...);
	goto out; -> will return but didn't calculate 'reserved'
 ...
Step3:
ext4_destroy_inode -> trigger "i_reserved_data_blocks (1) not cleared!"

To solve above issue if 'len2>0' call 'get_rsvd()' before goto out.

Reported-by: syzbot+05a0f0ccab4a25626e38@syzkaller.appspotmail.com
Fixes: 8fcc3a580651 ("ext4: rework reserved cluster accounting when invalidating pages")
Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Eric Whitney <enwlinux@gmail.com>
Link: https://lore.kernel.org/r/20221208033426.1832460-2-yebin@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents_status.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -1372,7 +1372,7 @@ retry:
 		if (count_reserved)
 			count_rsvd(inode, lblk, orig_es.es_len - len1 - len2,
 				   &orig_es, &rc);
-		goto out;
+		goto out_get_reserved;
 	}
 
 	if (len1 > 0) {
@@ -1414,6 +1414,7 @@ retry:
 		}
 	}
 
+out_get_reserved:
 	if (count_reserved)
 		*reserved = get_rsvd(inode, end, es, &rc);
 out:


