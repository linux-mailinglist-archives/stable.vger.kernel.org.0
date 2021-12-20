Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34CA447AF34
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239375AbhLTPKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:10:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239699AbhLTPJY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:09:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB40C0619D9;
        Mon, 20 Dec 2021 06:54:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6CF5B80EE3;
        Mon, 20 Dec 2021 14:54:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED347C36AE8;
        Mon, 20 Dec 2021 14:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012089;
        bh=Zy8qrhFdtK+Ed6bke3gLyQTai4ioJFb/OW4UjBJnNCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y6A7ekRxJ6eokEauKgYFGpMt48bV+UK+Ahn5w1p+b3ohH8VMsw06EaHsgWf09jH/A
         QYkXYUyb7vY/AcQyuJaaBw72wpLUFtpOgYyQd33nlTcG1qH8I9KJ96SMh2UA2obEO1
         BDjt+QIed/plG6y/LFdshvrVXTPaEzOKcXkGgWGs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+e4d843bb96a9431e6331@syzkaller.appspotmail.com
Subject: [PATCH 5.15 077/177] mptcp: never allow the PM to close a listener subflow
Date:   Mon, 20 Dec 2021 15:33:47 +0100
Message-Id: <20211220143042.700050320@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit b0cdc5dbcf2ba0d99785da5aabf1b17943805b8a ]

Currently, when deleting an endpoint the netlink PM treverses
all the local MPTCP sockets, regardless of their status.

If an MPTCP listener socket is bound to the IP matching the
delete endpoint, the listener TCP socket will be closed.
That is unexpected, the PM should only affect data subflows.

Additionally, syzbot was able to trigger a NULL ptr dereference
due to the above:

general protection fault, probably for non-canonical address 0xdffffc0000000003: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
CPU: 1 PID: 6550 Comm: syz-executor122 Not tainted 5.16.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__lock_acquire+0xd7d/0x54a0 kernel/locking/lockdep.c:4897
Code: 0f 0e 41 be 01 00 00 00 0f 86 c8 00 00 00 89 05 69 cc 0f 0e e9 bd 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 da 48 c1 ea 03 <80> 3c 02 00 0f 85 f3 2f 00 00 48 81 3b 20 75 17 8f 0f 84 52 f3 ff
RSP: 0018:ffffc90001f2f818 EFLAGS: 00010016
RAX: dffffc0000000000 RBX: 0000000000000018 RCX: 0000000000000000
RDX: 0000000000000003 RSI: 0000000000000000 RDI: 0000000000000001
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000000 R11: 000000000000000a R12: 0000000000000000
R13: ffff88801b98d700 R14: 0000000000000000 R15: 0000000000000001
FS:  00007f177cd3d700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f177cd1b268 CR3: 000000001dd55000 CR4: 0000000000350ee0
Call Trace:
 <TASK>
 lock_acquire kernel/locking/lockdep.c:5637 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5602
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:162
 finish_wait+0xc0/0x270 kernel/sched/wait.c:400
 inet_csk_wait_for_connect net/ipv4/inet_connection_sock.c:464 [inline]
 inet_csk_accept+0x7de/0x9d0 net/ipv4/inet_connection_sock.c:497
 mptcp_accept+0xe5/0x500 net/mptcp/protocol.c:2865
 inet_accept+0xe4/0x7b0 net/ipv4/af_inet.c:739
 mptcp_stream_accept+0x2e7/0x10e0 net/mptcp/protocol.c:3345
 do_accept+0x382/0x510 net/socket.c:1773
 __sys_accept4_file+0x7e/0xe0 net/socket.c:1816
 __sys_accept4+0xb0/0x100 net/socket.c:1846
 __do_sys_accept net/socket.c:1864 [inline]
 __se_sys_accept net/socket.c:1861 [inline]
 __x64_sys_accept+0x71/0xb0 net/socket.c:1861
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f177cd8b8e9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 b1 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f177cd3d308 EFLAGS: 00000246 ORIG_RAX: 000000000000002b
RAX: ffffffffffffffda RBX: 00007f177ce13408 RCX: 00007f177cd8b8e9
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 00007f177ce13400 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f177ce1340c
R13: 00007f177cde1004 R14: 6d705f706374706d R15: 0000000000022000
 </TASK>

Fix the issue explicitly skipping MPTCP socket in TCP_LISTEN
status.

Reported-and-tested-by: syzbot+e4d843bb96a9431e6331@syzkaller.appspotmail.com
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Fixes: 740d798e8767 ("mptcp: remove id 0 address")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Link: https://lore.kernel.org/r/ebc7594cdd420d241fb2172ddb8542ba64717657.1639238695.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm_netlink.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 050eea231528b..b79251a36dcbc 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -700,6 +700,9 @@ static void mptcp_pm_nl_rm_addr_or_subflow(struct mptcp_sock *msk,
 
 	msk_owned_by_me(msk);
 
+	if (sk->sk_state == TCP_LISTEN)
+		return;
+
 	if (!rm_list->nr)
 		return;
 
-- 
2.33.0



