Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB7003B6369
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232936AbhF1O4v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:56:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:55974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232647AbhF1Owz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:52:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2C3761D35;
        Mon, 28 Jun 2021 14:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891038;
        bh=4M3zh0sKiz8pFuMYN+Mx8hu3+A89vo/Vw1drW2OPuds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F+FO/knCmRn3V8NnWAe5sUl3YBz4AJ/M4fxS5dY+s9SaBTYSUyZHFsuyrMNw0SfoW
         +I5Aj4tVNdoQYPudCoWt+pKX8Fj/hWp7Z/Yqyf6LNU6NJ8XmctzKoE4BhDoiHQLzmc
         bPxWwi+vdb6G9P7TBh5i2Yuxzj5Jx9mXY5s+r22K2D+bbjumyQuNxb828LkUk6C47n
         3sq6kZhbuj51Wac7viLpFlIFBgOYBQ94Hq9qKcS8xETYSm7cW0eVFYdDqm1vYI6jYA
         Q9CJwRSH/BL610uaseSGVCn7ZavjCLR+LRxJZGSJr6B2jowQpTDzYqjsg7brjwTBHo
         Ly1u/j7AKldiw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 56/88] net: bridge: fix vlan tunnel dst refcnt when egressing
Date:   Mon, 28 Jun 2021 10:35:56 -0400
Message-Id: <20210628143628.33342-57-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143628.33342-1-sashal@kernel.org>
References: <20210628143628.33342-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.238-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.238-rc1
X-KernelTest-Deadline: 2021-06-30T14:36+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

commit cfc579f9d89af4ada58c69b03bcaa4887840f3b3 upstream.

The egress tunnel code uses dst_clone() and directly sets the result
which is wrong because the entry might have 0 refcnt or be already deleted,
causing number of problems. It also triggers the WARN_ON() in dst_hold()[1]
when a refcnt couldn't be taken. Fix it by using dst_hold_safe() and
checking if a reference was actually taken before setting the dst.

[1] dmesg WARN_ON log and following refcnt errors
 WARNING: CPU: 5 PID: 38 at include/net/dst.h:230 br_handle_egress_vlan_tunnel+0x10b/0x134 [bridge]
 Modules linked in: 8021q garp mrp bridge stp llc bonding ipv6 virtio_net
 CPU: 5 PID: 38 Comm: ksoftirqd/5 Kdump: loaded Tainted: G        W         5.13.0-rc3+ #360
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-1.fc33 04/01/2014
 RIP: 0010:br_handle_egress_vlan_tunnel+0x10b/0x134 [bridge]
 Code: e8 85 bc 01 e1 45 84 f6 74 90 45 31 f6 85 db 48 c7 c7 a0 02 19 a0 41 0f 94 c6 31 c9 31 d2 44 89 f6 e8 64 bc 01 e1 85 db 75 02 <0f> 0b 31 c9 31 d2 44 89 f6 48 c7 c7 70 02 19 a0 e8 4b bc 01 e1 49
 RSP: 0018:ffff8881003d39e8 EFLAGS: 00010246
 RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
 RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffffa01902a0
 RBP: ffff8881040c6700 R08: 0000000000000000 R09: 0000000000000001
 R10: 2ce93d0054fe0d00 R11: 54fe0d00000e0000 R12: ffff888109515000
 R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000401
 FS:  0000000000000000(0000) GS:ffff88822bf40000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007f42ba70f030 CR3: 0000000109926000 CR4: 00000000000006e0
 Call Trace:
  br_handle_vlan+0xbc/0xca [bridge]
  __br_forward+0x23/0x164 [bridge]
  deliver_clone+0x41/0x48 [bridge]
  br_handle_frame_finish+0x36f/0x3aa [bridge]
  ? skb_dst+0x2e/0x38 [bridge]
  ? br_handle_ingress_vlan_tunnel+0x3e/0x1c8 [bridge]
  ? br_handle_frame_finish+0x3aa/0x3aa [bridge]
  br_handle_frame+0x2c3/0x377 [bridge]
  ? __skb_pull+0x33/0x51
  ? vlan_do_receive+0x4f/0x36a
  ? br_handle_frame_finish+0x3aa/0x3aa [bridge]
  __netif_receive_skb_core+0x539/0x7c6
  ? __list_del_entry_valid+0x16e/0x1c2
  __netif_receive_skb_list_core+0x6d/0xd6
  netif_receive_skb_list_internal+0x1d9/0x1fa
  gro_normal_list+0x22/0x3e
  dev_gro_receive+0x55b/0x600
  ? detach_buf_split+0x58/0x140
  napi_gro_receive+0x94/0x12e
  virtnet_poll+0x15d/0x315 [virtio_net]
  __napi_poll+0x2c/0x1c9
  net_rx_action+0xe6/0x1fb
  __do_softirq+0x115/0x2d8
  run_ksoftirqd+0x18/0x20
  smpboot_thread_fn+0x183/0x19c
  ? smpboot_unregister_percpu_thread+0x66/0x66
  kthread+0x10a/0x10f
  ? kthread_mod_delayed_work+0xb6/0xb6
  ret_from_fork+0x22/0x30
 ---[ end trace 49f61b07f775fd2b ]---
 dst_release: dst:00000000c02d677a refcnt:-1
 dst_release underflow

Cc: stable@vger.kernel.org
Fixes: 11538d039ac6 ("bridge: vlan dst_metadata hooks in ingress and egress paths")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_vlan_tunnel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_vlan_tunnel.c b/net/bridge/br_vlan_tunnel.c
index 4d5100677c68..adb6845ceba4 100644
--- a/net/bridge/br_vlan_tunnel.c
+++ b/net/bridge/br_vlan_tunnel.c
@@ -208,8 +208,8 @@ int br_handle_egress_vlan_tunnel(struct sk_buff *skb,
 		return err;
 
 	tunnel_dst = rcu_dereference(vlan->tinfo.tunnel_dst);
-	if (tunnel_dst)
-		skb_dst_set(skb, dst_clone(&tunnel_dst->dst));
+	if (tunnel_dst && dst_hold_safe(&tunnel_dst->dst))
+		skb_dst_set(skb, &tunnel_dst->dst);
 
 	return 0;
 }
-- 
2.30.2

