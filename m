Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E69C44891E5
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240561AbiAJHhJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:37:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241428AbiAJHfr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:35:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D251C034008;
        Sun,  9 Jan 2022 23:30:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47DB2B81219;
        Mon, 10 Jan 2022 07:30:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F94AC36AE9;
        Mon, 10 Jan 2022 07:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799845;
        bh=bOhQIlelHmocyKnG+J9cBmRX+vsXjphmZVb/GZGImSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gQqg/xZuwD0VMDiUgDgHEZPL8yq/R4rnc6OtyqF1MT2WNUNFNEIarw9mlLXTUSU5W
         M+SRwrjyZDZg2Q7YaibObubYb6OTiiOJNGxnAXJYegsm1Iq48hqWKv6RZcLRA7YQjn
         /LdWaRNwKkwZHpgqYHCyeUco45ovMQXkykTs5jUo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d4b9a2851cc3ce998741@syzkaller.appspotmail.com,
        David Ahern <dsahern@kernel.org>, Thomas Graf <tgraf@suug.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 17/43] ipv4: Check attribute length for RTA_GATEWAY in multipath route
Date:   Mon, 10 Jan 2022 08:23:14 +0100
Message-Id: <20220110071817.931116602@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071817.337619922@linuxfoundation.org>
References: <20220110071817.337619922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsahern@kernel.org>

commit 7a3429bace0e08d94c39245631ea6bc109dafa49 upstream.

syzbot reported uninit-value:
============================================================
  BUG: KMSAN: uninit-value in fib_get_nhs+0xac4/0x1f80
  net/ipv4/fib_semantics.c:708
   fib_get_nhs+0xac4/0x1f80 net/ipv4/fib_semantics.c:708
   fib_create_info+0x2411/0x4870 net/ipv4/fib_semantics.c:1453
   fib_table_insert+0x45c/0x3a10 net/ipv4/fib_trie.c:1224
   inet_rtm_newroute+0x289/0x420 net/ipv4/fib_frontend.c:886

Add helper to validate RTA_GATEWAY length before using the attribute.

Fixes: 4e902c57417c ("[IPv4]: FIB configuration using struct fib_config")
Reported-by: syzbot+d4b9a2851cc3ce998741@syzkaller.appspotmail.com
Signed-off-by: David Ahern <dsahern@kernel.org>
Cc: Thomas Graf <tgraf@suug.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fib_semantics.c |   29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -663,6 +663,19 @@ static int fib_count_nexthops(struct rtn
 	return nhs;
 }
 
+static int fib_gw_from_attr(__be32 *gw, struct nlattr *nla,
+			    struct netlink_ext_ack *extack)
+{
+	if (nla_len(nla) < sizeof(*gw)) {
+		NL_SET_ERR_MSG(extack, "Invalid IPv4 address in RTA_GATEWAY");
+		return -EINVAL;
+	}
+
+	*gw = nla_get_in_addr(nla);
+
+	return 0;
+}
+
 /* only called when fib_nh is integrated into fib_info */
 static int fib_get_nhs(struct fib_info *fi, struct rtnexthop *rtnh,
 		       int remaining, struct fib_config *cfg,
@@ -705,7 +718,11 @@ static int fib_get_nhs(struct fib_info *
 				return -EINVAL;
 			}
 			if (nla) {
-				fib_cfg.fc_gw4 = nla_get_in_addr(nla);
+				ret = fib_gw_from_attr(&fib_cfg.fc_gw4, nla,
+						       extack);
+				if (ret)
+					goto errout;
+
 				if (fib_cfg.fc_gw4)
 					fib_cfg.fc_gw_family = AF_INET;
 			} else if (nlav) {
@@ -903,6 +920,7 @@ int fib_nh_match(struct net *net, struct
 		attrlen = rtnh_attrlen(rtnh);
 		if (attrlen > 0) {
 			struct nlattr *nla, *nlav, *attrs = rtnh_attrs(rtnh);
+			int err;
 
 			nla = nla_find(attrs, attrlen, RTA_GATEWAY);
 			nlav = nla_find(attrs, attrlen, RTA_VIA);
@@ -913,12 +931,17 @@ int fib_nh_match(struct net *net, struct
 			}
 
 			if (nla) {
+				__be32 gw;
+
+				err = fib_gw_from_attr(&gw, nla, extack);
+				if (err)
+					return err;
+
 				if (nh->fib_nh_gw_family != AF_INET ||
-				    nla_get_in_addr(nla) != nh->fib_nh_gw4)
+				    gw != nh->fib_nh_gw4)
 					return 1;
 			} else if (nlav) {
 				struct fib_config cfg2;
-				int err;
 
 				err = fib_gw_from_via(&cfg2, nlav, extack);
 				if (err)


