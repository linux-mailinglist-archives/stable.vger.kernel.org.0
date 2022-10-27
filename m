Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA99660FDD5
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 18:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236761AbiJ0Q7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 12:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236760AbiJ0Q7c (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 12:59:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 924DCDFC
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 09:59:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F941B82714
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 16:59:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A215C433C1;
        Thu, 27 Oct 2022 16:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666889965;
        bh=n4sq6fpSbaGV+9iuejm3tZZNIuh3G7HGQZuiBHzVJzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pSPhb0CQ0kzY6G3FkloVWBycEBWJrFYjW9Fg9VtHcI17lsEpb81AKUhDtXYotntdW
         m5AXjSHCLevzQeJ0r9rghCPzO0Z4Zo8QMX/+hCuHaYhZ4DCwxUEzFGLG9vjF+3P0Rw
         e9fGE2iEnkqqvle6Oolv8k3fShaGGUkCQczU/m/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, syzbot <syzkaller@googlegroups.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 66/94] net: hsr: avoid possible NULL deref in skb_clone()
Date:   Thu, 27 Oct 2022 18:55:08 +0200
Message-Id: <20221027165059.842608090@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d8b57135fd9ffe9a5b445350a686442a531c5339 ]

syzbot got a crash [1] in skb_clone(), caused by a bug
in hsr_get_untagged_frame().

When/if create_stripped_skb_hsr() returns NULL, we must
not attempt to call skb_clone().

While we are at it, replace a WARN_ONCE() by netdev_warn_once().

[1]
general protection fault, probably for non-canonical address 0xdffffc000000000f: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000078-0x000000000000007f]
CPU: 1 PID: 754 Comm: syz-executor.0 Not tainted 6.0.0-syzkaller-02734-g0326074ff465 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022
RIP: 0010:skb_clone+0x108/0x3c0 net/core/skbuff.c:1641
Code: 93 02 00 00 49 83 7c 24 28 00 0f 85 e9 00 00 00 e8 5d 4a 29 fa 4c 8d 75 7e 48 b8 00 00 00 00 00 fc ff df 4c 89 f2 48 c1 ea 03 <0f> b6 04 02 4c 89 f2 83 e2 07 38 d0 7f 08 84 c0 0f 85 9e 01 00 00
RSP: 0018:ffffc90003ccf4e0 EFLAGS: 00010207

RAX: dffffc0000000000 RBX: ffffc90003ccf5f8 RCX: ffffc9000c24b000
RDX: 000000000000000f RSI: ffffffff8751cb13 RDI: 0000000000000000
RBP: 0000000000000000 R08: 00000000000000f0 R09: 0000000000000140
R10: fffffbfff181d972 R11: 0000000000000000 R12: ffff888161fc3640
R13: 0000000000000a20 R14: 000000000000007e R15: ffffffff8dc5f620
FS: 00007feb621e4700(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007feb621e3ff8 CR3: 00000001643a9000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
<TASK>
hsr_get_untagged_frame+0x4e/0x610 net/hsr/hsr_forward.c:164
hsr_forward_do net/hsr/hsr_forward.c:461 [inline]
hsr_forward_skb+0xcca/0x1d50 net/hsr/hsr_forward.c:623
hsr_handle_frame+0x588/0x7c0 net/hsr/hsr_slave.c:69
__netif_receive_skb_core+0x9fe/0x38f0 net/core/dev.c:5379
__netif_receive_skb_one_core+0xae/0x180 net/core/dev.c:5483
__netif_receive_skb+0x1f/0x1c0 net/core/dev.c:5599
netif_receive_skb_internal net/core/dev.c:5685 [inline]
netif_receive_skb+0x12f/0x8d0 net/core/dev.c:5744
tun_rx_batched+0x4ab/0x7a0 drivers/net/tun.c:1544
tun_get_user+0x2686/0x3a00 drivers/net/tun.c:1995
tun_chr_write_iter+0xdb/0x200 drivers/net/tun.c:2025
call_write_iter include/linux/fs.h:2187 [inline]
new_sync_write fs/read_write.c:491 [inline]
vfs_write+0x9e9/0xdd0 fs/read_write.c:584
ksys_write+0x127/0x250 fs/read_write.c:637
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: f266a683a480 ("net/hsr: Better frame dispatch")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20221017165928.2150130-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_forward.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index 5bf357734b11..a50429a62f74 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -150,15 +150,15 @@ struct sk_buff *hsr_get_untagged_frame(struct hsr_frame_info *frame,
 				       struct hsr_port *port)
 {
 	if (!frame->skb_std) {
-		if (frame->skb_hsr) {
+		if (frame->skb_hsr)
 			frame->skb_std =
 				create_stripped_skb_hsr(frame->skb_hsr, frame);
-		} else {
-			/* Unexpected */
-			WARN_ONCE(1, "%s:%d: Unexpected frame received (port_src %s)\n",
-				  __FILE__, __LINE__, port->dev->name);
+		else
+			netdev_warn_once(port->dev,
+					 "Unexpected frame received in hsr_get_untagged_frame()\n");
+
+		if (!frame->skb_std)
 			return NULL;
-		}
 	}
 
 	return skb_clone(frame->skb_std, GFP_ATOMIC);
-- 
2.35.1



