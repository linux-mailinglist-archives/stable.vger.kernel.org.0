Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26A9C676F64
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbjAVPU7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:20:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbjAVPU6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:20:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20A49222F8
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:20:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8A8BB807E4
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:20:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FE56C433D2;
        Sun, 22 Jan 2023 15:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400854;
        bh=4FLqEhhHWEmpwMWNYiDj3sM/gfcdiz9lYsBuj1rjzlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jCqFCX4flzabOsSts1CM0GrMJoQLaS6XLwlVYVmz0WzEJ7BOSh4hLjIVDkI47cxtB
         oX78d4bnAiMKvxL38onid5pCsTS0Dlyl+ljO6rMW0TVQmsqbU+plzAcGnS7upzb9Br
         37MBESnbxlR2JTfEFF/OCrdtcWR3Vn0wx2BquQG4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Song Liu <song@kernel.org>,
        Kui-Feng Lee <kuifeng@meta.com>,
        Nathan Slingerland <slinger@meta.com>,
        Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 017/193] bpf: keep a reference to the mm, in case the task is dead.
Date:   Sun, 22 Jan 2023 16:02:26 +0100
Message-Id: <20230122150247.150966892@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kui-Feng Lee <kuifeng@meta.com>

[ Upstream commit 7ff94f276f8ea05df82eb115225e9b26f47a3347 ]

Fix the system crash that happens when a task iterator travel through
vma of tasks.

In task iterators, we used to access mm by following the pointer on
the task_struct; however, the death of a task will clear the pointer,
even though we still hold the task_struct.  That can cause an
unexpected crash for a null pointer when an iterator is visiting a
task that dies during the visit.  Keeping a reference of mm on the
iterator ensures we always have a valid pointer to mm.

Co-developed-by: Song Liu <song@kernel.org>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Kui-Feng Lee <kuifeng@meta.com>
Reported-by: Nathan Slingerland <slinger@meta.com>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/r/20221216221855.4122288-2-kuifeng@meta.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/task_iter.c | 39 +++++++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 12 deletions(-)

diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
index c2a2182ce570..c4ab9d6cdbe9 100644
--- a/kernel/bpf/task_iter.c
+++ b/kernel/bpf/task_iter.c
@@ -438,6 +438,7 @@ struct bpf_iter_seq_task_vma_info {
 	 */
 	struct bpf_iter_seq_task_common common;
 	struct task_struct *task;
+	struct mm_struct *mm;
 	struct vm_area_struct *vma;
 	u32 tid;
 	unsigned long prev_vm_start;
@@ -456,16 +457,19 @@ task_vma_seq_get_next(struct bpf_iter_seq_task_vma_info *info)
 	enum bpf_task_vma_iter_find_op op;
 	struct vm_area_struct *curr_vma;
 	struct task_struct *curr_task;
+	struct mm_struct *curr_mm;
 	u32 saved_tid = info->tid;
 
 	/* If this function returns a non-NULL vma, it holds a reference to
-	 * the task_struct, and holds read lock on vma->mm->mmap_lock.
+	 * the task_struct, holds a refcount on mm->mm_users, and holds
+	 * read lock on vma->mm->mmap_lock.
 	 * If this function returns NULL, it does not hold any reference or
 	 * lock.
 	 */
 	if (info->task) {
 		curr_task = info->task;
 		curr_vma = info->vma;
+		curr_mm = info->mm;
 		/* In case of lock contention, drop mmap_lock to unblock
 		 * the writer.
 		 *
@@ -504,13 +508,15 @@ task_vma_seq_get_next(struct bpf_iter_seq_task_vma_info *info)
 		 *    4.2) VMA2 and VMA2' covers different ranges, process
 		 *         VMA2'.
 		 */
-		if (mmap_lock_is_contended(curr_task->mm)) {
+		if (mmap_lock_is_contended(curr_mm)) {
 			info->prev_vm_start = curr_vma->vm_start;
 			info->prev_vm_end = curr_vma->vm_end;
 			op = task_vma_iter_find_vma;
-			mmap_read_unlock(curr_task->mm);
-			if (mmap_read_lock_killable(curr_task->mm))
+			mmap_read_unlock(curr_mm);
+			if (mmap_read_lock_killable(curr_mm)) {
+				mmput(curr_mm);
 				goto finish;
+			}
 		} else {
 			op = task_vma_iter_next_vma;
 		}
@@ -535,42 +541,47 @@ task_vma_seq_get_next(struct bpf_iter_seq_task_vma_info *info)
 			op = task_vma_iter_find_vma;
 		}
 
-		if (!curr_task->mm)
+		curr_mm = get_task_mm(curr_task);
+		if (!curr_mm)
 			goto next_task;
 
-		if (mmap_read_lock_killable(curr_task->mm))
+		if (mmap_read_lock_killable(curr_mm)) {
+			mmput(curr_mm);
 			goto finish;
+		}
 	}
 
 	switch (op) {
 	case task_vma_iter_first_vma:
-		curr_vma = find_vma(curr_task->mm, 0);
+		curr_vma = find_vma(curr_mm, 0);
 		break;
 	case task_vma_iter_next_vma:
-		curr_vma = find_vma(curr_task->mm, curr_vma->vm_end);
+		curr_vma = find_vma(curr_mm, curr_vma->vm_end);
 		break;
 	case task_vma_iter_find_vma:
 		/* We dropped mmap_lock so it is necessary to use find_vma
 		 * to find the next vma. This is similar to the  mechanism
 		 * in show_smaps_rollup().
 		 */
-		curr_vma = find_vma(curr_task->mm, info->prev_vm_end - 1);
+		curr_vma = find_vma(curr_mm, info->prev_vm_end - 1);
 		/* case 1) and 4.2) above just use curr_vma */
 
 		/* check for case 2) or case 4.1) above */
 		if (curr_vma &&
 		    curr_vma->vm_start == info->prev_vm_start &&
 		    curr_vma->vm_end == info->prev_vm_end)
-			curr_vma = find_vma(curr_task->mm, curr_vma->vm_end);
+			curr_vma = find_vma(curr_mm, curr_vma->vm_end);
 		break;
 	}
 	if (!curr_vma) {
 		/* case 3) above, or case 2) 4.1) with vma->next == NULL */
-		mmap_read_unlock(curr_task->mm);
+		mmap_read_unlock(curr_mm);
+		mmput(curr_mm);
 		goto next_task;
 	}
 	info->task = curr_task;
 	info->vma = curr_vma;
+	info->mm = curr_mm;
 	return curr_vma;
 
 next_task:
@@ -579,6 +590,7 @@ task_vma_seq_get_next(struct bpf_iter_seq_task_vma_info *info)
 
 	put_task_struct(curr_task);
 	info->task = NULL;
+	info->mm = NULL;
 	info->tid++;
 	goto again;
 
@@ -587,6 +599,7 @@ task_vma_seq_get_next(struct bpf_iter_seq_task_vma_info *info)
 		put_task_struct(curr_task);
 	info->task = NULL;
 	info->vma = NULL;
+	info->mm = NULL;
 	return NULL;
 }
 
@@ -658,7 +671,9 @@ static void task_vma_seq_stop(struct seq_file *seq, void *v)
 		 */
 		info->prev_vm_start = ~0UL;
 		info->prev_vm_end = info->vma->vm_end;
-		mmap_read_unlock(info->task->mm);
+		mmap_read_unlock(info->mm);
+		mmput(info->mm);
+		info->mm = NULL;
 		put_task_struct(info->task);
 		info->task = NULL;
 	}
-- 
2.35.1



