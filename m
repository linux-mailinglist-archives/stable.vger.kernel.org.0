Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82FA048006F
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236570AbhL0PqV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:46:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240160AbhL0Pos (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:44:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B321EC08E85B;
        Mon, 27 Dec 2021 07:42:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64199B810C3;
        Mon, 27 Dec 2021 15:42:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA80BC36AE7;
        Mon, 27 Dec 2021 15:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619722;
        bh=h6iyZW7D1YN8A39vEr+zP4+h4vEQF/FvgHMztDXlwCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N4OuDPadZ0xTfkCLY0wJ8AHzkeeA2u3MRXUhMz2HGTqeq4HdVnQaDNZf6O14TEvnT
         +9DHrWjUoaMFvZEGHMqbinXARfXm64K53nWlaaLy0D341l4vaEhmOGim0qwptYCral
         iC0/JSnqZ8DJKK8ox8KsNhkT3wl9e0B+mLJ4qHaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ignat Korchagin <ignat@cloudflare.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 045/128] veth: ensure skb entering GRO are not cloned.
Date:   Mon, 27 Dec 2021 16:30:20 +0100
Message-Id: <20211227151333.021469159@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 9695b7de5b4760ed22132aca919570c0190cb0ce ]

After commit d3256efd8e8b ("veth: allow enabling NAPI even without XDP"),
if GRO is enabled on a veth device and TSO is disabled on the peer
device, TCP skbs will go through the NAPI callback. If there is no XDP
program attached, the veth code does not perform any share check, and
shared/cloned skbs could enter the GRO engine.

Ignat reported a BUG triggered later-on due to the above condition:

[   53.970529][    C1] kernel BUG at net/core/skbuff.c:3574!
[   53.981755][    C1] invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
[   53.982634][    C1] CPU: 1 PID: 19 Comm: ksoftirqd/1 Not tainted 5.16.0-rc5+ #25
[   53.982634][    C1] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
[   53.982634][    C1] RIP: 0010:skb_shift+0x13ef/0x23b0
[   53.982634][    C1] Code: ea 03 0f b6 04 02 48 89 fa 83 e2 07 38 d0
7f 08 84 c0 0f 85 41 0c 00 00 41 80 7f 02 00 4d 8d b5 d0 00 00 00 0f
85 74 f5 ff ff <0f> 0b 4d 8d 77 20 be 04 00 00 00 4c 89 44 24 78 4c 89
f7 4c 89 8c
[   53.982634][    C1] RSP: 0018:ffff8881008f7008 EFLAGS: 00010246
[   53.982634][    C1] RAX: 0000000000000000 RBX: ffff8881180b4c80 RCX: 0000000000000000
[   53.982634][    C1] RDX: 0000000000000002 RSI: ffff8881180b4d3c RDI: ffff88810bc9cac2
[   53.982634][    C1] RBP: ffff8881008f70b8 R08: ffff8881180b4cf4 R09: ffff8881180b4cf0
[   53.982634][    C1] R10: ffffed1022999e5c R11: 0000000000000002 R12: 0000000000000590
[   53.982634][    C1] R13: ffff88810f940c80 R14: ffff88810f940d50 R15: ffff88810bc9cac0
[   53.982634][    C1] FS:  0000000000000000(0000) GS:ffff888235880000(0000) knlGS:0000000000000000
[   53.982634][    C1] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   53.982634][    C1] CR2: 00007ff5f9b86680 CR3: 0000000108ce8004 CR4: 0000000000170ee0
[   53.982634][    C1] Call Trace:
[   53.982634][    C1]  <TASK>
[   53.982634][    C1]  tcp_sacktag_walk+0xaba/0x18e0
[   53.982634][    C1]  tcp_sacktag_write_queue+0xe7b/0x3460
[   53.982634][    C1]  tcp_ack+0x2666/0x54b0
[   53.982634][    C1]  tcp_rcv_established+0x4d9/0x20f0
[   53.982634][    C1]  tcp_v4_do_rcv+0x551/0x810
[   53.982634][    C1]  tcp_v4_rcv+0x22ed/0x2ed0
[   53.982634][    C1]  ip_protocol_deliver_rcu+0x96/0xaf0
[   53.982634][    C1]  ip_local_deliver_finish+0x1e0/0x2f0
[   53.982634][    C1]  ip_sublist_rcv_finish+0x211/0x440
[   53.982634][    C1]  ip_list_rcv_finish.constprop.0+0x424/0x660
[   53.982634][    C1]  ip_list_rcv+0x2c8/0x410
[   53.982634][    C1]  __netif_receive_skb_list_core+0x65c/0x910
[   53.982634][    C1]  netif_receive_skb_list_internal+0x5f9/0xcb0
[   53.982634][    C1]  napi_complete_done+0x188/0x6e0
[   53.982634][    C1]  gro_cell_poll+0x10c/0x1d0
[   53.982634][    C1]  __napi_poll+0xa1/0x530
[   53.982634][    C1]  net_rx_action+0x567/0x1270
[   53.982634][    C1]  __do_softirq+0x28a/0x9ba
[   53.982634][    C1]  run_ksoftirqd+0x32/0x60
[   53.982634][    C1]  smpboot_thread_fn+0x559/0x8c0
[   53.982634][    C1]  kthread+0x3b9/0x490
[   53.982634][    C1]  ret_from_fork+0x22/0x30
[   53.982634][    C1]  </TASK>

Address the issue by skipping the GRO stage for shared or cloned skbs.
To reduce the chance of OoO, try to unclone the skbs before giving up.

v1 -> v2:
 - use avoid skb_copy and fallback to netif_receive_skb  - Eric

Reported-by: Ignat Korchagin <ignat@cloudflare.com>
Fixes: d3256efd8e8b ("veth: allow enabling NAPI even without XDP")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Tested-by: Ignat Korchagin <ignat@cloudflare.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/b5f61c5602aab01bac8d711d8d1bfab0a4817db7.1640197544.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/veth.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 50eb43e5bf459..2acdb8ad6c713 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -879,8 +879,12 @@ static int veth_xdp_rcv(struct veth_rq *rq, int budget,
 
 			stats->xdp_bytes += skb->len;
 			skb = veth_xdp_rcv_skb(rq, skb, bq, stats);
-			if (skb)
-				napi_gro_receive(&rq->xdp_napi, skb);
+			if (skb) {
+				if (skb_shared(skb) || skb_unclone(skb, GFP_ATOMIC))
+					netif_receive_skb(skb);
+				else
+					napi_gro_receive(&rq->xdp_napi, skb);
+			}
 		}
 		done++;
 	}
-- 
2.34.1



