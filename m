Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6D32E687F
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729957AbfJ0V24 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:28:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:42654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730729AbfJ0VVo (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:21:44 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76D64214E0;
        Sun, 27 Oct 2019 21:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211303;
        bh=Cgywksyt4H2wmbf4RTwC80HR3uuAZ4hEsERpXkzJm8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g6ybWOshaY1tuL92SH+TPyO49bfASwNjhrnd/1gVLXKBdJpFTOr6pHwxuHLBrJ0ho
         yVK6VtSUEAHZGvw25skkuT4rvGOYa9NPS/JZDsyR1hVk3i0+9Ho44UVKLFotJTFf3U
         uZ3Tg8kRX87a5lwS08vmq4EySpEX3jwSy+K9Kydk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon Horman <simon.horman@netronome.com>,
        John Hurley <john.hurley@netronome.com>,
        Davide Caratti <dcaratti@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 087/197] net: avoid errors when trying to pop MLPS header on non-MPLS packets
Date:   Sun, 27 Oct 2019 22:00:05 +0100
Message-Id: <20191027203356.427262492@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

[ Upstream commit dedc5a08da07874c6e0d411e7f39c5c2cf137014 ]

the following script:

 # tc qdisc add dev eth0 clsact
 # tc filter add dev eth0 egress matchall action mpls pop

implicitly makes the kernel drop all packets transmitted by eth0, if they
don't have a MPLS header. This behavior is uncommon: other encapsulations
(like VLAN) just let the packet pass unmodified. Since the result of MPLS
'pop' operation would be the same regardless of the presence / absence of
MPLS header(s) in the original packet, we can let skb_mpls_pop() return 0
when dealing with non-MPLS packets.

For the OVS use-case, this is acceptable because __ovs_nla_copy_actions()
already ensures that MPLS 'pop' operation only occurs with packets having
an MPLS Ethernet type (and there are no other callers in current code, so
the semantic change should be ok).

v2: better documentation of use-cases for skb_mpls_pop(), thanks to Simon
    Horman

Fixes: 2a2ea50870ba ("net: sched: add mpls manipulation actions to TC")
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Acked-by: John Hurley <john.hurley@netronome.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5524,7 +5524,7 @@ int skb_mpls_pop(struct sk_buff *skb, __
 	int err;
 
 	if (unlikely(!eth_p_mpls(skb->protocol)))
-		return -EINVAL;
+		return 0;
 
 	err = skb_ensure_writable(skb, skb->mac_len + MPLS_HLEN);
 	if (unlikely(err))


