Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BAE842ED19
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 11:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236539AbhJOJIb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 05:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236424AbhJOJIa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Oct 2021 05:08:30 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC24BC061753;
        Fri, 15 Oct 2021 02:06:23 -0700 (PDT)
Date:   Fri, 15 Oct 2021 09:06:20 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634288781;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=+2tGzUuCki1uvCxJfZMZhaA69QU6J2Z00UwYaGmBrck=;
        b=QyPrnwxwav0j6pdRh445bM/zv0qrCupS/BaEKheXhpRXShgFg+jicmcTOJjN9p1dX7qQPj
        h0jnyOe7eP5UcvXElVdmVcJgib7BTwNiPPEIFr6BKckrZApZKBmMAuRofuFaz4JitlPW61
        BpYmgasx/LAWRzi8jo05rYPUpCK5rZ4cbmspz0DWH2ESwJBnre9WTpWqWG8s0RtVScMvVa
        KU0Gs3+Lf+QkRlY8cz/dmLyP9+c1e5vI5eHs8CILki094LC9Y3EQbf/fxcgeKMj8GYrVxJ
        chi741/UHFni9RbnJXNKD0BPT15O+Q8IMnyjvfC+2SMW5Ll2txDQ1ssLmRnKVQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634288781;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=+2tGzUuCki1uvCxJfZMZhaA69QU6J2Z00UwYaGmBrck=;
        b=yhwwa3NWMU74eNHNjIP402okqVUHNFtEFOkBd39PZJjHsh+d+yoA/3u3cV40iaFOF0wIUz
        KKaHlI0o+hyZscBg==
From:   "tip-bot2 for Zhang Jianhua" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: efi/urgent] efi: Change down_interruptible() in
 virt_efi_reset_system() to down_trylock()
Cc:     <stable@vger.kernel.org>, Zhang Jianhua <chris.zjh@huawei.com>,
        Ard Biesheuvel <ardb@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-ID: <163428878052.25758.826531191991941318.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the efi/urgent branch of tip:

Commit-ID:     38fa3206bf441911258e5001ac8b6738693f8d82
Gitweb:        https://git.kernel.org/tip/38fa3206bf441911258e5001ac8b6738693f8d82
Author:        Zhang Jianhua <chris.zjh@huawei.com>
AuthorDate:    Thu, 23 Sep 2021 10:53:40 +08:00
Committer:     Ard Biesheuvel <ardb@kernel.org>
CommitterDate: Tue, 05 Oct 2021 13:07:01 +02:00

efi: Change down_interruptible() in virt_efi_reset_system() to down_trylock()

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
---
 drivers/firmware/efi/runtime-wrappers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index 1410bea..f3e54f6 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -414,7 +414,7 @@ static void virt_efi_reset_system(int reset_type,
 				  unsigned long data_size,
 				  efi_char16_t *data)
 {
-	if (down_interruptible(&efi_runtime_lock)) {
+	if (down_trylock(&efi_runtime_lock)) {
 		pr_warn("failed to invoke the reset_system() runtime service:\n"
 			"could not get exclusive access to the firmware\n");
 		return;
