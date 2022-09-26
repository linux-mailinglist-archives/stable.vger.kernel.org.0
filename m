Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD8C5EA740
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 15:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234967AbiIZN3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 09:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235452AbiIZN2w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 09:28:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2DB81DB548;
        Mon, 26 Sep 2022 04:53:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06F7460D30;
        Mon, 26 Sep 2022 10:37:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 094EBC43470;
        Mon, 26 Sep 2022 10:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188636;
        bh=oltk1OjiNQorMNCdlqIIDzftepr4ZhS75pVgiLfx544=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rcrG1LL4bw5KBHZVqQeveDNYS3bAKWg1dXx0PRYxJ+lxAwwSWdumeT+wJrivn2nJZ
         2vR2YXWgzWVDyZT0XrMwRbDrxE0B5USvAFn13pc/+072Fex5pZdmelA+TN92F7ieGg
         HMyTcalAkMg9RsrwzEXfaQRy5CJ3a/Ir/D5Uwcas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ludovic Cintrat <ludovic.cintrat@gatewatcher.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 072/148] net: core: fix flow symmetric hash
Date:   Mon, 26 Sep 2022 12:11:46 +0200
Message-Id: <20220926100758.733849813@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ludovic Cintrat <ludovic.cintrat@gatewatcher.com>

[ Upstream commit 64ae13ed478428135cddc2f1113dff162d8112d4 ]

__flow_hash_consistentify() wrongly swaps ipv4 addresses in few cases.
This function is indirectly used by __skb_get_hash_symmetric(), which is
used to fanout packets in AF_PACKET.
Intrusion detection systems may be impacted by this issue.

__flow_hash_consistentify() computes the addresses difference then swaps
them if the difference is negative. In few cases src - dst and dst - src
are both negative.

The following snippet mimics __flow_hash_consistentify():

```
 #include <stdio.h>
 #include <stdint.h>

 int main(int argc, char** argv) {

     int diffs_d, diffd_s;
     uint32_t dst  = 0xb225a8c0; /* 178.37.168.192 --> 192.168.37.178 */
     uint32_t src  = 0x3225a8c0; /*  50.37.168.192 --> 192.168.37.50  */
     uint32_t dst2 = 0x3325a8c0; /*  51.37.168.192 --> 192.168.37.51  */

     diffs_d = src - dst;
     diffd_s = dst - src;

     printf("src:%08x dst:%08x, diff(s-d)=%d(0x%x) diff(d-s)=%d(0x%x)\n",
             src, dst, diffs_d, diffs_d, diffd_s, diffd_s);

     diffs_d = src - dst2;
     diffd_s = dst2 - src;

     printf("src:%08x dst:%08x, diff(s-d)=%d(0x%x) diff(d-s)=%d(0x%x)\n",
             src, dst2, diffs_d, diffs_d, diffd_s, diffd_s);

     return 0;
 }
```

Results:

src:3225a8c0 dst:b225a8c0, \
    diff(s-d)=-2147483648(0x80000000) \
    diff(d-s)=-2147483648(0x80000000)

src:3225a8c0 dst:3325a8c0, \
    diff(s-d)=-16777216(0xff000000) \
    diff(d-s)=16777216(0x1000000)

In the first case the addresses differences are always < 0, therefore
__flow_hash_consistentify() always swaps, thus dst->src and src->dst
packets have differents hashes.

Fixes: c3f8324188fa8 ("net: Add full IPv6 addresses to flow_keys")
Signed-off-by: Ludovic Cintrat <ludovic.cintrat@gatewatcher.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/flow_dissector.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index bc50bd331d5b..1c34e2266578 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1519,9 +1519,8 @@ static inline void __flow_hash_consistentify(struct flow_keys *keys)
 
 	switch (keys->control.addr_type) {
 	case FLOW_DISSECTOR_KEY_IPV4_ADDRS:
-		addr_diff = (__force u32)keys->addrs.v4addrs.dst -
-			    (__force u32)keys->addrs.v4addrs.src;
-		if (addr_diff < 0)
+		if ((__force u32)keys->addrs.v4addrs.dst <
+		    (__force u32)keys->addrs.v4addrs.src)
 			swap(keys->addrs.v4addrs.src, keys->addrs.v4addrs.dst);
 
 		if ((__force u16)keys->ports.dst <
-- 
2.35.1



