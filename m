Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB837187ED2
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 11:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgCQK4W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 06:56:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:33846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726452AbgCQK4V (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 06:56:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FF0E20714;
        Tue, 17 Mar 2020 10:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584442581;
        bh=SanQ3vDyH9uTO+yYf1cJEVS1/6HAU0Rq1i5TyLKQZyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SE0RYgO2f6M9L6DQtwmvtc5FijrvrZj/cnAZyslaOwD2eBxwaZEt0ZAXi10aqYuze
         GBVqeAe82OzYfkliHLegnZbpwyr+DgblpTwOooyQ0ghDZnKEGw8sKUgZi1+WZhehW/
         QEJBOgMSzXe5oDqZNVKEvUPtZBlKMOQhhaCmVyUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 12/89] netlink: Use netlink header as base to calculate bad attribute offset
Date:   Tue, 17 Mar 2020 11:54:21 +0100
Message-Id: <20200317103301.291918811@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103259.744774526@linuxfoundation.org>
References: <20200317103259.744774526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 84b3268027641401bb8ad4427a90a3cce2eb86f5 ]

Userspace might send a batch that is composed of several netlink
messages. The netlink_ack() function must use the pointer to the netlink
header as base to calculate the bad attribute offset.

Fixes: 2d4bc93368f5 ("netlink: extended ACK reporting")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netlink/af_netlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2411,7 +2411,7 @@ void netlink_ack(struct sk_buff *in_skb,
 							       in_skb->len))
 				WARN_ON(nla_put_u32(skb, NLMSGERR_ATTR_OFFS,
 						    (u8 *)extack->bad_attr -
-						    in_skb->data));
+						    (u8 *)nlh));
 		} else {
 			if (extack->cookie_len)
 				WARN_ON(nla_put(skb, NLMSGERR_ATTR_COOKIE,


