Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECE2E406139
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbhIJAmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:42:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:44080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231132AbhIJARr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:17:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED51E611C7;
        Fri, 10 Sep 2021 00:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631232995;
        bh=NGJRrDCmuWGVT2PPXb6O+gDawF3o8qQtxaYhR2D6vSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S7uPaXp8dEo5AKYsX4ODLjhm4Zpb8dAXoolLgFdSv/0OziD+4sKyBGn0mDFKgNHXu
         i0oKkioh5/F15+HwTkUvHHeGA/09MjJpPcPB5QnXSu1Q3E5zHUx/BFIHWvFhZAhv5O
         qZTNlBkP2AZixlWZiyCfqkZyPJy2MfdHRwqWswHNNzuYUWEUBGxIua+pXtQAUhe1R0
         sGsRAaQv/FNV12OPH6c5RWsPu7M1EIpRza6wmJmQ6pGkYhzlyaD4540hyDSIETn9yz
         KkE08zGF0lyZVfcI8YUWcWd/d9H53IeGCnQC07TruIfmZ3De/JSzCGSEwYo3O4miii
         Vmt7iTkXqq4Bw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.14 27/99] f2fs: fix to force keeping write barrier for strict fsync mode
Date:   Thu,  9 Sep 2021 20:14:46 -0400
Message-Id: <20210910001558.173296-27-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001558.173296-1-sashal@kernel.org>
References: <20210910001558.173296-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <chao@kernel.org>

[ Upstream commit 2787991516468bfafafb9bf2b45a848e6b202e7c ]

[1] https://www.mail-archive.com/linux-f2fs-devel@lists.sourceforge.net/msg15126.html

As [1] reported, if lower device doesn't support write barrier, in below
case:

- write page #0; persist
- overwrite page #0
- fsync
 - write data page #0 OPU into device's cache
 - write inode page into device's cache
 - issue flush

If SPO is triggered during flush command, inode page can be persisted
before data page #0, so that after recovery, inode page can be recovered
with new physical block address of data page #0, however there may
contains dummy data in new physical block address.

Then what user will see is: after overwrite & fsync + SPO, old data in
file was corrupted, if any user do care about such case, we can suggest
user to use STRICT fsync mode, in this mode, we will force to use atomic
write sematics to keep write order in between data/node and last node,
so that it avoids potential data corruption during fsync().

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 6afd4562335f..00b45876eaa1 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -301,6 +301,18 @@ static int f2fs_do_sync_file(struct file *file, loff_t start, loff_t end,
 				f2fs_exist_written_data(sbi, ino, UPDATE_INO))
 			goto flush_out;
 		goto out;
+	} else {
+		/*
+		 * for OPU case, during fsync(), node can be persisted before
+		 * data when lower device doesn't support write barrier, result
+		 * in data corruption after SPO.
+		 * So for strict fsync mode, force to use atomic write sematics
+		 * to keep write order in between data/node and last node to
+		 * avoid potential data corruption.
+		 */
+		if (F2FS_OPTION(sbi).fsync_mode ==
+				FSYNC_MODE_STRICT && !atomic)
+			atomic = true;
 	}
 go_write:
 	/*
-- 
2.30.2

