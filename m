Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB1B2F13CE
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731644AbhAKNPJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:15:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:33634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732237AbhAKNPI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:15:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9381A2226A;
        Mon, 11 Jan 2021 13:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370867;
        bh=1K9Pg972ICtBt7DIEZRkm+CNLyIWfBeK/H4qN5fYCTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uWPYF0/EPB74Jx2xXmvQf6Aihu1mYsM2z4KAO47MjJOofF6XhS4kF7t3kfY8BiP8j
         UT31KVCxmuA0/jS16YoOJu4qiPFdi59ECAKkuuDdEHZ7OdT5pe7XWhh9s0AxiImCdm
         +F3NzVeKJnROR77EPfJU9Ou9yla9C7Pl1+00LO5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 039/145] bareudp: set NETIF_F_LLTX flag
Date:   Mon, 11 Jan 2021 14:01:03 +0100
Message-Id: <20210111130050.399613475@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit d9e44981739a96f1a468c13bbbd54ace378caf1c ]

Like other tunneling interfaces, the bareudp doesn't need TXLOCK.
So, It is good to set the NETIF_F_LLTX flag to improve performance and
to avoid lockdep's false-positive warning.

Test commands:
    ip netns add A
    ip netns add B
    ip link add veth0 netns A type veth peer name veth1 netns B
    ip netns exec A ip link set veth0 up
    ip netns exec A ip a a 10.0.0.1/24 dev veth0
    ip netns exec B ip link set veth1 up
    ip netns exec B ip a a 10.0.0.2/24 dev veth1

    for i in {2..1}
    do
            let A=$i-1
            ip netns exec A ip link add bareudp$i type bareudp \
		    dstport $i ethertype ip
            ip netns exec A ip link set bareudp$i up
            ip netns exec A ip a a 10.0.$i.1/24 dev bareudp$i
            ip netns exec A ip r a 10.0.$i.2 encap ip src 10.0.$A.1 \
		    dst 10.0.$A.2 via 10.0.$i.2 dev bareudp$i

            ip netns exec B ip link add bareudp$i type bareudp \
		    dstport $i ethertype ip
            ip netns exec B ip link set bareudp$i up
            ip netns exec B ip a a 10.0.$i.2/24 dev bareudp$i
            ip netns exec B ip r a 10.0.$i.1 encap ip src 10.0.$A.2 \
		    dst 10.0.$A.1 via 10.0.$i.1 dev bareudp$i
    done
    ip netns exec A ping 10.0.2.2

Splat looks like:
[   96.992803][  T822] ============================================
[   96.993954][  T822] WARNING: possible recursive locking detected
[   96.995102][  T822] 5.10.0+ #819 Not tainted
[   96.995927][  T822] --------------------------------------------
[   96.997091][  T822] ping/822 is trying to acquire lock:
[   96.998083][  T822] ffff88810f753898 (_xmit_NONE#2){+.-.}-{2:2}, at: __dev_queue_xmit+0x1f52/0x2960
[   96.999813][  T822]
[   96.999813][  T822] but task is already holding lock:
[   97.001192][  T822] ffff88810c385498 (_xmit_NONE#2){+.-.}-{2:2}, at: __dev_queue_xmit+0x1f52/0x2960
[   97.002908][  T822]
[   97.002908][  T822] other info that might help us debug this:
[   97.004401][  T822]  Possible unsafe locking scenario:
[   97.004401][  T822]
[   97.005784][  T822]        CPU0
[   97.006407][  T822]        ----
[   97.007010][  T822]   lock(_xmit_NONE#2);
[   97.007779][  T822]   lock(_xmit_NONE#2);
[   97.008550][  T822]
[   97.008550][  T822]  *** DEADLOCK ***
[   97.008550][  T822]
[   97.010057][  T822]  May be due to missing lock nesting notation
[   97.010057][  T822]
[   97.011594][  T822] 7 locks held by ping/822:
[   97.012426][  T822]  #0: ffff888109a144f0 (sk_lock-AF_INET){+.+.}-{0:0}, at: raw_sendmsg+0x12f7/0x2b00
[   97.014191][  T822]  #1: ffffffffbce2f5a0 (rcu_read_lock_bh){....}-{1:2}, at: ip_finish_output2+0x249/0x2020
[   97.016045][  T822]  #2: ffffffffbce2f5a0 (rcu_read_lock_bh){....}-{1:2}, at: __dev_queue_xmit+0x1fd/0x2960
[   97.017897][  T822]  #3: ffff88810c385498 (_xmit_NONE#2){+.-.}-{2:2}, at: __dev_queue_xmit+0x1f52/0x2960
[   97.019684][  T822]  #4: ffffffffbce2f600 (rcu_read_lock){....}-{1:2}, at: bareudp_xmit+0x31b/0x3690 [bareudp]
[   97.021573][  T822]  #5: ffffffffbce2f5a0 (rcu_read_lock_bh){....}-{1:2}, at: ip_finish_output2+0x249/0x2020
[   97.023424][  T822]  #6: ffffffffbce2f5a0 (rcu_read_lock_bh){....}-{1:2}, at: __dev_queue_xmit+0x1fd/0x2960
[   97.025259][  T822]
[   97.025259][  T822] stack backtrace:
[   97.026349][  T822] CPU: 3 PID: 822 Comm: ping Not tainted 5.10.0+ #819
[   97.027609][  T822] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
[   97.029407][  T822] Call Trace:
[   97.030015][  T822]  dump_stack+0x99/0xcb
[   97.030783][  T822]  __lock_acquire.cold.77+0x149/0x3a9
[   97.031773][  T822]  ? stack_trace_save+0x81/0xa0
[   97.032661][  T822]  ? register_lock_class+0x1910/0x1910
[   97.033673][  T822]  ? register_lock_class+0x1910/0x1910
[   97.034679][  T822]  ? rcu_read_lock_sched_held+0x91/0xc0
[   97.035697][  T822]  ? rcu_read_lock_bh_held+0xa0/0xa0
[   97.036690][  T822]  lock_acquire+0x1b2/0x730
[   97.037515][  T822]  ? __dev_queue_xmit+0x1f52/0x2960
[   97.038466][  T822]  ? check_flags+0x50/0x50
[   97.039277][  T822]  ? netif_skb_features+0x296/0x9c0
[   97.040226][  T822]  ? validate_xmit_skb+0x29/0xb10
[   97.041151][  T822]  _raw_spin_lock+0x30/0x70
[   97.041977][  T822]  ? __dev_queue_xmit+0x1f52/0x2960
[   97.042927][  T822]  __dev_queue_xmit+0x1f52/0x2960
[   97.043852][  T822]  ? netdev_core_pick_tx+0x290/0x290
[   97.044824][  T822]  ? mark_held_locks+0xb7/0x120
[   97.045712][  T822]  ? lockdep_hardirqs_on_prepare+0x12c/0x3e0
[   97.046824][  T822]  ? __local_bh_enable_ip+0xa5/0xf0
[   97.047771][  T822]  ? ___neigh_create+0x12a8/0x1eb0
[   97.048710][  T822]  ? trace_hardirqs_on+0x41/0x120
[   97.049626][  T822]  ? ___neigh_create+0x12a8/0x1eb0
[   97.050556][  T822]  ? __local_bh_enable_ip+0xa5/0xf0
[   97.051509][  T822]  ? ___neigh_create+0x12a8/0x1eb0
[   97.052443][  T822]  ? check_chain_key+0x244/0x5f0
[   97.053352][  T822]  ? rcu_read_lock_bh_held+0x56/0xa0
[   97.054317][  T822]  ? ip_finish_output2+0x6ea/0x2020
[   97.055263][  T822]  ? pneigh_lookup+0x410/0x410
[   97.056135][  T822]  ip_finish_output2+0x6ea/0x2020
[ ... ]

Acked-by: Guillaume Nault <gnault@redhat.com>
Fixes: 571912c69f0e ("net: UDP tunnel encapsulation module for tunnelling different protocols like MPLS, IP, NSH etc.")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Link: https://lore.kernel.org/r/20201228152136.24215-1-ap420073@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bareudp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -534,6 +534,7 @@ static void bareudp_setup(struct net_dev
 	SET_NETDEV_DEVTYPE(dev, &bareudp_type);
 	dev->features    |= NETIF_F_SG | NETIF_F_HW_CSUM;
 	dev->features    |= NETIF_F_RXCSUM;
+	dev->features    |= NETIF_F_LLTX;
 	dev->features    |= NETIF_F_GSO_SOFTWARE;
 	dev->hw_features |= NETIF_F_SG | NETIF_F_HW_CSUM | NETIF_F_RXCSUM;
 	dev->hw_features |= NETIF_F_GSO_SOFTWARE;


