Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C96136DEF48
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbjDLIt2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbjDLItY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:49:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 579AD93D7
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:48:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4274F62A5F
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:48:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57695C433D2;
        Wed, 12 Apr 2023 08:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289326;
        bh=LrpfqlZ4yljw+XsO1vqvbJYyBofPs1sTF9uY+uHhJy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Bse5C9FZ14o/SNkxMw3mPPKpDfKy5bufJEQmvHCz4Z8yCb7aTt3FyUT+jVvB/QxS
         ttf1GExFa7tcF4b4tQbOMB5Ov3zdE2s7uhO2cg+3x9nyVQtNN5nj6YNUC6mQeMBb51
         H0EmV/mVo+d0Wd4W0yKZgD340Q0hCD5WsxXhmZy8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+d373d60fddbdc915e666@syzkaller.appspotmail.com,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 027/173] icmp: guard against too small mtu
Date:   Wed, 12 Apr 2023 10:32:33 +0200
Message-Id: <20230412082839.184250304@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
index 46aa2d65e40ab..635ed4f057495 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -746,6 +746,11 @@ void __icmp_send(struct sk_buff *skb_in, int type, int code, __be32 info,
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



