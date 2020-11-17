Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69AAF2B6163
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730694AbgKQNSe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:18:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:48888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730492AbgKQNQu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:16:50 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B510D2225B;
        Tue, 17 Nov 2020 13:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619009;
        bh=Erzmw6T1KHPpYXvP6UTHaqQVh+xzUZeFxd3OXrj3tkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KQgkOeNTcVYTOhxVmczsN/HGW1fbt38tixSF0UTBVvuMkK8tPwDa5cfIIV3R6QSmP
         vv6pKOEsaWtthNtPCH/oZo4AchJqHlAyhgMrb0TAThFT4eqj0aW2ooFYfUtFzqE2sM
         1Xhyi2CaW4zbmICB5ZMmifU1WVofj0MGAfA0lbQo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matteo Croce <mcroce@microsoft.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabian Frederick <fabf@skynet.be>,
        Guenter Roeck <linux@roeck-us.net>,
        Kees Cook <keescook@chromium.org>,
        Mike Rapoport <rppt@kernel.org>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Petr Mladek <pmladek@suse.com>,
        Robin Holt <robinmholt@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.14 84/85] reboot: fix overflow parsing reboot cpu number
Date:   Tue, 17 Nov 2020 14:05:53 +0100
Message-Id: <20201117122115.170985258@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122111.018425544@linuxfoundation.org>
References: <20201117122111.018425544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

commit df5b0ab3e08a156701b537809914b339b0daa526 upstream.

Limit the CPU number to num_possible_cpus(), because setting it to a
value lower than INT_MAX but higher than NR_CPUS produces the following
error on reboot and shutdown:

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
      do_syscall_64+0x2d/0x40

Fixes: 1b3a5d02ee07 ("reboot: move arch/x86 reboot= handling to generic kernel")
Signed-off-by: Matteo Croce <mcroce@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Robin Holt <robinmholt@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20201103214025.116799-3-mcroce@linux.microsoft.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[sudip: use reboot_mode instead of mode]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/reboot.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -519,6 +519,13 @@ static int __init reboot_setup(char *str
 				reboot_cpu = simple_strtoul(str+3, NULL, 0);
 			else
 				reboot_mode = REBOOT_SOFT;
+			if (reboot_cpu >= num_possible_cpus()) {
+				pr_err("Ignoring the CPU number in reboot= option. "
+				       "CPU %d exceeds possible cpu number %d\n",
+				       reboot_cpu, num_possible_cpus());
+				reboot_cpu = 0;
+				break;
+			}
 			break;
 
 		case 'g':


