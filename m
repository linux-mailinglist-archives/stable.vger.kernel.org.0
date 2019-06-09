Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C132C3A7B1
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731381AbfFIQwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:52:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732154AbfFIQwQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:52:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96AF3206BB;
        Sun,  9 Jun 2019 16:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099136;
        bh=uA1XUY8Y9JhDRjVcaTRxjH3VmToFHsV8hi0Ve44fnq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jqGvNbrzxUip7dqQ0xT8vr7RuO5igPsQbDRb6InlQYMuZeSmiiW7BwtPRl/Ja1j1R
         Z6/+NO6qnEmeOZBQ4fywRIXyy5GMUClz9jA6B4m8AKOcBvMVSnj263lypzaWBC/frW
         gW7xcMWiFwhw8hpLfMjhfFmAa9BX3yduWPTcx0Ag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 04/83] net-gro: fix use-after-free read in napi_gro_frags()
Date:   Sun,  9 Jun 2019 18:41:34 +0200
Message-Id: <20190609164128.066835650@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.843327870@linuxfoundation.org>
References: <20190609164127.843327870@linuxfoundation.org>
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
@@ -4828,7 +4828,6 @@ static struct sk_buff *napi_frags_skb(st
 	skb_reset_mac_header(skb);
 	skb_gro_reset_offset(skb);
 
-	eth = skb_gro_header_fast(skb, 0);
 	if (unlikely(skb_gro_header_hard(skb, hlen))) {
 		eth = skb_gro_header_slow(skb, hlen, 0);
 		if (unlikely(!eth)) {
@@ -4838,6 +4837,7 @@ static struct sk_buff *napi_frags_skb(st
 			return NULL;
 		}
 	} else {
+		eth = (const struct ethhdr *)skb->data;
 		gro_pull_from_frag0(skb, hlen);
 		NAPI_GRO_CB(skb)->frag0 += hlen;
 		NAPI_GRO_CB(skb)->frag0_len -= hlen;


