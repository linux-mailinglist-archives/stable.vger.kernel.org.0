Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E20133B6C7
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbhCON6r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:58:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:36788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232093AbhCON6H (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBC9C64EF9;
        Mon, 15 Mar 2021 13:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816684;
        bh=iDE8WNAc2YpEAw+DCtortrJQ9uhD2hnReSWZ40rFk4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ig0gW8pjj99v9ifzGoOxqtBDGCxTZzmBErolHP+sbjTOkH5Bh7qctFH31NQ+WyKzS
         kGvyc76nIsAjyG1MYljA45mr/FdmsqcgCO+Dz10i11hhtSIbcgC+KdKLkkb5lyHPLQ
         8byyGiADi/dQP0tc3K6wcIdWdyTWCw/+UM5NbFh8=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 005/120] net: Introduce parse_protocol header_ops callback
Date:   Mon, 15 Mar 2021 14:55:56 +0100
Message-Id: <20210315135720.187858706@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135720.002213995@linuxfoundation.org>
References: <20210315135720.002213995@linuxfoundation.org>
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
@@ -274,6 +274,7 @@ struct header_ops {
 				const struct net_device *dev,
 				const unsigned char *haddr);
 	bool	(*validate)(const char *ll_header, unsigned int len);
+	__be16	(*parse_protocol)(const struct sk_buff *skb);
 };
 
 /* These flag bits are private to the generic network queueing
@@ -2895,6 +2896,15 @@ static inline int dev_parse_header(const
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


