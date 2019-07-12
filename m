Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B999666EAF
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727937AbfGLMZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:25:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:34882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728230AbfGLMZL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:25:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 222FF216C8;
        Fri, 12 Jul 2019 12:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934310;
        bh=IZFwTvEIcTvaCGjRdKSOG5Zo8cveP1HASfIMy1Kc0+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gsyDju9MkEeExMSEJCJ3dOnPb5Qjo5Qvyk/1HhpI7fP65y4T5hb4h9YQqnD2ZRzUO
         n0F0nM3k9FCjjix2rJ573PFnxxlOpgBQXPRq2SEv5lR1kSDoL6cPtfgXWbT/bPPGE3
         YPajAkLwkn8uGEzb+pPC+S5LxR2++8CuUdxE3NMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Sitnicki <jakub@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 014/138] bpf: sockmap, restore sk_write_space when psock gets dropped
Date:   Fri, 12 Jul 2019 14:17:58 +0200
Message-Id: <20190712121629.269744465@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
References: <20190712121628.731888964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 186bcc3dcd106dc52d706117f912054b616666e1 ]

Once psock gets unlinked from its sock (sk_psock_drop), user-space can
still trigger a call to sk->sk_write_space by setting TCP_NOTSENT_LOWAT
socket option. This causes a null-ptr-deref because we try to read
psock->saved_write_space from sk_psock_write_space:

==================================================================
BUG: KASAN: null-ptr-deref in sk_psock_write_space+0x69/0x80
Read of size 8 at addr 00000000000001a0 by task sockmap-echo/131

CPU: 0 PID: 131 Comm: sockmap-echo Not tainted 5.2.0-rc1-00094-gf49aa1de9836 #81
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
?-20180724_192412-buildhw-07.phx2.fedoraproject.org-1.fc29 04/01/2014
Call Trace:
 ? sk_psock_write_space+0x69/0x80
 __kasan_report.cold.2+0x5/0x3f
 ? sk_psock_write_space+0x69/0x80
 kasan_report+0xe/0x20
 sk_psock_write_space+0x69/0x80
 tcp_setsockopt+0x69a/0xfc0
 ? tcp_shutdown+0x70/0x70
 ? fsnotify+0x5b0/0x5f0
 ? remove_wait_queue+0x90/0x90
 ? __fget_light+0xa5/0xf0
 __sys_setsockopt+0xe6/0x180
 ? sockfd_lookup_light+0xb0/0xb0
 ? vfs_write+0x195/0x210
 ? ksys_write+0xc9/0x150
 ? __x64_sys_read+0x50/0x50
 ? __bpf_trace_x86_fpu+0x10/0x10
 __x64_sys_setsockopt+0x61/0x70
 do_syscall_64+0xc5/0x520
 ? vmacache_find+0xc0/0x110
 ? syscall_return_slowpath+0x110/0x110
 ? handle_mm_fault+0xb4/0x110
 ? entry_SYSCALL_64_after_hwframe+0x3e/0xbe
 ? trace_hardirqs_off_caller+0x4b/0x120
 ? trace_hardirqs_off_thunk+0x1a/0x3a
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x7f2e5e7cdcce
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb b1 66 2e 0f 1f 84 00 00 00 00 00
0f 1f 44 00 00 f3 0f 1e fa 49 89 ca b8 36 00 00 00 0f 05 <48> 3d 01 f0 ff
ff 73 01 c3 48 8b 0d 8a 11 0c 00 f7 d8 64 89 01 48
RSP: 002b:00007ffed011b778 EFLAGS: 00000206 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f2e5e7cdcce
RDX: 0000000000000019 RSI: 0000000000000006 RDI: 0000000000000007
RBP: 00007ffed011b790 R08: 0000000000000004 R09: 00007f2e5e84ee80
R10: 00007ffed011b788 R11: 0000000000000206 R12: 00007ffed011b78c
R13: 00007ffed011b788 R14: 0000000000000007 R15: 0000000000000068
==================================================================

Restore the saved sk_write_space callback when psock is being dropped to
fix the crash.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skmsg.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 178a3933a71b..50ced8aba9db 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -351,6 +351,8 @@ static inline void sk_psock_update_proto(struct sock *sk,
 static inline void sk_psock_restore_proto(struct sock *sk,
 					  struct sk_psock *psock)
 {
+	sk->sk_write_space = psock->saved_write_space;
+
 	if (psock->sk_proto) {
 		sk->sk_prot = psock->sk_proto;
 		psock->sk_proto = NULL;
-- 
2.20.1



