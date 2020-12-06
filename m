Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40DB12D041A
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729079AbgLFLnP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:43:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:41946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729127AbgLFLnN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 06:43:13 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Davide Caratti <dcaratti@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 31/39] net: openvswitch: ensure LSE is pullable before reading it
Date:   Sun,  6 Dec 2020 12:17:35 +0100
Message-Id: <20201206111556.183049233@linuxfoundation.org>
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

[ Upstream commit 43c13605bad44b8abbc9776d6e63f62ccb7a47d6 ]

when openvswitch is configured to mangle the LSE, the current value is
read from the packet dereferencing 4 bytes at mpls_hdr(): ensure that
the label is contained in the skb "linear" area.

Found by code inspection.

Fixes: d27cf5c59a12 ("net: core: add MPLS update core helper and use in OvS")
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Link: https://lore.kernel.org/r/aa099f245d93218b84b5c056b67b6058ccf81a66.1606987185.git.dcaratti@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/actions.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -196,6 +196,9 @@ static int set_mpls(struct sk_buff *skb,
 	__be32 lse;
 	int err;
 
+	if (!pskb_may_pull(skb, skb_network_offset(skb) + MPLS_HLEN))
+		return -ENOMEM;
+
 	stack = mpls_hdr(skb);
 	lse = OVS_MASKED(stack->label_stack_entry, *mpls_lse, *mask);
 	err = skb_mpls_update_lse(skb, lse);


