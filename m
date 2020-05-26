Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84B041ACDB2
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 18:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389153AbgDPQ3N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 12:29:13 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:35520 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733145AbgDPQ3L (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Apr 2020 12:29:11 -0400
Received: by mail-pj1-f65.google.com with SMTP id ms17so578467pjb.0;
        Thu, 16 Apr 2020 09:29:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DDeQhmuGsl8P+DilsgHCEUTImjUmWGBw1IP6hd63Tjk=;
        b=Crv61j+wqF1+7jHShJqfAnBSaKoLv586kb+csDCIeCpIJnuFXcrCiiXob8iKKnAI1n
         JfxrokzsnVZ6NHK6vcm8ZrtLzoYXse3V160R3mtatfiAeAJ9a3krYKd4VoHnY1r9uitp
         3FXTsRmz7InZ8RIhInwgc0LSkkLM03vPsK5L6zoN2LPUG9LJgO7yHLv9sPVtZ/WJRYkh
         lAgeDmZw2V+rqjxrNgDuvTzDECt3FO8z9o/uoiBf0fC8OIKROQhxvAoWqLGJb1oFwQQd
         LobQ4FEyWGhRjGsUatdJzF4/N+/1f0ka/L8ffJFdmbeKDBsytGsTB22MBFpp+kcWA6IN
         YXsQ==
X-Gm-Message-State: AGi0PuYrS5FDvo3nww/EegfO25Q0XH0IFKkZOcEh2xBucigdl9Jo1cW0
        V94fV26MNxriXEWaktzIxuc=
X-Google-Smtp-Source: APiQypIE3NnhVIIWmHInD6C3QjxS21/kjvOOYBbRR6eRrmBzANsib0A8qE0C3s1Dbtoni/H9AWpWyg==
X-Received: by 2002:a17:90a:32ea:: with SMTP id l97mr6067769pjb.50.1587054547892;
        Thu, 16 Apr 2020 09:29:07 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id r16sm2590313pfl.176.2020.04.16.09.29.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 09:29:06 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 10AAF40277; Thu, 16 Apr 2020 16:29:06 +0000 (UTC)
From:   "Luis R. Rodriguez" <mcgrof@kernel.org>
To:     gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk
Cc:     slyfox@gentoo.org, ast@kernel.org, keescook@chromium.org,
        josh@joshtriplett.org, ravenexp@gmail.com, chainsaw@gentoo.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] coredump: fix crash when umh is disabled
Date:   Thu, 16 Apr 2020 16:28:59 +0000
Message-Id: <20200416162859.26518-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.23.0.rc1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luis Chamberlain <mcgrof@kernel.org>

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
Fixes: 64e90a8acb859 ("Introduce STATIC_USERMODEHELPER to mediate call_usermodehelper()")
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=199795
Reported-by: Tony Vroon <chainsaw@gentoo.org>
Reported-by: Sergey Kvachonok <ravenexp@gmail.com>
Tested-by: Sergei Trofimovich <slyfox@gentoo.org>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 fs/coredump.c | 8 ++++++++
 kernel/umh.c  | 5 +++++
 2 files changed, 13 insertions(+)

diff --git a/fs/coredump.c b/fs/coredump.c
index f8296a82d01d..c92074fb152d 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -786,6 +786,14 @@ void do_coredump(const kernel_siginfo_t *siginfo)
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
diff --git a/kernel/umh.c b/kernel/umh.c
index 7f255b5a8845..11bf5eea474c 100644
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
-- 
2.25.1

