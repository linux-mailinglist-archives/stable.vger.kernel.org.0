Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17C1D35BF14
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239348AbhDLJCq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:02:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:54638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239689AbhDLJBE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:01:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2191E61019;
        Mon, 12 Apr 2021 08:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217944;
        bh=Mpf+gdz9ZuJzZvVs489Nfd3utEa3JCIYGGpAYho6Usc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D3AY+N71VU4W7dVP3MmSLTxn6rb4J7PK9r7D/n4bWYBpZawS4eL+XcsWK0giWrlTf
         G743KTobz2yNs9W6WFF8MrRGGXVi18ifzYG0yqG1UYmCHZTvJ13Jy0u+4ETc32ltJg
         PBti3Ewwq/7wsL/hlokFDQPgW4/pJiMBaiJvy6XQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+283ce5a46486d6acdbaf@syzkaller.appspotmail.com,
        Christoph Hellwig <hch@lst.de>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 5.11 005/210] file: fix close_range() for unshare+cloexec
Date:   Mon, 12 Apr 2021 10:38:30 +0200
Message-Id: <20210412084016.183518359@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

commit 9b5b872215fe6d1ca6a1ef411f130bd58e269012 upstream.

syzbot reported a bug when putting the last reference to a tasks file
descriptor table. Debugging this showed we didn't recalculate the
current maximum fd number for CLOSE_RANGE_UNSHARE | CLOSE_RANGE_CLOEXEC
after we unshared the file descriptors table. So max_fd could exceed the
current fdtable maximum causing us to set excessive bits. As a concrete
example, let's say the user requested everything from fd 4 to ~0UL to be
closed and their current fdtable size is 256 with their highest open fd
being 4. With CLOSE_RANGE_UNSHARE the caller will end up with a new
fdtable which has room for 64 file descriptors since that is the lowest
fdtable size we accept. But now max_fd will still point to 255 and needs
to be adjusted. Fix this by retrieving the correct maximum fd value in
__range_cloexec().

Reported-by: syzbot+283ce5a46486d6acdbaf@syzkaller.appspotmail.com
Fixes: 582f1fb6b721 ("fs, close_range: add flag CLOSE_RANGE_CLOEXEC")
Fixes: fec8a6a69103 ("close_range: unshare all fds for CLOSE_RANGE_UNSHARE | CLOSE_RANGE_CLOEXEC")
Cc: Christoph Hellwig <hch@lst.de>
Cc: Giuseppe Scrivano <gscrivan@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/file.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

--- a/fs/file.c
+++ b/fs/file.c
@@ -629,17 +629,30 @@ int close_fd(unsigned fd)
 }
 EXPORT_SYMBOL(close_fd); /* for ksys_close() */
 
+/**
+ * last_fd - return last valid index into fd table
+ * @cur_fds: files struct
+ *
+ * Context: Either rcu read lock or files_lock must be held.
+ *
+ * Returns: Last valid index into fdtable.
+ */
+static inline unsigned last_fd(struct fdtable *fdt)
+{
+	return fdt->max_fds - 1;
+}
+
 static inline void __range_cloexec(struct files_struct *cur_fds,
 				   unsigned int fd, unsigned int max_fd)
 {
 	struct fdtable *fdt;
 
-	if (fd > max_fd)
-		return;
-
+	/* make sure we're using the correct maximum value */
 	spin_lock(&cur_fds->file_lock);
 	fdt = files_fdtable(cur_fds);
-	bitmap_set(fdt->close_on_exec, fd, max_fd - fd + 1);
+	max_fd = min(last_fd(fdt), max_fd);
+	if (fd <= max_fd)
+		bitmap_set(fdt->close_on_exec, fd, max_fd - fd + 1);
 	spin_unlock(&cur_fds->file_lock);
 }
 


