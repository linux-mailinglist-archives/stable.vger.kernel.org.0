Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA5B88DAA
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbfHJUr5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:47:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55000 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726829AbfHJUoD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:44:03 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDY-00058M-Ej; Sat, 10 Aug 2019 21:44:00 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDN-0003i3-GF; Sat, 10 Aug 2019 21:43:49 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Guillaume Nault" <g.nault@alphalink.fr>,
        "syzbot" <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.500325280@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 117/157] l2ip: fix possible use-after-free
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit a622b40035d16196bf19b2b33b854862595245fc upstream.

Before taking a refcount on a rcu protected structure,
we need to make sure the refcount is not zero.

syzbot reported :

refcount_t: increment on 0; use-after-free.
WARNING: CPU: 1 PID: 23533 at lib/refcount.c:156 refcount_inc_checked lib/refcount.c:156 [inline]
WARNING: CPU: 1 PID: 23533 at lib/refcount.c:156 refcount_inc_checked+0x61/0x70 lib/refcount.c:154
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 23533 Comm: syz-executor.2 Not tainted 5.1.0-rc7+ #93
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x172/0x1f0 lib/dump_stack.c:113
 panic+0x2cb/0x65c kernel/panic.c:214
 __warn.cold+0x20/0x45 kernel/panic.c:571
 report_bug+0x263/0x2b0 lib/bug.c:186
 fixup_bug arch/x86/kernel/traps.c:179 [inline]
 fixup_bug arch/x86/kernel/traps.c:174 [inline]
 do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:272
 do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:291
 invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:973
RIP: 0010:refcount_inc_checked lib/refcount.c:156 [inline]
RIP: 0010:refcount_inc_checked+0x61/0x70 lib/refcount.c:154
Code: 1d 98 2b 2a 06 31 ff 89 de e8 db 2c 40 fe 84 db 75 dd e8 92 2b 40 fe 48 c7 c7 20 7a a1 87 c6 05 78 2b 2a 06 01 e8 7d d9 12 fe <0f> 0b eb c1 90 90 90 90 90 90 90 90 90 90 90 55 48 89 e5 41 57 41
RSP: 0018:ffff888069f0fba8 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 000000000000f353 RSI: ffffffff815afcb6 RDI: ffffed100d3e1f67
RBP: ffff888069f0fbb8 R08: ffff88809b1845c0 R09: ffffed1015d23ef1
R10: ffffed1015d23ef0 R11: ffff8880ae91f787 R12: ffff8880a8f26968
R13: 0000000000000004 R14: dffffc0000000000 R15: ffff8880a49a6440
 l2tp_tunnel_inc_refcount net/l2tp/l2tp_core.h:240 [inline]
 l2tp_tunnel_get+0x250/0x580 net/l2tp/l2tp_core.c:173
 pppol2tp_connect+0xc00/0x1c70 net/l2tp/l2tp_ppp.c:702
 __sys_connect+0x266/0x330 net/socket.c:1808
 __do_sys_connect net/socket.c:1819 [inline]
 __se_sys_connect net/socket.c:1816 [inline]
 __x64_sys_connect+0x73/0xb0 net/socket.c:1816

Fixes: 54652eb12c1b ("l2tp: hold tunnel while looking up sessions in l2tp_netlink")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.16: use atomic not refcount API]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/l2tp/l2tp_core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -217,8 +217,8 @@ struct l2tp_tunnel *l2tp_tunnel_get(cons
 
 	rcu_read_lock_bh();
 	list_for_each_entry_rcu(tunnel, &pn->l2tp_tunnel_list, list) {
-		if (tunnel->tunnel_id == tunnel_id) {
-			l2tp_tunnel_inc_refcount(tunnel);
+		if (tunnel->tunnel_id == tunnel_id &&
+		    atomic_inc_not_zero(&tunnel->ref_count)) {
 			rcu_read_unlock_bh();
 
 			return tunnel;
@@ -238,8 +238,8 @@ struct l2tp_tunnel *l2tp_tunnel_get_nth(
 
 	rcu_read_lock_bh();
 	list_for_each_entry_rcu(tunnel, &pn->l2tp_tunnel_list, list) {
-		if (++count > nth) {
-			l2tp_tunnel_inc_refcount(tunnel);
+		if (++count > nth &&
+		    atomic_inc_not_zero(&tunnel->ref_count)) {
 			rcu_read_unlock_bh();
 			return tunnel;
 		}

