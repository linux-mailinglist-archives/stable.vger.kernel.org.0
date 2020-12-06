Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 090342D0415
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbgLFLnD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:43:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:41906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729027AbgLFLnC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 06:43:02 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 30/39] net: skbuff: ensure LSE is pullable before decrementing the MPLS ttl
Date:   Sun,  6 Dec 2020 12:17:34 +0100
Message-Id: <20201206111556.133608027@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206111554.677764505@linuxfoundation.org>
References: <20201206111554.677764505@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

[ Upstream commit 13de4ed9e3a9ccbe54d05f7d5c773f69ecaf6c64 ]

skb_mpls_dec_ttl() reads the LSE without ensuring that it is contained in
the skb "linear" area. Fix this calling pskb_may_pull() before reading the
current ttl.

Found by code inspection.

Fixes: 2a2ea50870ba ("net: sched: add mpls manipulation actions to TC")
Reported-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Link: https://lore.kernel.org/r/53659f28be8bc336c113b5254dc637cc76bbae91.1606987074.git.dcaratti@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5618,6 +5618,9 @@ int skb_mpls_dec_ttl(struct sk_buff *skb
 	if (unlikely(!eth_p_mpls(skb->protocol)))
 		return -EINVAL;
 
+	if (!pskb_may_pull(skb, skb_network_offset(skb) + MPLS_HLEN))
+		return -ENOMEM;
+
 	lse = be32_to_cpu(mpls_hdr(skb)->label_stack_entry);
 	ttl = (lse & MPLS_LS_TTL_MASK) >> MPLS_LS_TTL_SHIFT;
 	if (!--ttl)


