Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 631B86BB186
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232555AbjCOM2R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232277AbjCOM2A (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:28:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C80720062
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:26:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1479061D49
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:26:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 287C0C433EF;
        Wed, 15 Mar 2023 12:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883216;
        bh=C7Swx3QKnzr2XYbi0Hg7ZgMMjRzj45Y5penNN59BpuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XwDk6qWhWFvqHagHnGXiBdDhUTYZl3V0ZJ/kNjrK8JWruwhSPZYw+YPXJNKuG+QdA
         KrtZ5barz1c9mU0c/oSrK+BSmR5npb/bfUGr4sRp8TJXOjmVgmtZrWD2Ms8eaRQf14
         rBjXvGdC+BmHPclBE78OWslgTS7CPUZHAkJGXG8c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Liu Jian <liujian56@huawei.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 059/145] bpf, sockmap: Fix an infinite loop error when len is 0 in tcp_bpf_recvmsg_parser()
Date:   Wed, 15 Mar 2023 13:12:05 +0100
Message-Id: <20230315115740.977878675@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Jian <liujian56@huawei.com>

[ Upstream commit d900f3d20cc3169ce42ec72acc850e662a4d4db2 ]

When the buffer length of the recvmsg system call is 0, we got the
flollowing soft lockup problem:

watchdog: BUG: soft lockup - CPU#3 stuck for 27s! [a.out:6149]
CPU: 3 PID: 6149 Comm: a.out Kdump: loaded Not tainted 6.2.0+ #30
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01/2014
RIP: 0010:remove_wait_queue+0xb/0xc0
Code: 5e 41 5f c3 cc cc cc cc 0f 1f 80 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 0f 1f 44 00 00 41 57 <41> 56 41 55 41 54 55 48 89 fd 53 48 89 f3 4c 8d 6b 18 4c 8d 73 20
RSP: 0018:ffff88811b5978b8 EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffff88811a7d3780 RCX: ffffffffb7a4d768
RDX: dffffc0000000000 RSI: ffff88811b597908 RDI: ffff888115408040
RBP: 1ffff110236b2f1b R08: 0000000000000000 R09: ffff88811a7d37e7
R10: ffffed10234fa6fc R11: 0000000000000001 R12: ffff88811179b800
R13: 0000000000000001 R14: ffff88811a7d38a8 R15: ffff88811a7d37e0
FS:  00007f6fb5398740(0000) GS:ffff888237180000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000000 CR3: 000000010b6ba002 CR4: 0000000000370ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 tcp_msg_wait_data+0x279/0x2f0
 tcp_bpf_recvmsg_parser+0x3c6/0x490
 inet_recvmsg+0x280/0x290
 sock_recvmsg+0xfc/0x120
 ____sys_recvmsg+0x160/0x3d0
 ___sys_recvmsg+0xf0/0x180
 __sys_recvmsg+0xea/0x1a0
 do_syscall_64+0x3f/0x90
 entry_SYSCALL_64_after_hwframe+0x72/0xdc

The logic in tcp_bpf_recvmsg_parser is as follows:

msg_bytes_ready:
	copied = sk_msg_recvmsg(sk, psock, msg, len, flags);
	if (!copied) {
		wait data;
		goto msg_bytes_ready;
	}

In this case, "copied" always is 0, the infinite loop occurs.

According to the Linux system call man page, 0 should be returned in this
case. Therefore, in tcp_bpf_recvmsg_parser(), if the length is 0, directly
return. Also modify several other functions with the same problem.

Fixes: 1f5be6b3b063 ("udp: Implement udp_bpf_recvmsg() for sockmap")
Fixes: 9825d866ce0d ("af_unix: Implement unix_dgram_bpf_recvmsg()")
Fixes: c5d2177a72a1 ("bpf, sockmap: Fix race in ingress receive verdict with redirect to self")
Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: Liu Jian <liujian56@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/20230303080946.1146638-1-liujian56@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_bpf.c  | 6 ++++++
 net/ipv4/udp_bpf.c  | 3 +++
 net/unix/unix_bpf.c | 3 +++
 3 files changed, 12 insertions(+)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 7f34c455651db..20ad554af3693 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -187,6 +187,9 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
 	if (unlikely(flags & MSG_ERRQUEUE))
 		return inet_recv_error(sk, msg, len, addr_len);
 
+	if (!len)
+		return 0;
+
 	psock = sk_psock_get(sk);
 	if (unlikely(!psock))
 		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
@@ -245,6 +248,9 @@ static int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (unlikely(flags & MSG_ERRQUEUE))
 		return inet_recv_error(sk, msg, len, addr_len);
 
+	if (!len)
+		return 0;
+
 	psock = sk_psock_get(sk);
 	if (unlikely(!psock))
 		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
diff --git a/net/ipv4/udp_bpf.c b/net/ipv4/udp_bpf.c
index bbe6569c9ad34..56e1047632f6b 100644
--- a/net/ipv4/udp_bpf.c
+++ b/net/ipv4/udp_bpf.c
@@ -69,6 +69,9 @@ static int udp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (unlikely(flags & MSG_ERRQUEUE))
 		return inet_recv_error(sk, msg, len, addr_len);
 
+	if (!len)
+		return 0;
+
 	psock = sk_psock_get(sk);
 	if (unlikely(!psock))
 		return sk_udp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
diff --git a/net/unix/unix_bpf.c b/net/unix/unix_bpf.c
index 452376c6f4194..5919d61d9874a 100644
--- a/net/unix/unix_bpf.c
+++ b/net/unix/unix_bpf.c
@@ -55,6 +55,9 @@ static int unix_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
 	struct sk_psock *psock;
 	int copied;
 
+	if (!len)
+		return 0;
+
 	psock = sk_psock_get(sk);
 	if (unlikely(!psock))
 		return __unix_recvmsg(sk, msg, len, flags);
-- 
2.39.2



