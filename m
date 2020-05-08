Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1491CAEC9
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729218AbgEHMrx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:47:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:50890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728970AbgEHMrw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:47:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 024E7221F7;
        Fri,  8 May 2020 12:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942071;
        bh=nwlzXYC+UHKQNyuU/Ac8698iQoeR5eSXGmmZcPzFB50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XEX8vDxVRMh/55yPkNsCE2lYHJNZ5PFrXJdeHGgQ8fuoIdaDhM1Ky/lFLh704P45p
         auYwW2LnAHrmDsWwOoNpstQ6F8ITcP2HJl3E2Bn5B06qxbdH8R1HOEWBYfX+yp2Yu/
         jwB6Lb1o9lHxjHlflTMqi42yssKoK5ey9zMRVBUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsa@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 286/312] net: icmp_route_lookup should use rt dev to determine L3 domain
Date:   Fri,  8 May 2020 14:34:37 +0200
Message-Id: <20200508123144.510017235@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsa@cumulusnetworks.com>

commit 9d1a6c4ea43e48c7880c85971c17939b56832d8a upstream.

icmp_send is called in response to some event. The skb may not have
the device set (skb->dev is NULL), but it is expected to have an rt.
Update icmp_route_lookup to use the rt on the skb to determine L3
domain.

Fixes: 613d09b30f8b ("net: Use VRF device index for lookups on TX")
Signed-off-by: David Ahern <dsa@cumulusnetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/icmp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -478,7 +478,7 @@ static struct rtable *icmp_route_lookup(
 	fl4->flowi4_proto = IPPROTO_ICMP;
 	fl4->fl4_icmp_type = type;
 	fl4->fl4_icmp_code = code;
-	fl4->flowi4_oif = l3mdev_master_ifindex(skb_in->dev);
+	fl4->flowi4_oif = l3mdev_master_ifindex(skb_dst(skb_in)->dev);
 
 	security_skb_classify_flow(skb_in, flowi4_to_flowi(fl4));
 	rt = __ip_route_output_key_hash(net, fl4,
@@ -503,7 +503,7 @@ static struct rtable *icmp_route_lookup(
 	if (err)
 		goto relookup_failed;
 
-	if (inet_addr_type_dev_table(net, skb_in->dev,
+	if (inet_addr_type_dev_table(net, skb_dst(skb_in)->dev,
 				     fl4_dec.saddr) == RTN_LOCAL) {
 		rt2 = __ip_route_output_key(net, &fl4_dec);
 		if (IS_ERR(rt2))


