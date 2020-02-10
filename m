Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE7E157C77
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727592AbgBJNhm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:37:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:51094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727573AbgBJMfB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:35:01 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C29D2168B;
        Mon, 10 Feb 2020 12:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338099;
        bh=vpjViyxndPCTq73XRGWNsXqvllWolP+lFmHN0ggM0W8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Hdol6UgRHN+XGY2AXEnL1u71s6egLyLa2FkBBHLV9DIfnBl8gyhPwerFwX8L+orH
         wxzrGA19KrNIERBeAvrkJMeX0gRFms4jXYZKExMqeLO+JQtFTbkJI9FUrhlykduG/Y
         p/KoUEYEsfAdyzEeftZoHtgdRI9iMu6oT/jmMNZg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 014/195] net: hsr: fix possible NULL deref in hsr_handle_frame()
Date:   Mon, 10 Feb 2020 04:31:12 -0800
Message-Id: <20200210122307.060956688@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 2b5b8251bc9fe2f9118411f037862ee17cf81e97 ]

hsr_port_get_rcu() can return NULL, so we need to be careful.

general protection fault, probably for non-canonical address 0xdffffc0000000006: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000030-0x0000000000000037]
CPU: 1 PID: 10249 Comm: syz-executor.5 Not tainted 5.5.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__read_once_size include/linux/compiler.h:199 [inline]
RIP: 0010:hsr_addr_is_self+0x86/0x330 net/hsr/hsr_framereg.c:44
Code: 04 00 f3 f3 f3 65 48 8b 04 25 28 00 00 00 48 89 45 d0 31 c0 e8 6b ff 94 f9 4c 89 f2 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <80> 3c 02 00 0f 85 75 02 00 00 48 8b 43 30 49 39 c6 49 89 47 c0 0f
RSP: 0018:ffffc90000da8a90 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff87e0cc33
RDX: 0000000000000006 RSI: ffffffff87e035d5 RDI: 0000000000000000
RBP: ffffc90000da8b20 R08: ffff88808e7de040 R09: ffffed1015d2707c
R10: ffffed1015d2707b R11: ffff8880ae9383db R12: ffff8880a689bc5e
R13: 1ffff920001b5153 R14: 0000000000000030 R15: ffffc90000da8af8
FS:  00007fd7a42be700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b32338000 CR3: 00000000a928c000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 hsr_handle_frame+0x1c5/0x630 net/hsr/hsr_slave.c:31
 __netif_receive_skb_core+0xfbc/0x30b0 net/core/dev.c:5099
 __netif_receive_skb_one_core+0xa8/0x1a0 net/core/dev.c:5196
 __netif_receive_skb+0x2c/0x1d0 net/core/dev.c:5312
 process_backlog+0x206/0x750 net/core/dev.c:6144
 napi_poll net/core/dev.c:6582 [inline]
 net_rx_action+0x508/0x1120 net/core/dev.c:6650
 __do_softirq+0x262/0x98c kernel/softirq.c:292
 do_softirq_own_stack+0x2a/0x40 arch/x86/entry/entry_64.S:1082
 </IRQ>

Fixes: c5a759117210 ("net/hsr: Use list_head (and rcu) instead of array for slave devices.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/hsr/hsr_slave.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/hsr/hsr_slave.c
+++ b/net/hsr/hsr_slave.c
@@ -32,6 +32,8 @@ static rx_handler_result_t hsr_handle_fr
 
 	rcu_read_lock(); /* hsr->node_db, hsr->ports */
 	port = hsr_port_get_rcu(skb->dev);
+	if (!port)
+		goto finish_pass;
 
 	if (hsr_addr_is_self(port->hsr, eth_hdr(skb)->h_source)) {
 		/* Directly kill frames sent by ourselves */


