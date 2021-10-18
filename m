Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAA17431ABE
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbhJRN3F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:29:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:40248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231495AbhJRN2D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:28:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECE4561250;
        Mon, 18 Oct 2021 13:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563552;
        bh=o86vtXUV4131K8TJF7T3Do477KsQhv26QQ/gZby7KJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T29ph93klHlP+fiMt2+1ckGFgSjbhwSCvmxO4zFzZVjaCraRkRICLEa6b2JEkAUBO
         xVxarP9oTk24w5sI4kf/KovfqduZNvaKwX0Ogn1R/g/6kWYX32UGzv6Qu8I3Vz2nBF
         TFPo0MKT7dRyIdl7e6aWckXvthpdT0QGYYi8cKW0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Jianhua <chris.zjh@huawei.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 4.14 11/39] efi: Change down_interruptible() in virt_efi_reset_system() to down_trylock()
Date:   Mon, 18 Oct 2021 15:24:20 +0200
Message-Id: <20211018132325.821945885@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132325.426739023@linuxfoundation.org>
References: <20211018132325.426739023@linuxfoundation.org>
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
@@ -259,7 +259,7 @@ static void virt_efi_reset_system(int re
 				  unsigned long data_size,
 				  efi_char16_t *data)
 {
-	if (down_interruptible(&efi_runtime_lock)) {
+	if (down_trylock(&efi_runtime_lock)) {
 		pr_warn("failed to invoke the reset_system() runtime service:\n"
 			"could not get exclusive access to the firmware\n");
 		return;


