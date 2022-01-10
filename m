Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D23EA48916A
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239288AbiAJHbo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:31:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240355AbiAJH3z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:29:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF8AC028BFA;
        Sun,  9 Jan 2022 23:27:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8178CB81161;
        Mon, 10 Jan 2022 07:27:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F24F0C36AE9;
        Mon, 10 Jan 2022 07:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799630;
        bh=SpT8iyIODNYO93lTTSNKXblLyQcmyZA84JzizvJXAyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0obQkCDJvVfALmWNJNFcC30JXtc48AuSYuONLo/dqH3z6yKJXkPWG0H5mCCIfc+gm
         Ygc6dl5ebAdk4u4UCjsp0eb4ybhyRaKLe0aScdkXnO0W7Ey1kaNPVd03Yrzjqi6l79
         q4TZ7aXQP4SVSdMbZQvCXN7U0ErwssXbGdgCqWQU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 08/21] ipv6: Check attribute length for RTA_GATEWAY in multipath route
Date:   Mon, 10 Jan 2022 08:23:09 +0100
Message-Id: <20220110071814.232226952@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071813.967414697@linuxfoundation.org>
References: <20220110071813.967414697@linuxfoundation.org>
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
@@ -4413,6 +4413,19 @@ static void ip6_route_mpath_notify(struc
 		inet6_rt_notify(RTM_NEWROUTE, rt, info, nlflags);
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
@@ -4453,7 +4466,13 @@ static int ip6_route_multipath_add(struc
 
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


