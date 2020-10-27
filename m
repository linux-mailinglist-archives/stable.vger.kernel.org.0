Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 036E229B5EC
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1796374AbgJ0PRz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:17:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:55206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1796364AbgJ0PRr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:17:47 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F328206E5;
        Tue, 27 Oct 2020 15:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811866;
        bh=JUSRvPFQ1lQHB5gvu6wyAiEWe3VTe2HprP/nSuA1g8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f2iaQBYoL0xjknDK1pxompB4GhZcu4W2DB2FcCHEy14JJwoKWHee1+0eBwIByWCei
         9/AXIssxjCSJyxQkbnf7xqXU0LBI50nZtYsGwbBhTo+xgIG5hUr9ymYpdjqfaWAbCh
         SlcTSq2GEsl31Z7WQKggGvBh/zijbM0Y3rOwEtCQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Herat Ramani <herat@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 003/757] cxgb4: handle 4-tuple PEDIT to NAT mode translation
Date:   Tue, 27 Oct 2020 14:44:13 +0100
Message-Id: <20201027135450.679758375@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herat Ramani <herat@chelsio.com>

[ Upstream commit 2ef813b8f405db3f72202b6fcae40a628ab80a53 ]

The 4-tuple NAT offload via PEDIT always overwrites all the 4-tuple
fields even if they had not been explicitly enabled. If any fields in
the 4-tuple are not enabled, then the hardware overwrites the
disabled fields with zeros, instead of ignoring them.

So, add a parser that can translate the enabled 4-tuple PEDIT fields
to one of the NAT mode combinations supported by the hardware and
hence avoid overwriting disabled fields to 0. Any rule with
unsupported NAT mode combination is rejected.

Signed-off-by: Herat Ramani <herat@chelsio.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c |  175 +++++++++++++++++--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h |   15 +
 2 files changed, 177 insertions(+), 13 deletions(-)

--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
@@ -60,6 +60,89 @@ static struct ch_tc_pedit_fields pedits[
 	PEDIT_FIELDS(IP6_, DST_127_96, 4, nat_lip, 12),
 };
 
+static const struct cxgb4_natmode_config cxgb4_natmode_config_array[] = {
+	/* Default supported NAT modes */
+	{
+		.chip = CHELSIO_T5,
+		.flags = CXGB4_ACTION_NATMODE_NONE,
+		.natmode = NAT_MODE_NONE,
+	},
+	{
+		.chip = CHELSIO_T5,
+		.flags = CXGB4_ACTION_NATMODE_DIP,
+		.natmode = NAT_MODE_DIP,
+	},
+	{
+		.chip = CHELSIO_T5,
+		.flags = CXGB4_ACTION_NATMODE_DIP | CXGB4_ACTION_NATMODE_DPORT,
+		.natmode = NAT_MODE_DIP_DP,
+	},
+	{
+		.chip = CHELSIO_T5,
+		.flags = CXGB4_ACTION_NATMODE_DIP | CXGB4_ACTION_NATMODE_DPORT |
+			 CXGB4_ACTION_NATMODE_SIP,
+		.natmode = NAT_MODE_DIP_DP_SIP,
+	},
+	{
+		.chip = CHELSIO_T5,
+		.flags = CXGB4_ACTION_NATMODE_DIP | CXGB4_ACTION_NATMODE_DPORT |
+			 CXGB4_ACTION_NATMODE_SPORT,
+		.natmode = NAT_MODE_DIP_DP_SP,
+	},
+	{
+		.chip = CHELSIO_T5,
+		.flags = CXGB4_ACTION_NATMODE_SIP | CXGB4_ACTION_NATMODE_SPORT,
+		.natmode = NAT_MODE_SIP_SP,
+	},
+	{
+		.chip = CHELSIO_T5,
+		.flags = CXGB4_ACTION_NATMODE_DIP | CXGB4_ACTION_NATMODE_SIP |
+			 CXGB4_ACTION_NATMODE_SPORT,
+		.natmode = NAT_MODE_DIP_SIP_SP,
+	},
+	{
+		.chip = CHELSIO_T5,
+		.flags = CXGB4_ACTION_NATMODE_DIP | CXGB4_ACTION_NATMODE_SIP |
+			 CXGB4_ACTION_NATMODE_DPORT |
+			 CXGB4_ACTION_NATMODE_SPORT,
+		.natmode = NAT_MODE_ALL,
+	},
+	/* T6+ can ignore L4 ports when they're disabled. */
+	{
+		.chip = CHELSIO_T6,
+		.flags = CXGB4_ACTION_NATMODE_SIP,
+		.natmode = NAT_MODE_SIP_SP,
+	},
+	{
+		.chip = CHELSIO_T6,
+		.flags = CXGB4_ACTION_NATMODE_DIP | CXGB4_ACTION_NATMODE_SPORT,
+		.natmode = NAT_MODE_DIP_DP_SP,
+	},
+	{
+		.chip = CHELSIO_T6,
+		.flags = CXGB4_ACTION_NATMODE_DIP | CXGB4_ACTION_NATMODE_SIP,
+		.natmode = NAT_MODE_ALL,
+	},
+};
+
+static void cxgb4_action_natmode_tweak(struct ch_filter_specification *fs,
+				       u8 natmode_flags)
+{
+	u8 i = 0;
+
+	/* Translate the enabled NAT 4-tuple fields to one of the
+	 * hardware supported NAT mode configurations. This ensures
+	 * that we pick a valid combination, where the disabled fields
+	 * do not get overwritten to 0.
+	 */
+	for (i = 0; i < ARRAY_SIZE(cxgb4_natmode_config_array); i++) {
+		if (cxgb4_natmode_config_array[i].flags == natmode_flags) {
+			fs->nat_mode = cxgb4_natmode_config_array[i].natmode;
+			return;
+		}
+	}
+}
+
 static struct ch_tc_flower_entry *allocate_flower_entry(void)
 {
 	struct ch_tc_flower_entry *new = kzalloc(sizeof(*new), GFP_KERNEL);
@@ -289,7 +372,8 @@ static void offload_pedit(struct ch_filt
 }
 
 static void process_pedit_field(struct ch_filter_specification *fs, u32 val,
-				u32 mask, u32 offset, u8 htype)
+				u32 mask, u32 offset, u8 htype,
+				u8 *natmode_flags)
 {
 	switch (htype) {
 	case FLOW_ACT_MANGLE_HDR_TYPE_ETH:
@@ -314,67 +398,102 @@ static void process_pedit_field(struct c
 		switch (offset) {
 		case PEDIT_IP4_SRC:
 			offload_pedit(fs, val, mask, IP4_SRC);
+			*natmode_flags |= CXGB4_ACTION_NATMODE_SIP;
 			break;
 		case PEDIT_IP4_DST:
 			offload_pedit(fs, val, mask, IP4_DST);
+			*natmode_flags |= CXGB4_ACTION_NATMODE_DIP;
 		}
-		fs->nat_mode = NAT_MODE_ALL;
 		break;
 	case FLOW_ACT_MANGLE_HDR_TYPE_IP6:
 		switch (offset) {
 		case PEDIT_IP6_SRC_31_0:
 			offload_pedit(fs, val, mask, IP6_SRC_31_0);
+			*natmode_flags |= CXGB4_ACTION_NATMODE_SIP;
 			break;
 		case PEDIT_IP6_SRC_63_32:
 			offload_pedit(fs, val, mask, IP6_SRC_63_32);
+			*natmode_flags |=  CXGB4_ACTION_NATMODE_SIP;
 			break;
 		case PEDIT_IP6_SRC_95_64:
 			offload_pedit(fs, val, mask, IP6_SRC_95_64);
+			*natmode_flags |= CXGB4_ACTION_NATMODE_SIP;
 			break;
 		case PEDIT_IP6_SRC_127_96:
 			offload_pedit(fs, val, mask, IP6_SRC_127_96);
+			*natmode_flags |= CXGB4_ACTION_NATMODE_SIP;
 			break;
 		case PEDIT_IP6_DST_31_0:
 			offload_pedit(fs, val, mask, IP6_DST_31_0);
+			*natmode_flags |= CXGB4_ACTION_NATMODE_DIP;
 			break;
 		case PEDIT_IP6_DST_63_32:
 			offload_pedit(fs, val, mask, IP6_DST_63_32);
+			*natmode_flags |= CXGB4_ACTION_NATMODE_DIP;
 			break;
 		case PEDIT_IP6_DST_95_64:
 			offload_pedit(fs, val, mask, IP6_DST_95_64);
+			*natmode_flags |= CXGB4_ACTION_NATMODE_DIP;
 			break;
 		case PEDIT_IP6_DST_127_96:
 			offload_pedit(fs, val, mask, IP6_DST_127_96);
+			*natmode_flags |= CXGB4_ACTION_NATMODE_DIP;
 		}
-		fs->nat_mode = NAT_MODE_ALL;
 		break;
 	case FLOW_ACT_MANGLE_HDR_TYPE_TCP:
 		switch (offset) {
 		case PEDIT_TCP_SPORT_DPORT:
-			if (~mask & PEDIT_TCP_UDP_SPORT_MASK)
+			if (~mask & PEDIT_TCP_UDP_SPORT_MASK) {
 				fs->nat_fport = val;
-			else
+				*natmode_flags |= CXGB4_ACTION_NATMODE_SPORT;
+			} else {
 				fs->nat_lport = val >> 16;
+				*natmode_flags |= CXGB4_ACTION_NATMODE_DPORT;
+			}
 		}
-		fs->nat_mode = NAT_MODE_ALL;
 		break;
 	case FLOW_ACT_MANGLE_HDR_TYPE_UDP:
 		switch (offset) {
 		case PEDIT_UDP_SPORT_DPORT:
-			if (~mask & PEDIT_TCP_UDP_SPORT_MASK)
+			if (~mask & PEDIT_TCP_UDP_SPORT_MASK) {
 				fs->nat_fport = val;
-			else
+				*natmode_flags |= CXGB4_ACTION_NATMODE_SPORT;
+			} else {
 				fs->nat_lport = val >> 16;
+				*natmode_flags |= CXGB4_ACTION_NATMODE_DPORT;
+			}
 		}
-		fs->nat_mode = NAT_MODE_ALL;
+		break;
 	}
 }
 
+static int cxgb4_action_natmode_validate(struct adapter *adap, u8 natmode_flags,
+					 struct netlink_ext_ack *extack)
+{
+	u8 i = 0;
+
+	/* Extract the NAT mode to enable based on what 4-tuple fields
+	 * are enabled to be overwritten. This ensures that the
+	 * disabled fields don't get overwritten to 0.
+	 */
+	for (i = 0; i < ARRAY_SIZE(cxgb4_natmode_config_array); i++) {
+		const struct cxgb4_natmode_config *c;
+
+		c = &cxgb4_natmode_config_array[i];
+		if (CHELSIO_CHIP_VERSION(adap->params.chip) >= c->chip &&
+		    natmode_flags == c->flags)
+			return 0;
+	}
+	NL_SET_ERR_MSG_MOD(extack, "Unsupported NAT mode 4-tuple combination");
+	return -EOPNOTSUPP;
+}
+
 void cxgb4_process_flow_actions(struct net_device *in,
 				struct flow_action *actions,
 				struct ch_filter_specification *fs)
 {
 	struct flow_action_entry *act;
+	u8 natmode_flags = 0;
 	int i;
 
 	flow_action_for_each(i, act, actions) {
@@ -426,7 +545,8 @@ void cxgb4_process_flow_actions(struct n
 			val = act->mangle.val;
 			offset = act->mangle.offset;
 
-			process_pedit_field(fs, val, mask, offset, htype);
+			process_pedit_field(fs, val, mask, offset, htype,
+					    &natmode_flags);
 			}
 			break;
 		case FLOW_ACTION_QUEUE:
@@ -438,6 +558,9 @@ void cxgb4_process_flow_actions(struct n
 			break;
 		}
 	}
+	if (natmode_flags)
+		cxgb4_action_natmode_tweak(fs, natmode_flags);
+
 }
 
 static bool valid_l4_mask(u32 mask)
@@ -454,7 +577,8 @@ static bool valid_l4_mask(u32 mask)
 }
 
 static bool valid_pedit_action(struct net_device *dev,
-			       const struct flow_action_entry *act)
+			       const struct flow_action_entry *act,
+			       u8 *natmode_flags)
 {
 	u32 mask, offset;
 	u8 htype;
@@ -479,7 +603,10 @@ static bool valid_pedit_action(struct ne
 	case FLOW_ACT_MANGLE_HDR_TYPE_IP4:
 		switch (offset) {
 		case PEDIT_IP4_SRC:
+			*natmode_flags |= CXGB4_ACTION_NATMODE_SIP;
+			break;
 		case PEDIT_IP4_DST:
+			*natmode_flags |= CXGB4_ACTION_NATMODE_DIP;
 			break;
 		default:
 			netdev_err(dev, "%s: Unsupported pedit field\n",
@@ -493,10 +620,13 @@ static bool valid_pedit_action(struct ne
 		case PEDIT_IP6_SRC_63_32:
 		case PEDIT_IP6_SRC_95_64:
 		case PEDIT_IP6_SRC_127_96:
+			*natmode_flags |= CXGB4_ACTION_NATMODE_SIP;
+			break;
 		case PEDIT_IP6_DST_31_0:
 		case PEDIT_IP6_DST_63_32:
 		case PEDIT_IP6_DST_95_64:
 		case PEDIT_IP6_DST_127_96:
+			*natmode_flags |= CXGB4_ACTION_NATMODE_DIP;
 			break;
 		default:
 			netdev_err(dev, "%s: Unsupported pedit field\n",
@@ -512,6 +642,10 @@ static bool valid_pedit_action(struct ne
 					   __func__);
 				return false;
 			}
+			if (~mask & PEDIT_TCP_UDP_SPORT_MASK)
+				*natmode_flags |= CXGB4_ACTION_NATMODE_SPORT;
+			else
+				*natmode_flags |= CXGB4_ACTION_NATMODE_DPORT;
 			break;
 		default:
 			netdev_err(dev, "%s: Unsupported pedit field\n",
@@ -527,6 +661,10 @@ static bool valid_pedit_action(struct ne
 					   __func__);
 				return false;
 			}
+			if (~mask & PEDIT_TCP_UDP_SPORT_MASK)
+				*natmode_flags |= CXGB4_ACTION_NATMODE_SPORT;
+			else
+				*natmode_flags |= CXGB4_ACTION_NATMODE_DPORT;
 			break;
 		default:
 			netdev_err(dev, "%s: Unsupported pedit field\n",
@@ -546,10 +684,12 @@ int cxgb4_validate_flow_actions(struct n
 				struct netlink_ext_ack *extack,
 				u8 matchall_filter)
 {
+	struct adapter *adap = netdev2adap(dev);
 	struct flow_action_entry *act;
 	bool act_redir = false;
 	bool act_pedit = false;
 	bool act_vlan = false;
+	u8 natmode_flags = 0;
 	int i;
 
 	if (!flow_action_basic_hw_stats_check(actions, extack))
@@ -563,7 +703,6 @@ int cxgb4_validate_flow_actions(struct n
 			break;
 		case FLOW_ACTION_MIRRED:
 		case FLOW_ACTION_REDIRECT: {
-			struct adapter *adap = netdev2adap(dev);
 			struct net_device *n_dev, *target_dev;
 			bool found = false;
 			unsigned int i;
@@ -620,7 +759,8 @@ int cxgb4_validate_flow_actions(struct n
 			}
 			break;
 		case FLOW_ACTION_MANGLE: {
-			bool pedit_valid = valid_pedit_action(dev, act);
+			bool pedit_valid = valid_pedit_action(dev, act,
+							      &natmode_flags);
 
 			if (!pedit_valid)
 				return -EOPNOTSUPP;
@@ -642,6 +782,15 @@ int cxgb4_validate_flow_actions(struct n
 		return -EINVAL;
 	}
 
+	if (act_pedit) {
+		int ret;
+
+		ret = cxgb4_action_natmode_validate(adap, natmode_flags,
+						    extack);
+		if (ret)
+			return ret;
+	}
+
 	return 0;
 }
 
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h
@@ -108,6 +108,21 @@ struct ch_tc_pedit_fields {
 #define PEDIT_TCP_SPORT_DPORT		0x0
 #define PEDIT_UDP_SPORT_DPORT		0x0
 
+enum cxgb4_action_natmode_flags {
+	CXGB4_ACTION_NATMODE_NONE = 0,
+	CXGB4_ACTION_NATMODE_DIP = (1 << 0),
+	CXGB4_ACTION_NATMODE_SIP = (1 << 1),
+	CXGB4_ACTION_NATMODE_DPORT = (1 << 2),
+	CXGB4_ACTION_NATMODE_SPORT = (1 << 3),
+};
+
+/* TC PEDIT action to NATMODE translation entry */
+struct cxgb4_natmode_config {
+	enum chip_type chip;
+	u8 flags;
+	u8 natmode;
+};
+
 void cxgb4_process_flow_actions(struct net_device *in,
 				struct flow_action *actions,
 				struct ch_filter_specification *fs);


