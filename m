Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C882F352AB6
	for <lists+stable@lfdr.de>; Fri,  2 Apr 2021 14:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235459AbhDBMhX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Apr 2021 08:37:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:53574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229599AbhDBMhU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Apr 2021 08:37:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 571D26113D;
        Fri,  2 Apr 2021 12:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617367039;
        bh=9GuXs4JFL9lprrwhKcXigHOxwumN2t08r+Qo5w/YarA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HEGDpzdbze4dLz3ugi0T2/Ezlabeg33O55oUdO3NB/o9Zox0pSnkrbUAQZDcvRtPm
         +UHRUfhIxIXxzuHh+lAMQnObqnQuHhADAsLYYAQaclOzFMf2bacpn9hhpQoft3NcRg
         GwJNw/VTDvEqaxZzOMbobUwKEZhtFGhxokunjDdPHTwFfxcwkfC+kRRgKcpsebussn
         y8xuYkF0aTnBnp9sksfxbUt460uZq5nTw4/Lf+wnAv+7r8OgjTCwruEXL/W0hZRhyr
         uNlNNP/xAM2wtldDYBcPMPbiPVNpmSxQTxRp3BOQOM80+0veog1+vsXlc7ZyGINKAb
         K2PRMSgfmGAmQ==
From:   Christian Brauner <brauner@kernel.org>
To:     linux-fsdevel@vger.kernel.org
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        syzbot+283ce5a46486d6acdbaf@syzkaller.appspotmail.com,
        Christoph Hellwig <hch@lst.de>,
        Giuseppe Scrivano <gscrivan@redhat.com>, stable@vger.kernel.org
Subject: [PATCH 1/3] file: fix close_range() for unshare+cloexec
Date:   Fri,  2 Apr 2021 14:35:46 +0200
Message-Id: <20210402123548.108372-2-brauner@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <00000000000069c40405be6bdad4@google.com>
References: <00000000000069c40405be6bdad4@google.com>
MIME-Version: 1.0
X-Patch-Hashes: v=1; h=sha256; i=DDPyKPZCC8FIkQkPEEkdiKdYYPVAVuw4Qg1xYqd73jY=; m=8/Zhg3Z3pa7YXOyLuaIwanqtd/bcMtM1+zAN4ociwX4=; p=Clx1VMg4laFLwVnvcDU1YDrFJZstmZPkSo4NueEmkzM=; g=785a20cb6d48830f588c9624bf8dc10727ee1a6e
X-Patch-Sig: m=pgp; i=christian.brauner@ubuntu.com; s=0x0x91C61BC06578DCA2; b=iHUEABYKAB0WIQRAhzRXHqcMeLMyaSiRxhvAZXjcogUCYGcPkgAKCRCRxhvAZXjcom/0AQCRgpV 1s1KSk2tQVNpOvgDp3CttvF5o7UoOwNBe9CFntgEAtWznzqPnGQ+fVu+7jHN/vWgo9Zc/jv9rhbqa fzfpLwg=
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

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
---
 fs/file.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index f3a4bac2cbe9..f633348029a5 100644
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
 
-- 
2.27.0

