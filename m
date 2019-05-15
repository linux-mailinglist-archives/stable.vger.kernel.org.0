Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 421751F208
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730016AbfEOLPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:15:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:51484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730239AbfEOLPF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:15:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A156A2084F;
        Wed, 15 May 2019 11:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918905;
        bh=WSi2F3UmA+pw0fP1sHBvGdLDfQyed5uZVYLj3tIf/V0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gYq6x0MsJQGafRP0+fCPkosw41joUYkMJjzgkTAxkM9VDpCfSQ4044NfvoD+66rNM
         cl8qZ/2QG1Lm6kTom5m3CcP1s2mo8C5CcUIJxlc4XjAGG9hvX3Y7UPWi+BFT+Tr654
         neN9YVN0NTvToaIvzcJsdIIpWLPQbTZaAKaPYxqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Suryaputra <ssuryaextr@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 45/51] vrf: sit mtu should not be updated when vrf netdev is the link
Date:   Wed, 15 May 2019 12:56:20 +0200
Message-Id: <20190515090629.026454910@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090616.669619870@linuxfoundation.org>
References: <20190515090616.669619870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Suryaputra <ssuryaextr@gmail.com>

[ Upstream commit ff6ab32bd4e073976e4d8797b4d514a172cfe6cb ]

VRF netdev mtu isn't typically set and have an mtu of 65536. When the
link of a tunnel is set, the tunnel mtu is changed from 1480 to the link
mtu minus tunnel header. In the case of VRF netdev is the link, then the
tunnel mtu becomes 65516. So, fix it by not setting the tunnel mtu in
this case.

Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/sit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1069,7 +1069,7 @@ static void ipip6_tunnel_bind_dev(struct
 	if (!tdev && tunnel->parms.link)
 		tdev = __dev_get_by_index(tunnel->net, tunnel->parms.link);
 
-	if (tdev) {
+	if (tdev && !netif_is_l3_master(tdev)) {
 		int t_hlen = tunnel->hlen + sizeof(struct iphdr);
 
 		dev->hard_header_len = tdev->hard_header_len + sizeof(struct iphdr);


