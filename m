Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 422662060AC
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391667AbgFWUpS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:45:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:42690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392628AbgFWUpQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:45:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB37320656;
        Tue, 23 Jun 2020 20:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592945116;
        bh=o4PHRK78AEjEwD8SHYfozcVWsNFhfNTt6rbCYn+7N7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PAoWmeFlvx7B5ON0neqA/qxrKcKSW8FmgwfmH1dKEzBMSBrmRHvoboLEbQjtOarl8
         d5dwC1garln74OHjQQukZEk6GPNUTpOnzvvkqtKjHCczHBuUviAA/QXFj878Wu0Tw+
         3SuUQ/Mqt1Juz1rlDVE/IMoea7csVQhH03Km+RWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 046/136] drivers: base: Fix NULL pointer exception in __platform_driver_probe() if a driver developer is foolish
Date:   Tue, 23 Jun 2020 21:58:22 +0200
Message-Id: <20200623195305.957093812@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195303.601828702@linuxfoundation.org>
References: <20200623195303.601828702@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index bcb6519fe2113..0ee3cab88f70f 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -702,6 +702,8 @@ int __init_or_module __platform_driver_probe(struct platform_driver *drv,
 	/* temporary section violation during probe() */
 	drv->probe = probe;
 	retval = code = __platform_driver_register(drv, module);
+	if (retval)
+		return retval;
 
 	/*
 	 * Fixup that section violation, being paranoid about code scanning
-- 
2.25.1



