Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 702DA6E648C
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbjDRMuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232132AbjDRMuL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:50:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14CC716DE5
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:50:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3E31633F4
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2E7C4339B;
        Tue, 18 Apr 2023 12:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822209;
        bh=izZKBrFPUX9A1vIZgGaZ0mPYuSsmWRCnnERQMNubdzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e5zf9GyWEskEm/E3sqbwNJcivfmcV1+QKqDQTyhhA3EEOaNaX4+t0x4cV9lAugNeu
         avC/QcGnvoWMAdHgJlMk8wto/rcykzq/59vxv2u/hdXulN69phBNh+QSbckN+k44P1
         eGJklUeh0oIFusn909kXu65o6+ykZbEaf2W5uomU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+7e1e1bdb852961150198@syzkaller.appspotmail.com,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 063/139] smc: Fix use-after-free in tcp_write_timer_handler().
Date:   Tue, 18 Apr 2023 14:22:08 +0200
Message-Id: <20230418120316.163050105@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 9744d2bf19762703704ecba885b7ac282c02eacf ]

With Eric's ref tracker, syzbot finally found a repro for
use-after-free in tcp_write_timer_handler() by kernel TCP
sockets. [0]

If SMC creates a kernel socket in __smc_create(), the kernel
socket is supposed to be freed in smc_clcsock_release() by
calling sock_release() when we close() the parent SMC socket.

However, at the end of smc_clcsock_release(), the kernel
socket's sk_state might not be TCP_CLOSE.  This means that
we have not called inet_csk_destroy_sock() in __tcp_close()
and have not stopped the TCP timers.

The kernel socket's TCP timers can be fired later, so we
need to hold a refcnt for net as we do for MPTCP subflows
in mptcp_subflow_create_socket().

[0]:
leaked reference.
 sk_alloc (./include/net/net_namespace.h:335 net/core/sock.c:2108)
 inet_create (net/ipv4/af_inet.c:319 net/ipv4/af_inet.c:244)
 __sock_create (net/socket.c:1546)
 smc_create (net/smc/af_smc.c:3269 net/smc/af_smc.c:3284)
 __sock_create (net/socket.c:1546)
 __sys_socket (net/socket.c:1634 net/socket.c:1618 net/socket.c:1661)
 __x64_sys_socket (net/socket.c:1672)
 do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
 entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:120)
==================================================================
BUG: KASAN: slab-use-after-free in tcp_write_timer_handler (net/ipv4/tcp_timer.c:378 net/ipv4/tcp_timer.c:624 net/ipv4/tcp_timer.c:594)
Read of size 1 at addr ffff888052b65e0d by task syzrepro/18091

CPU: 0 PID: 18091 Comm: syzrepro Tainted: G        W          6.3.0-rc4-01174-gb5d54eb5899a #7
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.0-1.amzn2022.0.1 04/01/2014
Call Trace:
 <IRQ>
 dump_stack_lvl (lib/dump_stack.c:107)
 print_report (mm/kasan/report.c:320 mm/kasan/report.c:430)
 kasan_report (mm/kasan/report.c:538)
 tcp_write_timer_handler (net/ipv4/tcp_timer.c:378 net/ipv4/tcp_timer.c:624 net/ipv4/tcp_timer.c:594)
 tcp_write_timer (./include/linux/spinlock.h:390 net/ipv4/tcp_timer.c:643)
 call_timer_fn (./arch/x86/include/asm/jump_label.h:27 ./include/linux/jump_label.h:207 ./include/trace/events/timer.h:127 kernel/time/timer.c:1701)
 __run_timers.part.0 (kernel/time/timer.c:1752 kernel/time/timer.c:2022)
 run_timer_softirq (kernel/time/timer.c:2037)
 __do_softirq (./arch/x86/include/asm/jump_label.h:27 ./include/linux/jump_label.h:207 ./include/trace/events/irq.h:142 kernel/softirq.c:572)
 __irq_exit_rcu (kernel/softirq.c:445 kernel/softirq.c:650)
 irq_exit_rcu (kernel/softirq.c:664)
 sysvec_apic_timer_interrupt (arch/x86/kernel/apic/apic.c:1107 (discriminator 14))
 </IRQ>

Fixes: ac7138746e14 ("smc: establish new socket family")
Reported-by: syzbot+7e1e1bdb852961150198@syzkaller.appspotmail.com
Link: https://lore.kernel.org/netdev/000000000000a3f51805f8bcc43a@google.com/
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index e8018b0fb7676..bdeaee727538d 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -3257,6 +3257,17 @@ static int __smc_create(struct net *net, struct socket *sock, int protocol,
 			sk_common_release(sk);
 			goto out;
 		}
+
+		/* smc_clcsock_release() does not wait smc->clcsock->sk's
+		 * destruction;  its sk_state might not be TCP_CLOSE after
+		 * smc->sk is close()d, and TCP timers can be fired later,
+		 * which need net ref.
+		 */
+		sk = smc->clcsock->sk;
+		__netns_tracker_free(net, &sk->ns_tracker, false);
+		sk->sk_net_refcnt = 1;
+		get_net_track(net, &sk->ns_tracker, GFP_KERNEL);
+		sock_inuse_add(net, 1);
 	} else {
 		smc->clcsock = clcsock;
 	}
-- 
2.39.2



