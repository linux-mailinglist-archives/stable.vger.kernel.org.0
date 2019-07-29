Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF167958E
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389421AbfG2Tno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:43:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:60174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389168AbfG2Tnn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:43:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9E2621655;
        Mon, 29 Jul 2019 19:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429422;
        bh=c/1hPGg/6CR6iTEm4wN+3cRAbYNxlzSAfACA9J40vec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1vy2i3wACVTnkLOaveJG//BgvUe0ZokOqSWwxBbODCOH8G7D6JNASFevNt4xoh8bj
         8T8qC1HmGQvs2Zjjw1NLTnkPuHlM2MRA8y/+/gpzZbvwkyX1msVyG84tU9YdapRP1S
         g9pwu7jb1WnGjdlcUAXZ0cF3R4fmHYOBKg3g/L9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Roman Gushchin <guro@fb.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Michal Hocko <mhocko@suse.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <willy@infradead.org>,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 092/113] proc: use down_read_killable mmap_sem for /proc/pid/map_files
Date:   Mon, 29 Jul 2019 21:22:59 +0200
Message-Id: <20190729190717.491633878@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190655.455345569@linuxfoundation.org>
References: <20190729190655.455345569@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit cd9e2bb8271c971d9f37c722be2616c7f8ba0664 ]

Do not remain stuck forever if something goes wrong.  Using a killable
lock permits cleanup of stuck tasks and simplifies investigation.

It seems ->d_revalidate() could return any error (except ECHILD) to abort
validation and pass error as result of lookup sequence.

[akpm@linux-foundation.org: fix proc_map_files_lookup() return value, per Andrei]
Link: http://lkml.kernel.org/r/156007493995.3335.9595044802115356911.stgit@buzz
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Reviewed-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Cyrill Gorcunov <gorcunov@gmail.com>
Reviewed-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/base.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index f999e8bd3771..a7fbda72afeb 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1960,9 +1960,12 @@ static int map_files_d_revalidate(struct dentry *dentry, unsigned int flags)
 		goto out;
 
 	if (!dname_to_vma_addr(dentry, &vm_start, &vm_end)) {
-		down_read(&mm->mmap_sem);
-		exact_vma_exists = !!find_exact_vma(mm, vm_start, vm_end);
-		up_read(&mm->mmap_sem);
+		status = down_read_killable(&mm->mmap_sem);
+		if (!status) {
+			exact_vma_exists = !!find_exact_vma(mm, vm_start,
+							    vm_end);
+			up_read(&mm->mmap_sem);
+		}
 	}
 
 	mmput(mm);
@@ -2008,8 +2011,11 @@ static int map_files_get_link(struct dentry *dentry, struct path *path)
 	if (rc)
 		goto out_mmput;
 
+	rc = down_read_killable(&mm->mmap_sem);
+	if (rc)
+		goto out_mmput;
+
 	rc = -ENOENT;
-	down_read(&mm->mmap_sem);
 	vma = find_exact_vma(mm, vm_start, vm_end);
 	if (vma && vma->vm_file) {
 		*path = vma->vm_file->f_path;
@@ -2105,7 +2111,11 @@ static struct dentry *proc_map_files_lookup(struct inode *dir,
 	if (!mm)
 		goto out_put_task;
 
-	down_read(&mm->mmap_sem);
+	result = ERR_PTR(-EINTR);
+	if (down_read_killable(&mm->mmap_sem))
+		goto out_put_mm;
+
+	result = ERR_PTR(-ENOENT);
 	vma = find_exact_vma(mm, vm_start, vm_end);
 	if (!vma)
 		goto out_no_vma;
@@ -2116,6 +2126,7 @@ static struct dentry *proc_map_files_lookup(struct inode *dir,
 
 out_no_vma:
 	up_read(&mm->mmap_sem);
+out_put_mm:
 	mmput(mm);
 out_put_task:
 	put_task_struct(task);
@@ -2157,7 +2168,12 @@ proc_map_files_readdir(struct file *file, struct dir_context *ctx)
 	mm = get_task_mm(task);
 	if (!mm)
 		goto out_put_task;
-	down_read(&mm->mmap_sem);
+
+	ret = down_read_killable(&mm->mmap_sem);
+	if (ret) {
+		mmput(mm);
+		goto out_put_task;
+	}
 
 	nr_files = 0;
 
-- 
2.20.1



