Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1DB514843B
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390603AbgAXLSM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:18:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:55182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729351AbgAXLSL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:18:11 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6247020708;
        Fri, 24 Jan 2020 11:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864690;
        bh=LQB4Zhi24o8/X+v34Z1NZFwGXcTPiXecARvgH7JrTaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J5LuMGnZ9wb1s1y8tfZ8QRA/7NhAWq9qlhR+AyrmZZKAX+WflVRoEGv8/xyqea0fG
         WahHP4mHh7U580NSNiVik6AnwaMUEBkvpk6WuYY8g19h8JegktyH+x/fnsEq2PStua
         Rxmdxkuqbd0NVSWLCFD8QM09n10IDha3UOG2CweU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Billings <jsbillings@jsbillings.org>,
        David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 325/639] afs: Fix AFS file locking to allow fine grained locks
Date:   Fri, 24 Jan 2020 10:28:15 +0100
Message-Id: <20200124093127.839498079@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 68ce801ffd82e72d5005ab5458e8b9e59f24d9cc ]

Fix AFS file locking to allow fine grained locks as some applications, such
as firefox, won't work if they can't take such locks on certain state files
- thereby preventing the use of kAFS to distribute a home directory.

Note that this cannot be made completely functional as the protocol only
has provision for whole-file locks, so there exists the possibility of a
process deadlocking itself by getting a partial read-lock on a file first
and then trying to get a non-overlapping write-lock - but we got the
server's read lock with the first lock, so we're now stuck.

OpenAFS solves this by just granting any partial-range lock directly
without consulting the server - and hoping there's no remote collision.  I
want to implement that in a separate patch and it requires a bit more
thought.

Fixes: 8d6c554126b8 ("AFS: implement file locking")
Reported-by: Jonathan Billings <jsbillings@jsbillings.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/flock.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/fs/afs/flock.c b/fs/afs/flock.c
index 1bb300ef362b0..dffbb456629c9 100644
--- a/fs/afs/flock.c
+++ b/fs/afs/flock.c
@@ -432,10 +432,6 @@ static int afs_do_setlk(struct file *file, struct file_lock *fl)
 
 	_enter("{%x:%u},%u", vnode->fid.vid, vnode->fid.vnode, fl->fl_type);
 
-	/* only whole-file locks are supported */
-	if (fl->fl_start != 0 || fl->fl_end != OFFSET_MAX)
-		return -EINVAL;
-
 	fl->fl_ops = &afs_lock_ops;
 	INIT_LIST_HEAD(&fl->fl_u.afs.link);
 	fl->fl_u.afs.state = AFS_LOCK_PENDING;
@@ -587,10 +583,6 @@ static int afs_do_unlk(struct file *file, struct file_lock *fl)
 	/* Flush all pending writes before doing anything with locks. */
 	vfs_fsync(file, 0);
 
-	/* only whole-file unlocks are supported */
-	if (fl->fl_start != 0 || fl->fl_end != OFFSET_MAX)
-		return -EINVAL;
-
 	ret = posix_lock_file(file, fl, NULL);
 	_leave(" = %d [%u]", ret, vnode->lock_state);
 	return ret;
@@ -618,12 +610,15 @@ static int afs_do_getlk(struct file *file, struct file_lock *fl)
 			goto error;
 
 		lock_count = READ_ONCE(vnode->status.lock_count);
-		if (lock_count > 0)
-			fl->fl_type = F_RDLCK;
-		else
-			fl->fl_type = F_WRLCK;
-		fl->fl_start = 0;
-		fl->fl_end = OFFSET_MAX;
+		if (lock_count != 0) {
+			if (lock_count > 0)
+				fl->fl_type = F_RDLCK;
+			else
+				fl->fl_type = F_WRLCK;
+			fl->fl_start = 0;
+			fl->fl_end = OFFSET_MAX;
+			fl->fl_pid = 0;
+		}
 	}
 
 	ret = 0;
-- 
2.20.1



