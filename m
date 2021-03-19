Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68DEC341C48
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbhCSMUK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:20:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:57072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230226AbhCSMTn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 08:19:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BBEA6146D;
        Fri, 19 Mar 2021 12:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616156373;
        bh=CJcrEU5C8PIHLQYMAt2nMwlWGPZCZPRYiefaQttAUOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OqRKQ5WVsm6CDLxdUe2W7ZCX/pIxke5PPq3GkOzzLvtv9dm3GvJH2QzY2Orr1DSAR
         EY8f+JIA6MOItic/DudxcoQV7qM6dnV7UngwvTfMXbZkMNAeYI947CL5tRRbCkCnt0
         P6FCFwLkgf+ckAyriiy9Ry38tq3qqW4rR7R7mzgo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.4 13/18] fuse: fix live lock in fuse_iget()
Date:   Fri, 19 Mar 2021 13:18:51 +0100
Message-Id: <20210319121745.903641756@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210319121745.449875976@linuxfoundation.org>
References: <20210319121745.449875976@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

commit 775c5033a0d164622d9d10dd0f0a5531639ed3ed upstream.

Commit 5d069dbe8aaf ("fuse: fix bad inode") replaced make_bad_inode()
in fuse_iget() with a private implementation fuse_make_bad().

The private implementation fails to remove the bad inode from inode
cache, so the retry loop with iget5_locked() finds the same bad inode
and marks it bad forever.

kmsg snip:

[ ] rcu: INFO: rcu_sched self-detected stall on CPU
...
[ ]  ? bit_wait_io+0x50/0x50
[ ]  ? fuse_init_file_inode+0x70/0x70
[ ]  ? find_inode.isra.32+0x60/0xb0
[ ]  ? fuse_init_file_inode+0x70/0x70
[ ]  ilookup5_nowait+0x65/0x90
[ ]  ? fuse_init_file_inode+0x70/0x70
[ ]  ilookup5.part.36+0x2e/0x80
[ ]  ? fuse_init_file_inode+0x70/0x70
[ ]  ? fuse_inode_eq+0x20/0x20
[ ]  iget5_locked+0x21/0x80
[ ]  ? fuse_inode_eq+0x20/0x20
[ ]  fuse_iget+0x96/0x1b0

Fixes: 5d069dbe8aaf ("fuse: fix bad inode")
Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/fuse_i.h |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -791,6 +791,7 @@ static inline u64 fuse_get_attr_version(
 
 static inline void fuse_make_bad(struct inode *inode)
 {
+	remove_inode_hash(inode);
 	set_bit(FUSE_I_BAD, &get_fuse_inode(inode)->state);
 }
 


