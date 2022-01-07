Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9CA487885
	for <lists+stable@lfdr.de>; Fri,  7 Jan 2022 14:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347663AbiAGNsh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jan 2022 08:48:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238971AbiAGNsh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jan 2022 08:48:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 296F5C061574
        for <stable@vger.kernel.org>; Fri,  7 Jan 2022 05:48:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7F38B82527
        for <stable@vger.kernel.org>; Fri,  7 Jan 2022 13:48:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36510C36AE0;
        Fri,  7 Jan 2022 13:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641563314;
        bh=WmewzoqasgI9hjIfIpdElHbD6dVZ7Poer2jxnFRvBo4=;
        h=Subject:To:Cc:From:Date:From;
        b=Dxa+uP7UzvY8Y2RxIKrSTmnrlraaimjyNeWYMz+lhqjXBbjLK94GAobjj21GHHNIf
         aVODw2zM6riYsiYrNO4Knlt5S+I2QrAjdxbRYwTYsjFIYV7LsNVg6wCBl879iWPOnJ
         UfE9qwRAhbJi7oaEYmCuOWYInjCpZkenmF7ptWcg=
Subject: FAILED: patch "[PATCH] ipv6: Check attribute length for RTA_GATEWAY in multipath" failed to apply to 4.9-stable tree
To:     dsahern@kernel.org, davem@davemloft.net, nicolas.dichtel@6wind.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 07 Jan 2022 14:48:32 +0100
Message-ID: <164156331294155@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4619bcf91399f00a40885100fb61d594d8454033 Mon Sep 17 00:00:00 2001
From: David Ahern <dsahern@kernel.org>
Date: Thu, 30 Dec 2021 17:36:33 -0700
Subject: [PATCH] ipv6: Check attribute length for RTA_GATEWAY in multipath
 route

Commit referenced in the Fixes tag used nla_memcpy for RTA_GATEWAY as
does the current nla_get_in6_addr. nla_memcpy protects against accessing
memory greater than what is in the attribute, but there is no check
requiring the attribute to have an IPv6 address. Add it.

Fixes: 51ebd3181572 ("ipv6: add support of equal cost multipath (ECMP)")
Signed-off-by: David Ahern <dsahern@kernel.org>
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 42d60c76d30a..d16599c225b8 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5224,6 +5224,19 @@ static bool ip6_route_mpath_should_notify(const struct fib6_info *rt)
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
@@ -5264,7 +5277,13 @@ static int ip6_route_multipath_add(struct fib6_config *cfg,
 
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

