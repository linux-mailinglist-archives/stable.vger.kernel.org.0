Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8CBD2B64EE
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731769AbgKQNbx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:31:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:41190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732193AbgKQNbr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:31:47 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CA162078E;
        Tue, 17 Nov 2020 13:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619906;
        bh=fLP/TmWcuJGS2zWkd6vJZ2o9VAbP5C2PCdoRjGqmOfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uBFK31xq1GsErWIyJNsYSdzsEp+2LcXnLDEYx/wA4s3YkBBRP1vcTQtu3Z5C72+ei
         WnwczERs2cCxOS3rkY55MHqySW9C/30PLiR7bK+Wdw32exAy5+J1eHBha8bTx9RfcL
         YMSe6q9/LwL4rCyXxLcsZz8kOttrccf4bgF269nM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 043/255] afs: Fix incorrect freeing of the ACL passed to the YFS ACL store op
Date:   Tue, 17 Nov 2020 14:03:03 +0100
Message-Id: <20201117122141.047754990@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit f4c79144edd8a49ffca8fa737a31d606be742a34 ]

The cleanup for the yfs_store_opaque_acl2_operation calls the wrong
function to destroy the ACL content buffer.  It's an afs_acl struct, not
a yfs_acl struct - and the free function for latter may pass invalid
pointers to kfree().

Fix this by using the afs_acl_put() function.  The yfs_acl_put()
function is then no longer used and can be removed.

	general protection fault, probably for non-canonical address 0x7ebde00000000: 0000 [#1] SMP PTI
	...
	RIP: 0010:compound_head+0x0/0x11
	...
	Call Trace:
	 virt_to_cache+0x8/0x51
	 kfree+0x5d/0x79
	 yfs_free_opaque_acl+0x16/0x29
	 afs_put_operation+0x60/0x114
	 __vfs_setxattr+0x67/0x72
	 __vfs_setxattr_noperm+0x66/0xe9
	 vfs_setxattr+0x67/0xce
	 setxattr+0x14e/0x184
	 __do_sys_fsetxattr+0x66/0x8f
	 do_syscall_64+0x2d/0x3a
	 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: e49c7b2f6de7 ("afs: Build an abstraction around an "operation" concept")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/xattr.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/afs/xattr.c b/fs/afs/xattr.c
index 38884d6c57cdc..95c573dcda116 100644
--- a/fs/afs/xattr.c
+++ b/fs/afs/xattr.c
@@ -148,11 +148,6 @@ static const struct xattr_handler afs_xattr_afs_acl_handler = {
 	.set    = afs_xattr_set_acl,
 };
 
-static void yfs_acl_put(struct afs_operation *op)
-{
-	yfs_free_opaque_acl(op->yacl);
-}
-
 static const struct afs_operation_ops yfs_fetch_opaque_acl_operation = {
 	.issue_yfs_rpc	= yfs_fs_fetch_opaque_acl,
 	.success	= afs_acl_success,
@@ -246,7 +241,7 @@ error:
 static const struct afs_operation_ops yfs_store_opaque_acl2_operation = {
 	.issue_yfs_rpc	= yfs_fs_store_opaque_acl2,
 	.success	= afs_acl_success,
-	.put		= yfs_acl_put,
+	.put		= afs_acl_put,
 };
 
 /*
-- 
2.27.0



