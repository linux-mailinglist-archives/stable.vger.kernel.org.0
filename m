Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFCE628B872
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389520AbgJLNw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:52:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:55730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731830AbgJLNsM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:48:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61B16206D9;
        Mon, 12 Oct 2020 13:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510417;
        bh=umLZUFZadFKyR9l6EetllRon0TRqQ8w0P/ZClO1UZTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dx0W2/0xTKMMpy8AXh3ZJACj4OUdBfO5fqVr4Bv4dtzR0sNzcqyTe+34lyeS1YLUC
         V90BuhKIV0mFxPiOcfIttqJaXUAUrWr6GO2JHF1mNEzCXPI8TiCSVVvzHdA0moG64J
         UDpIN5Mq2OxfYKpcSWGz0MUt0JPGy1Zi4IrYSqW0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 083/124] pipe: Fix memory leaks in create_pipe_files()
Date:   Mon, 12 Oct 2020 15:31:27 +0200
Message-Id: <20201012133150.881895405@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@redhat.com>

[ Upstream commit 8a018eb55e3ac033592afbcb476b0ffe64465b12 ]

        Calling pipe2() with O_NOTIFICATION_PIPE could results in memory
leaks unless watch_queue_init() is successful.

        In case of watch_queue_init() failure in pipe2() we are left
with inode and pipe_inode_info instances that need to be freed.  That
failure exit has been introduced in commit c73be61cede5 ("pipe: Add
general notification queue support") and its handling should've been
identical to nearby treatment of alloc_file_pseudo() failures - it
is dealing with the same situation.  As it is, the mainline kernel
leaks in that case.

        Another problem is that CONFIG_WATCH_QUEUE and !CONFIG_WATCH_QUEUE
cases are treated differently (and the former leaks just pipe_inode_info,
the latter - both pipe_inode_info and inode).

        Fixed by providing a dummy wacth_queue_init() in !CONFIG_WATCH_QUEUE
case and by having failures of wacth_queue_init() handled the same way
we handle alloc_file_pseudo() ones.

Fixes: c73be61cede5 ("pipe: Add general notification queue support")
Signed-off-by: Qian Cai <cai@redhat.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pipe.c                   | 11 +++++------
 include/linux/watch_queue.h |  6 ++++++
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index 117db82b10af5..0ac197658a2d6 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -894,19 +894,18 @@ int create_pipe_files(struct file **res, int flags)
 {
 	struct inode *inode = get_pipe_inode();
 	struct file *f;
+	int error;
 
 	if (!inode)
 		return -ENFILE;
 
 	if (flags & O_NOTIFICATION_PIPE) {
-#ifdef CONFIG_WATCH_QUEUE
-		if (watch_queue_init(inode->i_pipe) < 0) {
+		error = watch_queue_init(inode->i_pipe);
+		if (error) {
+			free_pipe_info(inode->i_pipe);
 			iput(inode);
-			return -ENOMEM;
+			return error;
 		}
-#else
-		return -ENOPKG;
-#endif
 	}
 
 	f = alloc_file_pseudo(inode, pipe_mnt, "",
diff --git a/include/linux/watch_queue.h b/include/linux/watch_queue.h
index 5e08db2adc319..c994d1b2cdbaa 100644
--- a/include/linux/watch_queue.h
+++ b/include/linux/watch_queue.h
@@ -122,6 +122,12 @@ static inline void remove_watch_list(struct watch_list *wlist, u64 id)
  */
 #define watch_sizeof(STRUCT) (sizeof(STRUCT) << WATCH_INFO_LENGTH__SHIFT)
 
+#else
+static inline int watch_queue_init(struct pipe_inode_info *pipe)
+{
+	return -ENOPKG;
+}
+
 #endif
 
 #endif /* _LINUX_WATCH_QUEUE_H */
-- 
2.25.1



