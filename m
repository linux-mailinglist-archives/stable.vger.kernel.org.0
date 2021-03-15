Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB8633B6F6
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232083AbhCON7M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:59:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232290AbhCON6W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69F9B64EF3;
        Mon, 15 Mar 2021 13:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816698;
        bh=6JzNxAYuGj0N3DsPXW3YpmIefZQqBRq5K6bvIzYn8aU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JLOK71+1lQzsUQ6IMd3uDZDn66R6rKDWYcTcvXvDIQhUebCMcCNKJtMCPKweZZ8HJ
         tJq8CeVUG20N7S1uj+vpbgRom0eT/6fkQfP5cHjXyWhi+Fq722J4v5XaOD6BnS9bYE
         0oDfJpjqhlZUviqVpcMCFw+oD1iuV8WS0WBSFI9Y=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 05/95] net: Introduce parse_protocol header_ops callback
Date:   Mon, 15 Mar 2021 14:56:35 +0100
Message-Id: <20210315135740.438622487@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135740.245494252@linuxfoundation.org>
References: <20210315135740.245494252@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Maxim Mikityanskiy <maximmi@mellanox.com>

commit e78b2915517e8fcadb1bc130ad6aeac7099e510c upstream.

Introduce a new optional header_ops callback called parse_protocol and a
wrapper function dev_parse_header_protocol, similar to dev_parse_header.

The new callback's purpose is to extract the protocol number from the L2
header, the format of which is known to the driver, but not to the upper
layers of the stack.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/netdevice.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -272,6 +272,7 @@ struct header_ops {
 				const struct net_device *dev,
 				const unsigned char *haddr);
 	bool	(*validate)(const char *ll_header, unsigned int len);
+	__be16	(*parse_protocol)(const struct sk_buff *skb);
 };
 
 /* These flag bits are private to the generic network queueing
@@ -2731,6 +2732,15 @@ static inline int dev_parse_header(const
 	return dev->header_ops->parse(skb, haddr);
 }
 
+static inline __be16 dev_parse_header_protocol(const struct sk_buff *skb)
+{
+	const struct net_device *dev = skb->dev;
+
+	if (!dev->header_ops || !dev->header_ops->parse_protocol)
+		return 0;
+	return dev->header_ops->parse_protocol(skb);
+}
+
 /* ll_header must have at least hard_header_len allocated */
 static inline bool dev_validate_header(const struct net_device *dev,
 				       char *ll_header, int len)


