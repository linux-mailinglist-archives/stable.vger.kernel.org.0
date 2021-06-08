Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFE83A0175
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235510AbhFHSwP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:52:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:49530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236277AbhFHSuO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:50:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51F4C61434;
        Tue,  8 Jun 2021 18:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177564;
        bh=zZAex3+iOCLqMsDHxUYFmab/TdhF2AokETnbGhnIJ7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GaO6YN3517rNDLXVS/+wLKhRjUYEX/y98+uutTNhnE9nd/HSV9eNS2uRbzjB8OTnS
         S+zoGnj73dHL1vZb+q9FbwDl1Diy6QVcOMqSVNZQ9maaNY4AkPEhTf2jq4YZnXQOtK
         /xfBxXfclpU0e8OKMCcql7AFlVfCCPb/TnCTUDhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oz Shlomo <ozsh@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Paul Blakey <paulb@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 019/137] net/sched: act_ct: Offload connections with commit action
Date:   Tue,  8 Jun 2021 20:25:59 +0200
Message-Id: <20210608175943.058403110@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

[ Upstream commit 0cc254e5aa37cf05f65bcdcdc0ac5c58010feb33 ]

Currently established connections are not offloaded if the filter has a
"ct commit" action. This behavior will not offload connections of the
following scenario:

$ tc_filter add dev $DEV ingress protocol ip prio 1 flower \
  ct_state -trk \
  action ct commit action goto chain 1

$ tc_filter add dev $DEV ingress protocol ip chain 1 prio 1 flower \
  action mirred egress redirect dev $DEV2

$ tc_filter add dev $DEV2 ingress protocol ip prio 1 flower \
  action ct commit action goto chain 1

$ tc_filter add dev $DEV2 ingress protocol ip prio 1 chain 1 flower \
  ct_state +trk+est \
  action mirred egress redirect dev $DEV

Offload established connections, regardless of the commit flag.

Fixes: 46475bb20f4b ("net/sched: act_ct: Software offload of established flows")
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Paul Blakey <paulb@nvidia.com>
Link: https://lore.kernel.org/r/1622029449-27060-1-git-send-email-paulb@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_ct.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index aba3cd85f284..6376b7b22325 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -979,7 +979,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 	 */
 	cached = tcf_ct_skb_nfct_cached(net, skb, p->zone, force);
 	if (!cached) {
-		if (!commit && tcf_ct_flow_table_lookup(p, skb, family)) {
+		if (tcf_ct_flow_table_lookup(p, skb, family)) {
 			skip_add = true;
 			goto do_nat;
 		}
@@ -1019,10 +1019,11 @@ do_nat:
 		 * even if the connection is already confirmed.
 		 */
 		nf_conntrack_confirm(skb);
-	} else if (!skip_add) {
-		tcf_ct_flow_table_process_conn(p->ct_ft, ct, ctinfo);
 	}
 
+	if (!skip_add)
+		tcf_ct_flow_table_process_conn(p->ct_ft, ct, ctinfo);
+
 out_push:
 	skb_push_rcsum(skb, nh_ofs);
 
-- 
2.30.2



