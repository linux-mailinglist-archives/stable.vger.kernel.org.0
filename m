Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78F343D2A49
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234720AbhGVQKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:10:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:45354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235515AbhGVQJ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:09:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44242613BA;
        Thu, 22 Jul 2021 16:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972571;
        bh=RUZiFHDlKzuWl7OOQqPe6IncVMoYDfmrEYwWKCO6JYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IAQVB+5FvurFV2rH8kn4XvreTic07BdlqXruhAbRbyG7DxaosbRQgJ54lsd/bZlcC
         zqRjgprLd4oAsJ0VPV2UQHAdhaKOFiFeiXTo1+jjrQDqM43/Fmvo1HiSIoqZHIxJdr
         zPQikHcDnwAPAV3yRc7IPbuk6J6u6M52A9D4D+WY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Treydte <mt@waldheinz.de>
Subject: [PATCH 5.13 155/156] udp: properly flush normal packet at GRO time
Date:   Thu, 22 Jul 2021 18:32:10 +0200
Message-Id: <20210722155633.366057376@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

commit b43c8909be52f2baca8884f967b418a88424494a upstream.

If an UDP packet enters the GRO engine but is not eligible
for aggregation and is not targeting an UDP tunnel,
udp_gro_receive() will not set the flush bit, and packet
could delayed till the next napi flush.

Fix the issue ensuring non GROed packets traverse
skb_gro_flush_final().

Reported-and-tested-by: Matthias Treydte <mt@waldheinz.de>
Fixes: 18f25dc39990 ("udp: skip L4 aggregation for UDP tunnel packets")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/udp_offload.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -525,8 +525,10 @@ struct sk_buff *udp_gro_receive(struct l
 
 		if ((!sk && (skb->dev->features & NETIF_F_GRO_UDP_FWD)) ||
 		    (sk && udp_sk(sk)->gro_enabled) || NAPI_GRO_CB(skb)->is_flist)
-			pp = call_gro_receive(udp_gro_receive_segment, head, skb);
-		return pp;
+			return call_gro_receive(udp_gro_receive_segment, head, skb);
+
+		/* no GRO, be sure flush the current packet */
+		goto out;
 	}
 
 	if (NAPI_GRO_CB(skb)->encap_mark ||


