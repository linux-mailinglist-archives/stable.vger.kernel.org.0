Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EEA5658377
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233328AbiL1Qr7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:47:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234940AbiL1Qrf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:47:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99CA1B1E5
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:42:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72F9C61572
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:42:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 838B7C433D2;
        Wed, 28 Dec 2022 16:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245769;
        bh=Wxpn4VT2sG5tdkERScDr+DU3aoj/og+kDGTWbXqoHhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DbSE5aMr4YYayF7fzVT/U5IRa2+vaSOGzIZ1u2vMmjeqKg/sZcvrG3r4HNB3bgx07
         VuHGO/CBrFHGI7wWwVfQTdX81vSZbIoE2ThpROZ3nSQEHuHM0f9u2JsdJhJwtL+0KT
         ZqTC+4sKUCt4f0/UOsy8YyB/oFeI5Mx+o5QcP/9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eelco Chaudron <echaudro@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0919/1146] openvswitch: Fix flow lookup to use unmasked key
Date:   Wed, 28 Dec 2022 15:40:58 +0100
Message-Id: <20221228144355.218444336@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eelco Chaudron <echaudro@redhat.com>

[ Upstream commit 68bb10101e6b0a6bb44e9c908ef795fc4af99eae ]

The commit mentioned below causes the ovs_flow_tbl_lookup() function
to be called with the masked key. However, it's supposed to be called
with the unmasked key. This due to the fact that the datapath supports
installing wider flows, and OVS relies on this behavior. For example
if ipv4(src=1.1.1.1/192.0.0.0, dst=1.1.1.2/192.0.0.0) exists, a wider
flow (smaller mask) of ipv4(src=192.1.1.1/128.0.0.0,dst=192.1.1.2/
128.0.0.0) is allowed to be added.

However, if we try to add a wildcard rule, the installation fails:

$ ovs-appctl dpctl/add-flow system@myDP "in_port(1),eth_type(0x0800), \
  ipv4(src=1.1.1.1/192.0.0.0,dst=1.1.1.2/192.0.0.0,frag=no)" 2
$ ovs-appctl dpctl/add-flow system@myDP "in_port(1),eth_type(0x0800), \
  ipv4(src=192.1.1.1/0.0.0.0,dst=49.1.1.2/0.0.0.0,frag=no)" 2
ovs-vswitchd: updating flow table (File exists)

The reason is that the key used to determine if the flow is already
present in the system uses the original key ANDed with the mask.
This results in the IP address not being part of the (miniflow) key,
i.e., being substituted with an all-zero value. When doing the actual
lookup, this results in the key wrongfully matching the first flow,
and therefore the flow does not get installed.

This change reverses the commit below, but rather than having the key
on the stack, it's allocated.

Fixes: 190aa3e77880 ("openvswitch: Fix Frame-size larger than 1024 bytes warning.")

Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/datapath.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 8b84869eb2ac..fa0f1952d763 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -948,6 +948,7 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	struct sw_flow_mask mask;
 	struct sk_buff *reply;
 	struct datapath *dp;
+	struct sw_flow_key *key;
 	struct sw_flow_actions *acts;
 	struct sw_flow_match match;
 	u32 ufid_flags = ovs_nla_get_ufid_flags(a[OVS_FLOW_ATTR_UFID_FLAGS]);
@@ -975,24 +976,26 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	/* Extract key. */
-	ovs_match_init(&match, &new_flow->key, false, &mask);
+	key = kzalloc(sizeof(*key), GFP_KERNEL);
+	if (!key) {
+		error = -ENOMEM;
+		goto err_kfree_key;
+	}
+
+	ovs_match_init(&match, key, false, &mask);
 	error = ovs_nla_get_match(net, &match, a[OVS_FLOW_ATTR_KEY],
 				  a[OVS_FLOW_ATTR_MASK], log);
 	if (error)
 		goto err_kfree_flow;
 
+	ovs_flow_mask_key(&new_flow->key, key, true, &mask);
+
 	/* Extract flow identifier. */
 	error = ovs_nla_get_identifier(&new_flow->id, a[OVS_FLOW_ATTR_UFID],
-				       &new_flow->key, log);
+				       key, log);
 	if (error)
 		goto err_kfree_flow;
 
-	/* unmasked key is needed to match when ufid is not used. */
-	if (ovs_identifier_is_key(&new_flow->id))
-		match.key = new_flow->id.unmasked_key;
-
-	ovs_flow_mask_key(&new_flow->key, &new_flow->key, true, &mask);
-
 	/* Validate actions. */
 	error = ovs_nla_copy_actions(net, a[OVS_FLOW_ATTR_ACTIONS],
 				     &new_flow->key, &acts, log);
@@ -1019,7 +1022,7 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	if (ovs_identifier_is_ufid(&new_flow->id))
 		flow = ovs_flow_tbl_lookup_ufid(&dp->table, &new_flow->id);
 	if (!flow)
-		flow = ovs_flow_tbl_lookup(&dp->table, &new_flow->key);
+		flow = ovs_flow_tbl_lookup(&dp->table, key);
 	if (likely(!flow)) {
 		rcu_assign_pointer(new_flow->sf_acts, acts);
 
@@ -1089,6 +1092,8 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
 
 	if (reply)
 		ovs_notify(&dp_flow_genl_family, reply, info);
+
+	kfree(key);
 	return 0;
 
 err_unlock_ovs:
@@ -1098,6 +1103,8 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	ovs_nla_free_flow_actions(acts);
 err_kfree_flow:
 	ovs_flow_free(new_flow, false);
+err_kfree_key:
+	kfree(key);
 error:
 	return error;
 }
-- 
2.35.1



