Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67E0A28B695
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbgJLNfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:35:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:37134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729957AbgJLNei (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:34:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB84D208B8;
        Mon, 12 Oct 2020 13:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509677;
        bh=EGZ3U6t60tbulp34moqSIixJM/dTXPvwEQcAfdxFVzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lXwKMj5R5jGYogRbuTSUlqxorB+19BNNqRV0afTzpMX79SmNDGpUi85T19/zEv6mo
         Nd9qTZw+OWBGL8fECnd4XFnsGxYLzZgTVxGkfgc2vR1DAhCswtleBElUAG7vfUnt07
         QZ3ENSlNOTa94jfhqkXPIcbF69MUtcpHQasROHEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.9 37/54] sctp: fix sctp_auth_init_hmacs() error path
Date:   Mon, 12 Oct 2020 15:26:59 +0200
Message-Id: <20201012132631.304806495@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132629.585664421@linuxfoundation.org>
References: <20201012132629.585664421@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit d42ee76ecb6c49d499fc5eb32ca34468d95dbc3e upstream.

After freeing ep->auth_hmacs we have to clear the pointer
or risk use-after-free as reported by syzbot:

BUG: KASAN: use-after-free in sctp_auth_destroy_hmacs net/sctp/auth.c:509 [inline]
BUG: KASAN: use-after-free in sctp_auth_destroy_hmacs net/sctp/auth.c:501 [inline]
BUG: KASAN: use-after-free in sctp_auth_free+0x17e/0x1d0 net/sctp/auth.c:1070
Read of size 8 at addr ffff8880a8ff52c0 by task syz-executor941/6874

CPU: 0 PID: 6874 Comm: syz-executor941 Not tainted 5.9.0-rc8-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x497 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 sctp_auth_destroy_hmacs net/sctp/auth.c:509 [inline]
 sctp_auth_destroy_hmacs net/sctp/auth.c:501 [inline]
 sctp_auth_free+0x17e/0x1d0 net/sctp/auth.c:1070
 sctp_endpoint_destroy+0x95/0x240 net/sctp/endpointola.c:203
 sctp_endpoint_put net/sctp/endpointola.c:236 [inline]
 sctp_endpoint_free+0xd6/0x110 net/sctp/endpointola.c:183
 sctp_destroy_sock+0x9c/0x3c0 net/sctp/socket.c:4981
 sctp_v6_destroy_sock+0x11/0x20 net/sctp/socket.c:9415
 sk_common_release+0x64/0x390 net/core/sock.c:3254
 sctp_close+0x4ce/0x8b0 net/sctp/socket.c:1533
 inet_release+0x12e/0x280 net/ipv4/af_inet.c:431
 inet6_release+0x4c/0x70 net/ipv6/af_inet6.c:475
 __sock_release+0xcd/0x280 net/socket.c:596
 sock_close+0x18/0x20 net/socket.c:1277
 __fput+0x285/0x920 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:141
 exit_task_work include/linux/task_work.h:25 [inline]
 do_exit+0xb7d/0x29f0 kernel/exit.c:806
 do_group_exit+0x125/0x310 kernel/exit.c:903
 __do_sys_exit_group kernel/exit.c:914 [inline]
 __se_sys_exit_group kernel/exit.c:912 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:912
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x43f278
Code: Bad RIP value.
RSP: 002b:00007fffe0995c38 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 000000000043f278
RDX: 0000000000000000 RSI: 000000000000003c RDI: 0000000000000000
RBP: 00000000004bf068 R08: 00000000000000e7 R09: ffffffffffffffd0
R10: 0000000020000000 R11: 0000000000000246 R12: 0000000000000001
R13: 00000000006d1180 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 6874:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:461
 kmem_cache_alloc_trace+0x174/0x300 mm/slab.c:3554
 kmalloc include/linux/slab.h:554 [inline]
 kmalloc_array include/linux/slab.h:593 [inline]
 kcalloc include/linux/slab.h:605 [inline]
 sctp_auth_init_hmacs+0xdb/0x3b0 net/sctp/auth.c:464
 sctp_auth_init+0x8a/0x4a0 net/sctp/auth.c:1049
 sctp_setsockopt_auth_supported net/sctp/socket.c:4354 [inline]
 sctp_setsockopt+0x477e/0x97f0 net/sctp/socket.c:4631
 __sys_setsockopt+0x2db/0x610 net/socket.c:2132
 __do_sys_setsockopt net/socket.c:2143 [inline]
 __se_sys_setsockopt net/socket.c:2140 [inline]
 __x64_sys_setsockopt+0xba/0x150 net/socket.c:2140
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 6874:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:56
 kasan_set_free_info+0x1b/0x30 mm/kasan/generic.c:355
 __kasan_slab_free+0xd8/0x120 mm/kasan/common.c:422
 __cache_free mm/slab.c:3422 [inline]
 kfree+0x10e/0x2b0 mm/slab.c:3760
 sctp_auth_destroy_hmacs net/sctp/auth.c:511 [inline]
 sctp_auth_destroy_hmacs net/sctp/auth.c:501 [inline]
 sctp_auth_init_hmacs net/sctp/auth.c:496 [inline]
 sctp_auth_init_hmacs+0x2b7/0x3b0 net/sctp/auth.c:454
 sctp_auth_init+0x8a/0x4a0 net/sctp/auth.c:1049
 sctp_setsockopt_auth_supported net/sctp/socket.c:4354 [inline]
 sctp_setsockopt+0x477e/0x97f0 net/sctp/socket.c:4631
 __sys_setsockopt+0x2db/0x610 net/socket.c:2132
 __do_sys_setsockopt net/socket.c:2143 [inline]
 __se_sys_setsockopt net/socket.c:2140 [inline]
 __x64_sys_setsockopt+0xba/0x150 net/socket.c:2140
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 1f485649f529 ("[SCTP]: Implement SCTP-AUTH internals")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sctp/auth.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -494,6 +494,7 @@ int sctp_auth_init_hmacs(struct sctp_end
 out_err:
 	/* Clean up any successful allocations */
 	sctp_auth_destroy_hmacs(ep->auth_hmacs);
+	ep->auth_hmacs = NULL;
 	return -ENOMEM;
 }
 


