Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D938406329
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242439AbhIJAq6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:46:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229990AbhIJAXF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:23:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DB2060F24;
        Fri, 10 Sep 2021 00:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233315;
        bh=HUjSc51v8Q/VSajJJxCN9AZhLPCBhX+xYJx2+V+j7iY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TdD1sa2zsKvLwLZoVw7ODh+WTY6NT0yD+DmTeCYGGviwJQ8kcvWlaRuSCcGuHJFNt
         gzSwk3TqH3zNkuLAnk4Uq6RrtyGzmNT7gmRmi8QtBFZq01c1QRRytbG8wNWDkDiCgV
         6fi1AwQVMlykRcT354s0KOp482jZNdZSQ8EyY8pn865284fnr1Cd77YWcE92OwfriU
         NxP+t7AX7hThizwQ10Ags0vnqBUGi1KdCMVx1BXNnOK88bdq7X5/g84RjkZMiD5ERh
         Zyl6NPRRzSJtEjWy+LUOPhSrsJw1pAFM//nzE37T1JGW1ourXowq9gYZf3duuiaCFt
         V083GuYvRw4Ew==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.4 09/37] f2fs: fix to force keeping write barrier for strict fsync mode
Date:   Thu,  9 Sep 2021 20:21:14 -0400
Message-Id: <20210910002143.175731-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002143.175731-1-sashal@kernel.org>
References: <20210910002143.175731-1-sashal@kernel.org>
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
index 6e58b2e62b18..4fc0e62a5ef3 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -259,6 +259,18 @@ static int f2fs_do_sync_file(struct file *file, loff_t start, loff_t end,
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

