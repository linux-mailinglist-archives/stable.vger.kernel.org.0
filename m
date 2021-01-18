Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17BEC2FA2C5
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 15:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392862AbhAROTI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 09:19:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:39146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390624AbhARLot (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:44:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B10B22E01;
        Mon, 18 Jan 2021 11:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970250;
        bh=m9RstEPCumU8Lo/fqYJ4cs9tZXJkpHMODr5qVXvkzls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BoDcRaDpSwcadtpsNSJu4oL7A7gbdjETUQSgWITr+eQzEZsxE7P3p5VF/gzjc+dP1
         mz6usNddcAwU0PziQziqrBxh0NxtyrgwCb7r7nR4OM5ARA1Iku/gp70FhXwlRmrVz+
         6sguB/kbAVakIwHxzNKMC5I8OuZJENtfUl3CnCXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 099/152] bpf: Simplify task_file_seq_get_next()
Date:   Mon, 18 Jan 2021 12:34:34 +0100
Message-Id: <20210118113357.490328939@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Song Liu <songliubraving@fb.com>

[ Upstream commit 91b2db27d3ff9ad29e8b3108dfbf1e2f49fe9bd3 ]

Simplify task_file_seq_get_next() by removing two in/out arguments: task
and fstruct. Use info->task and info->files instead.

Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20201120002833.2481110-1-songliubraving@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/task_iter.c | 54 +++++++++++++-----------------------------
 1 file changed, 17 insertions(+), 37 deletions(-)

diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
index 5b6af30bfbcd8..767c93d38bf55 100644
--- a/kernel/bpf/task_iter.c
+++ b/kernel/bpf/task_iter.c
@@ -136,8 +136,7 @@ struct bpf_iter_seq_task_file_info {
 };
 
 static struct file *
-task_file_seq_get_next(struct bpf_iter_seq_task_file_info *info,
-		       struct task_struct **task, struct files_struct **fstruct)
+task_file_seq_get_next(struct bpf_iter_seq_task_file_info *info)
 {
 	struct pid_namespace *ns = info->common.ns;
 	u32 curr_tid = info->tid, max_fds;
@@ -150,14 +149,17 @@ task_file_seq_get_next(struct bpf_iter_seq_task_file_info *info,
 	 * Otherwise, it does not hold any reference.
 	 */
 again:
-	if (*task) {
-		curr_task = *task;
-		curr_files = *fstruct;
+	if (info->task) {
+		curr_task = info->task;
+		curr_files = info->files;
 		curr_fd = info->fd;
 	} else {
 		curr_task = task_seq_get_next(ns, &curr_tid, true);
-		if (!curr_task)
+		if (!curr_task) {
+			info->task = NULL;
+			info->files = NULL;
 			return NULL;
+		}
 
 		curr_files = get_files_struct(curr_task);
 		if (!curr_files) {
@@ -167,9 +169,8 @@ task_file_seq_get_next(struct bpf_iter_seq_task_file_info *info,
 			goto again;
 		}
 
-		/* set *fstruct, *task and info->tid */
-		*fstruct = curr_files;
-		*task = curr_task;
+		info->files = curr_files;
+		info->task = curr_task;
 		if (curr_tid == info->tid) {
 			curr_fd = info->fd;
 		} else {
@@ -199,8 +200,8 @@ task_file_seq_get_next(struct bpf_iter_seq_task_file_info *info,
 	rcu_read_unlock();
 	put_files_struct(curr_files);
 	put_task_struct(curr_task);
-	*task = NULL;
-	*fstruct = NULL;
+	info->task = NULL;
+	info->files = NULL;
 	info->fd = 0;
 	curr_tid = ++(info->tid);
 	goto again;
@@ -209,21 +210,13 @@ task_file_seq_get_next(struct bpf_iter_seq_task_file_info *info,
 static void *task_file_seq_start(struct seq_file *seq, loff_t *pos)
 {
 	struct bpf_iter_seq_task_file_info *info = seq->private;
-	struct files_struct *files = NULL;
-	struct task_struct *task = NULL;
 	struct file *file;
 
-	file = task_file_seq_get_next(info, &task, &files);
-	if (!file) {
-		info->files = NULL;
-		info->task = NULL;
-		return NULL;
-	}
-
-	if (*pos == 0)
+	info->task = NULL;
+	info->files = NULL;
+	file = task_file_seq_get_next(info);
+	if (file && *pos == 0)
 		++*pos;
-	info->task = task;
-	info->files = files;
 
 	return file;
 }
@@ -231,24 +224,11 @@ static void *task_file_seq_start(struct seq_file *seq, loff_t *pos)
 static void *task_file_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
 	struct bpf_iter_seq_task_file_info *info = seq->private;
-	struct files_struct *files = info->files;
-	struct task_struct *task = info->task;
-	struct file *file;
 
 	++*pos;
 	++info->fd;
 	fput((struct file *)v);
-	file = task_file_seq_get_next(info, &task, &files);
-	if (!file) {
-		info->files = NULL;
-		info->task = NULL;
-		return NULL;
-	}
-
-	info->task = task;
-	info->files = files;
-
-	return file;
+	return task_file_seq_get_next(info);
 }
 
 struct bpf_iter__task_file {
-- 
2.27.0



