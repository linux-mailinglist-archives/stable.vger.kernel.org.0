Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1D6014B627
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727746AbgA1OCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:02:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:49320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727745AbgA1OCw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:02:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F6A1205F4;
        Tue, 28 Jan 2020 14:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220171;
        bh=eRPpBemmrylxoLQco6RIBVK3EcneMkMw+GNOefxkzqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lkajAEgWiVsf03PdZArrFfGCt3kuMjDLgGKWFr6olyyw+atISxwFaJj51vIxowzWv
         TJhqTAgsXES6Wd2L31ku4TxO6KbMTq+jKlT+kffycUPvnCVe/52l6xQPR5F4Vjrylq
         FJ8LnnwgVRlmfM/apH0WmMBmgl+BDY6f8vXrMEHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuki Taguchi <tagyounit@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 004/104] ipv6: sr: remove SKB_GSO_IPXIP6 on End.D* actions
Date:   Tue, 28 Jan 2020 14:59:25 +0100
Message-Id: <20200128135817.860523140@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuki Taguchi <tagyounit@gmail.com>

[ Upstream commit 62ebaeaedee7591c257543d040677a60e35c7aec ]

After LRO/GRO is applied, SRv6 encapsulated packets have
SKB_GSO_IPXIP6 feature flag, and this flag must be removed right after
decapulation procedure.

Currently, SKB_GSO_IPXIP6 flag is not removed on End.D* actions, which
creates inconsistent packet state, that is, a normal TCP/IP packets
have the SKB_GSO_IPXIP6 flag. This behavior can cause unexpected
fallback to GSO on routing to netdevices that do not support
SKB_GSO_IPXIP6. For example, on inter-VRF forwarding, decapsulated
packets separated into small packets by GSO because VRF devices do not
support TSO for packets with SKB_GSO_IPXIP6 flag, and this degrades
forwarding performance.

This patch removes encapsulation related GSO flags from the skb right
after the End.D* action is applied.

Fixes: d7a669dd2f8b ("ipv6: sr: add helper functions for seg6local")
Signed-off-by: Yuki Taguchi <tagyounit@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/seg6_local.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -23,6 +23,7 @@
 #include <net/addrconf.h>
 #include <net/ip6_route.h>
 #include <net/dst_cache.h>
+#include <net/ip_tunnels.h>
 #ifdef CONFIG_IPV6_SEG6_HMAC
 #include <net/seg6_hmac.h>
 #endif
@@ -135,7 +136,8 @@ static bool decap_and_validate(struct sk
 
 	skb_reset_network_header(skb);
 	skb_reset_transport_header(skb);
-	skb->encapsulation = 0;
+	if (iptunnel_pull_offloads(skb))
+		return false;
 
 	return true;
 }


