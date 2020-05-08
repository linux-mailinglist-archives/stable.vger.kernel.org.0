Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B55761CAEAA
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729289AbgEHMpZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:45:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:44898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728697AbgEHMpX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:45:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25A22208D6;
        Fri,  8 May 2020 12:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941922;
        bh=KwyJlyh8TSrt9jjm908nE7DOnSvlPz4pBNo4ppNNUbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i6VWqnpA9d3SqcVHVmWsce/OBFuzeaI4O8ceKQ4WqNHDocK0dQ4rGUJrHoV4YifD7
         qrzDcY4/pxREoHxIrf/Kqg2KcWt9W1RDLUwI7Fxs7euneFbSv5BIfhR8zVQMeLdk2n
         CXCPww8Hk7nFKsPNUE0xHIFeqRhZMAAu58r4+yyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hadar Hen Zion <hadarh@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 225/312] net_sched: flower: Avoid dissection of unmasked keys
Date:   Fri,  8 May 2020 14:33:36 +0200
Message-Id: <20200508123140.279796079@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hadar Hen Zion <hadarh@mellanox.com>

commit 339ba878cfb01b68de3d281ba33fd5e4c9f76546 upstream.

The current flower implementation checks the mask range and set all the
keys included in that range as "used_keys", even if a specific key in
the range has a zero mask.

This behavior can cause a false positive return value of
dissector_uses_key function and unnecessary dissection in
__skb_flow_dissect.

This patch checks explicitly the mask of each key and "used_keys" will
be set accordingly.

Fixes: 77b9900ef53a ('tc: introduce Flower classifier')
Signed-off-by: Hadar Hen Zion <hadarh@mellanox.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sched/cls_flower.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -351,12 +351,10 @@ static int fl_init_hashtable(struct cls_
 
 #define FL_KEY_MEMBER_OFFSET(member) offsetof(struct fl_flow_key, member)
 #define FL_KEY_MEMBER_SIZE(member) (sizeof(((struct fl_flow_key *) 0)->member))
-#define FL_KEY_MEMBER_END_OFFSET(member)					\
-	(FL_KEY_MEMBER_OFFSET(member) + FL_KEY_MEMBER_SIZE(member))
 
-#define FL_KEY_IN_RANGE(mask, member)						\
-        (FL_KEY_MEMBER_OFFSET(member) <= (mask)->range.end &&			\
-         FL_KEY_MEMBER_END_OFFSET(member) >= (mask)->range.start)
+#define FL_KEY_IS_MASKED(mask, member)						\
+	memchr_inv(((char *)mask) + FL_KEY_MEMBER_OFFSET(member),		\
+		   0, FL_KEY_MEMBER_SIZE(member))				\
 
 #define FL_KEY_SET(keys, cnt, id, member)					\
 	do {									\
@@ -365,9 +363,9 @@ static int fl_init_hashtable(struct cls_
 		cnt++;								\
 	} while(0);
 
-#define FL_KEY_SET_IF_IN_RANGE(mask, keys, cnt, id, member)			\
+#define FL_KEY_SET_IF_MASKED(mask, keys, cnt, id, member)			\
 	do {									\
-		if (FL_KEY_IN_RANGE(mask, member))				\
+		if (FL_KEY_IS_MASKED(mask, member))				\
 			FL_KEY_SET(keys, cnt, id, member);			\
 	} while(0);
 
@@ -379,14 +377,14 @@ static void fl_init_dissector(struct cls
 
 	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_CONTROL, control);
 	FL_KEY_SET(keys, cnt, FLOW_DISSECTOR_KEY_BASIC, basic);
-	FL_KEY_SET_IF_IN_RANGE(mask, keys, cnt,
-			       FLOW_DISSECTOR_KEY_ETH_ADDRS, eth);
-	FL_KEY_SET_IF_IN_RANGE(mask, keys, cnt,
-			       FLOW_DISSECTOR_KEY_IPV4_ADDRS, ipv4);
-	FL_KEY_SET_IF_IN_RANGE(mask, keys, cnt,
-			       FLOW_DISSECTOR_KEY_IPV6_ADDRS, ipv6);
-	FL_KEY_SET_IF_IN_RANGE(mask, keys, cnt,
-			       FLOW_DISSECTOR_KEY_PORTS, tp);
+	FL_KEY_SET_IF_MASKED(&mask->key, keys, cnt,
+			     FLOW_DISSECTOR_KEY_ETH_ADDRS, eth);
+	FL_KEY_SET_IF_MASKED(&mask->key, keys, cnt,
+			     FLOW_DISSECTOR_KEY_IPV4_ADDRS, ipv4);
+	FL_KEY_SET_IF_MASKED(&mask->key, keys, cnt,
+			     FLOW_DISSECTOR_KEY_IPV6_ADDRS, ipv6);
+	FL_KEY_SET_IF_MASKED(&mask->key, keys, cnt,
+			     FLOW_DISSECTOR_KEY_PORTS, tp);
 
 	skb_flow_dissector_init(&head->dissector, keys, cnt);
 }


