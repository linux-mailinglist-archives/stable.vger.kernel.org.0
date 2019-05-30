Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63E792EFDA
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729968AbfE3D6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:58:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:52258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730213AbfE3DSn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:18:43 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 959DF2475F;
        Thu, 30 May 2019 03:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186322;
        bh=tDB5YY0NPcT0l/Ix8REcVlx+WJ/4cDK4koo2CQwZI9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DXj1mQfxDKKIQnSK4NIcYqTfb483F9S64qhmmmVPi2NTJZX2THFEchOsYDKS5iP1A
         83kYDZpgKpmsvVkikVious7Up2N3L48sSFCTziD7FW21iR/1Kc/lQJ/lLI8qRdpE6p
         OBVM6rVx2tLBG9mmwsxoj88e6aP2n12m+uVOa5Qk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+9723f2d288e49b492cf0@syzkaller.appspotmail.com,
        syzbot+f0ddeb2b032a8e1d9098@syzkaller.appspotmail.com,
        syzbot+f14b3703cd8d7670203f@syzkaller.appspotmail.com,
        syzbot+eefa384efad8d7997f20@syzkaller.appspotmail.com,
        William Tu <u9012063@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Paasch <cpaasch@apple.com>
Subject: [PATCH 4.14 034/193] net: erspan: fix use-after-free
Date:   Wed, 29 May 2019 20:04:48 -0700
Message-Id: <20190530030454.006155866@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: William Tu <u9012063@gmail.com>

commit b423d13c08a656c719fa56324a8f4279c835d90c upstream.

When building the erspan header for either v1 or v2, the eth_hdr()
does not point to the right inner packet's eth_hdr,
causing kasan report use-after-free and slab-out-of-bouds read.

The patch fixes the following syzkaller issues:
[1] BUG: KASAN: slab-out-of-bounds in erspan_xmit+0x22d4/0x2430 net/ipv4/ip_gre.c:735
[2] BUG: KASAN: slab-out-of-bounds in erspan_build_header+0x3bf/0x3d0 net/ipv4/ip_gre.c:698
[3] BUG: KASAN: use-after-free in erspan_xmit+0x22d4/0x2430 net/ipv4/ip_gre.c:735
[4] BUG: KASAN: use-after-free in erspan_build_header+0x3bf/0x3d0 net/ipv4/ip_gre.c:698

[2] CPU: 0 PID: 3654 Comm: syzkaller377964 Not tainted 4.15.0-rc9+ #185
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:17 [inline]
 dump_stack+0x194/0x257 lib/dump_stack.c:53
 print_address_description+0x73/0x250 mm/kasan/report.c:252
 kasan_report_error mm/kasan/report.c:351 [inline]
 kasan_report+0x25b/0x340 mm/kasan/report.c:409
 __asan_report_load_n_noabort+0xf/0x20 mm/kasan/report.c:440
 erspan_build_header+0x3bf/0x3d0 net/ipv4/ip_gre.c:698
 erspan_xmit+0x3b8/0x13b0 net/ipv4/ip_gre.c:740
 __netdev_start_xmit include/linux/netdevice.h:4042 [inline]
 netdev_start_xmit include/linux/netdevice.h:4051 [inline]
 packet_direct_xmit+0x315/0x6b0 net/packet/af_packet.c:266
 packet_snd net/packet/af_packet.c:2943 [inline]
 packet_sendmsg+0x3aed/0x60b0 net/packet/af_packet.c:2968
 sock_sendmsg_nosec net/socket.c:638 [inline]
 sock_sendmsg+0xca/0x110 net/socket.c:648
 SYSC_sendto+0x361/0x5c0 net/socket.c:1729
 SyS_sendto+0x40/0x50 net/socket.c:1697
 do_syscall_32_irqs_on arch/x86/entry/common.c:327 [inline]
 do_fast_syscall_32+0x3ee/0xf9d arch/x86/entry/common.c:389
 entry_SYSENTER_compat+0x54/0x63 arch/x86/entry/entry_64_compat.S:129
RIP: 0023:0xf7fcfc79
RSP: 002b:00000000ffc6976c EFLAGS: 00000286 ORIG_RAX: 0000000000000171
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 0000000020011000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000020008000
RBP: 000000000000001c R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Fixes: f551c91de262 ("net: erspan: introduce erspan v2 for ip_gre")
Fixes: 84e54fe0a5ea ("gre: introduce native tunnel support for ERSPAN")
Reported-by: syzbot+9723f2d288e49b492cf0@syzkaller.appspotmail.com
Reported-by: syzbot+f0ddeb2b032a8e1d9098@syzkaller.appspotmail.com
Reported-by: syzbot+f14b3703cd8d7670203f@syzkaller.appspotmail.com
Reported-by: syzbot+eefa384efad8d7997f20@syzkaller.appspotmail.com
Signed-off-by: William Tu <u9012063@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Christoph Paasch <cpaasch@apple.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/ip_gre.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -689,7 +689,7 @@ static void erspan_build_header(struct s
 				__be32 id, u32 index, bool truncate)
 {
 	struct iphdr *iphdr = ip_hdr(skb);
-	struct ethhdr *eth = eth_hdr(skb);
+	struct ethhdr *eth = (struct ethhdr *)skb->data;
 	enum erspan_encap_type enc_type;
 	struct erspanhdr *ershdr;
 	struct qtag_prefix {


