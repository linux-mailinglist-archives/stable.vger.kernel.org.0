Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E28B854F857
	for <lists+stable@lfdr.de>; Fri, 17 Jun 2022 15:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382020AbiFQNd1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jun 2022 09:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234792AbiFQNdS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jun 2022 09:33:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 865732181E
        for <stable@vger.kernel.org>; Fri, 17 Jun 2022 06:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655472795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=IMlUtI8g7KlS/m82SOabV5LMRbCW2wc3lb78ZHXz35Y=;
        b=VHAvkCmL0fxZqFD5mPtxdty3y3XZl7W/fW9uViQw6o0nueIeYujFGutEs+yvd5VT3qHbi0
        zYsaXZxqgHGNQA+f52Rd4de3nnqTKiXOLbJKI30MFusZH4AC73pDq8Pi4EVmecr6EnlKZL
        Vdk8ZCpNno4wdjJXp1n495vOdYy7tS4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-467-JO0oT96eMOCDghw3QC7uUw-1; Fri, 17 Jun 2022 09:33:11 -0400
X-MC-Unique: JO0oT96eMOCDghw3QC7uUw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 184652A59541;
        Fri, 17 Jun 2022 13:33:11 +0000 (UTC)
Received: from dcaratti.users.ipa.redhat.com (unknown [10.40.193.75])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0397F1415106;
        Fri, 17 Jun 2022 13:33:09 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     stable@vger.kernel.org
Cc:     Greg KH <gregkh@linuxfoundation.org>, echaudro@redhat.com,
        i.maximets@ovn.org
Subject: [PATCH 5.10] net/sched: act_police: more accurate MTU policing
Date:   Fri, 17 Jun 2022 15:32:59 +0200
Message-Id: <9793e31d40fa043c5965d3008d8534d01f533fa0.1655471603.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

[dcaratti: fix conflicts due to lack of the following commits:
 - commit 2ffe0395288a ("net/sched: act_police: add support for
   packet-per-second policing")
 - commit 53b61f29367d ("selftests: forwarding: Add tc-police tests for
   packets per second")]
Link: https://lore.kernel.org/netdev/876d597a0ff55f6ba786f73c5a9fd9eb8d597a03.1644514748.git.dcaratti@redhat.com
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/sched/act_police.c                        | 16 +++++-
 .../selftests/net/forwarding/tc_police.sh     | 52 +++++++++++++++++++
 2 files changed, 67 insertions(+), 1 deletion(-)

diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index 8d8452b1cdd4..380733588959 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -213,6 +213,20 @@ static int tcf_police_init(struct net *net, struct nlattr *nla,
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
@@ -235,7 +249,7 @@ static int tcf_police_act(struct sk_buff *skb, const struct tc_action *a,
 			goto inc_overlimits;
 	}
 
-	if (qdisc_pkt_len(skb) <= p->tcfp_mtu) {
+	if (tcf_police_mtu_check(skb, p->tcfp_mtu)) {
 		if (!p->rate_present) {
 			ret = p->tcfp_result;
 			goto end;
diff --git a/tools/testing/selftests/net/forwarding/tc_police.sh b/tools/testing/selftests/net/forwarding/tc_police.sh
index 160f9cccdfb7..eb09acdcb3ff 100755
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
-- 
2.35.3

