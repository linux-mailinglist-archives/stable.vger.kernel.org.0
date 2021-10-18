Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF0324313E2
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 11:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbhJRJ7E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 05:59:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:38732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229548AbhJRJ7E (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 05:59:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91F7160FD7;
        Mon, 18 Oct 2021 09:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634551013;
        bh=IhQIyPPB3L8GKihYwDq1WxgnwUAIXE6Tq7OHoiD8sqY=;
        h=Subject:To:Cc:From:Date:From;
        b=ISaNmm2IsCBz1qEZTefRuzA5yWGwOYZdTUkM7qKbNdRkvTvxVrM7zeVdOnpfxt0Xu
         nXqQ/YLwkKdd75vqGTBmsHSZpypzaoQshUS8IqhCN3nGsDLARtq7Rap+RjRmFkqIKl
         sMJ48ndF5QWqBZWDc8INyiYB6UGp0JB3MCldfeNo=
Subject: FAILED: patch "[PATCH] misc: fastrpc: Add missing lock before accessing find_vma()" failed to apply to 5.4-stable tree
To:     srinivas.kandagatla@linaro.org, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Oct 2021 11:55:43 +0200
Message-ID: <1634550943149112@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f9a470db2736b01538ad193c316eb3f26be37d58 Mon Sep 17 00:00:00 2001
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Date: Wed, 22 Sep 2021 16:43:26 +0100
Subject: [PATCH] misc: fastrpc: Add missing lock before accessing find_vma()

fastrpc driver is using find_vma() without any protection, as a
result we see below warning due to recent patch 5b78ed24e8ec
("mm/pagemap: add mmap_assert_locked() annotations to find_vma*()")
which added mmap_assert_locked() in find_vma() function.

This bug went un-noticed in previous versions. Fix this issue by adding
required protection while calling find_vma().

CPU: 0 PID: 209746 Comm: benchmark_model Not tainted 5.15.0-rc2-00445-ge14fe2bf817a-dirty #969
Hardware name: Qualcomm Technologies, Inc. Robotics RB5 (DT)
pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : find_vma+0x64/0xd0
lr : find_vma+0x60/0xd0
sp : ffff8000158ebc40
...

Call trace:
 find_vma+0x64/0xd0
 fastrpc_internal_invoke+0x570/0xda8
 fastrpc_device_ioctl+0x3e0/0x928
 __arm64_sys_ioctl+0xac/0xf0
 invoke_syscall+0x44/0x100
 el0_svc_common.constprop.3+0x70/0xf8
 do_el0_svc+0x24/0x88
 el0_svc+0x3c/0x138
 el0t_64_sync_handler+0x90/0xb8
 el0t_64_sync+0x180/0x184

Fixes: 80f3afd72bd4 ("misc: fastrpc: consider address offset before sending to DSP")
Cc: stable@vger.kernel.org
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20210922154326.8927-1-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
index beda610e6b30..ad6ced454655 100644
--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -814,10 +814,12 @@ static int fastrpc_get_args(u32 kernel, struct fastrpc_invoke_ctx *ctx)
 			rpra[i].pv = (u64) ctx->args[i].ptr;
 			pages[i].addr = ctx->maps[i]->phys;
 
+			mmap_read_lock(current->mm);
 			vma = find_vma(current->mm, ctx->args[i].ptr);
 			if (vma)
 				pages[i].addr += ctx->args[i].ptr -
 						 vma->vm_start;
+			mmap_read_unlock(current->mm);
 
 			pg_start = (ctx->args[i].ptr & PAGE_MASK) >> PAGE_SHIFT;
 			pg_end = ((ctx->args[i].ptr + len - 1) & PAGE_MASK) >>

