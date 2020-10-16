Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24C09290B1D
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 20:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390965AbgJPSJZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 14:09:25 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34647 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390932AbgJPSJZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 14:09:25 -0400
Received: by mail-wr1-f65.google.com with SMTP id i1so3986587wro.1;
        Fri, 16 Oct 2020 11:09:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Bk6kC03HiqZabgl2QWag2dtJ81+wm7Y8OH2ujhqXScQ=;
        b=dAlq+mOHoyzy3iFB29hXN3OQvQFWQhpch2kpB84upyA0pXNNpCummwhAe7OB1kn7MR
         taTxDhNNrmocxNGbARTvG8hNzfvuJZrXODJdeXBrS0cdiKqkOCXRZsWsyArjKALsf+1c
         5Qa1Un6H1yyoPLlN2Qsgq3wo9TA/zihmqsFuDO0IJSgNJUeiyhytn7DJCXgJXOuBuaGq
         QQfQas2rap2fSCGBJJ9qSrAcLv3PyzYYui8K/UGgOMJ2Snc7rwn+16kVpHX27ToMUPiA
         kG5vgJRQX26a4oHhuIZr6JzfC05qVv7DXzbVEzMaf1eiSUTG7Kd1PhhUvib09IxoHLaL
         cF2A==
X-Gm-Message-State: AOAM531AaeJA6ly9mzLjII0/yx4rvu6yS+g9k3NXTe30OMIcEGVoweS8
        QTjtLMbAagymtwRU0OL8sovzNx9h0iIcv5m3
X-Google-Smtp-Source: ABdhPJzwJgLXn4TXrMJN4BcSQ1iZty6qQr7LRrwLo6aGDAJqdK5y02RFIpLvXXH5JylrpgrW86PE2Q==
X-Received: by 2002:a5d:4ed2:: with SMTP id s18mr5327716wrv.36.1602871760876;
        Fri, 16 Oct 2020 11:09:20 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-2-36-134-112.cust.vodafonedsl.it. [2.36.134.112])
        by smtp.gmail.com with ESMTPSA id x1sm4369260wrl.41.2020.10.16.11.09.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 11:09:20 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     linux-kernel@vger.kernel.org
Cc:     Guenter Roeck <linux@roeck-us.net>, Petr Mladek <pmladek@suse.com>,
        Arnd Bergmann <arnd@arndb.de>, Mike Rapoport <rppt@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Robin Holt <robinmholt@gmail.com>,
        Fabian Frederick <fabf@skynet.be>, stable@vger.kernel.org
Subject: [PATCH 1/2] reboot: fix overflow parsing reboot cpu number
Date:   Fri, 16 Oct 2020 20:09:06 +0200
Message-Id: <20201016180907.171957-2-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201016180907.171957-1-mcroce@linux.microsoft.com>
References: <20201016180907.171957-1-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

Limit the CPU number to num_possible_cpus(), because setting it
to a value lower than INT_MAX but higher than NR_CPUS produces the
following error on reboot and shutdown:

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
Signed-off-by: Matteo Croce <mcroce@microsoft.com>
---
 kernel/reboot.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/reboot.c b/kernel/reboot.c
index e7b78d5ae1ab..c4e7965c39b9 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -558,11 +558,19 @@ static int __init reboot_setup(char *str)
 				rc = kstrtoint(str+1, 0, &reboot_cpu);
 				if (rc)
 					return rc;
+				if (reboot_cpu >= num_possible_cpus()) {
+					reboot_cpu = 0;
+					return -ERANGE;
+				}
 			} else if (str[1] == 'm' && str[2] == 'p' &&
 				   isdigit(*(str+3))) {
 				rc = kstrtoint(str+3, 0, &reboot_cpu);
 				if (rc)
 					return rc;
+				if (reboot_cpu >= num_possible_cpus()) {
+					reboot_cpu = 0;
+					return -ERANGE;
+				}
 			} else
 				*mode = REBOOT_SOFT;
 			break;
-- 
2.26.2

