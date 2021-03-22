Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB16344168
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231577AbhCVMdZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:33:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:54800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231500AbhCVMcd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:32:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68442619A5;
        Mon, 22 Mar 2021 12:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416350;
        bh=3iSwuQS17vR/pELboJm0Hl9EfUZ6e7jum/23SXCimB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wY5UW+JGI6vJ3LAvBCZ8d4TbZ6IYBSbV0ioh26kiZbtzfG+7YwkxW5ub9IQAyZmSI
         Y10EWowHnkHLy4Xs5Sq59R2u/Bzt1Acv5R/W5C24/wZMXH2ON02yBWINET6Eb1YK4x
         U7rF/F6FSLGN9NuRn4dmldCfdJQA+64KW/swDc9I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gaja Sophie Peters <gaja.peters@math.uni-hamburg.de>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Jeffrey Altman <jaltman@auristor.com>,
        linux-afs@lists.infradead.org
Subject: [PATCH 5.11 038/120] afs: Fix accessing YFS xattrs on a non-YFS server
Date:   Mon, 22 Mar 2021 13:27:01 +0100
Message-Id: <20210322121930.926928658@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

commit 64fcbb6158ecc684d84c64424830a9c37c77c5b9 upstream.

If someone attempts to access YFS-related xattrs (e.g. afs.yfs.acl) on a
file on a non-YFS AFS server (such as OpenAFS), then the kernel will jump
to a NULL function pointer because the afs_fetch_acl_operation descriptor
doesn't point to a function for issuing an operation on a non-YFS
server[1].

Fix this by making afs_wait_for_operation() check that the issue_afs_rpc
method is set before jumping to it and setting -ENOTSUPP if not.  This fix
also covers other potential operations that also only exist on YFS servers.

afs_xattr_get/set_yfs() then need to translate -ENOTSUPP to -ENODATA as the
former error is internal to the kernel.

The bug shows up as an oops like the following:

	BUG: kernel NULL pointer dereference, address: 0000000000000000
	[...]
	Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
	[...]
	Call Trace:
	 afs_wait_for_operation+0x83/0x1b0 [kafs]
	 afs_xattr_get_yfs+0xe6/0x270 [kafs]
	 __vfs_getxattr+0x59/0x80
	 vfs_getxattr+0x11c/0x140
	 getxattr+0x181/0x250
	 ? __check_object_size+0x13f/0x150
	 ? __fput+0x16d/0x250
	 __x64_sys_fgetxattr+0x64/0xb0
	 do_syscall_64+0x49/0xc0
	 entry_SYSCALL_64_after_hwframe+0x44/0xa9
	RIP: 0033:0x7fb120a9defe

This was triggered with "cp -a" which attempts to copy xattrs, including
afs ones, but is easier to reproduce with getfattr, e.g.:

	getfattr -d -m ".*" /afs/openafs.org/

Fixes: e49c7b2f6de7 ("afs: Build an abstraction around an "operation" concept")
Reported-by: Gaja Sophie Peters <gaja.peters@math.uni-hamburg.de>
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Gaja Sophie Peters <gaja.peters@math.uni-hamburg.de>
Reviewed-by: Marc Dionne <marc.dionne@auristor.com>
Reviewed-by: Jeffrey Altman <jaltman@auristor.com>
cc: linux-afs@lists.infradead.org
Link: http://lists.infradead.org/pipermail/linux-afs/2021-March/003498.html [1]
Link: http://lists.infradead.org/pipermail/linux-afs/2021-March/003566.html # v1
Link: http://lists.infradead.org/pipermail/linux-afs/2021-March/003572.html # v2
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/afs/fs_operation.c |    7 +++++--
 fs/afs/xattr.c        |    8 +++++++-
 2 files changed, 12 insertions(+), 3 deletions(-)

--- a/fs/afs/fs_operation.c
+++ b/fs/afs/fs_operation.c
@@ -181,10 +181,13 @@ void afs_wait_for_operation(struct afs_o
 		if (test_bit(AFS_SERVER_FL_IS_YFS, &op->server->flags) &&
 		    op->ops->issue_yfs_rpc)
 			op->ops->issue_yfs_rpc(op);
-		else
+		else if (op->ops->issue_afs_rpc)
 			op->ops->issue_afs_rpc(op);
+		else
+			op->ac.error = -ENOTSUPP;
 
-		op->error = afs_wait_for_call_to_complete(op->call, &op->ac);
+		if (op->call)
+			op->error = afs_wait_for_call_to_complete(op->call, &op->ac);
 	}
 
 	switch (op->error) {
--- a/fs/afs/xattr.c
+++ b/fs/afs/xattr.c
@@ -230,6 +230,8 @@ static int afs_xattr_get_yfs(const struc
 			else
 				ret = -ERANGE;
 		}
+	} else if (ret == -ENOTSUPP) {
+		ret = -ENODATA;
 	}
 
 error_yacl:
@@ -254,6 +256,7 @@ static int afs_xattr_set_yfs(const struc
 {
 	struct afs_operation *op;
 	struct afs_vnode *vnode = AFS_FS_I(inode);
+	int ret;
 
 	if (flags == XATTR_CREATE ||
 	    strcmp(name, "acl") != 0)
@@ -268,7 +271,10 @@ static int afs_xattr_set_yfs(const struc
 		return afs_put_operation(op);
 
 	op->ops = &yfs_store_opaque_acl2_operation;
-	return afs_do_sync_operation(op);
+	ret = afs_do_sync_operation(op);
+	if (ret == -ENOTSUPP)
+		ret = -ENODATA;
+	return ret;
 }
 
 static const struct xattr_handler afs_xattr_yfs_handler = {


