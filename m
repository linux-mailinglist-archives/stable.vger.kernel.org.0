Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFC752F15D6
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731288AbhAKNKz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:10:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:57732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730987AbhAKNKw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:10:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DAFB2255F;
        Mon, 11 Jan 2021 13:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370636;
        bh=5igYRM//wsP2dCkuShwXCZoN+YG4ADcFp0CzWco+I50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rybj4UJKlqYHqSjBnnx7EEGkSb4uzCdVrk15Rfy+yIlR+oS2Tlt4BRAGWGDV5MiZE
         /KjQMjygs22hwLunDPNiOVW8aIerE/1qgYLFwHpv66zkC9iHG/F15/jAi4MMdCbcWx
         Pr64lGsNW3K8CqgUNbKUU92zzrxpDdKur7CAljsc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 08/92] proc: change ->nlink under proc_subdir_lock
Date:   Mon, 11 Jan 2021 14:01:12 +0100
Message-Id: <20210111130039.556916907@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130039.165470698@linuxfoundation.org>
References: <20210111130039.165470698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>

[ Upstream commit e06689bf57017ac022ccf0f2a5071f760821ce0f ]

Currently gluing PDE into global /proc tree is done under lock, but
changing ->nlink is not.  Additionally struct proc_dir_entry::nlink is
not atomic so updates can be lost.

Link: http://lkml.kernel.org/r/20190925202436.GA17388@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/generic.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 64e9ee1b129e2..d4f353187d67c 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -138,8 +138,12 @@ static int proc_getattr(const struct path *path, struct kstat *stat,
 {
 	struct inode *inode = d_inode(path->dentry);
 	struct proc_dir_entry *de = PDE(inode);
-	if (de && de->nlink)
-		set_nlink(inode, de->nlink);
+	if (de) {
+		nlink_t nlink = READ_ONCE(de->nlink);
+		if (nlink > 0) {
+			set_nlink(inode, nlink);
+		}
+	}
 
 	generic_fillattr(inode, stat);
 	return 0;
@@ -362,6 +366,7 @@ struct proc_dir_entry *proc_register(struct proc_dir_entry *dir,
 		write_unlock(&proc_subdir_lock);
 		goto out_free_inum;
 	}
+	dir->nlink++;
 	write_unlock(&proc_subdir_lock);
 
 	return dp;
@@ -472,10 +477,7 @@ struct proc_dir_entry *proc_mkdir_data(const char *name, umode_t mode,
 		ent->data = data;
 		ent->proc_fops = &proc_dir_operations;
 		ent->proc_iops = &proc_dir_inode_operations;
-		parent->nlink++;
 		ent = proc_register(parent, ent);
-		if (!ent)
-			parent->nlink--;
 	}
 	return ent;
 }
@@ -505,10 +507,7 @@ struct proc_dir_entry *proc_create_mount_point(const char *name)
 		ent->data = NULL;
 		ent->proc_fops = NULL;
 		ent->proc_iops = NULL;
-		parent->nlink++;
 		ent = proc_register(parent, ent);
-		if (!ent)
-			parent->nlink--;
 	}
 	return ent;
 }
@@ -666,8 +665,12 @@ void remove_proc_entry(const char *name, struct proc_dir_entry *parent)
 	len = strlen(fn);
 
 	de = pde_subdir_find(parent, fn, len);
-	if (de)
+	if (de) {
 		rb_erase(&de->subdir_node, &parent->subdir);
+		if (S_ISDIR(de->mode)) {
+			parent->nlink--;
+		}
+	}
 	write_unlock(&proc_subdir_lock);
 	if (!de) {
 		WARN(1, "name '%s'\n", name);
@@ -676,9 +679,6 @@ void remove_proc_entry(const char *name, struct proc_dir_entry *parent)
 
 	proc_entry_rundown(de);
 
-	if (S_ISDIR(de->mode))
-		parent->nlink--;
-	de->nlink = 0;
 	WARN(pde_subdir_first(de),
 	     "%s: removing non-empty directory '%s/%s', leaking at least '%s'\n",
 	     __func__, de->parent->name, de->name, pde_subdir_first(de)->name);
@@ -714,13 +714,12 @@ int remove_proc_subtree(const char *name, struct proc_dir_entry *parent)
 			de = next;
 			continue;
 		}
-		write_unlock(&proc_subdir_lock);
-
-		proc_entry_rundown(de);
 		next = de->parent;
 		if (S_ISDIR(de->mode))
 			next->nlink--;
-		de->nlink = 0;
+		write_unlock(&proc_subdir_lock);
+
+		proc_entry_rundown(de);
 		if (de == root)
 			break;
 		pde_put(de);
-- 
2.27.0



