Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE4DD18B523
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbgCSNQD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:16:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:36110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729478AbgCSNQC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:16:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7829720724;
        Thu, 19 Mar 2020 13:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623761;
        bh=lyNKpJMdv/hRGrY6vQ5FO5YBieAql1r3tO2rsCM3OB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gzTyZUf4940+pgnYFLIxvCLyThXCpun4nI1cUxnh3yFC/8I5NuTEHORJ/o/dpkKIs
         m78SnccjdhWwC1SzNUb39/CbVj1lOnqtILiEvSJGBZpD13TiV3yqdSSNJLCWAFzgjs
         Qhobb6nijUKFC9xQMvPqfO20MdA1wojbLhrFZyWQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        stable@kernel.org
Subject: [PATCH 4.14 45/99] cifs_atomic_open(): fix double-put on late allocation failure
Date:   Thu, 19 Mar 2020 14:03:23 +0100
Message-Id: <20200319123955.571682852@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123941.630731708@linuxfoundation.org>
References: <20200319123941.630731708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit d9a9f4849fe0c9d560851ab22a85a666cddfdd24 upstream.

several iterations of ->atomic_open() calling conventions ago, we
used to need fput() if ->atomic_open() failed at some point after
successful finish_open().  Now (since 2016) it's not needed -
struct file carries enough state to make fput() work regardless
of the point in struct file lifecycle and discarding it on
failure exits in open() got unified.  Unfortunately, I'd missed
the fact that we had an instance of ->atomic_open() (cifs one)
that used to need that fput(), as well as the stale comment in
finish_open() demanding such late failure handling.  Trivially
fixed...

Fixes: fe9ec8291fca "do_last(): take fput() on error after opening to out:"
Cc: stable@kernel.org # v4.7+
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/filesystems/porting |    7 +++++++
 fs/cifs/dir.c                     |    1 -
 fs/open.c                         |    3 ---
 3 files changed, 7 insertions(+), 4 deletions(-)

--- a/Documentation/filesystems/porting
+++ b/Documentation/filesystems/porting
@@ -606,3 +606,10 @@ in your dentry operations instead.
 	dentry separately, and it now has request_mask and query_flags arguments
 	to specify the fields and sync type requested by statx.  Filesystems not
 	supporting any statx-specific features may ignore the new arguments.
+--
+[mandatory]
+
+	[should've been added in 2016] stale comment in finish_open()
+	nonwithstanding, failure exits in ->atomic_open() instances should
+	*NOT* fput() the file, no matter what.  Everything is handled by the
+	caller.
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -562,7 +562,6 @@ cifs_atomic_open(struct inode *inode, st
 		if (server->ops->close)
 			server->ops->close(xid, tcon, &fid);
 		cifs_del_pending_open(&open);
-		fput(file);
 		rc = -ENOMEM;
 	}
 
--- a/fs/open.c
+++ b/fs/open.c
@@ -824,9 +824,6 @@ cleanup_file:
  * the return value of d_splice_alias(), then the caller needs to perform dput()
  * on it after finish_open().
  *
- * On successful return @file is a fully instantiated open file.  After this, if
- * an error occurs in ->atomic_open(), it needs to clean up with fput().
- *
  * Returns zero on success or -errno if the open failed.
  */
 int finish_open(struct file *file, struct dentry *dentry,


