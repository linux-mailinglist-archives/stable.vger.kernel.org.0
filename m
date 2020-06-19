Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6605200BA5
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 16:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387449AbgFSOgD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:36:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:52326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387438AbgFSOgB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:36:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A8A720DD4;
        Fri, 19 Jun 2020 14:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577359;
        bh=p/Kys53zbYuJeLd7yzPdO3LNO9TBUIaC/O6+gWDNqjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hKC/8bNzOXXLT0DiBsBSm4gcWZR8jhJ1J9ehgYWemSEWLYTDYg3da8cLNis2vVWVs
         ktPef0rMKwoh6h6nqm7dl+guF8maidFrChkrs/2mNLKnodJ+HvuM1xmB8ZZjHmI+gk
         iFGMQSvekIBAPphCo5p/0LPrEF019R4DguT2V2W4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@mellanox.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 002/101] vxlan: Avoid infinite loop when suppressing NS messages with invalid options
Date:   Fri, 19 Jun 2020 16:31:51 +0200
Message-Id: <20200619141614.143014219@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141614.001544111@linuxfoundation.org>
References: <20200619141614.001544111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

[ Upstream commit 8066e6b449e050675df48e7c4b16c29f00507ff0 ]

When proxy mode is enabled the vxlan device might reply to Neighbor
Solicitation (NS) messages on behalf of remote hosts.

In case the NS message includes the "Source link-layer address" option
[1], the vxlan device will use the specified address as the link-layer
destination address in its reply.

To avoid an infinite loop, break out of the options parsing loop when
encountering an option with length zero and disregard the NS message.

This is consistent with the IPv6 ndisc code and RFC 4886 which states
that "Nodes MUST silently discard an ND packet that contains an option
with length zero" [2].

[1] https://tools.ietf.org/html/rfc4861#section-4.3
[2] https://tools.ietf.org/html/rfc4861#section-4.6

Fixes: 4b29dba9c085 ("vxlan: fix nonfunctional neigh_reduce()")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1476,6 +1476,10 @@ static struct sk_buff *vxlan_na_create(s
 	daddr = eth_hdr(request)->h_source;
 	ns_olen = request->len - skb_transport_offset(request) - sizeof(*ns);
 	for (i = 0; i < ns_olen-1; i += (ns->opt[i+1]<<3)) {
+		if (!ns->opt[i + 1]) {
+			kfree_skb(reply);
+			return NULL;
+		}
 		if (ns->opt[i] == ND_OPT_SOURCE_LL_ADDR) {
 			daddr = ns->opt + i + sizeof(struct nd_opt_hdr);
 			break;


