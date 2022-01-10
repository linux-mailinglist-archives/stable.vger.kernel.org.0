Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5EDC48915F
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239361AbiAJHba (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:31:30 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38784 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240230AbiAJH33 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:29:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A727611B8;
        Mon, 10 Jan 2022 07:29:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D2BBC36AE9;
        Mon, 10 Jan 2022 07:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799769;
        bh=12lybpMKHhawVt8MCae9nzetMzfc8flqHe6kQ8r7dZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OEQ53VrR8YXH4XESK6T9xkPdUEKSC3LJoJLBuPgJyiVl0LFjsDMOWtOVuypYN1YM4
         4OO/1ACjofbBibGQ6l2O5VFqtiecYe+6AHp3C0Z4S80R5TLZd1e9I7XL9kriFdyCym
         9LqiyhswQuLFUbGvcOwLaSXL9SDGDTuSAEd1Mv6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d4b9a2851cc3ce998741@syzkaller.appspotmail.com,
        David Ahern <dsahern@kernel.org>, Thomas Graf <tgraf@suug.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 14/34] ipv4: Check attribute length for RTA_GATEWAY in multipath route
Date:   Mon, 10 Jan 2022 08:23:09 +0100
Message-Id: <20220110071816.131748180@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071815.647309738@linuxfoundation.org>
References: <20220110071815.647309738@linuxfoundation.org>
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
@@ -654,6 +654,19 @@ static int fib_count_nexthops(struct rtn
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
@@ -696,7 +709,11 @@ static int fib_get_nhs(struct fib_info *
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
@@ -894,6 +911,7 @@ int fib_nh_match(struct fib_config *cfg,
 		attrlen = rtnh_attrlen(rtnh);
 		if (attrlen > 0) {
 			struct nlattr *nla, *nlav, *attrs = rtnh_attrs(rtnh);
+			int err;
 
 			nla = nla_find(attrs, attrlen, RTA_GATEWAY);
 			nlav = nla_find(attrs, attrlen, RTA_VIA);
@@ -904,12 +922,17 @@ int fib_nh_match(struct fib_config *cfg,
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


