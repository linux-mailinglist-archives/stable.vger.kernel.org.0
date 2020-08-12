Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5642423CC
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 03:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgHLBf0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 21:35:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:36362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726430AbgHLBf0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Aug 2020 21:35:26 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C1EB2054F;
        Wed, 12 Aug 2020 01:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196125;
        bh=OUfkmlnS9oZDsBG34zAmOqH1i91rmucGYG8ZFVQCZhk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=gn3eSNf+3iC7Qi4l74deScdTZucjEOXTEllC1Sw6N3pBIarpdpGTfr263Jd6AEifF
         ubhsx35QPjDpQCaI+fc4KF3Ltt2yHoq155wMsF17MJLWIl2H7zhK8GcxSXDSEZyXsR
         y1OiC2mq9khv1bp7ZL8rj1rLE5l/99MCCYFv7gMw=
Date:   Tue, 11 Aug 2020 18:35:24 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anenbupt@gmail.com, ebiggers@google.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk
Subject:  [patch 098/165] fs/minix: check return value of
 sb_getblk()
Message-ID: <20200812013524.C4dEigLKz%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>
Subject: fs/minix: check return value of sb_getblk()

Patch series "fs/minix: fix syzbot bugs and set s_maxbytes".

This series fixes all syzbot bugs in the minix filesystem:

	KASAN: null-ptr-deref Write in get_block
	KASAN: use-after-free Write in get_block
	KASAN: use-after-free Read in get_block
	WARNING in inc_nlink
	KMSAN: uninit-value in get_block
	WARNING in drop_nlink

It also fixes the minix filesystem to set s_maxbytes correctly, so that
userspace sees the correct behavior when exceeding the max file size.


This patch (of 6):

sb_getblk() can fail, so check its return value.

This fixes a NULL pointer dereference.

Originally from Qiujun Huang.

Link: http://lkml.kernel.org/r/20200628060846.682158-1-ebiggers@kernel.org
Link: http://lkml.kernel.org/r/20200628060846.682158-2-ebiggers@kernel.org
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reported-by: syzbot+4a88b2b9dc280f47baf4@syzkaller.appspotmail.com
Cc: Qiujun Huang <anenbupt@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/minix/itree_common.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/minix/itree_common.c~fs-minix-check-return-value-of-sb_getblk
+++ a/fs/minix/itree_common.c
@@ -75,6 +75,7 @@ static int alloc_branch(struct inode *in
 	int n = 0;
 	int i;
 	int parent = minix_new_block(inode);
+	int err = -ENOSPC;
 
 	branch[0].key = cpu_to_block(parent);
 	if (parent) for (n = 1; n < num; n++) {
@@ -85,6 +86,11 @@ static int alloc_branch(struct inode *in
 			break;
 		branch[n].key = cpu_to_block(nr);
 		bh = sb_getblk(inode->i_sb, parent);
+		if (!bh) {
+			minix_free_block(inode, nr);
+			err = -ENOMEM;
+			break;
+		}
 		lock_buffer(bh);
 		memset(bh->b_data, 0, bh->b_size);
 		branch[n].bh = bh;
@@ -103,7 +109,7 @@ static int alloc_branch(struct inode *in
 		bforget(branch[i].bh);
 	for (i = 0; i < n; i++)
 		minix_free_block(inode, block_to_cpu(branch[i].key));
-	return -ENOSPC;
+	return err;
 }
 
 static inline int splice_branch(struct inode *inode,
_
