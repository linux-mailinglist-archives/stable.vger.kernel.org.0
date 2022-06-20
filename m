Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEACE551B8F
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245191AbiFTNLA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343687AbiFTNJe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:09:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B3B1A82D;
        Mon, 20 Jun 2022 06:04:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A87B3B811C3;
        Mon, 20 Jun 2022 13:04:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 011EBC3411B;
        Mon, 20 Jun 2022 13:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730248;
        bh=cmruC+OqZfqrMTsfd/DVGK3o8B7R6lhV1CvtHack+6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c53i8IoSu7pddUGYWRtTgBqiy/eiMNeu/lqkDOwQ5utQyMfp+p7MLdnp93+azd5Ga
         KQusycmK9KM7YJym5z7dWvVfOB2dnWUVaoHFeoXyHH2rtLZzmA1H2GTmA+WJbkFiIK
         nA82OT5hXTkduLa8FgNYonUgY/BodS3U+ic/+c7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Davide Caratti <dcaratti@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 79/84] net/sched: act_police: more accurate MTU policing
Date:   Mon, 20 Jun 2022 14:51:42 +0200
Message-Id: <20220620124723.225943635@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124720.882450983@linuxfoundation.org>
References: <20220620124720.882450983@linuxfoundation.org>
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

From: Davide Caratti <dcaratti@redhat.com>

commit 4ddc844eb81da59bfb816d8d52089aba4e59e269 upstream.

in current Linux, MTU policing does not take into account that packets at
the TC ingress have the L2 header pulled. Thus, the same TC police action
(with the same value of tcfp_mtu) behaves differently for ingress/egress.
In addition, the full GSO size is compared to tcfp_mtu: as a consequence,
the policer drops GSO packets even when individual segments have the L2 +
L3 + L4 + payload length below the configured valued of tcfp_mtu.

Improve the accuracy of MTU policing as follows:
 - account for mac_len for non-GSO packets at TC ingress.
 - compare MTU threshold with the segmented size for GSO packets.
Also, add a kselftest that verifies the correct behavior.

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[dcaratti: fix conflicts due to lack of the following commits:
 - commit 2ffe0395288a ("net/sched: act_police: add support for
   packet-per-second policing")
 - commit 53b61f29367d ("selftests: forwarding: Add tc-police tests for
   packets per second")]
Link: https://lore.kernel.org/netdev/876d597a0ff55f6ba786f73c5a9fd9eb8d597a03.1644514748.git.dcaratti@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_police.c                              |   16 +++++-
 tools/testing/selftests/net/forwarding/tc_police.sh |   52 ++++++++++++++++++++
 2 files changed, 67 insertions(+), 1 deletion(-)

--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -213,6 +213,20 @@ release_idr:
 	return err;
 }
 
+static bool tcf_police_mtu_check(struct sk_buff *skb, u32 limit)
+{
+	u32 len;
+
+	if (skb_is_gso(skb))
+		return skb_gso_validate_mac_len(skb, limit);
+
+	len = qdisc_pkt_len(skb);
+	if (skb_at_tc_ingress(skb))
+		len += skb->mac_len;
+
+	return len <= limit;
+}
+
 static int tcf_police_act(struct sk_buff *skb, const struct tc_action *a,
 			  struct tcf_result *res)
 {
@@ -235,7 +249,7 @@ static int tcf_police_act(struct sk_buff
 			goto inc_overlimits;
 	}
 
-	if (qdisc_pkt_len(skb) <= p->tcfp_mtu) {
+	if (tcf_police_mtu_check(skb, p->tcfp_mtu)) {
 		if (!p->rate_present) {
 			ret = p->tcfp_result;
 			goto end;
--- a/tools/testing/selftests/net/forwarding/tc_police.sh
+++ b/tools/testing/selftests/net/forwarding/tc_police.sh
@@ -35,6 +35,8 @@ ALL_TESTS="
 	police_shared_test
 	police_rx_mirror_test
 	police_tx_mirror_test
+	police_mtu_rx_test
+	police_mtu_tx_test
 "
 NUM_NETIFS=6
 source tc_common.sh
@@ -290,6 +292,56 @@ police_tx_mirror_test()
 	police_mirror_common_test $rp2 egress "police tx and mirror"
 }
 
+police_mtu_common_test() {
+	RET=0
+
+	local test_name=$1; shift
+	local dev=$1; shift
+	local direction=$1; shift
+
+	tc filter add dev $dev $direction protocol ip pref 1 handle 101 flower \
+		dst_ip 198.51.100.1 ip_proto udp dst_port 54321 \
+		action police mtu 1042 conform-exceed drop/ok
+
+	# to count "conform" packets
+	tc filter add dev $h2 ingress protocol ip pref 1 handle 101 flower \
+		dst_ip 198.51.100.1 ip_proto udp dst_port 54321 \
+		action drop
+
+	mausezahn $h1 -a own -b $(mac_get $rp1) -A 192.0.2.1 -B 198.51.100.1 \
+		-t udp sp=12345,dp=54321 -p 1001 -c 10 -q
+
+	mausezahn $h1 -a own -b $(mac_get $rp1) -A 192.0.2.1 -B 198.51.100.1 \
+		-t udp sp=12345,dp=54321 -p 1000 -c 3 -q
+
+	tc_check_packets "dev $dev $direction" 101 13
+	check_err $? "wrong packet counter"
+
+	# "exceed" packets
+	local overlimits_t0=$(tc_rule_stats_get ${dev} 1 ${direction} .overlimits)
+	test ${overlimits_t0} = 10
+	check_err $? "wrong overlimits, expected 10 got ${overlimits_t0}"
+
+	# "conform" packets
+	tc_check_packets "dev $h2 ingress" 101 3
+	check_err $? "forwarding error"
+
+	tc filter del dev $h2 ingress protocol ip pref 1 handle 101 flower
+	tc filter del dev $dev $direction protocol ip pref 1 handle 101 flower
+
+	log_test "$test_name"
+}
+
+police_mtu_rx_test()
+{
+	police_mtu_common_test "police mtu (rx)" $rp1 ingress
+}
+
+police_mtu_tx_test()
+{
+	police_mtu_common_test "police mtu (tx)" $rp2 egress
+}
+
 setup_prepare()
 {
 	h1=${NETIFS[p1]}


