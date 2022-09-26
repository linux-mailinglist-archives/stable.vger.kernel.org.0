Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F08AD5EA21A
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237044AbiIZLCJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237072AbiIZLAb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:00:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C1F5E306;
        Mon, 26 Sep 2022 03:31:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39CB6B80920;
        Mon, 26 Sep 2022 10:30:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76A67C433D6;
        Mon, 26 Sep 2022 10:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188201;
        bh=FI7rEFrMOyPLbRt3cV65JHtUQoUe/HdoklP+CaTR/68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=McBw2FW1NsH81rD8heYbykkcTGZu22HK2QmibVIsL4Kku7CzuyxQ7QDkCzFvTeUzl
         /b/+q/sJ19tjJ7mxFIspuHJhEIvB7qwsWg2Ghrt2H7nosdMYuGF+HxLOy8bY1GkSvQ
         b0gK7xcyYZ44higu8bRbYcSj7CZZ7PQeQIIfr+V0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, zhang kai <zhangkaiheb@126.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 073/141] net: let flow have same hash in two directions
Date:   Mon, 26 Sep 2022 12:11:39 +0200
Message-Id: <20220926100757.094339606@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
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

From: zhang kai <zhangkaiheb@126.com>

[ Upstream commit 1e60cebf82948cfdc9497ea4553bab125587593c ]

using same source and destination ip/port for flow hash calculation
within the two directions.

Signed-off-by: zhang kai <zhangkaiheb@126.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 64ae13ed4784 ("net: core: fix flow symmetric hash")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/flow_dissector.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index f9baa9b1c77f..aad311c73810 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1485,7 +1485,7 @@ __be32 flow_get_u32_dst(const struct flow_keys *flow)
 }
 EXPORT_SYMBOL(flow_get_u32_dst);
 
-/* Sort the source and destination IP (and the ports if the IP are the same),
+/* Sort the source and destination IP and the ports,
  * to have consistent hash within the two directions
  */
 static inline void __flow_hash_consistentify(struct flow_keys *keys)
@@ -1496,11 +1496,11 @@ static inline void __flow_hash_consistentify(struct flow_keys *keys)
 	case FLOW_DISSECTOR_KEY_IPV4_ADDRS:
 		addr_diff = (__force u32)keys->addrs.v4addrs.dst -
 			    (__force u32)keys->addrs.v4addrs.src;
-		if ((addr_diff < 0) ||
-		    (addr_diff == 0 &&
-		     ((__force u16)keys->ports.dst <
-		      (__force u16)keys->ports.src))) {
+		if (addr_diff < 0)
 			swap(keys->addrs.v4addrs.src, keys->addrs.v4addrs.dst);
+
+		if ((__force u16)keys->ports.dst <
+		    (__force u16)keys->ports.src) {
 			swap(keys->ports.src, keys->ports.dst);
 		}
 		break;
@@ -1508,13 +1508,13 @@ static inline void __flow_hash_consistentify(struct flow_keys *keys)
 		addr_diff = memcmp(&keys->addrs.v6addrs.dst,
 				   &keys->addrs.v6addrs.src,
 				   sizeof(keys->addrs.v6addrs.dst));
-		if ((addr_diff < 0) ||
-		    (addr_diff == 0 &&
-		     ((__force u16)keys->ports.dst <
-		      (__force u16)keys->ports.src))) {
+		if (addr_diff < 0) {
 			for (i = 0; i < 4; i++)
 				swap(keys->addrs.v6addrs.src.s6_addr32[i],
 				     keys->addrs.v6addrs.dst.s6_addr32[i]);
+		}
+		if ((__force u16)keys->ports.dst <
+		    (__force u16)keys->ports.src) {
 			swap(keys->ports.src, keys->ports.dst);
 		}
 		break;
-- 
2.35.1



