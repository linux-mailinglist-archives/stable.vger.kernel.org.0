Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97E2A498B87
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346273AbiAXTOR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:14:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37974 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345368AbiAXTMK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:12:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07733B81215;
        Mon, 24 Jan 2022 19:12:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2419BC340E5;
        Mon, 24 Jan 2022 19:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051526;
        bh=LNtD9UZWvbmDOw7paLtYgM/qBbS/NqI14rCQ7TsFR8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZQghJyv3b6ziiak7yNrofbh4oPEmZdjjW3rp94Cun0KCeu/YFalhoQxvI32D9Z/G7
         nY7uIRWlzcFvCipX4xrosNgnPNrZ3v4e4R253OUHEsqhDJNnhh3iZJLsQWgkzcBMrx
         neRRqv0Y4eaWLQcFn958ZjTE63lFfglng63yvleY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.14 183/186] fuse: fix live lock in fuse_iget()
Date:   Mon, 24 Jan 2022 19:44:18 +0100
Message-Id: <20220124183942.988636950@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
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
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/fuse_i.h |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -691,6 +691,7 @@ static inline u64 get_node_id(struct ino
 
 static inline void fuse_make_bad(struct inode *inode)
 {
+	remove_inode_hash(inode);
 	set_bit(FUSE_I_BAD, &get_fuse_inode(inode)->state);
 }
 


