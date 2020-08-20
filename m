Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1030024B666
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730558AbgHTKfe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:35:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:42002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731432AbgHTKTA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:19:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 666E120658;
        Thu, 20 Aug 2020 10:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918739;
        bh=QPfgkXAnfs8QNNM41LgdhFQ5pN1N0syzwJkAzKKiL5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wHDQ+CxyucABp/tGd+asYFREzJ0UbCMOlRzIBsXq2qhdBCFE7XmQ2nMnGL82MiZ8R
         /NMJyR16RFcBT7EtKB29a66Fo3DbEJHATyfLiU8bmBhfs8euS55dYl0n1w0BQxjw4E
         xNSaTr8XZb3y/O3bzuMqmNgN8QDHIA7NyPXRIAK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        Guillaume Nault <gnault@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 049/149] Revert "vxlan: fix tos value before xmit"
Date:   Thu, 20 Aug 2020 11:22:06 +0200
Message-Id: <20200820092128.114037102@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820092125.688850368@linuxfoundation.org>
References: <20200820092125.688850368@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit a0dced17ad9dc08b1b25e0065b54c97a318e6e8b ]

This reverts commit 71130f29979c7c7956b040673e6b9d5643003176.

In commit 71130f29979c ("vxlan: fix tos value before xmit") we want to
make sure the tos value are filtered by RT_TOS() based on RFC1349.

       0     1     2     3     4     5     6     7
    +-----+-----+-----+-----+-----+-----+-----+-----+
    |   PRECEDENCE    |          TOS          | MBZ |
    +-----+-----+-----+-----+-----+-----+-----+-----+

But RFC1349 has been obsoleted by RFC2474. The new DSCP field defined like

       0     1     2     3     4     5     6     7
    +-----+-----+-----+-----+-----+-----+-----+-----+
    |          DS FIELD, DSCP           | ECN FIELD |
    +-----+-----+-----+-----+-----+-----+-----+-----+

So with

IPTOS_TOS_MASK          0x1E
RT_TOS(tos)		((tos)&IPTOS_TOS_MASK)

the first 3 bits DSCP info will get lost.

To take all the DSCP info in xmit, we should revert the patch and just push
all tos bits to ip_tunnel_ecn_encap(), which will handling ECN field later.

Fixes: 71130f29979c ("vxlan: fix tos value before xmit")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2070,7 +2070,7 @@ static void vxlan_xmit_one(struct sk_buf
 			return;
 		}
 
-		tos = ip_tunnel_ecn_encap(RT_TOS(tos), old_iph, skb);
+		tos = ip_tunnel_ecn_encap(tos, old_iph, skb);
 		ttl = ttl ? : ip4_dst_hoplimit(&rt->dst);
 		err = vxlan_xmit_skb(rt, sk, skb, fl4.saddr,
 				     dst->sin.sin_addr.s_addr, tos, ttl, df,


