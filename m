Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 556D61D8604
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732023AbgERSWX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:22:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:52980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730772AbgERRun (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:50:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C16F320674;
        Mon, 18 May 2020 17:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824242;
        bh=cQVQT3iUocej6eK0goFCTG8v0zVNtUi2E3q8neVuBng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FoKYT3ySgQ6DsEiixRdSUdgNvJeXDnNLOUusNh1CxEfuBqxCAcXHXYy3N+43IduNv
         xr5UgF6/WrXrdc3aAE3DnD9sPbObK9hqVcSTX3+kbpgLF2hAhrr51cbehHM+ymf5J2
         UVNkL6TmMPKEsEUri6sDj0vt0xe/BaH9SNlluanc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 14/80] tcp: fix error recovery in tcp_zerocopy_receive()
Date:   Mon, 18 May 2020 19:36:32 +0200
Message-Id: <20200518173453.263188710@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.097837707@linuxfoundation.org>
References: <20200518173450.097837707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit e776af608f692a7a647455106295fa34469e7475 ]

If user provides wrong virtual address in TCP_ZEROCOPY_RECEIVE
operation we want to return -EINVAL error.

But depending on zc->recv_skip_hint content, we might return
-EIO error if the socket has SOCK_DONE set.

Make sure to return -EINVAL in this case.

BUG: KMSAN: uninit-value in tcp_zerocopy_receive net/ipv4/tcp.c:1833 [inline]
BUG: KMSAN: uninit-value in do_tcp_getsockopt+0x4494/0x6320 net/ipv4/tcp.c:3685
CPU: 1 PID: 625 Comm: syz-executor.0 Not tainted 5.7.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1c9/0x220 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:121
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 tcp_zerocopy_receive net/ipv4/tcp.c:1833 [inline]
 do_tcp_getsockopt+0x4494/0x6320 net/ipv4/tcp.c:3685
 tcp_getsockopt+0xf8/0x1f0 net/ipv4/tcp.c:3728
 sock_common_getsockopt+0x13f/0x180 net/core/sock.c:3131
 __sys_getsockopt+0x533/0x7b0 net/socket.c:2177
 __do_sys_getsockopt net/socket.c:2192 [inline]
 __se_sys_getsockopt+0xe1/0x100 net/socket.c:2189
 __x64_sys_getsockopt+0x62/0x80 net/socket.c:2189
 do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:297
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45c829
Code: 0d b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f1deeb72c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000037
RAX: ffffffffffffffda RBX: 00000000004e01e0 RCX: 000000000045c829
RDX: 0000000000000023 RSI: 0000000000000006 RDI: 0000000000000009
RBP: 000000000078bf00 R08: 0000000020000200 R09: 0000000000000000
R10: 00000000200001c0 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000000001d8 R14: 00000000004d3038 R15: 00007f1deeb736d4

Local variable ----zc@do_tcp_getsockopt created at:
 do_tcp_getsockopt+0x1a74/0x6320 net/ipv4/tcp.c:3670
 do_tcp_getsockopt+0x1a74/0x6320 net/ipv4/tcp.c:3670

Fixes: 05255b823a61 ("tcp: add TCP_ZEROCOPY_RECEIVE support for zerocopy receive")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1774,10 +1774,11 @@ static int tcp_zerocopy_receive(struct s
 
 	down_read(&current->mm->mmap_sem);
 
-	ret = -EINVAL;
 	vma = find_vma(current->mm, address);
-	if (!vma || vma->vm_start > address || vma->vm_ops != &tcp_vm_ops)
-		goto out;
+	if (!vma || vma->vm_start > address || vma->vm_ops != &tcp_vm_ops) {
+		up_read(&current->mm->mmap_sem);
+		return -EINVAL;
+	}
 	zc->length = min_t(unsigned long, zc->length, vma->vm_end - address);
 
 	tp = tcp_sk(sk);


