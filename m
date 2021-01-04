Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5861E2E9A3C
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727713AbhADQB2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:01:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:38732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728576AbhADQBZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:01:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 684C922522;
        Mon,  4 Jan 2021 16:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776044;
        bh=zalySSx7DbzBGWtwr3ORW40jKfdlWX2z7z2fB+j1pO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=elVDUO9zRy+BCiO/2WEhLek4Th2sBr0MoYYxhGmjjEwSZ9/0H80V3PEZe/OORK4nL
         bR63xLGMUzHtsQMfr3Zxo0FLGmpqFcn8yDL5yzH1E6+7170jQfcCjTSuCI4pkMyVPT
         1xhsKMLOLDl9/Z+7jkP3SmCX5yoCOEcVFVTPdGDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>,
        Eric Biggers <ebiggers@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 43/47] fs/namespace.c: WARN if mnt_count has become negative
Date:   Mon,  4 Jan 2021 16:57:42 +0100
Message-Id: <20210104155707.809306684@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155705.740576914@linuxfoundation.org>
References: <20210104155705.740576914@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit edf7ddbf1c5eb98b720b063b73e20e8a4a1ce673 ]

Missing calls to mntget() (or equivalently, too many calls to mntput())
are hard to detect because mntput() delays freeing mounts using
task_work_add(), then again using call_rcu().  As a result, mnt_count
can often be decremented to -1 without getting a KASAN use-after-free
report.  Such cases are still bugs though, and they point to real
use-after-frees being possible.

For an example of this, see the bug fixed by commit 1b0b9cc8d379
("vfs: fsmount: add missing mntget()"), discussed at
https://lkml.kernel.org/linux-fsdevel/20190605135401.GB30925@xxxxxxxxxxxxxxxxxxxxxxxxx/T/#u.
This bug *should* have been trivial to find.  But actually, it wasn't
found until syzkaller happened to use fchdir() to manipulate the
reference count just right for the bug to be noticeable.

Address this by making mntput_no_expire() issue a WARN if mnt_count has
become negative.

Suggested-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 9 ++++++---
 fs/pnode.h     | 2 +-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 2adfe7b166a3e..76ea92994d26d 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -156,10 +156,10 @@ static inline void mnt_add_count(struct mount *mnt, int n)
 /*
  * vfsmount lock must be held for write
  */
-unsigned int mnt_get_count(struct mount *mnt)
+int mnt_get_count(struct mount *mnt)
 {
 #ifdef CONFIG_SMP
-	unsigned int count = 0;
+	int count = 0;
 	int cpu;
 
 	for_each_possible_cpu(cpu) {
@@ -1123,6 +1123,7 @@ static DECLARE_DELAYED_WORK(delayed_mntput_work, delayed_mntput);
 static void mntput_no_expire(struct mount *mnt)
 {
 	LIST_HEAD(list);
+	int count;
 
 	rcu_read_lock();
 	if (likely(READ_ONCE(mnt->mnt_ns))) {
@@ -1146,7 +1147,9 @@ static void mntput_no_expire(struct mount *mnt)
 	 */
 	smp_mb();
 	mnt_add_count(mnt, -1);
-	if (mnt_get_count(mnt)) {
+	count = mnt_get_count(mnt);
+	if (count != 0) {
+		WARN_ON(count < 0);
 		rcu_read_unlock();
 		unlock_mount_hash();
 		return;
diff --git a/fs/pnode.h b/fs/pnode.h
index 49a058c73e4c7..26f74e092bd98 100644
--- a/fs/pnode.h
+++ b/fs/pnode.h
@@ -44,7 +44,7 @@ int propagate_mount_busy(struct mount *, int);
 void propagate_mount_unlock(struct mount *);
 void mnt_release_group_id(struct mount *);
 int get_dominating_id(struct mount *mnt, const struct path *root);
-unsigned int mnt_get_count(struct mount *mnt);
+int mnt_get_count(struct mount *mnt);
 void mnt_set_mountpoint(struct mount *, struct mountpoint *,
 			struct mount *);
 void mnt_change_mountpoint(struct mount *parent, struct mountpoint *mp,
-- 
2.27.0



