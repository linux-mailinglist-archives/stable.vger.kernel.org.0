Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5198E28E863
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 23:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbgJNV1z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 17:27:55 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38742 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726484AbgJNV1z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Oct 2020 17:27:55 -0400
Received: by mail-wr1-f66.google.com with SMTP id n18so711664wrs.5;
        Wed, 14 Oct 2020 14:27:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B1E7gywNvQcqAwZZyXiQ7hBi3wsqy6S4QLYyQ5HVYO0=;
        b=Z7eBVqsKt67zq7T+7jprw59DcZPX7rf0q9lfrqBxseN4ccJG6oBnT14WdWBgRBODvz
         tsh6eY0+p5cjgl5J8PxZMoX2dDRueSuVIcYo5y4w5mA4wb6jYbHtr9ah6nvllohPxYMQ
         5NlIpYFXokFFrmgOsTJMwbliXgMRvR46P4B2/kKW46H3vP4q7HzziudB+leqN1VwLfVd
         wRUrmsx0qI0p8ABqAETXJKJkAFVIFqPk7/EM+wBLB4OyI35jfR/MqOikau0Tlr2ITq3z
         3t1sd46AtLRuI4aSq+KGiS3xCGlF+NvJjSaoxQw+FZvhzZR5MzS/1e8Bsa7gRHjfkRmE
         mBlg==
X-Gm-Message-State: AOAM532isdIlIEdquXL+K0lldn5D+tlBww0445Jmqw820xzb2Ly7k0hH
        TNd+FkrA/kInkKhV+GX0U50CmJmsHHgqvwWk
X-Google-Smtp-Source: ABdhPJwxi5GV+g9Es1whO/71hFaW33Jn7EWfyaG/LYrJiuLwuRtRCipgdMefzBKEYhcNnlMdzfF5nA==
X-Received: by 2002:a5d:65d2:: with SMTP id e18mr733622wrw.252.1602710870020;
        Wed, 14 Oct 2020 14:27:50 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-2-36-134-112.cust.vodafonedsl.it. [2.36.134.112])
        by smtp.gmail.com with ESMTPSA id m14sm912209wro.43.2020.10.14.14.27.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 14:27:49 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     linux-kernel@vger.kernel.org
Cc:     Guenter Roeck <linux@roeck-us.net>, Petr Mladek <pmladek@suse.com>,
        Arnd Bergmann <arnd@arndb.de>, Mike Rapoport <rppt@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Robin Holt <robinmholt@gmail.com>,
        Fabian Frederick <fabf@skynet.be>, stable@vger.kernel.org
Subject: [PATCH] reboot: fix parsing of reboot cpu number
Date:   Wed, 14 Oct 2020 23:27:46 +0200
Message-Id: <20201014212746.161363-1-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

The kernel cmdline reboot= argument allows to specify the CPU used
for rebooting, with the syntax `s####` among the other flags, e.g.

  reboot=soft,s4
  reboot=warm,s31,force

In the early days the parsing was done with simple_strtoul(), later
deprecated in favor of the safer kstrtoint() which handles overflow.

But kstrtoint() returns -EINVAL if there are non-digit characters
in a string, so if this flag is not the last given, it's silently
ignored as well as the subsequent ones.

To fix it, use _parse_integer() which still handles overflow, but
restores the old behaviour of parsing until a non-digit character
is found.

While at it, limit the CPU number to num_possible_cpus(),
because setting it to a value lower than INT_MAX but higher
than NR_CPUS produces the following error on reboot and shutdown:

    BUG: unable to handle page fault for address: ffffffff90ab1bb0
    #PF: supervisor read access in kernel mode
    #PF: error_code(0x0000) - not-present page
    PGD 1c09067 P4D 1c09067 PUD 1c0a063 PMD 0
    Oops: 0000 [#1] SMP
    CPU: 1 PID: 1 Comm: systemd-shutdow Not tainted 5.9.0-rc8-kvm #110
    Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-2.fc32 04/01/2014
    RIP: 0010:migrate_to_reboot_cpu+0xe/0x60
    Code: ea ea 00 48 89 fa 48 c7 c7 30 57 f1 81 e9 fa ef ff ff 66 2e 0f 1f 84 00 00 00 00 00 53 8b 1d d5 ea ea 00 e8 14 33 fe ff 89 da <48> 0f a3 15 ea fc bd 00 48 89 d0 73 29 89 c2 c1 e8 06 65 48 8b 3c
    RSP: 0018:ffffc90000013e08 EFLAGS: 00010246
    RAX: ffff88801f0a0000 RBX: 0000000077359400 RCX: 0000000000000000
    RDX: 0000000077359400 RSI: 0000000000000002 RDI: ffffffff81c199e0
    RBP: ffffffff81c1e3c0 R08: ffff88801f41f000 R09: ffffffff81c1e348
    R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
    R13: 00007f32bedf8830 R14: 00000000fee1dead R15: 0000000000000000
    FS:  00007f32bedf8980(0000) GS:ffff88801f480000(0000) knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: ffffffff90ab1bb0 CR3: 000000001d057000 CR4: 00000000000006a0
    DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
    DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
    Call Trace:
    __do_sys_reboot.cold+0x34/0x5b
    ? vfs_writev+0x92/0xc0
    ? do_writev+0x52/0xd0
    do_syscall_64+0x2d/0x40
    entry_SYSCALL_64_after_hwframe+0x44/0xa9
    RIP: 0033:0x7f32bfaaecd3
    Code: 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 89 fa be 69 19 12 28 bf ad de e1 fe b8 a9 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 05 c3 0f 1f 40 00 48 8b 15 89 81 0c 00 f7 d8
    RSP: 002b:00007fff6265fb58 EFLAGS: 00000202 ORIG_RAX: 00000000000000a9
    RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f32bfaaecd3
    RDX: 0000000001234567 RSI: 0000000028121969 RDI: 00000000fee1dead
    RBP: 0000000000000000 R08: 0000000000008020 R09: 00007fff6265ef60
    R10: 00007f32bedf8830 R11: 0000000000000202 R12: 0000000000000000
    R13: 0000557bba2c51c0 R14: 0000000000000000 R15: 00007fff6265fbc8
    CR2: ffffffff90ab1bb0
    ---[ end trace b813e80157136563 ]---
    RIP: 0010:migrate_to_reboot_cpu+0xe/0x60
    Code: ea ea 00 48 89 fa 48 c7 c7 30 57 f1 81 e9 fa ef ff ff 66 2e 0f 1f 84 00 00 00 00 00 53 8b 1d d5 ea ea 00 e8 14 33 fe ff 89 da <48> 0f a3 15 ea fc bd 00 48 89 d0 73 29 89 c2 c1 e8 06 65 48 8b 3c
    RSP: 0018:ffffc90000013e08 EFLAGS: 00010246
    RAX: ffff88801f0a0000 RBX: 0000000077359400 RCX: 0000000000000000
    RDX: 0000000077359400 RSI: 0000000000000002 RDI: ffffffff81c199e0
    RBP: ffffffff81c1e3c0 R08: ffff88801f41f000 R09: ffffffff81c1e348
    R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
    R13: 00007f32bedf8830 R14: 00000000fee1dead R15: 0000000000000000
    FS:  00007f32bedf8980(0000) GS:ffff88801f480000(0000) knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: ffffffff90ab1bb0 CR3: 000000001d057000 CR4: 00000000000006a0
    DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
    DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
    Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
    Kernel Offset: disabled
    ---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009 ]---

Fixes: 1b3a5d02ee07 ("reboot: move arch/x86 reboot= handling to generic kernel")
Fixes: 616feab75397 ("kernel/reboot.c: convert simple_strtoul to kstrtoint")
Signed-off-by: Matteo Croce <mcroce@microsoft.com>
---
 kernel/reboot.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/kernel/reboot.c b/kernel/reboot.c
index e7b78d5ae1ab..79e5d4522d0e 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -18,6 +18,8 @@
 #include <linux/syscore_ops.h>
 #include <linux/uaccess.h>
 
+#include "../lib/kstrtox.h"
+
 /*
  * this indicates whether you can reboot with ctrl-alt-del: the default is yes
  */
@@ -552,19 +554,23 @@ static int __init reboot_setup(char *str)
 
 		case 's':
 		{
-			int rc;
-
-			if (isdigit(*(str+1))) {
-				rc = kstrtoint(str+1, 0, &reboot_cpu);
-				if (rc)
-					return rc;
-			} else if (str[1] == 'm' && str[2] == 'p' &&
-				   isdigit(*(str+3))) {
-				rc = kstrtoint(str+3, 0, &reboot_cpu);
-				if (rc)
-					return rc;
-			} else
+			unsigned long long number;
+			unsigned int rc;
+
+			/*
+			 * reboot_cpu is s[mp]#### with #### being the processor
+			 * to be used for rebooting. Skip 's' or 'smp' prefix.
+			 */
+			str += str[1] == 'm' && str[2] == 'p' ? 3 : 1;
+
+			if (isdigit(str[0])) {
+				rc = _parse_integer(str, 10, &number);
+				if (rc & KSTRTOX_OVERFLOW || number > num_possible_cpus())
+					return -ERANGE;
+				reboot_cpu = number;
+			} else {
 				*mode = REBOOT_SOFT;
+			}
 			break;
 		}
 		case 'g':
-- 
2.26.2

