Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50BD334C57F
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbhC2IAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:00:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:42192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231470AbhC2IAi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:00:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFB5361969;
        Mon, 29 Mar 2021 08:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617004837;
        bh=u6QD78nIPBH5SMYynzvec6iVRMmJVsG/h/VvBRBZDQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MwQU4MF66WUKJyKW0AulJmmDBlZf/Mu/qDIOqEbnWT8Q3VIBQPdcO+O0qpMOlgoK9
         rBinl0QKIt5t985rk1ShdFSQJPXqDwM9QbIio6ifD+jEv4QBDJoqcrFFu1+MIna8DT
         HtsjF0xK60d+j27wCkWLXS3KSxOE3qij2v57GmOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 19/33] macvlan: macvlan_count_rx() needs to be aware of preemption
Date:   Mon, 29 Mar 2021 09:58:04 +0200
Message-Id: <20210329075605.885932688@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075605.290845195@linuxfoundation.org>
References: <20210329075605.290845195@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit dd4fa1dae9f4847cc1fd78ca468ad69e16e5db3e ]

macvlan_count_rx() can be called from process context, it is thus
necessary to disable preemption before calling u64_stats_update_begin()

syzbot was able to spot this on 32bit arch:

WARNING: CPU: 1 PID: 4632 at include/linux/seqlock.h:271 __seqprop_assert include/linux/seqlock.h:271 [inline]
WARNING: CPU: 1 PID: 4632 at include/linux/seqlock.h:271 __seqprop_assert.constprop.0+0xf0/0x11c include/linux/seqlock.h:269
Modules linked in:
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 4632 Comm: kworker/1:3 Not tainted 5.12.0-rc2-syzkaller #0
Hardware name: ARM-Versatile Express
Workqueue: events macvlan_process_broadcast
Backtrace:
[<82740468>] (dump_backtrace) from [<827406dc>] (show_stack+0x18/0x1c arch/arm/kernel/traps.c:252)
 r7:00000080 r6:60000093 r5:00000000 r4:8422a3c4
[<827406c4>] (show_stack) from [<82751b58>] (__dump_stack lib/dump_stack.c:79 [inline])
[<827406c4>] (show_stack) from [<82751b58>] (dump_stack+0xb8/0xe8 lib/dump_stack.c:120)
[<82751aa0>] (dump_stack) from [<82741270>] (panic+0x130/0x378 kernel/panic.c:231)
 r7:830209b4 r6:84069ea4 r5:00000000 r4:844350d0
[<82741140>] (panic) from [<80244924>] (__warn+0xb0/0x164 kernel/panic.c:605)
 r3:8404ec8c r2:00000000 r1:00000000 r0:830209b4
 r7:0000010f
[<80244874>] (__warn) from [<82741520>] (warn_slowpath_fmt+0x68/0xd4 kernel/panic.c:628)
 r7:81363f70 r6:0000010f r5:83018e50 r4:00000000
[<827414bc>] (warn_slowpath_fmt) from [<81363f70>] (__seqprop_assert include/linux/seqlock.h:271 [inline])
[<827414bc>] (warn_slowpath_fmt) from [<81363f70>] (__seqprop_assert.constprop.0+0xf0/0x11c include/linux/seqlock.h:269)
 r8:5a109000 r7:0000000f r6:a568dac0 r5:89802300 r4:00000001
[<81363e80>] (__seqprop_assert.constprop.0) from [<81364af0>] (u64_stats_update_begin include/linux/u64_stats_sync.h:128 [inline])
[<81363e80>] (__seqprop_assert.constprop.0) from [<81364af0>] (macvlan_count_rx include/linux/if_macvlan.h:47 [inline])
[<81363e80>] (__seqprop_assert.constprop.0) from [<81364af0>] (macvlan_broadcast+0x154/0x26c drivers/net/macvlan.c:291)
 r5:89802300 r4:8a927740
[<8136499c>] (macvlan_broadcast) from [<81365020>] (macvlan_process_broadcast+0x258/0x2d0 drivers/net/macvlan.c:317)
 r10:81364f78 r9:8a86d000 r8:8a9c7e7c r7:8413aa5c r6:00000000 r5:00000000
 r4:89802840
[<81364dc8>] (macvlan_process_broadcast) from [<802696a4>] (process_one_work+0x2d4/0x998 kernel/workqueue.c:2275)
 r10:00000008 r9:8404ec98 r8:84367a02 r7:ddfe6400 r6:ddfe2d40 r5:898dac80
 r4:8a86d43c
[<802693d0>] (process_one_work) from [<80269dcc>] (worker_thread+0x64/0x54c kernel/workqueue.c:2421)
 r10:00000008 r9:8a9c6000 r8:84006d00 r7:ddfe2d78 r6:898dac94 r5:ddfe2d40
 r4:898dac80
[<80269d68>] (worker_thread) from [<80271f40>] (kthread+0x184/0x1a4 kernel/kthread.c:292)
 r10:85247e64 r9:898dac80 r8:80269d68 r7:00000000 r6:8a9c6000 r5:89a2ee40
 r4:8a97bd00
[<80271dbc>] (kthread) from [<80200114>] (ret_from_fork+0x14/0x20 arch/arm/kernel/entry-common.S:158)
Exception stack(0x8a9c7fb0 to 0x8a9c7ff8)

Fixes: 412ca1550cbe ("macvlan: Move broadcasts into a work queue")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Reported-by: syzbot <syzkaller@googlegroups.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/if_macvlan.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/if_macvlan.h b/include/linux/if_macvlan.h
index a4ccc3122f93..cfcbc49f4ddf 100644
--- a/include/linux/if_macvlan.h
+++ b/include/linux/if_macvlan.h
@@ -70,13 +70,14 @@ static inline void macvlan_count_rx(const struct macvlan_dev *vlan,
 	if (likely(success)) {
 		struct vlan_pcpu_stats *pcpu_stats;
 
-		pcpu_stats = this_cpu_ptr(vlan->pcpu_stats);
+		pcpu_stats = get_cpu_ptr(vlan->pcpu_stats);
 		u64_stats_update_begin(&pcpu_stats->syncp);
 		pcpu_stats->rx_packets++;
 		pcpu_stats->rx_bytes += len;
 		if (multicast)
 			pcpu_stats->rx_multicast++;
 		u64_stats_update_end(&pcpu_stats->syncp);
+		put_cpu_ptr(vlan->pcpu_stats);
 	} else {
 		this_cpu_inc(vlan->pcpu_stats->rx_errors);
 	}
-- 
2.30.1



