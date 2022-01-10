Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C8548918D
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240103AbiAJHdY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:33:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59994 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240190AbiAJHbY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:31:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B4A9B811F9;
        Mon, 10 Jan 2022 07:31:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52DD9C36AED;
        Mon, 10 Jan 2022 07:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799881;
        bh=2pfskG3xd5gnNddhXGV28wFIlf1Cv6P6HIl4FJpN97A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FGbSk1YSWT39mUISuj79MvU1DLxrCGw5ako5It5VO7H5N29MKvO5efydt/bTJjoGu
         uVP8sbL9p0G6MtBdB6QSEFE++ZWsExiLjwAxMRhio1l/gpZnn9OmEGyQpdHkd1SPpU
         7zKOqewURKQA4bJRzC3kJMJQLlToo3jQR8DUEkvc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 21/43] lwtunnel: Validate RTA_ENCAP_TYPE attribute length
Date:   Mon, 10 Jan 2022 08:23:18 +0100
Message-Id: <20220110071818.057582556@linuxfoundation.org>
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

commit 8bda81a4d400cf8a72e554012f0d8c45e07a3904 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/lwtunnel.c      |    4 ++++
 net/ipv4/fib_semantics.c |    3 +++
 net/ipv6/route.c         |    4 ++++
 3 files changed, 11 insertions(+)

--- a/net/core/lwtunnel.c
+++ b/net/core/lwtunnel.c
@@ -192,6 +192,10 @@ int lwtunnel_valid_encap_type_attr(struc
 			nla_entype = nla_find(attrs, attrlen, RTA_ENCAP_TYPE);
 
 			if (nla_entype) {
+				if (nla_len(nla_entype) < sizeof(u16)) {
+					NL_SET_ERR_MSG(extack, "Invalid RTA_ENCAP_TYPE");
+					return -EINVAL;
+				}
 				encap_type = nla_get_u16(nla_entype);
 
 				if (lwtunnel_valid_encap_type(encap_type,
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -741,6 +741,9 @@ static int fib_get_nhs(struct fib_info *
 			}
 
 			fib_cfg.fc_encap = nla_find(attrs, attrlen, RTA_ENCAP);
+			/* RTA_ENCAP_TYPE length checked in
+			 * lwtunnel_valid_encap_type_attr
+			 */
 			nla = nla_find(attrs, attrlen, RTA_ENCAP_TYPE);
 			if (nla)
 				fib_cfg.fc_encap_type = nla_get_u16(nla);
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5176,6 +5176,10 @@ static int ip6_route_multipath_add(struc
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


