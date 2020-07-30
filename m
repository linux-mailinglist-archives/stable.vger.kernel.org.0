Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC40E232E87
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730322AbgG3IVA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:21:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:42484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728883AbgG3IFW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:05:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F3B222CB3;
        Thu, 30 Jul 2020 08:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096321;
        bh=ujPKpPCEH1vowH1yF5817YURZkyiHerQ4CbRd4rKHq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tTSWai1hVhWrOPkUIUu59w4IIZlsETPlPLOLjMP7yyBTUHH9m+pTa0nI2sxUWP5pQ
         nBEk5riSEK8DLJeCniKBkb5YBzOFZphpG+BYkgoPdjhylGLUBFUM3ZUvliiPt6fpCE
         Ye1wrE07uJuIMZ6UidkLkbh0YMiSRTXo/5abVwe0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, wenxu <wenxu@ucloud.cn>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 06/20] net/sched: act_ct: fix restore the qdisc_skb_cb after defrag
Date:   Thu, 30 Jul 2020 10:03:56 +0200
Message-Id: <20200730074420.845160025@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200730074420.533211699@linuxfoundation.org>
References: <20200730074420.533211699@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

[ Upstream commit ae372cb1750f6c95370f92fe5f5620e0954663ba ]

The fragment packets do defrag in tcf_ct_handle_fragments
will clear the skb->cb which make the qdisc_skb_cb clear
too. So the qdsic_skb_cb should be store before defrag and
restore after that.
It also update the pkt_len after all the
fragments finish the defrag to one packet and make the
following actions counter correct.

Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
Signed-off-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_ct.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -671,9 +671,10 @@ static int tcf_ct_ipv6_is_fragment(struc
 }
 
 static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
-				   u8 family, u16 zone)
+				   u8 family, u16 zone, bool *defrag)
 {
 	enum ip_conntrack_info ctinfo;
+	struct qdisc_skb_cb cb;
 	struct nf_conn *ct;
 	int err = 0;
 	bool frag;
@@ -691,6 +692,7 @@ static int tcf_ct_handle_fragments(struc
 		return err;
 
 	skb_get(skb);
+	cb = *qdisc_skb_cb(skb);
 
 	if (family == NFPROTO_IPV4) {
 		enum ip_defrag_users user = IP_DEFRAG_CONNTRACK_IN + zone;
@@ -701,6 +703,9 @@ static int tcf_ct_handle_fragments(struc
 		local_bh_enable();
 		if (err && err != -EINPROGRESS)
 			goto out_free;
+
+		if (!err)
+			*defrag = true;
 	} else { /* NFPROTO_IPV6 */
 #if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
 		enum ip6_defrag_users user = IP6_DEFRAG_CONNTRACK_IN + zone;
@@ -709,12 +714,16 @@ static int tcf_ct_handle_fragments(struc
 		err = nf_ct_frag6_gather(net, skb, user);
 		if (err && err != -EINPROGRESS)
 			goto out_free;
+
+		if (!err)
+			*defrag = true;
 #else
 		err = -EOPNOTSUPP;
 		goto out_free;
 #endif
 	}
 
+	*qdisc_skb_cb(skb) = cb;
 	skb_clear_hash(skb);
 	skb->ignore_df = 1;
 	return err;
@@ -912,6 +921,7 @@ static int tcf_ct_act(struct sk_buff *sk
 	int nh_ofs, err, retval;
 	struct tcf_ct_params *p;
 	bool skip_add = false;
+	bool defrag = false;
 	struct nf_conn *ct;
 	u8 family;
 
@@ -942,7 +952,7 @@ static int tcf_ct_act(struct sk_buff *sk
 	 */
 	nh_ofs = skb_network_offset(skb);
 	skb_pull_rcsum(skb, nh_ofs);
-	err = tcf_ct_handle_fragments(net, skb, family, p->zone);
+	err = tcf_ct_handle_fragments(net, skb, family, p->zone, &defrag);
 	if (err == -EINPROGRESS) {
 		retval = TC_ACT_STOLEN;
 		goto out;
@@ -1010,6 +1020,8 @@ out_push:
 
 out:
 	tcf_action_update_bstats(&c->common, skb);
+	if (defrag)
+		qdisc_skb_cb(skb)->pkt_len = skb->len;
 	return retval;
 
 drop:


