Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 145951B40C5
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732027AbgDVKrw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:47:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:50464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729244AbgDVKPP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:15:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC2E620575;
        Wed, 22 Apr 2020 10:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550514;
        bh=J2Tscg0fW3pcCyob+6YGj5QCeCv1qdJ+BxsxnfTJYBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TLswHyqUxGOOeL7690T5HGokE8YX2bguNeD/qulb4+Fa3JXDm0Wd562vuNHuYPQCR
         z6QmaszBoERT/Ab4e3n7opudlj78JEeQ8Ze+FCBs9VsqBH4T+LFT+rrsHZctRsx31D
         jVAdgPTn0InLg8jawocDI1oDglxUNLz1dRZA0+Wk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 46/64] f2fs: fix NULL pointer dereference in f2fs_write_begin()
Date:   Wed, 22 Apr 2020 11:57:30 +0200
Message-Id: <20200422095021.001448305@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095008.799686511@linuxfoundation.org>
References: <20200422095008.799686511@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 62f63eea291b50a5677ae7503ac128803174698a ]

BUG: kernel NULL pointer dereference, address: 0000000000000000
RIP: 0010:f2fs_write_begin+0x823/0xb90 [f2fs]
Call Trace:
 f2fs_quota_write+0x139/0x1d0 [f2fs]
 write_blk+0x36/0x80 [quota_tree]
 get_free_dqblk+0x42/0xa0 [quota_tree]
 do_insert_tree+0x235/0x4a0 [quota_tree]
 do_insert_tree+0x26e/0x4a0 [quota_tree]
 do_insert_tree+0x26e/0x4a0 [quota_tree]
 do_insert_tree+0x26e/0x4a0 [quota_tree]
 qtree_write_dquot+0x70/0x190 [quota_tree]
 v2_write_dquot+0x43/0x90 [quota_v2]
 dquot_acquire+0x77/0x100
 f2fs_dquot_acquire+0x2f/0x60 [f2fs]
 dqget+0x310/0x450
 dquot_transfer+0x7e/0x120
 f2fs_setattr+0x11a/0x4a0 [f2fs]
 notify_change+0x349/0x480
 chown_common+0x168/0x1c0
 do_fchownat+0xbc/0xf0
 __x64_sys_fchownat+0x20/0x30
 do_syscall_64+0x5f/0x220
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Passing fsdata parameter to .write_{begin,end} in f2fs_quota_write(),
so that if quota file is compressed one, we can avoid above NULL
pointer dereference when updating quota content.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index da348cf4ff56a..45f8f6ec22a55 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1648,6 +1648,7 @@ static ssize_t f2fs_quota_write(struct super_block *sb, int type,
 	int offset = off & (sb->s_blocksize - 1);
 	size_t towrite = len;
 	struct page *page;
+	void *fsdata = NULL;
 	char *kaddr;
 	int err = 0;
 	int tocopy;
@@ -1657,7 +1658,7 @@ static ssize_t f2fs_quota_write(struct super_block *sb, int type,
 								towrite);
 retry:
 		err = a_ops->write_begin(NULL, mapping, off, tocopy, 0,
-							&page, NULL);
+							&page, &fsdata);
 		if (unlikely(err)) {
 			if (err == -ENOMEM) {
 				congestion_wait(BLK_RW_ASYNC, HZ/50);
@@ -1672,7 +1673,7 @@ static ssize_t f2fs_quota_write(struct super_block *sb, int type,
 		flush_dcache_page(page);
 
 		a_ops->write_end(NULL, mapping, off, tocopy, tocopy,
-						page, NULL);
+						page, fsdata);
 		offset = 0;
 		towrite -= tocopy;
 		off += tocopy;
-- 
2.20.1



