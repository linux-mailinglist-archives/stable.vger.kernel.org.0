Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9FD538A907
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238851AbhETK4Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:56:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:52618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238991AbhETKyW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:54:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A382A61CE0;
        Thu, 20 May 2021 10:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504862;
        bh=FVsaYYVv1Qhaj3OnFiRvL2dMG6YsftuPWFaj/nUClgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NoZhUYRp0LwsT4vH4zcxpob1d0L00AJirFqc5AkPNPMlz+4/AkR4/+qVePtV4rgcq
         xUgGyvc573wL6IPSGJKFVPs0TRRdILTw1pcQUrpnGMWO4tqCXkRPBR6t3No9g6qy2k
         ocbiuduokwkIvj6W2cr8ifGJyLlRwbjUSKJo+q0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        George Kennedy <george.kennedy@oracle.com>
Subject: [PATCH 4.9 069/240] hsr: use netdev_err() instead of WARN_ONCE()
Date:   Thu, 20 May 2021 11:21:01 +0200
Message-Id: <20210520092110.988964282@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

commit 4b793acdca0050739b99ace6a8b9e7f717f57c6b upstream.

When HSR interface is sending a frame, it finds a node with
the destination ethernet address from the list.
If there is no node, it calls WARN_ONCE().
But, using WARN_ONCE() for this situation is a little bit overdoing.
So, in this patch, the netdev_err() is used instead.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: George Kennedy <george.kennedy@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/hsr/hsr_framereg.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -310,7 +310,8 @@ void hsr_addr_subst_dest(struct hsr_node
 
 	node_dst = find_node_by_AddrA(&port->hsr->node_db, eth_hdr(skb)->h_dest);
 	if (!node_dst) {
-		WARN_ONCE(1, "%s: Unknown node\n", __func__);
+		if (net_ratelimit())
+			netdev_err(skb->dev, "%s: Unknown node\n", __func__);
 		return;
 	}
 	if (port->type != node_dst->AddrB_port)


