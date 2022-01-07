Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51333487889
	for <lists+stable@lfdr.de>; Fri,  7 Jan 2022 14:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347671AbiAGNuc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jan 2022 08:50:32 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60206 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347702AbiAGNtd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jan 2022 08:49:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 828A061589
        for <stable@vger.kernel.org>; Fri,  7 Jan 2022 13:49:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A52DC36AE0;
        Fri,  7 Jan 2022 13:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641563373;
        bh=zPvTcvn+4O87qTZYQrG66SsL2f5BURfa+mgVxIQv9R4=;
        h=Subject:To:Cc:From:Date:From;
        b=bcP6GvTdHoB3rakJbDF5Ebz6jh9qHinSMjV9DjjvvAJde4mS0sScJrQCfZHtTi7Ba
         tzHSMZso+p/fSzsE/0e5ybWW11XL5txfCBoZGHz7EWVFyafBe64gcE5yAbIsR5y1DO
         +QdgWYx5gghaM779zfVtgaaR43nmLlgSy4B8uci8=
Subject: FAILED: patch "[PATCH] lwtunnel: Validate RTA_ENCAP_TYPE attribute length" failed to apply to 4.14-stable tree
To:     dsahern@kernel.org, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 07 Jan 2022 14:49:25 +0100
Message-ID: <1641563365197130@kroah.com>
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

From 8bda81a4d400cf8a72e554012f0d8c45e07a3904 Mon Sep 17 00:00:00 2001
From: David Ahern <dsahern@kernel.org>
Date: Thu, 30 Dec 2021 17:36:35 -0700
Subject: [PATCH] lwtunnel: Validate RTA_ENCAP_TYPE attribute length

lwtunnel_valid_encap_type_attr is used to validate encap attributes
within a multipath route. Add length validation checking to the type.

lwtunnel_valid_encap_type_attr is called converting attributes to
fib{6,}_config struct which means it is used before fib_get_nhs,
ip6_route_multipath_add, and ip6_route_multipath_del - other
locations that use rtnh_ok and then nla_get_u16 on RTA_ENCAP_TYPE
attribute.

Fixes: 9ed59592e3e3 ("lwtunnel: fix autoload of lwt modules")

Signed-off-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/core/lwtunnel.c b/net/core/lwtunnel.c
index 2820aca2173a..9ccd64e8a666 100644
--- a/net/core/lwtunnel.c
+++ b/net/core/lwtunnel.c
@@ -197,6 +197,10 @@ int lwtunnel_valid_encap_type_attr(struct nlattr *attr, int remaining,
 			nla_entype = nla_find(attrs, attrlen, RTA_ENCAP_TYPE);
 
 			if (nla_entype) {
+				if (nla_len(nla_entype) < sizeof(u16)) {
+					NL_SET_ERR_MSG(extack, "Invalid RTA_ENCAP_TYPE");
+					return -EINVAL;
+				}
 				encap_type = nla_get_u16(nla_entype);
 
 				if (lwtunnel_valid_encap_type(encap_type,
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 36bc429f1635..92c29ab3d042 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -740,6 +740,9 @@ static int fib_get_nhs(struct fib_info *fi, struct rtnexthop *rtnh,
 			}
 
 			fib_cfg.fc_encap = nla_find(attrs, attrlen, RTA_ENCAP);
+			/* RTA_ENCAP_TYPE length checked in
+			 * lwtunnel_valid_encap_type_attr
+			 */
 			nla = nla_find(attrs, attrlen, RTA_ENCAP_TYPE);
 			if (nla)
 				fib_cfg.fc_encap_type = nla_get_u16(nla);
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index b311c0bc9983..d2ff8a7e1709 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5287,6 +5287,10 @@ static int ip6_route_multipath_add(struct fib6_config *cfg,
 				r_cfg.fc_flags |= RTF_GATEWAY;
 			}
 			r_cfg.fc_encap = nla_find(attrs, attrlen, RTA_ENCAP);
+
+			/* RTA_ENCAP_TYPE length checked in
+			 * lwtunnel_valid_encap_type_attr
+			 */
 			nla = nla_find(attrs, attrlen, RTA_ENCAP_TYPE);
 			if (nla)
 				r_cfg.fc_encap_type = nla_get_u16(nla);

