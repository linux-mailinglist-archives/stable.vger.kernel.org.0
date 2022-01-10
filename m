Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64CFB4890D6
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239396AbiAJH0P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:26:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56136 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239391AbiAJHZL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:25:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7D01B81204;
        Mon, 10 Jan 2022 07:25:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09CB9C36AE9;
        Mon, 10 Jan 2022 07:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799509;
        bh=DUyS+NzlEZMm7B3cX2hiwqjQtRwoqEXRYU0AEb0tmc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B4rdM3bhioXiAt+ybwSeOZBGBoaI/u71TxvID9dITLO4E0r1qD2QQxn5qoOgF8Nu5
         +yQR4J0gd/qj+QdmF0G5ASzdLxADXdVwdIueqX3/R7O/ricz57UA6p3yuNvR9AV/L1
         XoCjgmO8wD5ctFDIQgEL26IOEv0gJrHfpo3I3crM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, William Zhao <wizhao@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 18/21] ip6_vti: initialize __ip6_tnl_parm struct in vti6_siocdevprivate
Date:   Mon, 10 Jan 2022 08:23:05 +0100
Message-Id: <20220110071813.420061235@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071812.806606886@linuxfoundation.org>
References: <20220110071812.806606886@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: William Zhao <wizhao@redhat.com>

[ Upstream commit c1833c3964d5bd8c163bd4e01736a38bc473cb8a ]

The "__ip6_tnl_parm" struct was left uninitialized causing an invalid
load of random data when the "__ip6_tnl_parm" struct was used elsewhere.
As an example, in the function "ip6_tnl_xmit_ctl()", it tries to access
the "collect_md" member. With "__ip6_tnl_parm" being uninitialized and
containing random data, the UBSAN detected that "collect_md" held a
non-boolean value.

The UBSAN issue is as follows:
===============================================================
UBSAN: invalid-load in net/ipv6/ip6_tunnel.c:1025:14
load of value 30 is not a valid value for type '_Bool'
CPU: 1 PID: 228 Comm: kworker/1:3 Not tainted 5.16.0-rc4+ #8
Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
Workqueue: ipv6_addrconf addrconf_dad_work
Call Trace:
<TASK>
dump_stack_lvl+0x44/0x57
ubsan_epilogue+0x5/0x40
__ubsan_handle_load_invalid_value+0x66/0x70
? __cpuhp_setup_state+0x1d3/0x210
ip6_tnl_xmit_ctl.cold.52+0x2c/0x6f [ip6_tunnel]
vti6_tnl_xmit+0x79c/0x1e96 [ip6_vti]
? lock_is_held_type+0xd9/0x130
? vti6_rcv+0x100/0x100 [ip6_vti]
? lock_is_held_type+0xd9/0x130
? rcu_read_lock_bh_held+0xc0/0xc0
? lock_acquired+0x262/0xb10
dev_hard_start_xmit+0x1e6/0x820
__dev_queue_xmit+0x2079/0x3340
? mark_lock.part.52+0xf7/0x1050
? netdev_core_pick_tx+0x290/0x290
? kvm_clock_read+0x14/0x30
? kvm_sched_clock_read+0x5/0x10
? sched_clock_cpu+0x15/0x200
? find_held_lock+0x3a/0x1c0
? lock_release+0x42f/0xc90
? lock_downgrade+0x6b0/0x6b0
? mark_held_locks+0xb7/0x120
? neigh_connected_output+0x31f/0x470
? lockdep_hardirqs_on+0x79/0x100
? neigh_connected_output+0x31f/0x470
? ip6_finish_output2+0x9b0/0x1d90
? rcu_read_lock_bh_held+0x62/0xc0
? ip6_finish_output2+0x9b0/0x1d90
ip6_finish_output2+0x9b0/0x1d90
? ip6_append_data+0x330/0x330
? ip6_mtu+0x166/0x370
? __ip6_finish_output+0x1ad/0xfb0
? nf_hook_slow+0xa6/0x170
ip6_output+0x1fb/0x710
? nf_hook.constprop.32+0x317/0x430
? ip6_finish_output+0x180/0x180
? __ip6_finish_output+0xfb0/0xfb0
? lock_is_held_type+0xd9/0x130
ndisc_send_skb+0xb33/0x1590
? __sk_mem_raise_allocated+0x11cf/0x1560
? dst_output+0x4a0/0x4a0
? ndisc_send_rs+0x432/0x610
addrconf_dad_completed+0x30c/0xbb0
? addrconf_rs_timer+0x650/0x650
? addrconf_dad_work+0x73c/0x10e0
addrconf_dad_work+0x73c/0x10e0
? addrconf_dad_completed+0xbb0/0xbb0
? rcu_read_lock_sched_held+0xaf/0xe0
? rcu_read_lock_bh_held+0xc0/0xc0
process_one_work+0x97b/0x1740
? pwq_dec_nr_in_flight+0x270/0x270
worker_thread+0x87/0xbf0
? process_one_work+0x1740/0x1740
kthread+0x3ac/0x490
? set_kthread_struct+0x100/0x100
ret_from_fork+0x22/0x30
</TASK>
===============================================================

The solution is to initialize "__ip6_tnl_parm" struct to zeros in the
"vti6_siocdevprivate()" function.

Signed-off-by: William Zhao <wizhao@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_vti.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index f58d69216b616..ce5b55491942d 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -773,6 +773,8 @@ vti6_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	struct net *net = dev_net(dev);
 	struct vti6_net *ip6n = net_generic(net, vti6_net_id);
 
+	memset(&p1, 0, sizeof(p1));
+
 	switch (cmd) {
 	case SIOCGETTUNNEL:
 		if (dev == ip6n->fb_tnl_dev) {
-- 
2.34.1



