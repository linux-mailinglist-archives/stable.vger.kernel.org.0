Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA7518B599
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727326AbgCSNT7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:19:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729800AbgCSNTz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:19:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 895DE20724;
        Thu, 19 Mar 2020 13:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623995;
        bh=MwmVKbzFjB/OUbeF5mGEwWvUIwyFcI5zaCEIrfPymbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y0LXLGhgAxWT80BKzPm5sf7xiXjo3tEJMvbQ0Ratd1m81oHGSkh9Tn81kgtETpJ7T
         5LkbuuLWw33kVhjViyXmIZWWYdT86tGa0eK0au1NBukGmNMSI/yoe7sXW+ygW9FHYk
         M1Menbl4c31bmfkgP01GWAiGP9RHK+bhLBMIptGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 23/48] net: rmnet: fix NULL pointer dereference in rmnet_changelink()
Date:   Thu, 19 Mar 2020 14:04:05 +0100
Message-Id: <20200319123910.336213211@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123902.941451241@linuxfoundation.org>
References: <20200319123902.941451241@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 1eb1f43a6e37282348a41e3d68f5e9a6a4359212 ]

In the rmnet_changelink(), it uses IFLA_LINK without checking
NULL pointer.
tb[IFLA_LINK] could be NULL pointer.
So, NULL-ptr-deref could occur.

rmnet already has a lower interface (real_dev).
So, after this patch, rmnet_changelink() does not use IFLA_LINK anymore.

Test commands:
    modprobe rmnet
    ip link add dummy0 type dummy
    ip link add rmnet0 link dummy0 type rmnet mux_id 1
    ip link set rmnet0 type rmnet mux_id 2

Splat looks like:
[   90.578726][ T1131] general protection fault, probably for non-canonical address 0xdffffc0000000000I
[   90.581121][ T1131] KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
[   90.582380][ T1131] CPU: 2 PID: 1131 Comm: ip Not tainted 5.6.0-rc1+ #447
[   90.584285][ T1131] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   90.587506][ T1131] RIP: 0010:rmnet_changelink+0x5a/0x8a0 [rmnet]
[   90.588546][ T1131] Code: 83 ec 20 48 c1 ea 03 80 3c 02 00 0f 85 6f 07 00 00 48 8b 5e 28 48 b8 00 00 00 00 00 0
[   90.591447][ T1131] RSP: 0018:ffff8880ce78f1b8 EFLAGS: 00010247
[   90.592329][ T1131] RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffff8880ce78f8b0
[   90.593253][ T1131] RDX: 0000000000000000 RSI: ffff8880ce78f4a0 RDI: 0000000000000004
[   90.594058][ T1131] RBP: ffff8880cf543e00 R08: 0000000000000002 R09: 0000000000000002
[   90.594859][ T1131] R10: ffffffffc0586a40 R11: 0000000000000000 R12: ffff8880ca47c000
[   90.595690][ T1131] R13: ffff8880ca47c000 R14: ffff8880cf545000 R15: 0000000000000000
[   90.596553][ T1131] FS:  00007f21f6c7e0c0(0000) GS:ffff8880da400000(0000) knlGS:0000000000000000
[   90.597504][ T1131] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   90.599418][ T1131] CR2: 0000556e413db458 CR3: 00000000c917a002 CR4: 00000000000606e0
[   90.600289][ T1131] Call Trace:
[   90.600631][ T1131]  __rtnl_newlink+0x922/0x1270
[   90.601194][ T1131]  ? lock_downgrade+0x6e0/0x6e0
[   90.601724][ T1131]  ? rtnl_link_unregister+0x220/0x220
[   90.602309][ T1131]  ? lock_acquire+0x164/0x3b0
[   90.602784][ T1131]  ? is_bpf_image_address+0xff/0x1d0
[   90.603331][ T1131]  ? rtnl_newlink+0x4c/0x90
[   90.603810][ T1131]  ? kernel_text_address+0x111/0x140
[   90.604419][ T1131]  ? __kernel_text_address+0xe/0x30
[   90.604981][ T1131]  ? unwind_get_return_address+0x5f/0xa0
[   90.605616][ T1131]  ? create_prof_cpu_mask+0x20/0x20
[   90.606304][ T1131]  ? arch_stack_walk+0x83/0xb0
[   90.606985][ T1131]  ? stack_trace_save+0x82/0xb0
[   90.607656][ T1131]  ? stack_trace_consume_entry+0x160/0x160
[   90.608503][ T1131]  ? deactivate_slab.isra.78+0x2c5/0x800
[   90.609336][ T1131]  ? kasan_unpoison_shadow+0x30/0x40
[   90.610096][ T1131]  ? kmem_cache_alloc_trace+0x135/0x350
[   90.610889][ T1131]  ? rtnl_newlink+0x4c/0x90
[   90.611512][ T1131]  rtnl_newlink+0x65/0x90
[ ... ]

Fixes: 23790ef12082 ("net: qualcomm: rmnet: Allow to configure flags for existing devices")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
index 0fb9375b4f69e..ad46f5aadc0ab 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
@@ -309,10 +309,8 @@ static int rmnet_changelink(struct net_device *dev, struct nlattr *tb[],
 	if (!dev)
 		return -ENODEV;
 
-	real_dev = __dev_get_by_index(dev_net(dev),
-				      nla_get_u32(tb[IFLA_LINK]));
-
-	if (!real_dev || !rmnet_is_real_dev_registered(real_dev))
+	real_dev = priv->real_dev;
+	if (!rmnet_is_real_dev_registered(real_dev))
 		return -ENODEV;
 
 	port = rmnet_get_port_rtnl(real_dev);
-- 
2.20.1



