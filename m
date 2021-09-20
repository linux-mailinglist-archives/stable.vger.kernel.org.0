Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38F9C4121DD
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359837AbhITSKv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:10:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358796AbhITSIA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:08:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7FDD61A3F;
        Mon, 20 Sep 2021 17:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158321;
        bh=FdW8nJXIGgat2ntg19fcpH4kFetY/ojysidmGAJDBlc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SNH7DUONxghkRawlC1LcisBYuw2Mjgzl5vmMcjxCZ4GtKLVNzDpPPeL88eZ6FOM2s
         rbLXU79TjCHdTxNT/guCfWsMRmNCxRpZ6qtG5UmMPFANclMMdI+Zjs/uMAesBm9Kha
         GdSaS6T0Abeu+/CFXNQA+O8YKiF89vMjrPv8I3o8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 102/260] flow_dissector: Fix out-of-bounds warnings
Date:   Mon, 20 Sep 2021 18:42:00 +0200
Message-Id: <20210920163934.596456864@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo A. R. Silva <gustavoars@kernel.org>

[ Upstream commit 323e0cb473e2a8706ff162b6b4f4fa16023c9ba7 ]

Fix the following out-of-bounds warnings:

    net/core/flow_dissector.c: In function '__skb_flow_dissect':
>> net/core/flow_dissector.c:1104:4: warning: 'memcpy' offset [24, 39] from the object at '<unknown>' is out of the bounds of referenced subobject 'saddr' with type 'struct in6_addr' at offset 8 [-Warray-bounds]
     1104 |    memcpy(&key_addrs->v6addrs, &iph->saddr,
          |    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     1105 |           sizeof(key_addrs->v6addrs));
          |           ~~~~~~~~~~~~~~~~~~~~~~~~~~~
    In file included from include/linux/ipv6.h:5,
                     from net/core/flow_dissector.c:6:
    include/uapi/linux/ipv6.h:133:18: note: subobject 'saddr' declared here
      133 |  struct in6_addr saddr;
          |                  ^~~~~
>> net/core/flow_dissector.c:1059:4: warning: 'memcpy' offset [16, 19] from the object at '<unknown>' is out of the bounds of referenced subobject 'saddr' with type 'unsigned int' at offset 12 [-Warray-bounds]
     1059 |    memcpy(&key_addrs->v4addrs, &iph->saddr,
          |    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     1060 |           sizeof(key_addrs->v4addrs));
          |           ~~~~~~~~~~~~~~~~~~~~~~~~~~~
    In file included from include/linux/ip.h:17,
                     from net/core/flow_dissector.c:5:
    include/uapi/linux/ip.h:103:9: note: subobject 'saddr' declared here
      103 |  __be32 saddr;
          |         ^~~~~

The problem is that the original code is trying to copy data into a
couple of struct members adjacent to each other in a single call to
memcpy().  So, the compiler legitimately complains about it. As these
are just a couple of members, fix this by copying each one of them in
separate calls to memcpy().

This helps with the ongoing efforts to globally enable -Warray-bounds
and get us closer to being able to tighten the FORTIFY_SOURCE routines
on memcpy().

Link: https://github.com/KSPP/linux/issues/109
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/lkml/d5ae2e65-1f18-2577-246f-bada7eee6ccd@intel.com/
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/flow_dissector.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 96957a7c732f..b740a74f06f2 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1025,8 +1025,10 @@ bool __skb_flow_dissect(const struct net *net,
 							      FLOW_DISSECTOR_KEY_IPV4_ADDRS,
 							      target_container);
 
-			memcpy(&key_addrs->v4addrs, &iph->saddr,
-			       sizeof(key_addrs->v4addrs));
+			memcpy(&key_addrs->v4addrs.src, &iph->saddr,
+			       sizeof(key_addrs->v4addrs.src));
+			memcpy(&key_addrs->v4addrs.dst, &iph->daddr,
+			       sizeof(key_addrs->v4addrs.dst));
 			key_control->addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
 		}
 
@@ -1070,8 +1072,10 @@ bool __skb_flow_dissect(const struct net *net,
 							      FLOW_DISSECTOR_KEY_IPV6_ADDRS,
 							      target_container);
 
-			memcpy(&key_addrs->v6addrs, &iph->saddr,
-			       sizeof(key_addrs->v6addrs));
+			memcpy(&key_addrs->v6addrs.src, &iph->saddr,
+			       sizeof(key_addrs->v6addrs.src));
+			memcpy(&key_addrs->v6addrs.dst, &iph->daddr,
+			       sizeof(key_addrs->v6addrs.dst));
 			key_control->addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
 		}
 
-- 
2.30.2



