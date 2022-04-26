Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C217D50F73D
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234829AbiDZJLX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346321AbiDZJHa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:07:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5364CFB81;
        Tue, 26 Apr 2022 01:48:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A4F8B81A2F;
        Tue, 26 Apr 2022 08:48:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAAD3C385C6;
        Tue, 26 Apr 2022 08:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962930;
        bh=mt4oTxRDRytd2sDxSUA4c6vTrTy49Qqxkea0a5v82a8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Grank+nkG1TEqJt1zhydLDTLXRYMwvDDnUhCA6uej95QpUbod4POjRXp36POmkjYE
         vKNblCY7/TpNC0SXVgf9Nh1J7MdRdD43kh5QviUoeGHuKRaJnOQ9IJ2QqcltY9TeYX
         8IrTcu5yq8SW8lvJO0g1k40a3HfnB/ZyRy2Tsqn8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Ye Bin <yebin10@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.17 135/146] ext4: fix symlink file size not match to file content
Date:   Tue, 26 Apr 2022 10:22:10 +0200
Message-Id: <20220426081753.854119673@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
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
@@ -134,8 +134,10 @@ static void ext4_finish_bio(struct bio *
 				continue;
 			}
 			clear_buffer_async_write(bh);
-			if (bio->bi_status)
+			if (bio->bi_status) {
+				set_buffer_write_io_error(bh);
 				buffer_io_error(bh);
+			}
 		} while ((bh = bh->b_this_page) != head);
 		spin_unlock_irqrestore(&head->b_uptodate_lock, flags);
 		if (!under_io) {


