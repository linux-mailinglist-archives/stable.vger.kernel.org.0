Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC4B6948E6
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbjBMOyQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:54:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbjBMOyN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:54:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E1ADE06D
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:54:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 261C76113E
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:54:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A32AC433EF;
        Mon, 13 Feb 2023 14:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300049;
        bh=eVlFVa+lIV0yNgDX2e9Sm6dY+GzNPoq45rLmRtkR0uc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2aBMXXxA/+jvzgtClAeu4/OaBnwW0L78kvR4egyX+JlusUCqWo4JUIw0LhHqPKv1k
         LzxnnTHJ+fMirVgVgdDgolgam7benPCrxzY0Wa2P0BulpeioXR1Jr1x2KXhrIDJ3YW
         BAEbioGCFgJfSbRIo2YBxQdU3jN91lLclBTYzP6Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Simon Horman <simon.horman@corigine.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 044/114] net: mscc: ocelot: fix VCAP filters not matching on MAC with "protocol 802.1Q"
Date:   Mon, 13 Feb 2023 15:47:59 +0100
Message-Id: <20230213144744.430322970@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit f964f8399df29d3e3ced77177cf35131cd2491bf ]

Alternative short title: don't instruct the hardware to match on
EtherType with "protocol 802.1Q" flower filters. It doesn't work for the
reasons detailed below.

With a command such as the following:

tc filter add dev $swp1 ingress chain $(IS1 2) pref 3 \
	protocol 802.1Q flower skip_sw vlan_id 200 src_mac $h1_mac \
	action vlan modify id 300 \
	action goto chain $(IS2 0 0)

the created filter is set by ocelot_flower_parse_key() to be of type
OCELOT_VCAP_KEY_ETYPE, and etype is set to {value=0x8100, mask=0xffff}.
This gets propagated all the way to is1_entry_set() which commits it to
hardware (the VCAP_IS1_HK_ETYPE field of the key). Compare this to the
case where src_mac isn't specified - the key type is OCELOT_VCAP_KEY_ANY,
and is1_entry_set() doesn't populate VCAP_IS1_HK_ETYPE.

The problem is that for VLAN-tagged frames, the hardware interprets the
ETYPE field as holding the encapsulated VLAN protocol. So the above
filter will only match those packets which have an encapsulated protocol
of 0x8100, rather than all packets with VLAN ID 200 and the given src_mac.

The reason why this is allowed to occur is because, although we have a
block of code in ocelot_flower_parse_key() which sets "match_protocol"
to false when VLAN keys are present, that code executes too late.
There is another block of code, which executes for Ethernet addresses,
and has a "goto finished_key_parsing" and skips the VLAN header parsing.
By skipping it, "match_protocol" remains with the value it was
initialized with, i.e. "true", and "proto" is set to f->common.protocol,
or 0x8100.

The concept of ignoring some keys rather than erroring out when they are
present but can't be offloaded is dubious in itself, but is present
since the initial commit fe3490e6107e ("net: mscc: ocelot: Hardware
ofload for tc flower filter"), and it's outside of the scope of this
patch to change that.

The problem was introduced when the driver started to interpret the
flower filter's protocol, and populate the VCAP filter's ETYPE field
based on it.

To fix this, it is sufficient to move the code that parses the VLAN keys
earlier than the "goto finished_key_parsing" instruction. This will
ensure that if we have a flower filter with both VLAN and Ethernet
address keys, it won't match on ETYPE 0x8100, because the VLAN key
parsing sets "match_protocol = false".

Fixes: 86b956de119c ("net: mscc: ocelot: support matching on EtherType")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230205192409.1796428-1-vladimir.oltean@nxp.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot_flower.c | 24 +++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 7c0897e779dc6..ee052404eb55a 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -605,6 +605,18 @@ ocelot_flower_parse_key(struct ocelot *ocelot, int port, bool ingress,
 		flow_rule_match_control(rule, &match);
 	}
 
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_VLAN)) {
+		struct flow_match_vlan match;
+
+		flow_rule_match_vlan(rule, &match);
+		filter->key_type = OCELOT_VCAP_KEY_ANY;
+		filter->vlan.vid.value = match.key->vlan_id;
+		filter->vlan.vid.mask = match.mask->vlan_id;
+		filter->vlan.pcp.value[0] = match.key->vlan_priority;
+		filter->vlan.pcp.mask[0] = match.mask->vlan_priority;
+		match_protocol = false;
+	}
+
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
 		struct flow_match_eth_addrs match;
 
@@ -737,18 +749,6 @@ ocelot_flower_parse_key(struct ocelot *ocelot, int port, bool ingress,
 		match_protocol = false;
 	}
 
-	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_VLAN)) {
-		struct flow_match_vlan match;
-
-		flow_rule_match_vlan(rule, &match);
-		filter->key_type = OCELOT_VCAP_KEY_ANY;
-		filter->vlan.vid.value = match.key->vlan_id;
-		filter->vlan.vid.mask = match.mask->vlan_id;
-		filter->vlan.pcp.value[0] = match.key->vlan_priority;
-		filter->vlan.pcp.mask[0] = match.mask->vlan_priority;
-		match_protocol = false;
-	}
-
 finished_key_parsing:
 	if (match_protocol && proto != ETH_P_ALL) {
 		if (filter->block_id == VCAP_ES0) {
-- 
2.39.0



