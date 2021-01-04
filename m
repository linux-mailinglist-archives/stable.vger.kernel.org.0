Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2DA2E99B7
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728962AbhADQC6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:02:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:39992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728954AbhADQC6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:02:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17B6F20769;
        Mon,  4 Jan 2021 16:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776162;
        bh=NqEGqp1novZlMhQPthLuK9lzcA9lKdPOjw64y0wArsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nUJ3zA2P3GwrrGuBkJCdQj5UtGARi/iwnd547bSN9yv/emb4341UsmAEUG5x4DP3p
         4UOztkuwLuB0zoVyGAnrmMrXTLiRuv+Qx3r22q0PqLjYZo1J88sGQtXwl0Jd9dNGrz
         kJGkbRt2qTPS1QqlCz8NxhPXsctYjYlTnN37rAMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>,
        Eric Biggers <ebiggers@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 50/63] fs/namespace.c: WARN if mnt_count has become negative
Date:   Mon,  4 Jan 2021 16:57:43 +0100
Message-Id: <20210104155711.239399679@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155708.800470590@linuxfoundation.org>
References: <20210104155708.800470590@linuxfoundation.org>
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
index cebaa3e817940..93006abe7946a 100644
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
@@ -1139,6 +1139,7 @@ static DECLARE_DELAYED_WORK(delayed_mntput_work, delayed_mntput);
 static void mntput_no_expire(struct mount *mnt)
 {
 	LIST_HEAD(list);
+	int count;
 
 	rcu_read_lock();
 	if (likely(READ_ONCE(mnt->mnt_ns))) {
@@ -1162,7 +1163,9 @@ static void mntput_no_expire(struct mount *mnt)
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



