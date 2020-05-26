Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF5D1D0EB7
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387472AbgEMJuS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:50:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387470AbgEMJuR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:50:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D030206D6;
        Wed, 13 May 2020 09:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363417;
        bh=XqLpaBs6gOV3NeFStYNmFciupOw+sZY4klD0tUH5OUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TLeG7iGrWCwv2HHyKwXPeFLTUTwl1hrzmYn5Dla0RigJE8ZDwAjdb5vbFohod4Snc
         V2LjirIeFqq7CGuzSPky5Ou7ttu6PP+Eb1YyBHs2c/6gjVOTA8cbt3f2U2o9E1uEkU
         ohFAFgNUQoTEdsOQyprVUcTwJ+xl7160HHcbO9EE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Vroon <chainsaw@gentoo.org>,
        Sergey Kvachonok <ravenexp@gmail.com>,
        Sergei Trofimovich <slyfox@gentoo.org>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 5.4 65/90] coredump: fix crash when umh is disabled
Date:   Wed, 13 May 2020 11:45:01 +0200
Message-Id: <20200513094416.284461688@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094408.810028856@linuxfoundation.org>
References: <20200513094408.810028856@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luis Chamberlain <mcgrof@kernel.org>

commit 3740d93e37902b31159a82da2d5c8812ed825404 upstream.

Commit 64e90a8acb859 ("Introduce STATIC_USERMODEHELPER to mediate
call_usermodehelper()") added the optiont to disable all
call_usermodehelper() calls by setting STATIC_USERMODEHELPER_PATH to
an empty string. When this is done, and crashdump is triggered, it
will crash on null pointer dereference, since we make assumptions
over what call_usermodehelper_exec() did.

This has been reported by Sergey when one triggers a a coredump
with the following configuration:

```
CONFIG_STATIC_USERMODEHELPER=y
CONFIG_STATIC_USERMODEHELPER_PATH=""
kernel.core_pattern = |/usr/lib/systemd/systemd-coredump %P %u %g %s %t %c %h %e
```

The way disabling the umh was designed was that call_usermodehelper_exec()
would just return early, without an error. But coredump assumes
certain variables are set up for us when this happens, and calls
ile_start_write(cprm.file) with a NULL file.

[    2.819676] BUG: kernel NULL pointer dereference, address: 0000000000000020
[    2.819859] #PF: supervisor read access in kernel mode
[    2.820035] #PF: error_code(0x0000) - not-present page
[    2.820188] PGD 0 P4D 0
[    2.820305] Oops: 0000 [#1] SMP PTI
[    2.820436] CPU: 2 PID: 89 Comm: a Not tainted 5.7.0-rc1+ #7
[    2.820680] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190711_202441-buildvm-armv7-10.arm.fedoraproject.org-2.fc31 04/01/2014
[    2.821150] RIP: 0010:do_coredump+0xd80/0x1060
[    2.821385] Code: e8 95 11 ed ff 48 c7 c6 cc a7 b4 81 48 8d bd 28 ff
ff ff 89 c2 e8 70 f1 ff ff 41 89 c2 85 c0 0f 84 72 f7 ff ff e9 b4 fe ff
ff <48> 8b 57 20 0f b7 02 66 25 00 f0 66 3d 00 8
0 0f 84 9c 01 00 00 44
[    2.822014] RSP: 0000:ffffc9000029bcb8 EFLAGS: 00010246
[    2.822339] RAX: 0000000000000000 RBX: ffff88803f860000 RCX: 000000000000000a
[    2.822746] RDX: 0000000000000009 RSI: 0000000000000282 RDI: 0000000000000000
[    2.823141] RBP: ffffc9000029bde8 R08: 0000000000000000 R09: ffffc9000029bc00
[    2.823508] R10: 0000000000000001 R11: ffff88803dec90be R12: ffffffff81c39da0
[    2.823902] R13: ffff88803de84400 R14: 0000000000000000 R15: 0000000000000000
[    2.824285] FS:  00007fee08183540(0000) GS:ffff88803e480000(0000) knlGS:0000000000000000
[    2.824767] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    2.825111] CR2: 0000000000000020 CR3: 000000003f856005 CR4: 0000000000060ea0
[    2.825479] Call Trace:
[    2.825790]  get_signal+0x11e/0x720
[    2.826087]  do_signal+0x1d/0x670
[    2.826361]  ? force_sig_info_to_task+0xc1/0xf0
[    2.826691]  ? force_sig_fault+0x3c/0x40
[    2.826996]  ? do_trap+0xc9/0x100
[    2.827179]  exit_to_usermode_loop+0x49/0x90
[    2.827359]  prepare_exit_to_usermode+0x77/0xb0
[    2.827559]  ? invalid_op+0xa/0x30
[    2.827747]  ret_from_intr+0x20/0x20
[    2.827921] RIP: 0033:0x55e2c76d2129
[    2.828107] Code: 2d ff ff ff e8 68 ff ff ff 5d c6 05 18 2f 00 00 01
c3 0f 1f 80 00 00 00 00 c3 0f 1f 80 00 00 00 00 e9 7b ff ff ff 55 48 89
e5 <0f> 0b b8 00 00 00 00 5d c3 66 2e 0f 1f 84 0
0 00 00 00 00 0f 1f 40
[    2.828603] RSP: 002b:00007fffeba5e080 EFLAGS: 00010246
[    2.828801] RAX: 000055e2c76d2125 RBX: 0000000000000000 RCX: 00007fee0817c718
[    2.829034] RDX: 00007fffeba5e188 RSI: 00007fffeba5e178 RDI: 0000000000000001
[    2.829257] RBP: 00007fffeba5e080 R08: 0000000000000000 R09: 00007fee08193c00
[    2.829482] R10: 0000000000000009 R11: 0000000000000000 R12: 000055e2c76d2040
[    2.829727] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[    2.829964] CR2: 0000000000000020
[    2.830149] ---[ end trace ceed83d8c68a1bf1 ]---
```

Cc: <stable@vger.kernel.org> # v4.11+
Fixes: 64e90a8acb85 ("Introduce STATIC_USERMODEHELPER to mediate call_usermodehelper()")
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=199795
Reported-by: Tony Vroon <chainsaw@gentoo.org>
Reported-by: Sergey Kvachonok <ravenexp@gmail.com>
Tested-by: Sergei Trofimovich <slyfox@gentoo.org>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Link: https://lore.kernel.org/r/20200416162859.26518-1-mcgrof@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/coredump.c |    8 ++++++++
 kernel/umh.c  |    5 +++++
 2 files changed, 13 insertions(+)

--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -788,6 +788,14 @@ void do_coredump(const kernel_siginfo_t
 	if (displaced)
 		put_files_struct(displaced);
 	if (!dump_interrupted()) {
+		/*
+		 * umh disabled with CONFIG_STATIC_USERMODEHELPER_PATH="" would
+		 * have this set to NULL.
+		 */
+		if (!cprm.file) {
+			pr_info("Core dump to |%s disabled\n", cn.corename);
+			goto close_fail;
+		}
 		file_start_write(cprm.file);
 		core_dumped = binfmt->core_dump(&cprm);
 		file_end_write(cprm.file);
--- a/kernel/umh.c
+++ b/kernel/umh.c
@@ -544,6 +544,11 @@ EXPORT_SYMBOL_GPL(fork_usermode_blob);
  * Runs a user-space application.  The application is started
  * asynchronously if wait is not set, and runs as a child of system workqueues.
  * (ie. it runs with full root capabilities and optimized affinity).
+ *
+ * Note: successful return value does not guarantee the helper was called at
+ * all. You can't rely on sub_info->{init,cleanup} being called even for
+ * UMH_WAIT_* wait modes as STATIC_USERMODEHELPER_PATH="" turns all helpers
+ * into a successful no-op.
  */
 int call_usermodehelper_exec(struct subprocess_info *sub_info, int wait)
 {


