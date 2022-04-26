Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E794150F466
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344781AbiDZIgF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344840AbiDZIdr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:33:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C319B45059;
        Tue, 26 Apr 2022 01:25:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84046B81A2F;
        Tue, 26 Apr 2022 08:25:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFEECC385A0;
        Tue, 26 Apr 2022 08:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961539;
        bh=Wgd36B5rjC5/ZHNoZuT+EVys1kOLNjl1nZr2tmHVyXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1kv/2SVkNVXt0w3O5O2T7l0un7b1vfone/2arnfm+zkp5Secojklv5gFveREy7ILu
         XCrufsSGJIe0DlN3X393tCKAUj6iw4ZkszOsEBWpqOv00Whacjkz/QrZvqvtw7zv9W
         Df7EO+yLR8WBPAxW6tLu4HUfgsVqlkJvaq2ddCto=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Ye Bin <yebin10@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.14 29/43] ext4: fix symlink file size not match to file content
Date:   Tue, 26 Apr 2022 10:21:11 +0200
Message-Id: <20220426081735.376938779@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081734.509314186@linuxfoundation.org>
References: <20220426081734.509314186@linuxfoundation.org>
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

From: Ye Bin <yebin10@huawei.com>

commit a2b0b205d125f27cddfb4f7280e39affdaf46686 upstream.

We got issue as follows:
[home]# fsck.ext4  -fn  ram0yb
e2fsck 1.45.6 (20-Mar-2020)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Symlink /p3/d14/d1a/l3d (inode #3494) is invalid.
Clear? no
Entry 'l3d' in /p3/d14/d1a (3383) has an incorrect filetype (was 7, should be 0).
Fix? no

As the symlink file size does not match the file content. If the writeback
of the symlink data block failed, ext4_finish_bio() handles the end of IO.
However this function fails to mark the buffer with BH_write_io_error and
so when unmount does journal checkpoint it cannot detect the writeback
error and will cleanup the journal. Thus we've lost the correct data in the
journal area. To solve this issue, mark the buffer as BH_write_io_error in
ext4_finish_bio().

Cc: stable@kernel.org
Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220321144438.201685-1-yebin10@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/page-io.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -105,8 +105,10 @@ static void ext4_finish_bio(struct bio *
 				continue;
 			}
 			clear_buffer_async_write(bh);
-			if (bio->bi_status)
+			if (bio->bi_status) {
+				set_buffer_write_io_error(bh);
 				buffer_io_error(bh);
+			}
 		} while ((bh = bh->b_this_page) != head);
 		bit_spin_unlock(BH_Uptodate_Lock, &head->b_state);
 		local_irq_restore(flags);


