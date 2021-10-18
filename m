Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC4F0431BE9
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbhJRNgP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:36:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:43310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231911AbhJRNek (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:34:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49E9A613B3;
        Mon, 18 Oct 2021 13:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563811;
        bh=H6/bz4ph6WCr8Ka1uaSQPmCtR2591g3xQ5w1Amar1uQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VYpkFgCcrPkXwZUDRZzLjGPdUYFyNr6RkJFvp13nz7OeugOVFIfUIR89y8nXzZ6q6
         OxomjMfvwga3DWJTnx5QcLrCNGbT1xaeyKhSYAu/XflU0yeQbooQomECaei+4AhjRo
         Kavgk1D9FY0JSZDItc3108OAtw9lzgy4eSAPfJhk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Jianhua <chris.zjh@huawei.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5.4 24/69] efi: Change down_interruptible() in virt_efi_reset_system() to down_trylock()
Date:   Mon, 18 Oct 2021 15:24:22 +0200
Message-Id: <20211018132330.258606167@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132329.453964125@linuxfoundation.org>
References: <20211018132329.453964125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Jianhua <chris.zjh@huawei.com>

commit 38fa3206bf441911258e5001ac8b6738693f8d82 upstream.

While reboot the system by sysrq, the following bug will be occur.

BUG: sleeping function called from invalid context at kernel/locking/semaphore.c:90
in_atomic(): 0, irqs_disabled(): 128, non_block: 0, pid: 10052, name: rc.shutdown
CPU: 3 PID: 10052 Comm: rc.shutdown Tainted: G        W O      5.10.0 #1
Call trace:
 dump_backtrace+0x0/0x1c8
 show_stack+0x18/0x28
 dump_stack+0xd0/0x110
 ___might_sleep+0x14c/0x160
 __might_sleep+0x74/0x88
 down_interruptible+0x40/0x118
 virt_efi_reset_system+0x3c/0xd0
 efi_reboot+0xd4/0x11c
 machine_restart+0x60/0x9c
 emergency_restart+0x1c/0x2c
 sysrq_handle_reboot+0x1c/0x2c
 __handle_sysrq+0xd0/0x194
 write_sysrq_trigger+0xbc/0xe4
 proc_reg_write+0xd4/0xf0
 vfs_write+0xa8/0x148
 ksys_write+0x6c/0xd8
 __arm64_sys_write+0x18/0x28
 el0_svc_common.constprop.3+0xe4/0x16c
 do_el0_svc+0x1c/0x2c
 el0_svc+0x20/0x30
 el0_sync_handler+0x80/0x17c
 el0_sync+0x158/0x180

The reason for this problem is that irq has been disabled in
machine_restart() and then it calls down_interruptible() in
virt_efi_reset_system(), which would occur sleep in irq context,
it is dangerous! Commit 99409b935c9a("locking/semaphore: Add
might_sleep() to down_*() family") add might_sleep() in
down_interruptible(), so the bug info is here. down_trylock()
can solve this problem, cause there is no might_sleep.

--------

Cc: <stable@vger.kernel.org>
Signed-off-by: Zhang Jianhua <chris.zjh@huawei.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/runtime-wrappers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -414,7 +414,7 @@ static void virt_efi_reset_system(int re
 				  unsigned long data_size,
 				  efi_char16_t *data)
 {
-	if (down_interruptible(&efi_runtime_lock)) {
+	if (down_trylock(&efi_runtime_lock)) {
 		pr_warn("failed to invoke the reset_system() runtime service:\n"
 			"could not get exclusive access to the firmware\n");
 		return;


