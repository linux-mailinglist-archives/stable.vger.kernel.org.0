Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 741A71CAEBE
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729507AbgEHMrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:47:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:49006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729505AbgEHMrB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:47:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFE062145D;
        Fri,  8 May 2020 12:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942021;
        bh=L6fhEOE9L+MH7BX7fO5lV0ujd11NRggPnd/JTncYjGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gDuJHgfxF+ectFaSw3sKd4ZziclLu8CXMZ9rlo8eaXn2LvYjnYLCTGTI+8CvVruqW
         wgmnM1TS6bLRd4mVtzsImX7lyzHc61wRPxGko2lLfn5JhquRM7+/AuJ/47+JmSedKP
         TKttWZin72tfln16FvES4OnpQjl3GAKXZan+7KtY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsa@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 264/312] net: icmp6_send should use dst dev to determine L3 domain
Date:   Fri,  8 May 2020 14:34:15 +0200
Message-Id: <20200508123143.005408652@linuxfoundation.org>
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

commit 5d41ce29e3b91ef305f88d23f72b3359de329cec upstream.

icmp6_send is called in response to some event. The skb may not have
the device set (skb->dev is NULL), but it is expected to have a dst set.
Update icmp6_send to use the dst on the skb to determine L3 domain.

Fixes: ca254490c8dfd ("net: Add VRF support to IPv6 stack")
Signed-off-by: David Ahern <dsa@cumulusnetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv6/icmp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -446,7 +446,7 @@ static void icmp6_send(struct sk_buff *s
 	if (__ipv6_addr_needs_scope_id(addr_type))
 		iif = skb->dev->ifindex;
 	else
-		iif = l3mdev_master_ifindex(skb->dev);
+		iif = l3mdev_master_ifindex(skb_dst(skb)->dev);
 
 	/*
 	 *	Must not send error if the source does not uniquely


