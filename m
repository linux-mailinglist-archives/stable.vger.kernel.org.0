Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCB6505477
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241278AbiDRNHW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241039AbiDRNF2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:05:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 144CC340DF;
        Mon, 18 Apr 2022 05:46:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3C8CB80D9C;
        Mon, 18 Apr 2022 12:46:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FDB1C385A1;
        Mon, 18 Apr 2022 12:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285966;
        bh=WCzbYXy4QZE2nwEmpkErlYrqjEZkOGv7yFIJP1eHRAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eTn6U4/TUa46/S82Z4iO/iUpeEmzQRwIhttD6wI2G0aVo8bAtFYYaTpfrgVfXPCom
         PyLLTiNaL6JQUpMgU9ueY1IaAB9cEg4a1rQKSZRbeff5IVBrhmFA2WomIVbWpCT9Ok
         2kuwrQRwOyzlP94I5gDYWwuIWXUfkDhpqD0Dt/nU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlad Buslov <vladbu@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 02/32] net/sched: flower: fix parsing of ethertype following VLAN header
Date:   Mon, 18 Apr 2022 14:13:42 +0200
Message-Id: <20220418121127.200329057@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121127.127656835@linuxfoundation.org>
References: <20220418121127.127656835@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

[ Upstream commit 2105f700b53c24aa48b65c15652acc386044d26a ]

A tc flower filter matching TCA_FLOWER_KEY_VLAN_ETH_TYPE is expected to
match the L2 ethertype following the first VLAN header, as confirmed by
linked discussion with the maintainer. However, such rule also matches
packets that have additional second VLAN header, even though filter has
both eth_type and vlan_ethtype set to "ipv4". Looking at the code this
seems to be mostly an artifact of the way flower uses flow dissector.
First, even though looking at the uAPI eth_type and vlan_ethtype appear
like a distinct fields, in flower they are all mapped to the same
key->basic.n_proto. Second, flow dissector skips following VLAN header as
no keys for FLOW_DISSECTOR_KEY_CVLAN are set and eventually assigns the
value of n_proto to last parsed header. With these, such filters ignore any
headers present between first VLAN header and first "non magic"
header (ipv4 in this case) that doesn't result
FLOW_DISSECT_RET_PROTO_AGAIN.

Fix the issue by extending flow dissector VLAN key structure with new
'vlan_eth_type' field that matches first ethertype following previously
parsed VLAN header. Modify flower classifier to set the new
flow_dissector_key_vlan->vlan_eth_type with value obtained from
TCA_FLOWER_KEY_VLAN_ETH_TYPE/TCA_FLOWER_KEY_CVLAN_ETH_TYPE uAPIs.

Link: https://lore.kernel.org/all/Yjhgi48BpTGh6dig@nanopsycho/
Fixes: 9399ae9a6cb2 ("net_sched: flower: Add vlan support")
Fixes: d64efd0926ba ("net/sched: flower: Add supprt for matching on QinQ vlan headers")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/flow_dissector.h |  2 ++
 net/core/flow_dissector.c    |  1 +
 net/sched/cls_flower.c       | 18 +++++++++++++-----
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index 99f8580344d0..01229084b3ed 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -50,6 +50,8 @@ struct flow_dissector_key_vlan {
 	u16	vlan_id:12,
 		vlan_priority:3;
 	__be16	vlan_tpid;
+	__be16	vlan_eth_type;
+	u16	padding;
 };
 
 struct flow_dissector_key_mpls {
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 949694c70cbc..da860a680256 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -827,6 +827,7 @@ bool __skb_flow_dissect(const struct sk_buff *skb,
 					 VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
 			}
 			key_vlan->vlan_tpid = saved_vlan_tpid;
+			key_vlan->vlan_eth_type = proto;
 		}
 
 		fdret = FLOW_DISSECT_RET_PROTO_AGAIN;
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 208436eb107c..6163648145c1 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -554,6 +554,7 @@ static int fl_set_key_mpls(struct nlattr **tb,
 static void fl_set_key_vlan(struct nlattr **tb,
 			    __be16 ethertype,
 			    int vlan_id_key, int vlan_prio_key,
+			    int vlan_next_eth_type_key,
 			    struct flow_dissector_key_vlan *key_val,
 			    struct flow_dissector_key_vlan *key_mask)
 {
@@ -572,6 +573,11 @@ static void fl_set_key_vlan(struct nlattr **tb,
 	}
 	key_val->vlan_tpid = ethertype;
 	key_mask->vlan_tpid = cpu_to_be16(~0);
+	if (tb[vlan_next_eth_type_key]) {
+		key_val->vlan_eth_type =
+			nla_get_be16(tb[vlan_next_eth_type_key]);
+		key_mask->vlan_eth_type = cpu_to_be16(~0);
+	}
 }
 
 static void fl_set_key_flag(u32 flower_key, u32 flower_mask,
@@ -801,8 +807,9 @@ static int fl_set_key(struct net *net, struct nlattr **tb,
 
 		if (eth_type_vlan(ethertype)) {
 			fl_set_key_vlan(tb, ethertype, TCA_FLOWER_KEY_VLAN_ID,
-					TCA_FLOWER_KEY_VLAN_PRIO, &key->vlan,
-					&mask->vlan);
+					TCA_FLOWER_KEY_VLAN_PRIO,
+					TCA_FLOWER_KEY_VLAN_ETH_TYPE,
+					&key->vlan, &mask->vlan);
 
 			if (tb[TCA_FLOWER_KEY_VLAN_ETH_TYPE]) {
 				ethertype = nla_get_be16(tb[TCA_FLOWER_KEY_VLAN_ETH_TYPE]);
@@ -810,6 +817,7 @@ static int fl_set_key(struct net *net, struct nlattr **tb,
 					fl_set_key_vlan(tb, ethertype,
 							TCA_FLOWER_KEY_CVLAN_ID,
 							TCA_FLOWER_KEY_CVLAN_PRIO,
+							TCA_FLOWER_KEY_CVLAN_ETH_TYPE,
 							&key->cvlan, &mask->cvlan);
 					fl_set_key_val(tb, &key->basic.n_proto,
 						       TCA_FLOWER_KEY_CVLAN_ETH_TYPE,
@@ -1717,13 +1725,13 @@ static int fl_dump_key(struct sk_buff *skb, struct net *net,
 		goto nla_put_failure;
 
 	if (mask->basic.n_proto) {
-		if (mask->cvlan.vlan_tpid) {
+		if (mask->cvlan.vlan_eth_type) {
 			if (nla_put_be16(skb, TCA_FLOWER_KEY_CVLAN_ETH_TYPE,
 					 key->basic.n_proto))
 				goto nla_put_failure;
-		} else if (mask->vlan.vlan_tpid) {
+		} else if (mask->vlan.vlan_eth_type) {
 			if (nla_put_be16(skb, TCA_FLOWER_KEY_VLAN_ETH_TYPE,
-					 key->basic.n_proto))
+					 key->vlan.vlan_eth_type))
 				goto nla_put_failure;
 		}
 	}
-- 
2.35.1



