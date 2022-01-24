Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99EE4499B33
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574812AbiAXVu0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:50:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457579AbiAXVly (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:41:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1635EC07E336;
        Mon, 24 Jan 2022 12:29:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFE5BB8122A;
        Mon, 24 Jan 2022 20:29:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BBADC340E5;
        Mon, 24 Jan 2022 20:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056179;
        bh=lq3hf89fjyCLhDkpQ9WdaE1sdfeZJVi7g3LIOu5gNf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kRiKaOKe7iNwfZe5gMAiXnblL4J0Hlz27WoZVg489kN21IZLH1ISxWf1V8qVanW1n
         YHGtTpArQSUpjDUhTqX0UFCD2hFwWDnnF6whvwVcsv70qSaRofpIxMQeR1b8dNMVTW
         6opLLijQjuuEciLWwaCmri3p3gIbc17MJahWn2Ho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Blakey <paulb@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 365/846] net: openvswitch: Fix matching zone id for invalid conns arriving from tc
Date:   Mon, 24 Jan 2022 19:38:02 +0100
Message-Id: <20220124184113.531656257@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

[ Upstream commit 635d448a1cce4b4ebee52b351052c70434fa90ea ]

Zone id is not restored if we passed ct and ct rejected the connection,
as there is no ct info on the skb.

Save the zone from tc skb cb to tc skb extension and pass it on to
ovs, use that info to restore the zone id for invalid connections.

Fixes: d29334c15d33 ("net/sched: act_api: fix miss set post_ct for ovs after do conntrack in act_ct")
Signed-off-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h | 1 +
 net/openvswitch/flow.c | 8 +++++++-
 net/sched/cls_api.c    | 1 +
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 4f31ca71a82a7..f92839b726dc2 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -286,6 +286,7 @@ struct nf_bridge_info {
 struct tc_skb_ext {
 	__u32 chain;
 	__u16 mru;
+	__u16 zone;
 	bool post_ct;
 };
 #endif
diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
index 9713035b89e3a..6d262d9aa10ea 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -34,6 +34,7 @@
 #include <net/mpls.h>
 #include <net/ndisc.h>
 #include <net/nsh.h>
+#include <net/netfilter/nf_conntrack_zones.h>
 
 #include "conntrack.h"
 #include "datapath.h"
@@ -860,6 +861,7 @@ int ovs_flow_key_extract(const struct ip_tunnel_info *tun_info,
 #endif
 	bool post_ct = false;
 	int res, err;
+	u16 zone = 0;
 
 	/* Extract metadata from packet. */
 	if (tun_info) {
@@ -898,6 +900,7 @@ int ovs_flow_key_extract(const struct ip_tunnel_info *tun_info,
 		key->recirc_id = tc_ext ? tc_ext->chain : 0;
 		OVS_CB(skb)->mru = tc_ext ? tc_ext->mru : 0;
 		post_ct = tc_ext ? tc_ext->post_ct : false;
+		zone = post_ct ? tc_ext->zone : 0;
 	} else {
 		key->recirc_id = 0;
 	}
@@ -906,8 +909,11 @@ int ovs_flow_key_extract(const struct ip_tunnel_info *tun_info,
 #endif
 
 	err = key_extract(skb, key);
-	if (!err)
+	if (!err) {
 		ovs_ct_fill_key(skb, key, post_ct);   /* Must be after key_extract(). */
+		if (post_ct && !skb_get_nfct(skb))
+			key->ct_zone = zone;
+	}
 	return err;
 }
 
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index ff8a9383bf1c4..35c74bdde848e 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1625,6 +1625,7 @@ int tcf_classify(struct sk_buff *skb,
 		ext->chain = last_executed_chain;
 		ext->mru = cb->mru;
 		ext->post_ct = cb->post_ct;
+		ext->zone = cb->zone;
 	}
 
 	return ret;
-- 
2.34.1



