Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 163B947FDAA
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 14:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbhL0Nlt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 08:41:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbhL0Nlt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 08:41:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E644EC06173E
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 05:41:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A97CAB8103B
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 13:41:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4FC4C36AE7;
        Mon, 27 Dec 2021 13:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640612506;
        bh=aq4EIf3715aoyMmcn2Wf8yIkEeTsHGHw53sv9UPJKW0=;
        h=Subject:To:Cc:From:Date:From;
        b=T9CEwLUP8kXcXjhWJMfPnDnL6SivkwKGD9ie8+B5ERETn/SfJ0GRHmp9bwOJ0EUU7
         l8bax8EN1k4hMFl83rbh0oZCiAtEjLhEkqMh5U37M3MMb7uUZWpvdpg9ABMZFeM/LJ
         KsMBbB2qBQeCILORn4/UjRive5ZuGGq7EP65c9B4=
Subject: FAILED: patch "[PATCH] net: openvswitch: Fix matching zone id for invalid conns" failed to apply to 5.15-stable tree
To:     paulb@nvidia.com, kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 Dec 2021 14:41:43 +0100
Message-ID: <164061250321146@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 635d448a1cce4b4ebee52b351052c70434fa90ea Mon Sep 17 00:00:00 2001
From: Paul Blakey <paulb@nvidia.com>
Date: Tue, 14 Dec 2021 19:24:35 +0200
Subject: [PATCH] net: openvswitch: Fix matching zone id for invalid conns
 arriving from tc

Zone id is not restored if we passed ct and ct rejected the connection,
as there is no ct info on the skb.

Save the zone from tc skb cb to tc skb extension and pass it on to
ovs, use that info to restore the zone id for invalid connections.

Fixes: d29334c15d33 ("net/sched: act_api: fix miss set post_ct for ovs after do conntrack in act_ct")
Signed-off-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 2ecf8cfd2223..4507d77d6941 100644
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
index 9713035b89e3..6d262d9aa10e 100644
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
index ff8a9383bf1c..35c74bdde848 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1625,6 +1625,7 @@ int tcf_classify(struct sk_buff *skb,
 		ext->chain = last_executed_chain;
 		ext->mru = cb->mru;
 		ext->post_ct = cb->post_ct;
+		ext->zone = cb->zone;
 	}
 
 	return ret;

