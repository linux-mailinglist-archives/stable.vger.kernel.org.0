Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70658341C67
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbhCSMUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:20:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230316AbhCSMUW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 08:20:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C00DB6146D;
        Fri, 19 Mar 2021 12:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616156422;
        bh=HdbIVlhi+KrHLSVZ2TLqcSo72xulVN1bqgio34ZDE6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DPAWOsm1I5n9niXHflUnk6luHuFYj2ig9/kvEQvXMqy9ClHKxQ35akFN7jxcwf10A
         vlynLU9+aCv8ph4UeK44tY10dVzU7gVjau85bdnaVauXirLRhHAMshknMHHFC3W9fF
         dW7msEsSIIsncDfU1k97YdBiltax9UjgkhM6Cvhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.10 09/13] fuse: fix live lock in fuse_iget()
Date:   Fri, 19 Mar 2021 13:19:06 +0100
Message-Id: <20210319121745.408809708@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210319121745.112612545@linuxfoundation.org>
References: <20210319121745.112612545@linuxfoundation.org>
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
@@ -862,6 +862,7 @@ static inline u64 fuse_get_attr_version(
 
 static inline void fuse_make_bad(struct inode *inode)
 {
+	remove_inode_hash(inode);
 	set_bit(FUSE_I_BAD, &get_fuse_inode(inode)->state);
 }
 


