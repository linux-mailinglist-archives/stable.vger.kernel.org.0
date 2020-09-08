Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA61261C79
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731979AbgIHTUs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:20:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:51454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731110AbgIHQBn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:01:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 392BF23D68;
        Tue,  8 Sep 2020 15:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579454;
        bh=5HQkN1u01BKijaPr9cSXsQZwFQFxObonHNW4mRoT2+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wFwqxS3NXc87KqU6uSTUysl6JnV8fGsMfueDLJjncPHmgkZiQ0D1Mr5eoR4z0h9bS
         Xocyxjbtost69ZTfm2DGk1YNhPQDJ7hfS65k78gV8YcfPFAHmdLZyhJvuIINAfr7l+
         FuXKqu+FbxtsRBXVT6b8MetYLets+WJoHji+2TiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 085/186] netfilter: conntrack: do not auto-delete clash entries on reply
Date:   Tue,  8 Sep 2020 17:23:47 +0200
Message-Id: <20200908152245.763167029@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit c46172147ebbeb70094db48d76ab7945d96c638b ]

Its possible that we have more than one packet with the same ct tuple
simultaneously, e.g. when an application emits n packets on same UDP
socket from multiple threads.

NAT rules might be applied to those packets. With the right set of rules,
n packets will be mapped to m destinations, where at least two packets end
up with the same destination.

When this happens, the existing clash resolution may merge the skb that
is processed after the first has been received with the identical tuple
already in hash table.

However, its possible that this identical tuple is a NAT_CLASH tuple.
In that case the second skb will be sent, but no reply can be received
since the reply that is processed first removes the NAT_CLASH tuple.

Do not auto-delete, this gives a 1 second window for replies to be passed
back to originator.

Packets that are coming later (udp stream case) will not be affected:
they match the original ct entry, not a NAT_CLASH one.

Also prevent NAT_CLASH entries from getting offloaded.

Fixes: 6a757c07e51f ("netfilter: conntrack: allow insertion of clashing entries")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_proto_udp.c | 26 ++++++++++----------------
 net/netfilter/nft_flow_offload.c       |  2 +-
 2 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 760ca24228165..af402f458ee02 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -81,18 +81,6 @@ static bool udp_error(struct sk_buff *skb,
 	return false;
 }
 
-static void nf_conntrack_udp_refresh_unreplied(struct nf_conn *ct,
-					       struct sk_buff *skb,
-					       enum ip_conntrack_info ctinfo,
-					       u32 extra_jiffies)
-{
-	if (unlikely(ctinfo == IP_CT_ESTABLISHED_REPLY &&
-		     ct->status & IPS_NAT_CLASH))
-		nf_ct_kill(ct);
-	else
-		nf_ct_refresh_acct(ct, ctinfo, skb, extra_jiffies);
-}
-
 /* Returns verdict for packet, and may modify conntracktype */
 int nf_conntrack_udp_packet(struct nf_conn *ct,
 			    struct sk_buff *skb,
@@ -124,12 +112,15 @@ int nf_conntrack_udp_packet(struct nf_conn *ct,
 
 		nf_ct_refresh_acct(ct, ctinfo, skb, extra);
 
+		/* never set ASSURED for IPS_NAT_CLASH, they time out soon */
+		if (unlikely((ct->status & IPS_NAT_CLASH)))
+			return NF_ACCEPT;
+
 		/* Also, more likely to be important, and not a probe */
 		if (!test_and_set_bit(IPS_ASSURED_BIT, &ct->status))
 			nf_conntrack_event_cache(IPCT_ASSURED, ct);
 	} else {
-		nf_conntrack_udp_refresh_unreplied(ct, skb, ctinfo,
-						   timeouts[UDP_CT_UNREPLIED]);
+		nf_ct_refresh_acct(ct, ctinfo, skb, timeouts[UDP_CT_UNREPLIED]);
 	}
 	return NF_ACCEPT;
 }
@@ -206,12 +197,15 @@ int nf_conntrack_udplite_packet(struct nf_conn *ct,
 	if (test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
 		nf_ct_refresh_acct(ct, ctinfo, skb,
 				   timeouts[UDP_CT_REPLIED]);
+
+		if (unlikely((ct->status & IPS_NAT_CLASH)))
+			return NF_ACCEPT;
+
 		/* Also, more likely to be important, and not a probe */
 		if (!test_and_set_bit(IPS_ASSURED_BIT, &ct->status))
 			nf_conntrack_event_cache(IPCT_ASSURED, ct);
 	} else {
-		nf_conntrack_udp_refresh_unreplied(ct, skb, ctinfo,
-						   timeouts[UDP_CT_UNREPLIED]);
+		nf_ct_refresh_acct(ct, ctinfo, skb, timeouts[UDP_CT_UNREPLIED]);
 	}
 	return NF_ACCEPT;
 }
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 3b9b97aa4b32e..3a6c84fb2c90d 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -102,7 +102,7 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	}
 
 	if (nf_ct_ext_exist(ct, NF_CT_EXT_HELPER) ||
-	    ct->status & IPS_SEQ_ADJUST)
+	    ct->status & (IPS_SEQ_ADJUST | IPS_NAT_CLASH))
 		goto out;
 
 	if (!nf_ct_is_confirmed(ct))
-- 
2.25.1



