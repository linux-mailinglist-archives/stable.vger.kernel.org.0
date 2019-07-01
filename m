Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77ECB1EFAD
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733264AbfEOLdw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:33:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:45822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732737AbfEOLdw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:33:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEA65206BF;
        Wed, 15 May 2019 11:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557920031;
        bh=Fsna/64TZ5f41MRSB9y1QYQgLzTM+sOs5ADmu9gRS8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ynIO9k9zuL76r8zhJUrwrtCWNHmFZQSkCCUuWHUhP1EzGxEtqOaHF5XiCm6ZlPeFr
         zIaAih0hYHa0EY8LM7hZFJ5LeOK/0iFK5NCdjITezwTYkh+hpYRsaXAcQZXL/UZXdB
         Dy+TKq0lajyLSGyO+3KfhoP5gUybez3VV64ajUFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Petar Penkov <ppenkov@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 35/46] flow_dissector: disable preemption around BPF calls
Date:   Wed, 15 May 2019 12:56:59 +0200
Message-Id: <20190515090627.278573502@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090616.670410738@linuxfoundation.org>
References: <20190515090616.670410738@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit b1c17a9a353878602fd5bfe9103e4afe5e9a3f96 ]

Various things in eBPF really require us to disable preemption
before running an eBPF program.

syzbot reported :

BUG: assuming atomic context at net/core/flow_dissector.c:737
in_atomic(): 0, irqs_disabled(): 0, pid: 24710, name: syz-executor.3
2 locks held by syz-executor.3/24710:
 #0: 00000000e81a4bf1 (&tfile->napi_mutex){+.+.}, at: tun_get_user+0x168e/0x3ff0 drivers/net/tun.c:1850
 #1: 00000000254afebd (rcu_read_lock){....}, at: __skb_flow_dissect+0x1e1/0x4bb0 net/core/flow_dissector.c:822
CPU: 1 PID: 24710 Comm: syz-executor.3 Not tainted 5.1.0+ #6
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x172/0x1f0 lib/dump_stack.c:113
 __cant_sleep kernel/sched/core.c:6165 [inline]
 __cant_sleep.cold+0xa3/0xbb kernel/sched/core.c:6142
 bpf_flow_dissect+0xfe/0x390 net/core/flow_dissector.c:737
 __skb_flow_dissect+0x362/0x4bb0 net/core/flow_dissector.c:853
 skb_flow_dissect_flow_keys_basic include/linux/skbuff.h:1322 [inline]
 skb_probe_transport_header include/linux/skbuff.h:2500 [inline]
 skb_probe_transport_header include/linux/skbuff.h:2493 [inline]
 tun_get_user+0x2cfe/0x3ff0 drivers/net/tun.c:1940
 tun_chr_write_iter+0xbd/0x156 drivers/net/tun.c:2037
 call_write_iter include/linux/fs.h:1872 [inline]
 do_iter_readv_writev+0x5fd/0x900 fs/read_write.c:693
 do_iter_write fs/read_write.c:970 [inline]
 do_iter_write+0x184/0x610 fs/read_write.c:951
 vfs_writev+0x1b3/0x2f0 fs/read_write.c:1015
 do_writev+0x15b/0x330 fs/read_write.c:1058
 __do_sys_writev fs/read_write.c:1131 [inline]
 __se_sys_writev fs/read_write.c:1128 [inline]
 __x64_sys_writev+0x75/0xb0 fs/read_write.c:1128
 do_syscall_64+0x103/0x670 arch/x86/entry/common.c:298
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Fixes: d58e468b1112 ("flow_dissector: implements flow dissector BPF hook")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Petar Penkov <ppenkov@google.com>
Cc: Stanislav Fomichev <sdf@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/flow_dissector.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -712,7 +712,10 @@ bool __skb_flow_bpf_dissect(struct bpf_p
 	flow_keys->thoff = flow_keys->nhoff;
 
 	bpf_compute_data_pointers((struct sk_buff *)skb);
+
+	preempt_disable();
 	result = BPF_PROG_RUN(prog, skb);
+	preempt_enable();
 
 	/* Restore state */
 	memcpy(cb, &cb_saved, sizeof(cb_saved));


