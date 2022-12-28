Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8226582BC
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233629AbiL1Qky (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:40:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235053AbiL1Qk1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:40:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8C261D0E0
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:35:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A20EDB8171F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3428C433D2;
        Wed, 28 Dec 2022 16:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245308;
        bh=SQeq6W8COQ2H8Z6I8XHlflQaBEbjD4HX5d5GKdDWKkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Js2ap26fJHrGLBH4tALVhTI6HFRVjjfdUuh4O7dts68OC8JFa0DOcLokC7H6CVE7w
         T7Rz031ZmmQZpjT/0Pz+6pPLmqvL3Bqwa6G85bcdMRDlnBu6gPoXxa3m0aeNqu2jfS
         VXrWv9Kv+a4+KTCJALhBYYo+umh7ec4DZkpgQS5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eelco Chaudron <echaudro@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0870/1073] openvswitch: Fix flow lookup to use unmasked key
Date:   Wed, 28 Dec 2022 15:40:58 +0100
Message-Id: <20221228144351.653074524@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
index ae7d4d03790c..ac66cdc7b67b 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -947,6 +947,7 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	struct sw_flow_mask mask;
 	struct sk_buff *reply;
 	struct datapath *dp;
+	struct sw_flow_key *key;
 	struct sw_flow_actions *acts;
 	struct sw_flow_match match;
 	u32 ufid_flags = ovs_nla_get_ufid_flags(a[OVS_FLOW_ATTR_UFID_FLAGS]);
@@ -974,24 +975,26 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
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
@@ -1018,7 +1021,7 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
 	if (ovs_identifier_is_ufid(&new_flow->id))
 		flow = ovs_flow_tbl_lookup_ufid(&dp->table, &new_flow->id);
 	if (!flow)
-		flow = ovs_flow_tbl_lookup(&dp->table, &new_flow->key);
+		flow = ovs_flow_tbl_lookup(&dp->table, key);
 	if (likely(!flow)) {
 		rcu_assign_pointer(new_flow->sf_acts, acts);
 
@@ -1088,6 +1091,8 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
 
 	if (reply)
 		ovs_notify(&dp_flow_genl_family, reply, info);
+
+	kfree(key);
 	return 0;
 
 err_unlock_ovs:
@@ -1097,6 +1102,8 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
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



