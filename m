Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 730F21CAC87
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730166AbgEHMyK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:54:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:36310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730160AbgEHMyK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:54:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CBD724958;
        Fri,  8 May 2020 12:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942448;
        bh=jwEotNsfUdSyH6WucGJ1xceQfxb4ELYe5N6RD+odaMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I+xNkfktjJHSxCZRYsd55qzGipLgQ6FscTwh0JxMFOBRwvEsHkP3VSzhDRMDhiC/Z
         2nT7YzgW5Yeo/jFj+PIHWWvxQ5lsoyTQ06Enids/qjyXLPWT4lUSrCqsBXp0MIwYYN
         pZEgrX/Q6KHD3sP56WZULYkdzK0t4b+Ypx0I+9Ko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 49/50] udp: document udp_rcv_segment special case for looped packets
Date:   Fri,  8 May 2020 14:35:55 +0200
Message-Id: <20200508123049.719667187@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123043.085296641@linuxfoundation.org>
References: <20200508123043.085296641@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

commit d0208bf4da97f76237300afb83c097de25645de6 upstream.

Commit 6cd021a58c18a ("udp: segment looped gso packets correctly")
fixes an issue with rare udp gso multicast packets looped onto the
receive path.

The stable backport makes the narrowest change to target only these
packets, when needed. As opposed to, say, expanding __udp_gso_segment,
which is harder to reason to be free from unintended side-effects.

But the resulting code is hardly self-describing.
Document its purpose and rationale.

Signed-off-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/udp.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -476,6 +476,13 @@ static inline struct sk_buff *udp_rcv_se
 	if (!inet_get_convert_csum(sk))
 		features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
 
+	/* UDP segmentation expects packets of type CHECKSUM_PARTIAL or
+	 * CHECKSUM_NONE in __udp_gso_segment. UDP GRO indeed builds partial
+	 * packets in udp_gro_complete_segment. As does UDP GSO, verified by
+	 * udp_send_skb. But when those packets are looped in dev_loopback_xmit
+	 * their ip_summed is set to CHECKSUM_UNNECESSARY. Reset in this
+	 * specific case, where PARTIAL is both correct and required.
+	 */
 	if (skb->pkt_type == PACKET_LOOPBACK)
 		skb->ip_summed = CHECKSUM_PARTIAL;
 


