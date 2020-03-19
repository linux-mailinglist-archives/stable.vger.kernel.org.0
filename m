Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B590618B733
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728604AbgCSNRF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:17:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729421AbgCSNRE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:17:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D1E521835;
        Thu, 19 Mar 2020 13:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623823;
        bh=NtVO8LRWjvuQqw8jJnihBjciJWVRxF+cJQoyoevWB6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lUMMbr/iqvIQ+pVzU43OBtSPlkgw6MqcaTClSN5ZxzWvWr8BxipL7XRUqrq8CbDUG
         BWe1WsMTrugoPJWICaOE8uzbAPQpUVCoL4p0ie+it10i3e5x+CdjH07zfgF+a2vzT/
         SVG8ioDb7AtUk4i4NMv5ymnztB776OGUy+/7pz/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot+1938db17e275e85dc328@syzkaller.appspotmail.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 64/99] ipv6: restrict IPV6_ADDRFORM operation
Date:   Thu, 19 Mar 2020 14:03:42 +0100
Message-Id: <20200319124000.822089234@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123941.630731708@linuxfoundation.org>
References: <20200319123941.630731708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit b6f6118901d1e867ac9177bbff3b00b185bd4fdc upstream.

IPV6_ADDRFORM is able to transform IPv6 socket to IPv4 one.
While this operation sounds illogical, we have to support it.

One of the things it does for TCP socket is to switch sk->sk_prot
to tcp_prot.

We now have other layers playing with sk->sk_prot, so we should make
sure to not interfere with them.

This patch makes sure sk_prot is the default pointer for TCP IPv6 socket.

syzbot reported :
BUG: kernel NULL pointer dereference, address: 0000000000000000
PGD a0113067 P4D a0113067 PUD a8771067 PMD 0
Oops: 0010 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 10686 Comm: syz-executor.0 Not tainted 5.6.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:0x0
Code: Bad RIP value.
RSP: 0018:ffffc9000281fce0 EFLAGS: 00010246
RAX: 1ffffffff15f48ac RBX: ffffffff8afa4560 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8880a69a8f40
RBP: ffffc9000281fd10 R08: ffffffff86ed9b0c R09: ffffed1014d351f5
R10: ffffed1014d351f5 R11: 0000000000000000 R12: ffff8880920d3098
R13: 1ffff1101241a613 R14: ffff8880a69a8f40 R15: 0000000000000000
FS:  00007f2ae75db700(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 00000000a3b85000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 inet_release+0x165/0x1c0 net/ipv4/af_inet.c:427
 __sock_release net/socket.c:605 [inline]
 sock_close+0xe1/0x260 net/socket.c:1283
 __fput+0x2e4/0x740 fs/file_table.c:280
 ____fput+0x15/0x20 fs/file_table.c:313
 task_work_run+0x176/0x1b0 kernel/task_work.c:113
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_usermode_loop arch/x86/entry/common.c:164 [inline]
 prepare_exit_to_usermode+0x480/0x5b0 arch/x86/entry/common.c:195
 syscall_return_slowpath+0x113/0x4a0 arch/x86/entry/common.c:278
 do_syscall_64+0x11f/0x1c0 arch/x86/entry/common.c:304
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45c429
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f2ae75dac78 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: 0000000000000000 RBX: 00007f2ae75db6d4 RCX: 000000000045c429
RDX: 0000000000000001 RSI: 000000000000011a RDI: 0000000000000004
RBP: 000000000076bf20 R08: 0000000000000038 R09: 0000000000000000
R10: 0000000020000180 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000a9d R14: 00000000004ccfb4 R15: 000000000076bf2c
Modules linked in:
CR2: 0000000000000000
---[ end trace 82567b5207e87bae ]---
RIP: 0010:0x0
Code: Bad RIP value.
RSP: 0018:ffffc9000281fce0 EFLAGS: 00010246
RAX: 1ffffffff15f48ac RBX: ffffffff8afa4560 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8880a69a8f40
RBP: ffffc9000281fd10 R08: ffffffff86ed9b0c R09: ffffed1014d351f5
R10: ffffed1014d351f5 R11: 0000000000000000 R12: ffff8880920d3098
R13: 1ffff1101241a613 R14: ffff8880a69a8f40 R15: 0000000000000000
FS:  00007f2ae75db700(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 00000000a3b85000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot+1938db17e275e85dc328@syzkaller.appspotmail.com
Cc: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv6/ipv6_sockglue.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -185,9 +185,15 @@ static int do_ipv6_setsockopt(struct soc
 					retv = -EBUSY;
 					break;
 				}
-			} else if (sk->sk_protocol != IPPROTO_TCP)
+			} else if (sk->sk_protocol == IPPROTO_TCP) {
+				if (sk->sk_prot != &tcpv6_prot) {
+					retv = -EBUSY;
+					break;
+				}
+				break;
+			} else {
 				break;
-
+			}
 			if (sk->sk_state != TCP_ESTABLISHED) {
 				retv = -ENOTCONN;
 				break;


