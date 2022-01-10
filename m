Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E74048920B
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241355AbiAJHht (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:37:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241545AbiAJHf4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:35:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2837FC025267;
        Sun,  9 Jan 2022 23:31:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCEBB60B63;
        Mon, 10 Jan 2022 07:31:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04F9C36AE9;
        Mon, 10 Jan 2022 07:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799876;
        bh=ig92hey2Onqg/E9ZxomRHc1ckmA+ocL+WBV8lkyX5DM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qHgQdm2vKx2og2ca04u8dcQlvsSCqcdZ8hHyQ1jRniwQ1NL8LQUDe2Gb8IXc67+OO
         KFD+ghd/RFoh5uz6Ia5b7l81q7898zepkoA2D3qUPgYLHMkUBR4iOEfRaYK+dK9VX2
         F/JfBp36CNXv6doXYOvGpSyPaQ+tokbfGVzcmzVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 19/43] ipv6: Check attribute length for RTA_GATEWAY in multipath route
Date:   Mon, 10 Jan 2022 08:23:16 +0100
Message-Id: <20220110071817.997363901@linuxfoundation.org>
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
@@ -5113,6 +5113,19 @@ out:
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
@@ -5153,7 +5166,13 @@ static int ip6_route_multipath_add(struc
 
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


