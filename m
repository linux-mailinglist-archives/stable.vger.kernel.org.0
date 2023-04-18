Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54D116E612B
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbjDRMYA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231247AbjDRMX5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:23:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 090FB449E
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:23:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45F2A630F9
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:23:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD04C433EF;
        Tue, 18 Apr 2023 12:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681820632;
        bh=m6HOR5AHLxL/pd8PRtBQlcmmOA5iG9LFtuuLMoBgB5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oLPrIAhWzuexyDkyl9qdCrQ+Ub/mECKqi2GjC2Brd+LBiDdS4um6tJuxB+k9p7Iur
         Bj6qKaBywdRpOUj7BMA5+yxrEFhsqtC8jaGpAQ+MTsa3A0Np/0829NhhKF/NlpDpAH
         +WwfHA36W8urwBgSXG9cmYoyzeb+jARyRsNArc/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+d373d60fddbdc915e666@syzkaller.appspotmail.com,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 03/37] icmp: guard against too small mtu
Date:   Tue, 18 Apr 2023 14:21:13 +0200
Message-Id: <20230418120254.797509384@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120254.687480980@linuxfoundation.org>
References: <20230418120254.687480980@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 7d63b67125382ff0ffdfca434acbc94a38bd092b ]

syzbot was able to trigger a panic [1] in icmp_glue_bits(), or
more exactly in skb_copy_and_csum_bits()

There is no repro yet, but I think the issue is that syzbot
manages to lower device mtu to a small value, fooling __icmp_send()

__icmp_send() must make sure there is enough room for the
packet to include at least the headers.

We might in the future refactor skb_copy_and_csum_bits() and its
callers to no longer crash when something bad happens.

[1]
kernel BUG at net/core/skbuff.c:3343 !
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 15766 Comm: syz-executor.0 Not tainted 6.3.0-rc4-syzkaller-00039-gffe78bbd5121 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
RIP: 0010:skb_copy_and_csum_bits+0x798/0x860 net/core/skbuff.c:3343
Code: f0 c1 c8 08 41 89 c6 e9 73 ff ff ff e8 61 48 d4 f9 e9 41 fd ff ff 48 8b 7c 24 48 e8 52 48 d4 f9 e9 c3 fc ff ff e8 c8 27 84 f9 <0f> 0b 48 89 44 24 28 e8 3c 48 d4 f9 48 8b 44 24 28 e9 9d fb ff ff
RSP: 0018:ffffc90000007620 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 00000000000001e8 RCX: 0000000000000100
RDX: ffff8880276f6280 RSI: ffffffff87fdd138 RDI: 0000000000000005
RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
R10: 00000000000001e8 R11: 0000000000000001 R12: 000000000000003c
R13: 0000000000000000 R14: ffff888028244868 R15: 0000000000000b0e
FS: 00007fbc81f1c700(0000) GS:ffff88802ca00000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2df43000 CR3: 00000000744db000 CR4: 0000000000150ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
<IRQ>
icmp_glue_bits+0x7b/0x210 net/ipv4/icmp.c:353
__ip_append_data+0x1d1b/0x39f0 net/ipv4/ip_output.c:1161
ip_append_data net/ipv4/ip_output.c:1343 [inline]
ip_append_data+0x115/0x1a0 net/ipv4/ip_output.c:1322
icmp_push_reply+0xa8/0x440 net/ipv4/icmp.c:370
__icmp_send+0xb80/0x1430 net/ipv4/icmp.c:765
ipv4_send_dest_unreach net/ipv4/route.c:1239 [inline]
ipv4_link_failure+0x5a9/0x9e0 net/ipv4/route.c:1246
dst_link_failure include/net/dst.h:423 [inline]
arp_error_report+0xcb/0x1c0 net/ipv4/arp.c:296
neigh_invalidate+0x20d/0x560 net/core/neighbour.c:1079
neigh_timer_handler+0xc77/0xff0 net/core/neighbour.c:1166
call_timer_fn+0x1a0/0x580 kernel/time/timer.c:1700
expire_timers+0x29b/0x4b0 kernel/time/timer.c:1751
__run_timers kernel/time/timer.c:2022 [inline]

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+d373d60fddbdc915e666@syzkaller.appspotmail.com
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20230330174502.1915328-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/icmp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 1748dfb1dc0a3..005bc38bcdde2 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -758,6 +758,11 @@ void __icmp_send(struct sk_buff *skb_in, int type, int code, __be32 info,
 		room = 576;
 	room -= sizeof(struct iphdr) + icmp_param.replyopts.opt.opt.optlen;
 	room -= sizeof(struct icmphdr);
+	/* Guard against tiny mtu. We need to include at least one
+	 * IP network header for this message to make any sense.
+	 */
+	if (room <= (int)sizeof(struct iphdr))
+		goto ende;
 
 	icmp_param.data_len = skb_in->len - icmp_param.offset;
 	if (icmp_param.data_len > room)
-- 
2.39.2



