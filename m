Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C01E431CB4
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233280AbhJRNoD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:44:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232937AbhJRNmN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:42:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8605C61458;
        Mon, 18 Oct 2021 13:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564038;
        bh=suoiWp44/xr67QDUriN6p/vWMX8spM2MaexFh89YP7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=goORiLAo7VgFgT4gbXKyMWeBafn3bmDpMu1QMRmkHX+/b2H4Fh4EgFk0mh6Wyujwh
         1N3MqPd1Awo4IYNZUTdR/RyAeWyBmJMNSfM1cw+wOaeIwwZe+SEihim2RsegsLDod3
         /qXnJXtrOku/gNaBzyRjUeAKveolm5oDFWwOFtoE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 5.10 040/103] misc: fastrpc: Add missing lock before accessing find_vma()
Date:   Mon, 18 Oct 2021 15:24:16 +0200
Message-Id: <20211018132336.056196090@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132334.702559133@linuxfoundation.org>
References: <20211018132334.702559133@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

commit f9a470db2736b01538ad193c316eb3f26be37d58 upstream.

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
---
 drivers/misc/fastrpc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -812,10 +812,12 @@ static int fastrpc_get_args(u32 kernel,
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


