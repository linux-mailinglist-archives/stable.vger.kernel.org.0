Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4DC12F0CF
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728212AbgABWSi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:18:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:34010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728474AbgABWSh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:18:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D13E2253D;
        Thu,  2 Jan 2020 22:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003517;
        bh=NS5YAvQuPF8LGqne4QikjhrH8sI3xfzOa4RMFogxKnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KU6o1NTIUac5QlhrqGhgLvvs500dnq3+rcXJiSNHunzqPtn0mTiU/LMLpVQByxoxP
         Dms2krH7a/Nn415CYf4TAte8n4+kjlTUeSW1M/Ym3jteZWOF1gRKYjmDCsjmZvviYL
         hDHJ0ePpc8xZ4N8Th/1Us5XSxrr3vl4ZwE01LX/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 174/191] net/dst: do not confirm neighbor for vxlan and geneve pmtu update
Date:   Thu,  2 Jan 2020 23:07:36 +0100
Message-Id: <20200102215847.955146723@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit f081042d128a0c7acbd67611def62e1b52e2d294 ]

When do IPv6 tunnel PMTU update and calls __ip6_rt_update_pmtu() in the end,
we should not call dst_confirm_neigh() as there is no two-way communication.

So disable the neigh confirm for vxlan and geneve pmtu update.

v5: No change.
v4: No change.
v3: Do not remove dst_confirm_neigh, but add a new bool parameter in
    dst_ops.update_pmtu to control whether we should do neighbor confirm.
    Also split the big patch to small ones for each area.
v2: Remove dst_confirm_neigh in __ip6_rt_update_pmtu.

Fixes: a93bf0ff4490 ("vxlan: update skb dst pmtu on tx path")
Fixes: 52a589d51f10 ("geneve: update skb dst pmtu on tx path")
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Tested-by: Guillaume Nault <gnault@redhat.com>
Acked-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/dst.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -535,7 +535,7 @@ static inline void skb_tunnel_check_pmtu
 	u32 encap_mtu = dst_mtu(encap_dst);
 
 	if (skb->len > encap_mtu - headroom)
-		skb_dst_update_pmtu(skb, encap_mtu - headroom);
+		skb_dst_update_pmtu_no_confirm(skb, encap_mtu - headroom);
 }
 
 #endif /* _NET_DST_H */


