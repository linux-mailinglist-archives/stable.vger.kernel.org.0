Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2196212FC
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234526AbiKHNpM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:45:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234539AbiKHNpH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:45:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C35758020
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:45:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0184B81AEC
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:45:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FA4C433D6;
        Tue,  8 Nov 2022 13:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915102;
        bh=3yx14UzRNIPc3TQ9FS+QTk0chjHc3H+KLJQL0CXWCmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L0IwVOQDvWFm4VfOPGAbjNEUGZFZqqnka2IeK/xXgBtNNA9bdIpuzFaBcJNgWq6A/
         z4+QWDP1gUM8Aii61/rSCwx0txX8M3aGTFQmSg6S2b2069qbl//x/cOK4Mj2qEAU+M
         dG9fOp8Dg59fF2TT4ikd09d3JzBtx+XyybFWTkOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 11/48] net: tun: fix bugs for oversize packet when napi frags enabled
Date:   Tue,  8 Nov 2022 14:38:56 +0100
Message-Id: <20221108133329.919360197@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133329.533809494@linuxfoundation.org>
References: <20221108133329.533809494@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ziyang Xuan <william.xuanziyang@huawei.com>

[ Upstream commit 363a5328f4b0517e59572118ccfb7c626d81dca9 ]

Recently, we got two syzkaller problems because of oversize packet
when napi frags enabled.

One of the problems is because the first seg size of the iov_iter
from user space is very big, it is 2147479538 which is bigger than
the threshold value for bail out early in __alloc_pages(). And
skb->pfmemalloc is true, __kmalloc_reserve() would use pfmemalloc
reserves without __GFP_NOWARN flag. Thus we got a warning as following:

========================================================
WARNING: CPU: 1 PID: 17965 at mm/page_alloc.c:5295 __alloc_pages+0x1308/0x16c4 mm/page_alloc.c:5295
...
Call trace:
 __alloc_pages+0x1308/0x16c4 mm/page_alloc.c:5295
 __alloc_pages_node include/linux/gfp.h:550 [inline]
 alloc_pages_node include/linux/gfp.h:564 [inline]
 kmalloc_large_node+0x94/0x350 mm/slub.c:4038
 __kmalloc_node_track_caller+0x620/0x8e4 mm/slub.c:4545
 __kmalloc_reserve.constprop.0+0x1e4/0x2b0 net/core/skbuff.c:151
 pskb_expand_head+0x130/0x8b0 net/core/skbuff.c:1654
 __skb_grow include/linux/skbuff.h:2779 [inline]
 tun_napi_alloc_frags+0x144/0x610 drivers/net/tun.c:1477
 tun_get_user+0x31c/0x2010 drivers/net/tun.c:1835
 tun_chr_write_iter+0x98/0x100 drivers/net/tun.c:2036

The other problem is because odd IPv6 packets without NEXTHDR_NONE
extension header and have big packet length, it is 2127925 which is
bigger than ETH_MAX_MTU(65535). After ipv6_gso_pull_exthdrs() in
ipv6_gro_receive(), network_header offset and transport_header offset
are all bigger than U16_MAX. That would trigger skb->network_header
and skb->transport_header overflow error, because they are all '__u16'
type. Eventually, it would affect the value for __skb_push(skb, value),
and make it be a big value. After __skb_push() in ipv6_gro_receive(),
skb->data would less than skb->head, an out of bounds memory bug occurred.
That would trigger the problem as following:

==================================================================
BUG: KASAN: use-after-free in eth_type_trans+0x100/0x260
...
Call trace:
 dump_backtrace+0xd8/0x130
 show_stack+0x1c/0x50
 dump_stack_lvl+0x64/0x7c
 print_address_description.constprop.0+0xbc/0x2e8
 print_report+0x100/0x1e4
 kasan_report+0x80/0x120
 __asan_load8+0x78/0xa0
 eth_type_trans+0x100/0x260
 napi_gro_frags+0x164/0x550
 tun_get_user+0xda4/0x1270
 tun_chr_write_iter+0x74/0x130
 do_iter_readv_writev+0x130/0x1ec
 do_iter_write+0xbc/0x1e0
 vfs_writev+0x13c/0x26c

To fix the problems, restrict the packet size less than
(ETH_MAX_MTU - NET_SKB_PAD - NET_IP_ALIGN) which has considered reserved
skb space in napi_alloc_skb() because transport_header is an offset from
skb->head. Add len check in tun_napi_alloc_frags() simply.

Fixes: 90e33d459407 ("tun: enable napi_gro_frags() for TUN/TAP driver")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20221029094101.1653855-1-william.xuanziyang@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tun.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index c3390999842a..8d1b34640f79 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1473,7 +1473,8 @@ static struct sk_buff *tun_napi_alloc_frags(struct tun_file *tfile,
 	int err;
 	int i;
 
-	if (it->nr_segs > MAX_SKB_FRAGS + 1)
+	if (it->nr_segs > MAX_SKB_FRAGS + 1 ||
+	    len > (ETH_MAX_MTU - NET_SKB_PAD - NET_IP_ALIGN))
 		return ERR_PTR(-EMSGSIZE);
 
 	local_bh_disable();
-- 
2.35.1



