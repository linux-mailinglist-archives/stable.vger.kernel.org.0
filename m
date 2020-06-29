Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C47620D4E9
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 21:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730991AbgF2TMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:12:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730959AbgF2TKS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:10:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8089254C2;
        Mon, 29 Jun 2020 15:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593446018;
        bh=RfP7bVmwAMD3dBQYtCyQVoO76W8K0tcJwdBsE8JBTMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lIX/AXpUR8yJ0g6gfS7KsNReSZJfoKAkZMOfY5kBLWl9D5C2JhlnBIy6/moM/jDLh
         k4UgqJqBqc/7Z0p8zhH8Tr4aJ5kv5XMLUJJQr9HGCVvlMnvkadNtkiyE6rzhJL1r+R
         UGqd0tz+zG42r9Zwq4OTqwoOr3QnAuJ2vVu2l0F8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 025/135] drivers: base: Fix NULL pointer exception in __platform_driver_probe() if a driver developer is foolish
Date:   Mon, 29 Jun 2020 11:51:19 -0400
Message-Id: <20200629155309.2495516-26-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629155309.2495516-1-sashal@kernel.org>
References: <20200629155309.2495516-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:53+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>

[ Upstream commit 388bcc6ecc609fca1b4920de7dc3806c98ec535e ]

If platform bus driver registration is failed then, accessing
platform bus spin lock (&drv->driver.bus->p->klist_drivers.k_lock)
in __platform_driver_probe() without verifying the return value
__platform_driver_register() can lead to NULL pointer exception.

So check the return value before attempting the spin lock.

One such example is below:

For a custom usecase, I have intentionally failed the platform bus
registration and I expected all the platform device/driver
registrations to fail gracefully. But I came across this panic
issue.

[    1.331067] BUG: kernel NULL pointer dereference, address: 00000000000000c8
[    1.331118] #PF: supervisor write access in kernel mode
[    1.331163] #PF: error_code(0x0002) - not-present page
[    1.331208] PGD 0 P4D 0
[    1.331233] Oops: 0002 [#1] PREEMPT SMP
[    1.331268] CPU: 3 PID: 1 Comm: swapper/0 Tainted: G        W         5.6.0-00049-g670d35fb0144 #165
[    1.331341] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
[    1.331406] RIP: 0010:_raw_spin_lock+0x15/0x30
[    1.331588] RSP: 0000:ffffc9000001be70 EFLAGS: 00010246
[    1.331632] RAX: 0000000000000000 RBX: 00000000000000c8 RCX: 0000000000000001
[    1.331696] RDX: 0000000000000001 RSI: 0000000000000092 RDI: 0000000000000000
[    1.331754] RBP: 00000000ffffffed R08: 0000000000000501 R09: 0000000000000001
[    1.331817] R10: ffff88817abcc520 R11: 0000000000000670 R12: 00000000ffffffed
[    1.331881] R13: ffffffff82dbc268 R14: ffffffff832f070a R15: 0000000000000000
[    1.331945] FS:  0000000000000000(0000) GS:ffff88817bd80000(0000) knlGS:0000000000000000
[    1.332008] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.332062] CR2: 00000000000000c8 CR3: 000000000681e001 CR4: 00000000003606e0
[    1.332126] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    1.332189] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    1.332252] Call Trace:
[    1.332281]  __platform_driver_probe+0x92/0xee
[    1.332323]  ? rtc_dev_init+0x2b/0x2b
[    1.332358]  cmos_init+0x37/0x67
[    1.332396]  do_one_initcall+0x7d/0x168
[    1.332428]  kernel_init_freeable+0x16c/0x1c9
[    1.332473]  ? rest_init+0xc0/0xc0
[    1.332508]  kernel_init+0x5/0x100
[    1.332543]  ret_from_fork+0x1f/0x30
[    1.332579] CR2: 00000000000000c8
[    1.332616] ---[ end trace 3bd87f12e9010b87 ]---
[    1.333549] note: swapper/0[1] exited with preempt_count 1
[    1.333592] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
[    1.333736] Kernel Offset: disabled

Note, this can only be triggered if a driver errors out from this call,
which should never happen.  If it does, the driver needs to be fixed.

Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Link: https://lore.kernel.org/r/20200408214003.3356-1-sathyanarayanan.kuppuswamy@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/platform.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 065fcc4be263a..f89cb143f1cdf 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -638,6 +638,8 @@ int __init_or_module __platform_driver_probe(struct platform_driver *drv,
 	/* temporary section violation during probe() */
 	drv->probe = probe;
 	retval = code = __platform_driver_register(drv, module);
+	if (retval)
+		return retval;
 
 	/*
 	 * Fixup that section violation, being paranoid about code scanning
-- 
2.25.1

