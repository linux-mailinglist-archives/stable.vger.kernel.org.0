Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 688A248787E
	for <lists+stable@lfdr.de>; Fri,  7 Jan 2022 14:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbiAGNrw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jan 2022 08:47:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238943AbiAGNrw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jan 2022 08:47:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7FE0C061574
        for <stable@vger.kernel.org>; Fri,  7 Jan 2022 05:47:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77D6F61D41
        for <stable@vger.kernel.org>; Fri,  7 Jan 2022 13:47:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62923C36AE5;
        Fri,  7 Jan 2022 13:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641563270;
        bh=h/FSxHQc2CTExUf3g09lWUWnlSgRvu+it0isBPGA3N0=;
        h=Subject:To:Cc:From:Date:From;
        b=B+7+wJeJ/IGXb30WbuVJnwvf1e4MJ7nb64FhBMTnm25fhmFEGeRe4Pg3c2mtCTjfb
         HQNolIutNUbdc1/LWJLuAliDp0ujDee/gxedIn8dpVdnQFxl0EgfwS+MfJI/1mPc96
         2QQGAN8WvDzvNqsLbtcp3NHIQZIsgi+B5L95HTnQ=
Subject: FAILED: patch "[PATCH] ipv4: Check attribute length for RTA_GATEWAY in multipath" failed to apply to 4.14-stable tree
To:     dsahern@kernel.org, davem@davemloft.net, tgraf@suug.ch
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 07 Jan 2022 14:47:40 +0100
Message-ID: <1641563260238193@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7a3429bace0e08d94c39245631ea6bc109dafa49 Mon Sep 17 00:00:00 2001
From: David Ahern <dsahern@kernel.org>
Date: Thu, 30 Dec 2021 17:36:31 -0700
Subject: [PATCH] ipv4: Check attribute length for RTA_GATEWAY in multipath
 route

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

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index fde7797b5806..f1caa2c1c041 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -662,6 +662,19 @@ static int fib_count_nexthops(struct rtnexthop *rtnh, int remaining,
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
@@ -704,7 +717,11 @@ static int fib_get_nhs(struct fib_info *fi, struct rtnexthop *rtnh,
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
@@ -902,6 +919,7 @@ int fib_nh_match(struct net *net, struct fib_config *cfg, struct fib_info *fi,
 		attrlen = rtnh_attrlen(rtnh);
 		if (attrlen > 0) {
 			struct nlattr *nla, *nlav, *attrs = rtnh_attrs(rtnh);
+			int err;
 
 			nla = nla_find(attrs, attrlen, RTA_GATEWAY);
 			nlav = nla_find(attrs, attrlen, RTA_VIA);
@@ -912,12 +930,17 @@ int fib_nh_match(struct net *net, struct fib_config *cfg, struct fib_info *fi,
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

