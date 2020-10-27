Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E46E929B60D
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1796567AbgJ0PTg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:19:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:57078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1796554AbgJ0PT1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:19:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2C4A20657;
        Tue, 27 Oct 2020 15:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811966;
        bh=jEW7s/7k33gfDgToggwyp/NaZie/j6ZoVy6IfV0C14w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pyruCwKbFY+fxp3DIqWym1l5O8TdgtQHp1oCWPBWb1bbMU1+Bov8s7IdDaYZddqGZ
         ZaCGb8rsK8D6tdRDJQ1q8oOuo48tUMPn3NzxkG+QCLMnV0aCyYVJozog5O+x4JFlGV
         VzbRKOM+Rz7lph2wxk4k3M2Bg20NAjaMUTSBv1Jk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 014/757] net: sched: Fix suspicious RCU usage while accessing tcf_tunnel_info
Date:   Tue, 27 Oct 2020 14:44:24 +0100
Message-Id: <20201027135451.198752003@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit d086a1c65aabb5a4e1edc580ca583e2964c62b44 ]

The access of tcf_tunnel_info() produces the following splat, so fix it
by dereferencing the tcf_tunnel_key_params pointer with marker that
internal tcfa_liock is held.

 =============================
 WARNING: suspicious RCU usage
 5.9.0+ #1 Not tainted
 -----------------------------
 include/net/tc_act/tc_tunnel_key.h:59 suspicious rcu_dereference_protected() usage!
 other info that might help us debug this:

 rcu_scheduler_active = 2, debug_locks = 1
 1 lock held by tc/34839:
  #0: ffff88828572c2a0 (&p->tcfa_lock){+...}-{2:2}, at: tc_setup_flow_action+0xb3/0x48b5
 stack backtrace:
 CPU: 1 PID: 34839 Comm: tc Not tainted 5.9.0+ #1
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
 Call Trace:
  dump_stack+0x9a/0xd0
  tc_setup_flow_action+0x14cb/0x48b5
  fl_hw_replace_filter+0x347/0x690 [cls_flower]
  fl_change+0x2bad/0x4875 [cls_flower]
  tc_new_tfilter+0xf6f/0x1ba0
  rtnetlink_rcv_msg+0x5f2/0x870
  netlink_rcv_skb+0x124/0x350
  netlink_unicast+0x433/0x700
  netlink_sendmsg+0x6f1/0xbd0
  sock_sendmsg+0xb0/0xe0
  ____sys_sendmsg+0x4fa/0x6d0
  ___sys_sendmsg+0x12e/0x1b0
  __sys_sendmsg+0xa4/0x120
  do_syscall_64+0x2d/0x40
  entry_SYSCALL_64_after_hwframe+0x44/0xa9
 RIP: 0033:0x7f1f8cd4fe57
 Code: 0c 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 89 54 24 1c 48 89 74 24 10
 RSP: 002b:00007ffdc1e193b8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
 RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f1f8cd4fe57
 RDX: 0000000000000000 RSI: 00007ffdc1e19420 RDI: 0000000000000003
 RBP: 000000005f85aafa R08: 0000000000000001 R09: 00007ffdc1e1936c
 R10: 000000000040522d R11: 0000000000000246 R12: 0000000000000001
 R13: 0000000000000000 R14: 00007ffdc1e1d6f0 R15: 0000000000482420

Fixes: 3ebaf6da0716 ("net: sched: Do not assume RTNL is held in tunnel key action helpers")
Fixes: 7a47281439ba ("net: sched: lock action when translating it to flow_action infra")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Acked-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/tc_act/tc_tunnel_key.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/include/net/tc_act/tc_tunnel_key.h
+++ b/include/net/tc_act/tc_tunnel_key.h
@@ -56,7 +56,10 @@ static inline struct ip_tunnel_info *tcf
 {
 #ifdef CONFIG_NET_CLS_ACT
 	struct tcf_tunnel_key *t = to_tunnel_key(a);
-	struct tcf_tunnel_key_params *params = rtnl_dereference(t->params);
+	struct tcf_tunnel_key_params *params;
+
+	params = rcu_dereference_protected(t->params,
+					   lockdep_is_held(&a->tcfa_lock));
 
 	return &params->tcft_enc_metadata->u.tun_info;
 #else


