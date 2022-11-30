Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA55C63E050
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbiK3Szt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:55:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231611AbiK3Szs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:55:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BDAD63D75
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:55:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C50861D54
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:55:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC3C6C433C1;
        Wed, 30 Nov 2022 18:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834547;
        bh=msowT8m+yx0LdFH96MBohWz6eRLFoNUV0Bi7ojjdjVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fOIKOdNUsa//IAfaKbpkrEUKx4P+Gs6rQ5GnS80bCqRt1XD9EQx3I3IepsqlnaXcC
         82u9y64iYNNjbN7I7f4PMUKwwmGktc3bTxzg2tmn/cMEFbIlPLuoHx8Z6jSvVwIb2A
         CZLeA+ph4NKeLVWvR9AnKPwHZ/V+fuQvZMsnn994=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pengfei Xu <pengfei.xu@intel.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        syzbot+462da39f0667b357c4b6@syzkaller.appspotmail.com
Subject: [PATCH 6.0 266/289] fuse: lock inode unconditionally in fuse_fallocate()
Date:   Wed, 30 Nov 2022 19:24:11 +0100
Message-Id: <20221130180550.129505808@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Miklos Szeredi <mszeredi@redhat.com>

commit 44361e8cf9ddb23f17bdcc40ca944abf32e83e79 upstream.

file_modified() must be called with inode lock held.  fuse_fallocate()
didn't lock the inode in case of just FALLOC_KEEP_SIZE flags value, which
resulted in a kernel Warning in notify_change().

Lock the inode unconditionally, like all other fallocate implementations
do.

Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Reported-and-tested-by: syzbot+462da39f0667b357c4b6@syzkaller.appspotmail.com
Fixes: 4a6f278d4827 ("fuse: add file_modified() to fallocate")
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/file.c |   41 ++++++++++++++++++-----------------------
 1 file changed, 18 insertions(+), 23 deletions(-)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2963,11 +2963,9 @@ static long fuse_file_fallocate(struct f
 		.mode = mode
 	};
 	int err;
-	bool lock_inode = !(mode & FALLOC_FL_KEEP_SIZE) ||
-			   (mode & (FALLOC_FL_PUNCH_HOLE |
-				    FALLOC_FL_ZERO_RANGE));
-
-	bool block_faults = FUSE_IS_DAX(inode) && lock_inode;
+	bool block_faults = FUSE_IS_DAX(inode) &&
+		(!(mode & FALLOC_FL_KEEP_SIZE) ||
+		 (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE)));
 
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
 		     FALLOC_FL_ZERO_RANGE))
@@ -2976,22 +2974,20 @@ static long fuse_file_fallocate(struct f
 	if (fm->fc->no_fallocate)
 		return -EOPNOTSUPP;
 
-	if (lock_inode) {
-		inode_lock(inode);
-		if (block_faults) {
-			filemap_invalidate_lock(inode->i_mapping);
-			err = fuse_dax_break_layouts(inode, 0, 0);
-			if (err)
-				goto out;
-		}
-
-		if (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE)) {
-			loff_t endbyte = offset + length - 1;
-
-			err = fuse_writeback_range(inode, offset, endbyte);
-			if (err)
-				goto out;
-		}
+	inode_lock(inode);
+	if (block_faults) {
+		filemap_invalidate_lock(inode->i_mapping);
+		err = fuse_dax_break_layouts(inode, 0, 0);
+		if (err)
+			goto out;
+	}
+
+	if (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE)) {
+		loff_t endbyte = offset + length - 1;
+
+		err = fuse_writeback_range(inode, offset, endbyte);
+		if (err)
+			goto out;
 	}
 
 	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
@@ -3039,8 +3035,7 @@ out:
 	if (block_faults)
 		filemap_invalidate_unlock(inode->i_mapping);
 
-	if (lock_inode)
-		inode_unlock(inode);
+	inode_unlock(inode);
 
 	fuse_flush_time_update(inode);
 


