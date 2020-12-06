Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82AC72D0446
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbgLFLoZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:44:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:43844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729292AbgLFLoJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 06:44:09 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eelco Chaudron <echaudro@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 05/46] net: openvswitch: fix TTL decrement action netlink message format
Date:   Sun,  6 Dec 2020 12:17:13 +0100
Message-Id: <20201206111556.703800808@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206111556.455533723@linuxfoundation.org>
References: <20201206111556.455533723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eelco Chaudron <echaudro@redhat.com>

[ Upstream commit 69929d4c49e182f8526d42c43b37b460d562d3a0 ]

Currently, the openvswitch module is not accepting the correctly formated
netlink message for the TTL decrement action. For both setting and getting
the dec_ttl action, the actions should be nested in the
OVS_DEC_TTL_ATTR_ACTION attribute as mentioned in the openvswitch.h uapi.

When the original patch was sent, it was tested with a private OVS userspace
implementation. This implementation was unfortunately not upstreamed and
reviewed, hence an erroneous version of this patch was sent out.

Leaving the patch as-is would cause problems as the kernel module could
interpret additional attributes as actions and vice-versa, due to the
actions not being encapsulated/nested within the actual attribute, but
being concatinated after it.

Fixes: 744676e77720 ("openvswitch: add TTL decrement action")
Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
Link: https://lore.kernel.org/r/160622121495.27296.888010441924340582.stgit@wsfd-netdev64.ntdv.lab.eng.bos.redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/openvswitch.h |    2 +
 net/openvswitch/actions.c        |    7 +--
 net/openvswitch/flow_netlink.c   |   74 ++++++++++++++++++++++++++++-----------
 3 files changed, 60 insertions(+), 23 deletions(-)

--- a/include/uapi/linux/openvswitch.h
+++ b/include/uapi/linux/openvswitch.h
@@ -1058,4 +1058,6 @@ enum ovs_dec_ttl_attr {
 	__OVS_DEC_TTL_ATTR_MAX
 };
 
+#define OVS_DEC_TTL_ATTR_MAX (__OVS_DEC_TTL_ATTR_MAX - 1)
+
 #endif /* _LINUX_OPENVSWITCH_H */
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -970,14 +970,13 @@ static int dec_ttl_exception_handler(str
 {
 	/* The first action is always 'OVS_DEC_TTL_ATTR_ARG'. */
 	struct nlattr *dec_ttl_arg = nla_data(attr);
-	int rem = nla_len(attr);
 
 	if (nla_len(dec_ttl_arg)) {
-		struct nlattr *actions = nla_next(dec_ttl_arg, &rem);
+		struct nlattr *actions = nla_data(dec_ttl_arg);
 
 		if (actions)
-			return clone_execute(dp, skb, key, 0, actions, rem,
-					     last, false);
+			return clone_execute(dp, skb, key, 0, nla_data(actions),
+					     nla_len(actions), last, false);
 	}
 	consume_skb(skb);
 	return 0;
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -2503,28 +2503,42 @@ static int validate_and_copy_dec_ttl(str
 				     __be16 eth_type, __be16 vlan_tci,
 				     u32 mpls_label_count, bool log)
 {
-	int start, err;
-	u32 nested = true;
+	const struct nlattr *attrs[OVS_DEC_TTL_ATTR_MAX + 1];
+	int start, action_start, err, rem;
+	const struct nlattr *a, *actions;
+
+	memset(attrs, 0, sizeof(attrs));
+	nla_for_each_nested(a, attr, rem) {
+		int type = nla_type(a);
+
+		/* Ignore unknown attributes to be future proof. */
+		if (type > OVS_DEC_TTL_ATTR_MAX)
+			continue;
 
-	if (!nla_len(attr))
-		return ovs_nla_add_action(sfa, OVS_ACTION_ATTR_DEC_TTL,
-					  NULL, 0, log);
+		if (!type || attrs[type])
+			return -EINVAL;
+
+		attrs[type] = a;
+	}
+
+	actions = attrs[OVS_DEC_TTL_ATTR_ACTION];
+	if (rem || !actions || (nla_len(actions) && nla_len(actions) < NLA_HDRLEN))
+		return -EINVAL;
 
 	start = add_nested_action_start(sfa, OVS_ACTION_ATTR_DEC_TTL, log);
 	if (start < 0)
 		return start;
 
-	err = ovs_nla_add_action(sfa, OVS_DEC_TTL_ATTR_ACTION, &nested,
-				 sizeof(nested), log);
-
-	if (err)
-		return err;
+	action_start = add_nested_action_start(sfa, OVS_DEC_TTL_ATTR_ACTION, log);
+	if (action_start < 0)
+		return start;
 
-	err = __ovs_nla_copy_actions(net, attr, key, sfa, eth_type,
+	err = __ovs_nla_copy_actions(net, actions, key, sfa, eth_type,
 				     vlan_tci, mpls_label_count, log);
 	if (err)
 		return err;
 
+	add_nested_action_end(*sfa, action_start);
 	add_nested_action_end(*sfa, start);
 	return 0;
 }
@@ -3487,20 +3501,42 @@ out:
 static int dec_ttl_action_to_attr(const struct nlattr *attr,
 				  struct sk_buff *skb)
 {
-	int err = 0, rem = nla_len(attr);
-	struct nlattr *start;
+	struct nlattr *start, *action_start;
+	const struct nlattr *a;
+	int err = 0, rem;
 
 	start = nla_nest_start_noflag(skb, OVS_ACTION_ATTR_DEC_TTL);
-
 	if (!start)
 		return -EMSGSIZE;
 
-	err = ovs_nla_put_actions(nla_data(attr), rem, skb);
-	if (err)
-		nla_nest_cancel(skb, start);
-	else
-		nla_nest_end(skb, start);
+	nla_for_each_attr(a, nla_data(attr), nla_len(attr), rem) {
+		switch (nla_type(a)) {
+		case OVS_DEC_TTL_ATTR_ACTION:
+
+			action_start = nla_nest_start_noflag(skb, OVS_DEC_TTL_ATTR_ACTION);
+			if (!action_start) {
+				err = -EMSGSIZE;
+				goto out;
+			}
 
+			err = ovs_nla_put_actions(nla_data(a), nla_len(a), skb);
+			if (err)
+				goto out;
+
+			nla_nest_end(skb, action_start);
+			break;
+
+		default:
+			/* Ignore all other option to be future compatible */
+			break;
+		}
+	}
+
+	nla_nest_end(skb, start);
+	return 0;
+
+out:
+	nla_nest_cancel(skb, start);
 	return err;
 }
 


