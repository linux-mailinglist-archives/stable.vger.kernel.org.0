Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7BC35BFBA
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238641AbhDLJGa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:06:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:54864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238337AbhDLJED (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:04:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE0956128E;
        Mon, 12 Apr 2021 09:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218090;
        bh=PdRofA4xbs04jCkKVLwbmMnho9haWm1MiYUZlij7kTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FMnCP+vcou4ELtP2OrTEohMpEonIIbxUsp621mkOW2yJ6kRfz6kuyXNn0dJyhRSN8
         6YXB49qt/XKF0HL0rMWdJYFislNGWK+0Go3pMFsWDN9YCiQhTFo5V+jim1JBXLvL5u
         kzMxcPK4kiGEWKLpzkdrCNNKo7yfaSzb8s+t2wgc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.11 068/210] net: sched: sch_teql: fix null-pointer dereference
Date:   Mon, 12 Apr 2021 10:39:33 +0200
Message-Id: <20210412084018.271275682@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

commit 1ffbc7ea91606e4abd10eb60de5367f1c86daf5e upstream.

Reproduce:

  modprobe sch_teql
  tc qdisc add dev teql0 root teql0

This leads to (for instance in Centos 7 VM) OOPS:

[  532.366633] BUG: unable to handle kernel NULL pointer dereference at 00000000000000a8
[  532.366733] IP: [<ffffffffc06124a8>] teql_destroy+0x18/0x100 [sch_teql]
[  532.366825] PGD 80000001376d5067 PUD 137e37067 PMD 0
[  532.366906] Oops: 0000 [#1] SMP
[  532.366987] Modules linked in: sch_teql ...
[  532.367945] CPU: 1 PID: 3026 Comm: tc Kdump: loaded Tainted: G               ------------ T 3.10.0-1062.7.1.el7.x86_64 #1
[  532.368041] Hardware name: Virtuozzo KVM, BIOS 1.11.0-2.vz7.2 04/01/2014
[  532.368125] task: ffff8b7d37d31070 ti: ffff8b7c9fdbc000 task.ti: ffff8b7c9fdbc000
[  532.368224] RIP: 0010:[<ffffffffc06124a8>]  [<ffffffffc06124a8>] teql_destroy+0x18/0x100 [sch_teql]
[  532.368320] RSP: 0018:ffff8b7c9fdbf8e0  EFLAGS: 00010286
[  532.368394] RAX: ffffffffc0612490 RBX: ffff8b7cb1565e00 RCX: ffff8b7d35ba2000
[  532.368476] RDX: ffff8b7d35ba2000 RSI: 0000000000000000 RDI: ffff8b7cb1565e00
[  532.368557] RBP: ffff8b7c9fdbf8f8 R08: ffff8b7d3fd1f140 R09: ffff8b7d3b001600
[  532.368638] R10: ffff8b7d3b001600 R11: ffffffff84c7d65b R12: 00000000ffffffd8
[  532.368719] R13: 0000000000008000 R14: ffff8b7d35ba2000 R15: ffff8b7c9fdbf9a8
[  532.368800] FS:  00007f6a4e872740(0000) GS:ffff8b7d3fd00000(0000) knlGS:0000000000000000
[  532.368885] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  532.368961] CR2: 00000000000000a8 CR3: 00000001396ee000 CR4: 00000000000206e0
[  532.369046] Call Trace:
[  532.369159]  [<ffffffff84c8192e>] qdisc_create+0x36e/0x450
[  532.369268]  [<ffffffff846a9b49>] ? ns_capable+0x29/0x50
[  532.369366]  [<ffffffff849afde2>] ? nla_parse+0x32/0x120
[  532.369442]  [<ffffffff84c81b4c>] tc_modify_qdisc+0x13c/0x610
[  532.371508]  [<ffffffff84c693e7>] rtnetlink_rcv_msg+0xa7/0x260
[  532.372668]  [<ffffffff84907b65>] ? sock_has_perm+0x75/0x90
[  532.373790]  [<ffffffff84c69340>] ? rtnl_newlink+0x890/0x890
[  532.374914]  [<ffffffff84c8da7b>] netlink_rcv_skb+0xab/0xc0
[  532.376055]  [<ffffffff84c63708>] rtnetlink_rcv+0x28/0x30
[  532.377204]  [<ffffffff84c8d400>] netlink_unicast+0x170/0x210
[  532.378333]  [<ffffffff84c8d7a8>] netlink_sendmsg+0x308/0x420
[  532.379465]  [<ffffffff84c2f3a6>] sock_sendmsg+0xb6/0xf0
[  532.380710]  [<ffffffffc034a56e>] ? __xfs_filemap_fault+0x8e/0x1d0 [xfs]
[  532.381868]  [<ffffffffc034a75c>] ? xfs_filemap_fault+0x2c/0x30 [xfs]
[  532.383037]  [<ffffffff847ec23a>] ? __do_fault.isra.61+0x8a/0x100
[  532.384144]  [<ffffffff84c30269>] ___sys_sendmsg+0x3e9/0x400
[  532.385268]  [<ffffffff847f3fad>] ? handle_mm_fault+0x39d/0x9b0
[  532.386387]  [<ffffffff84d88678>] ? __do_page_fault+0x238/0x500
[  532.387472]  [<ffffffff84c31921>] __sys_sendmsg+0x51/0x90
[  532.388560]  [<ffffffff84c31972>] SyS_sendmsg+0x12/0x20
[  532.389636]  [<ffffffff84d8dede>] system_call_fastpath+0x25/0x2a
[  532.390704]  [<ffffffff84d8de21>] ? system_call_after_swapgs+0xae/0x146
[  532.391753] Code: 00 00 00 00 00 00 5b 5d c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48 89 e5 41 55 41 54 53 48 8b b7 48 01 00 00 48 89 fb <48> 8b 8e a8 00 00 00 48 85 c9 74 43 48 89 ca eb 0f 0f 1f 80 00
[  532.394036] RIP  [<ffffffffc06124a8>] teql_destroy+0x18/0x100 [sch_teql]
[  532.395127]  RSP <ffff8b7c9fdbf8e0>
[  532.396179] CR2: 00000000000000a8

Null pointer dereference happens on master->slaves dereference in
teql_destroy() as master is null-pointer.

When qdisc_create() calls teql_qdisc_init() it imediately fails after
check "if (m->dev == dev)" because both devices are teql0, and it does
not set qdisc_priv(sch)->m leaving it zero on error path, then
qdisc_create() imediately calls teql_destroy() which does not expect
zero master pointer and we get OOPS.

Fixes: 87b60cfacf9f ("net_sched: fix error recovery at qdisc creation")
Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_teql.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/sched/sch_teql.c
+++ b/net/sched/sch_teql.c
@@ -134,6 +134,9 @@ teql_destroy(struct Qdisc *sch)
 	struct teql_sched_data *dat = qdisc_priv(sch);
 	struct teql_master *master = dat->m;
 
+	if (!master)
+		return;
+
 	prev = master->slaves;
 	if (prev) {
 		do {


