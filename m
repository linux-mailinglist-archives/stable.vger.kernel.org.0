Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00EB1302CC9
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 21:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731705AbhAYUjw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 15:39:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:46032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732358AbhAYUij (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 15:38:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02C892256F;
        Mon, 25 Jan 2021 20:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611607079;
        bh=cjm7J/AAoT4fftjDeXu1l9wKZQi5XLGSMSCzkXD5w2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YkDPWsQnjI2mlgupYTxBCwGrDHuIs8eylXXdeOafB29i0k3CJ/YE0mAWqfJVoYAwd
         s/AJZNY8l9BJ2boPhicjgWKFAGKygLmG3+C7zPWbo/tXuWCwcD3tEXOKTLBasGQbsN
         wdiQK6d2VOLZhY0GeNDfCKx7BHTr3faKR02dUewAqVAdRa/qTFUksVCMoWVosbvdbR
         cMUApch2jiPEbgS8n2teDydbRmg4Mk7ROEFZVTUOU67GdrcbkJG9FdEDcTnrkFsRRt
         i2BieneMrC846RXGnEraZUAcp7xIR68pBqZObNcWGr6zbm5sOL0y6otMCl0UDns9tj
         TWFakxApdTcjQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 4.14 1/3] fs: move I_DIRTY_INODE to fs.h
Date:   Mon, 25 Jan 2021 12:37:42 -0800
Message-Id: <20210125203744.325479-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125203744.325479-1-ebiggers@kernel.org>
References: <20210125203744.325479-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 0e11f6443f522f89509495b13ef1f3745640144d upstream.

And use it in a few more places rather than opencoding the values.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/inode.c    | 4 ++--
 fs/fs-writeback.c  | 9 +++------
 fs/gfs2/super.c    | 2 +-
 include/linux/fs.h | 3 ++-
 4 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 898f962d3a068..098856fcecf8c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5064,12 +5064,12 @@ static int other_inode_match(struct inode * inode, unsigned long ino,
 
 	if ((inode->i_ino != ino) ||
 	    (inode->i_state & (I_FREEING | I_WILL_FREE | I_NEW |
-			       I_DIRTY_SYNC | I_DIRTY_DATASYNC)) ||
+			       I_DIRTY_INODE)) ||
 	    ((inode->i_state & I_DIRTY_TIME) == 0))
 		return 0;
 	spin_lock(&inode->i_lock);
 	if (((inode->i_state & (I_FREEING | I_WILL_FREE | I_NEW |
-				I_DIRTY_SYNC | I_DIRTY_DATASYNC)) == 0) &&
+				I_DIRTY_INODE)) == 0) &&
 	    (inode->i_state & I_DIRTY_TIME)) {
 		struct ext4_inode_info	*ei = EXT4_I(inode);
 
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 3dbb875ed7903..5a115dc9bc9a9 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1400,7 +1400,7 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 
 	dirty = inode->i_state & I_DIRTY;
 	if (inode->i_state & I_DIRTY_TIME) {
-		if ((dirty & (I_DIRTY_SYNC | I_DIRTY_DATASYNC)) ||
+		if ((dirty & I_DIRTY_INODE) ||
 		    wbc->sync_mode == WB_SYNC_ALL ||
 		    unlikely(inode->i_state & I_DIRTY_TIME_EXPIRED) ||
 		    unlikely(time_after(jiffies,
@@ -2136,7 +2136,6 @@ static noinline void block_dump___mark_inode_dirty(struct inode *inode)
  */
 void __mark_inode_dirty(struct inode *inode, int flags)
 {
-#define I_DIRTY_INODE (I_DIRTY_SYNC | I_DIRTY_DATASYNC)
 	struct super_block *sb = inode->i_sb;
 	int dirtytime;
 
@@ -2146,7 +2145,7 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 	 * Don't do this for I_DIRTY_PAGES - that doesn't actually
 	 * dirty the inode itself
 	 */
-	if (flags & (I_DIRTY_SYNC | I_DIRTY_DATASYNC | I_DIRTY_TIME)) {
+	if (flags & (I_DIRTY_INODE | I_DIRTY_TIME)) {
 		trace_writeback_dirty_inode_start(inode, flags);
 
 		if (sb->s_op->dirty_inode)
@@ -2222,7 +2221,7 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 			if (dirtytime)
 				inode->dirtied_time_when = jiffies;
 
-			if (inode->i_state & (I_DIRTY_INODE | I_DIRTY_PAGES))
+			if (inode->i_state & I_DIRTY)
 				dirty_list = &wb->b_dirty;
 			else
 				dirty_list = &wb->b_dirty_time;
@@ -2246,8 +2245,6 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 	}
 out_unlock_inode:
 	spin_unlock(&inode->i_lock);
-
-#undef I_DIRTY_INODE
 }
 EXPORT_SYMBOL(__mark_inode_dirty);
 
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 639e2c86758a4..bcf95ec1bc31d 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -791,7 +791,7 @@ static void gfs2_dirty_inode(struct inode *inode, int flags)
 	int need_endtrans = 0;
 	int ret;
 
-	if (!(flags & (I_DIRTY_DATASYNC|I_DIRTY_SYNC)))
+	if (!(flags & I_DIRTY_INODE))
 		return;
 	if (unlikely(test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
 		return;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 30172ad84b25f..50e7455195f77 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2015,7 +2015,8 @@ static inline void init_sync_kiocb(struct kiocb *kiocb, struct file *filp)
 #define I_OVL_INUSE			(1 << 14)
 #define I_SYNC_QUEUED		(1 << 17)
 
-#define I_DIRTY (I_DIRTY_SYNC | I_DIRTY_DATASYNC | I_DIRTY_PAGES)
+#define I_DIRTY_INODE (I_DIRTY_SYNC | I_DIRTY_DATASYNC)
+#define I_DIRTY (I_DIRTY_INODE | I_DIRTY_PAGES)
 #define I_DIRTY_ALL (I_DIRTY | I_DIRTY_TIME)
 
 extern void __mark_inode_dirty(struct inode *, int);
-- 
2.30.0

