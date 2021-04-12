Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B58CA35BFDC
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239255AbhDLJHG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:07:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:54638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240291AbhDLJFe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:05:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACBEA6136B;
        Mon, 12 Apr 2021 09:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218159;
        bh=BY7Uk15m7A87xQ8ndux9S94Ac7tSKin6BauCAWL4oaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jjwNiaaHUaeP1r4wixGlAqWHgFa+f9vAVEY1q7B2ztpkOV+Tdl5lM3oCI0SsWU6pB
         9Dxaj+wc7yxnAS1y18FZcOJT//JTWrBbxo44URdr00rd0lLfhF/QlzWM6Smcujz90p
         nMLtLHdC/ViAm+dY5G2z9xTJ2t4xSGKbHBx7B4YU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Marchevsky <davemarchevsky@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH 5.11 058/210] bpf: Refcount task stack in bpf_get_task_stack
Date:   Mon, 12 Apr 2021 10:39:23 +0200
Message-Id: <20210412084017.932826772@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Marchevsky <davemarchevsky@fb.com>

commit 06ab134ce8ecfa5a69e850f88f81c8a4c3fa91df upstream.

On x86 the struct pt_regs * grabbed by task_pt_regs() points to an
offset of task->stack. The pt_regs are later dereferenced in
__bpf_get_stack (e.g. by user_mode() check). This can cause a fault if
the task in question exits while bpf_get_task_stack is executing, as
warned by task_stack_page's comment:

* When accessing the stack of a non-current task that might exit, use
* try_get_task_stack() instead.  task_stack_page will return a pointer
* that could get freed out from under you.

Taking the comment's advice and using try_get_task_stack() and
put_task_stack() to hold task->stack refcount, or bail early if it's
already 0. Incrementing stack_refcount will ensure the task's stack
sticks around while we're using its data.

I noticed this bug while testing a bpf task iter similar to
bpf_iter_task_stack in selftests, except mine grabbed user stack, and
getting intermittent crashes, which resulted in dumps like:

  BUG: unable to handle page fault for address: 0000000000003fe0
  \#PF: supervisor read access in kernel mode
  \#PF: error_code(0x0000) - not-present page
  RIP: 0010:__bpf_get_stack+0xd0/0x230
  <snip...>
  Call Trace:
  bpf_prog_0a2be35c092cb190_get_task_stacks+0x5d/0x3ec
  bpf_iter_run_prog+0x24/0x81
  __task_seq_show+0x58/0x80
  bpf_seq_read+0xf7/0x3d0
  vfs_read+0x91/0x140
  ksys_read+0x59/0xd0
  do_syscall_64+0x48/0x120
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: fa28dcb82a38 ("bpf: Introduce helper bpf_get_task_stack()")
Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Song Liu <songliubraving@fb.com>
Link: https://lore.kernel.org/bpf/20210401000747.3648767-1-davemarchevsky@fb.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/stackmap.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -652,9 +652,17 @@ const struct bpf_func_proto bpf_get_stac
 BPF_CALL_4(bpf_get_task_stack, struct task_struct *, task, void *, buf,
 	   u32, size, u64, flags)
 {
-	struct pt_regs *regs = task_pt_regs(task);
+	struct pt_regs *regs;
+	long res;
 
-	return __bpf_get_stack(regs, task, NULL, buf, size, flags);
+	if (!try_get_task_stack(task))
+		return -EFAULT;
+
+	regs = task_pt_regs(task);
+	res = __bpf_get_stack(regs, task, NULL, buf, size, flags);
+	put_task_stack(task);
+
+	return res;
 }
 
 BTF_ID_LIST_SINGLE(bpf_get_task_stack_btf_ids, struct, task_struct)


