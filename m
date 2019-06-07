Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51D8D3917A
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 18:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730178AbfFGPlD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:41:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:50554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729783AbfFGPlB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:41:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1AD42146F;
        Fri,  7 Jun 2019 15:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922060;
        bh=oYudx6GRFL5to2nlzf9auCcRhrsv3IIMd6j94J16tRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BHcR9id+CLoVYDP38tzixSGZTQ7R9RM5+43j1KdgmA9yTGMnYPtezlhB37t8qbDkA
         tK8gvOyzOcdjEQstWzHy3WNBVvsMpPw3lVC5Fc7YRB4IfjZU7j9pqzp0LaKD1kiWvu
         7o4P8ZJLtYap59y7RVXS3xt7mHQ4SpAhd0dlEcKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 05/69] net-gro: fix use-after-free read in napi_gro_frags()
Date:   Fri,  7 Jun 2019 17:38:46 +0200
Message-Id: <20190607153848.925279853@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153848.271562617@linuxfoundation.org>
References: <20190607153848.271562617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a4270d6795b0580287453ea55974d948393e66ef ]

If a network driver provides to napi_gro_frags() an
skb with a page fragment of exactly 14 bytes, the call
to gro_pull_from_frag0() will 'consume' the fragment
by calling skb_frag_unref(skb, 0), and the page might
be freed and reused.

Reading eth->h_proto at the end of napi_frags_skb() might
read mangled data, or crash under specific debugging features.

BUG: KASAN: use-after-free in napi_frags_skb net/core/dev.c:5833 [inline]
BUG: KASAN: use-after-free in napi_gro_frags+0xc6f/0xd10 net/core/dev.c:5841
Read of size 2 at addr ffff88809366840c by task syz-executor599/8957

CPU: 1 PID: 8957 Comm: syz-executor599 Not tainted 5.2.0-rc1+ #32
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x172/0x1f0 lib/dump_stack.c:113
 print_address_description.cold+0x7c/0x20d mm/kasan/report.c:188
 __kasan_report.cold+0x1b/0x40 mm/kasan/report.c:317
 kasan_report+0x12/0x20 mm/kasan/common.c:614
 __asan_report_load_n_noabort+0xf/0x20 mm/kasan/generic_report.c:142
 napi_frags_skb net/core/dev.c:5833 [inline]
 napi_gro_frags+0xc6f/0xd10 net/core/dev.c:5841
 tun_get_user+0x2f3c/0x3ff0 drivers/net/tun.c:1991
 tun_chr_write_iter+0xbd/0x156 drivers/net/tun.c:2037
 call_write_iter include/linux/fs.h:1872 [inline]
 do_iter_readv_writev+0x5f8/0x8f0 fs/read_write.c:693
 do_iter_write fs/read_write.c:970 [inline]
 do_iter_write+0x184/0x610 fs/read_write.c:951
 vfs_writev+0x1b3/0x2f0 fs/read_write.c:1015
 do_writev+0x15b/0x330 fs/read_write.c:1058

Fixes: a50e233c50db ("net-gro: restore frag0 optimization")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5067,7 +5067,6 @@ static struct sk_buff *napi_frags_skb(st
 	skb_reset_mac_header(skb);
 	skb_gro_reset_offset(skb);
 
-	eth = skb_gro_header_fast(skb, 0);
 	if (unlikely(skb_gro_header_hard(skb, hlen))) {
 		eth = skb_gro_header_slow(skb, hlen, 0);
 		if (unlikely(!eth)) {
@@ -5077,6 +5076,7 @@ static struct sk_buff *napi_frags_skb(st
 			return NULL;
 		}
 	} else {
+		eth = (const struct ethhdr *)skb->data;
 		gro_pull_from_frag0(skb, hlen);
 		NAPI_GRO_CB(skb)->frag0 += hlen;
 		NAPI_GRO_CB(skb)->frag0_len -= hlen;


