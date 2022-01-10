Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A14D4891A6
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240643AbiAJHeR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:34:17 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41016 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239949AbiAJHcS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:32:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B2FB60C07;
        Mon, 10 Jan 2022 07:32:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF91C36AEF;
        Mon, 10 Jan 2022 07:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799937;
        bh=d54omvJKXtxsw0qDMGjWdh74hPgtXtK5QlJLBKK81Wk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vMLbCwSuKtlVyobQemOwyXfFSfjiFPUXyXFnh1DWPgIOazoA0RHHybC1/SKQ25uDO
         kS1SsgOgKxd7TSfK3w/VqlsiUOSf1nM9nD91/GVHNJM9Vc02Sy2LR/wNE/L/rGMIif
         Q2H/5qGPDXL16flEn/s+z1bJwe94r+/x411JvI7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 22/72] ipv6: Check attribute length for RTA_GATEWAY in multipath route
Date:   Mon, 10 Jan 2022 08:22:59 +0100
Message-Id: <20220110071822.321331406@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
References: <20220110071821.500480371@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsahern@kernel.org>

commit 4619bcf91399f00a40885100fb61d594d8454033 upstream.

Commit referenced in the Fixes tag used nla_memcpy for RTA_GATEWAY as
does the current nla_get_in6_addr. nla_memcpy protects against accessing
memory greater than what is in the attribute, but there is no check
requiring the attribute to have an IPv6 address. Add it.

Fixes: 51ebd3181572 ("ipv6: add support of equal cost multipath (ECMP)")
Signed-off-by: David Ahern <dsahern@kernel.org>
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/route.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5224,6 +5224,19 @@ out:
 	return should_notify;
 }
 
+static int fib6_gw_from_attr(struct in6_addr *gw, struct nlattr *nla,
+			     struct netlink_ext_ack *extack)
+{
+	if (nla_len(nla) < sizeof(*gw)) {
+		NL_SET_ERR_MSG(extack, "Invalid IPv6 address in RTA_GATEWAY");
+		return -EINVAL;
+	}
+
+	*gw = nla_get_in6_addr(nla);
+
+	return 0;
+}
+
 static int ip6_route_multipath_add(struct fib6_config *cfg,
 				   struct netlink_ext_ack *extack)
 {
@@ -5264,7 +5277,13 @@ static int ip6_route_multipath_add(struc
 
 			nla = nla_find(attrs, attrlen, RTA_GATEWAY);
 			if (nla) {
-				r_cfg.fc_gateway = nla_get_in6_addr(nla);
+				int ret;
+
+				ret = fib6_gw_from_attr(&r_cfg.fc_gateway, nla,
+							extack);
+				if (ret)
+					return ret;
+
 				r_cfg.fc_flags |= RTF_GATEWAY;
 			}
 			r_cfg.fc_encap = nla_find(attrs, attrlen, RTA_ENCAP);


