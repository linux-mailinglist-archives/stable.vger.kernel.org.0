Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0822C6044F2
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 14:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232686AbiJSMTP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 08:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233061AbiJSMS7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 08:18:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 233AFB56;
        Wed, 19 Oct 2022 04:54:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B055CB822F3;
        Wed, 19 Oct 2022 08:44:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA801C433C1;
        Wed, 19 Oct 2022 08:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169052;
        bh=nUERqgW9u3L3Gmp0YEDns3/KS90y3rmvkG6wOm5wYsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qqcwACNfdv8ioKlc1kJncRwfqZHaT/6UjbqDYSWFzE1vMpbnKtAzlM87LgSVC6iet
         zI3jHgn3idqvyTeUyk1eugXExXJbxQ96V8dDEUdLVCBTRPCnMu2BnVZCTACdmPbpKw
         vTensmLcj+iIyGlnsMUMWwJ5HRC82t0ZpzzOvpfg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Zhang Yi <yi.zhang@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.0 141/862] ext4: ext4_read_bh_lock() should submit IO if the buffer isnt uptodate
Date:   Wed, 19 Oct 2022 10:23:48 +0200
Message-Id: <20221019083256.225377856@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Yi <yi.zhang@huawei.com>

commit 0b73284c564d3ae4feef4bc920292f004acf4980 upstream.

Recently we notice that ext4 filesystem would occasionally fail to read
metadata from disk and report error message, but the disk and block
layer looks fine. After analyse, we lockon commit 88dbcbb3a484
("blkdev: avoid migration stalls for blkdev pages"). It provide a
migration method for the bdev, we could move page that has buffers
without extra users now, but it lock the buffers on the page, which
breaks the fragile metadata read operation on ext4 filesystem,
ext4_read_bh_lock() was copied from ll_rw_block(), it depends on the
assumption of that locked buffer means it is under IO. So it just
trylock the buffer and skip submit IO if it lock failed, after
wait_on_buffer() we conclude IO error because the buffer is not
uptodate.

This issue could be easily reproduced by add some delay just after
buffer_migrate_lock_buffers() in __buffer_migrate_folio() and do
fsstress on ext4 filesystem.

  EXT4-fs error (device pmem1): __ext4_find_entry:1658: inode #73193:
  comm fsstress: reading directory lblock 0
  EXT4-fs error (device pmem1): __ext4_find_entry:1658: inode #75334:
  comm fsstress: reading directory lblock 0

Fix it by removing the trylock logic in ext4_read_bh_lock(), just lock
the buffer and submit IO if it's not uptodate, and also leave over
readahead helper.

Cc: stable@kernel.org
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220831074629.3755110-1-yi.zhang@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -205,19 +205,12 @@ int ext4_read_bh(struct buffer_head *bh,
 
 int ext4_read_bh_lock(struct buffer_head *bh, blk_opf_t op_flags, bool wait)
 {
-	if (trylock_buffer(bh)) {
-		if (wait)
-			return ext4_read_bh(bh, op_flags, NULL);
+	lock_buffer(bh);
+	if (!wait) {
 		ext4_read_bh_nowait(bh, op_flags, NULL);
 		return 0;
 	}
-	if (wait) {
-		wait_on_buffer(bh);
-		if (buffer_uptodate(bh))
-			return 0;
-		return -EIO;
-	}
-	return 0;
+	return ext4_read_bh(bh, op_flags, NULL);
 }
 
 /*
@@ -264,7 +257,8 @@ void ext4_sb_breadahead_unmovable(struct
 	struct buffer_head *bh = sb_getblk_gfp(sb, block, 0);
 
 	if (likely(bh)) {
-		ext4_read_bh_lock(bh, REQ_RAHEAD, false);
+		if (trylock_buffer(bh))
+			ext4_read_bh_nowait(bh, REQ_RAHEAD, NULL);
 		brelse(bh);
 	}
 }


