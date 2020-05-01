Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B54721C1667
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731655AbgEANr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:47:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:44016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731593AbgEANnJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:43:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE8E6205C9;
        Fri,  1 May 2020 13:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340588;
        bh=5SvYodR3cdhJYE5o749RtLFXryDUlwu/cXQ3NXA/kzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yHeSmDumxx22v7YAqJP4GDiaoW1XpUnCQGfJzeF4e2Ssx8RZz+6nsYQZ+p8DV9jFJ
         Qwf8XcWQ7jMhgl5kzOvOvSh91sSXK4hYvzflHfxL990Uq6o1TH/sRb+bg9V6RM3MKE
         hfSzFASsHU2ZTkaLKX0DfaPr7sdHEU93lId8fLDA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+33e06702fd6cffc24c40@syzkaller.appspotmail.com>,
        Florian Westphal <fw@strlen.de>,
        Stefano Brivio <sbrivio@redhat.com>,
        Hillf Danton <hdanton@sina.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.6 055/106] netfilter: nat: fix error handling upon registering inet hook
Date:   Fri,  1 May 2020 15:23:28 +0200
Message-Id: <20200501131550.240002482@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hillf Danton <hdanton@sina.com>

commit b4faef1739dd1f3b3981b8bf173a2266ea86b1eb upstream.

A case of warning was reported by syzbot.

------------[ cut here ]------------
WARNING: CPU: 0 PID: 19934 at net/netfilter/nf_nat_core.c:1106
nf_nat_unregister_fn+0x532/0x5c0 net/netfilter/nf_nat_core.c:1106
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 19934 Comm: syz-executor.5 Not tainted 5.6.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 __warn.cold+0x2f/0x35 kernel/panic.c:582
 report_bug+0x27b/0x2f0 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:175 [inline]
 fixup_bug arch/x86/kernel/traps.c:170 [inline]
 do_error_trap+0x12b/0x220 arch/x86/kernel/traps.c:267
 do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:nf_nat_unregister_fn+0x532/0x5c0 net/netfilter/nf_nat_core.c:1106
Code: ff df 48 c1 ea 03 80 3c 02 00 75 75 48 8b 44 24 10 4c 89 ef 48 c7 00 00 00 00 00 e8 e8 f8 53 fb e9 4d fe ff ff e8 ee 9c 16 fb <0f> 0b e9 41 fe ff ff e8 e2 45 54 fb e9 b5 fd ff ff 48 8b 7c 24 20
RSP: 0018:ffffc90005487208 EFLAGS: 00010246
RAX: 0000000000040000 RBX: 0000000000000004 RCX: ffffc9001444a000
RDX: 0000000000040000 RSI: ffffffff865c94a2 RDI: 0000000000000005
RBP: ffff88808b5cf000 R08: ffff8880a2620140 R09: fffffbfff14bcd79
R10: ffffc90005487208 R11: fffffbfff14bcd78 R12: 0000000000000000
R13: 0000000000000001 R14: 0000000000000001 R15: 0000000000000000
 nf_nat_ipv6_unregister_fn net/netfilter/nf_nat_proto.c:1017 [inline]
 nf_nat_inet_register_fn net/netfilter/nf_nat_proto.c:1038 [inline]
 nf_nat_inet_register_fn+0xfc/0x140 net/netfilter/nf_nat_proto.c:1023
 nf_tables_register_hook net/netfilter/nf_tables_api.c:224 [inline]
 nf_tables_addchain.constprop.0+0x82e/0x13c0 net/netfilter/nf_tables_api.c:1981
 nf_tables_newchain+0xf68/0x16a0 net/netfilter/nf_tables_api.c:2235
 nfnetlink_rcv_batch+0x83a/0x1610 net/netfilter/nfnetlink.c:433
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:543 [inline]
 nfnetlink_rcv+0x3af/0x420 net/netfilter/nfnetlink.c:561
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6bf/0x7e0 net/socket.c:2362
 ___sys_sendmsg+0x100/0x170 net/socket.c:2416
 __sys_sendmsg+0xec/0x1b0 net/socket.c:2449
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3

and to quiesce it, unregister NFPROTO_IPV6 hook instead of NFPROTO_INET
in case of failing to register NFPROTO_IPV4 hook.

Reported-by: syzbot <syzbot+33e06702fd6cffc24c40@syzkaller.appspotmail.com>
Fixes: d164385ec572 ("netfilter: nat: add inet family nat support")
Cc: Florian Westphal <fw@strlen.de>
Cc: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Hillf Danton <hdanton@sina.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nf_nat_proto.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -1035,8 +1035,8 @@ int nf_nat_inet_register_fn(struct net *
 	ret = nf_nat_register_fn(net, NFPROTO_IPV4, ops, nf_nat_ipv4_ops,
 				 ARRAY_SIZE(nf_nat_ipv4_ops));
 	if (ret)
-		nf_nat_ipv6_unregister_fn(net, ops);
-
+		nf_nat_unregister_fn(net, NFPROTO_IPV6, ops,
+					ARRAY_SIZE(nf_nat_ipv6_ops));
 	return ret;
 }
 EXPORT_SYMBOL_GPL(nf_nat_inet_register_fn);


