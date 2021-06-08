Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3506B3A0293
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234764AbhFHTGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:06:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:45022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236986AbhFHTDl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:03:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 643D0613C0;
        Tue,  8 Jun 2021 18:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177951;
        bh=JiNZlSikyQwZnPoSF3ec5ikNZ5ygRYEjh3PqydSZK+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xoQXTelzktkqv+DxXvu5hGXQXbNQle8KwO11BOzxKdhk2ZUDLCf2qiU+/Zckn0ct4
         BwdmU7oee2u+bZDRly0JWUfOgU0Wv3F8kHe1sYuSfGlHw+OSz3iB5yvnjst05g3C+0
         is8CdSLcbp6YURvIkHt8xqBFG9ybYoSQmDI6mc3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oz Shlomo <ozsh@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Paul Blakey <paulb@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 022/161] net/sched: act_ct: Offload connections with commit action
Date:   Tue,  8 Jun 2021 20:25:52 +0200
Message-Id: <20210608175946.199786615@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
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
index 48fdf7293dea..371fd64638d2 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -984,7 +984,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 	 */
 	cached = tcf_ct_skb_nfct_cached(net, skb, p->zone, force);
 	if (!cached) {
-		if (!commit && tcf_ct_flow_table_lookup(p, skb, family)) {
+		if (tcf_ct_flow_table_lookup(p, skb, family)) {
 			skip_add = true;
 			goto do_nat;
 		}
@@ -1024,10 +1024,11 @@ do_nat:
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



