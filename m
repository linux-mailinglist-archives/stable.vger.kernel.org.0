Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4FD374606
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405250AbfGYFpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:45:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:33168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405248AbfGYFpq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:45:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AB0C22BEB;
        Thu, 25 Jul 2019 05:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033545;
        bh=IU+gfeR+aLvaSZLrw3bgYBQUZrP95fI/FfqM3PaKlpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sv1WponBClx90xJIOvlpkoUmHjEOGNWBQpAAJRA+Y79YOyE4XKA6W0s4fM7NNd8XF
         Y6lhfbc6IpgbTQhFNp0JvxIjFentWVwaUmMIDQ3L9SODYcvwbuj+WDN16LGJEQjySg
         U7iDnR+fIsZ9uryty9r03uwXV6WixRC4svoxl0CQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Amir Goldstein <amir73il@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 244/271] xfs: dont overflow xattr listent buffer
Date:   Wed, 24 Jul 2019 21:21:53 +0200
Message-Id: <20190724191716.093741873@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 3b50086f0c0d78c144d9483fa292c1509c931b70 upstream.

For VFS listxattr calls, xfs_xattr_put_listent calls
__xfs_xattr_put_listent twice if it sees an attribute
"trusted.SGI_ACL_FILE": once for that name, and again for
"system.posix_acl_access".  Unfortunately, if we happen to run out of
buffer space while emitting the first name, we set count to -1 (so that
we can feed ERANGE to the caller).  The second invocation doesn't check that
the context parameters make sense and overwrites the byte before the
buffer, triggering a KASAN report:

==================================================================
BUG: KASAN: slab-out-of-bounds in strncpy+0xb3/0xd0
Write of size 1 at addr ffff88807fbd317f by task syz/1113

CPU: 3 PID: 1113 Comm: syz Not tainted 5.0.0-rc6-xfsx #rc6
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1 04/01/2014
Call Trace:
 dump_stack+0xcc/0x180
 print_address_description+0x6c/0x23c
 kasan_report.cold.3+0x1c/0x35
 strncpy+0xb3/0xd0
 __xfs_xattr_put_listent+0x1a9/0x2c0 [xfs]
 xfs_attr_list_int_ilocked+0x11af/0x1800 [xfs]
 xfs_attr_list_int+0x20c/0x2e0 [xfs]
 xfs_vn_listxattr+0x225/0x320 [xfs]
 listxattr+0x11f/0x1b0
 path_listxattr+0xbd/0x130
 do_syscall_64+0x139/0x560

While we're at it we add an assert to the other put_listent to avoid
this sort of thing ever happening to the attrlist_by_handle code.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Suggested-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_attr_list.c | 1 +
 fs/xfs/xfs_xattr.c     | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index a58034049995..3d213a7394c5 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -555,6 +555,7 @@ xfs_attr_put_listent(
 	attrlist_ent_t *aep;
 	int arraytop;
 
+	ASSERT(!context->seen_enough);
 	ASSERT(!(context->flags & ATTR_KERNOVAL));
 	ASSERT(context->count >= 0);
 	ASSERT(context->count < (ATTR_MAX_VALUELEN/8));
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 63ee1d5bf1d7..9a63016009a1 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -129,6 +129,9 @@ __xfs_xattr_put_listent(
 	char *offset;
 	int arraytop;
 
+	if (context->count < 0 || context->seen_enough)
+		return;
+
 	if (!context->alist)
 		goto compute_size;
 
-- 
2.20.1



