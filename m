Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E056F6CB16B
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 00:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbjC0WEs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 18:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjC0WEq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 18:04:46 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB8819AB
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 15:04:42 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id y144-20020a253296000000b00b69ce0e6f2dso10081086yby.18
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 15:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679954682;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=IPwePibMbAmj+me1DnLNC2ebL/saQbDYvEut7C3wxzs=;
        b=BHxcAhurr+W6wkdH45HdEocQpYaVN0TF5ZuW0TqkAUgxNMbF6k9X6IJWmUfkyQLga7
         Xz2c1QciN5Zo2+pK8PRjgZbeJ7yC1hg8sBV9VQDPCxS+HdivFbBxm5onO7eTWtiJih4P
         2tbM/7R3hnD/FZYUBlIGUFbuyld+CmQb6c5/FMnRUGRcr/eQ1j4D9vZ+34MH0iJ59vkv
         VF88zfNnZGQW1uQDQQwx0M1PLRHJdFZuwRxvoiwurIydTUVjHvPCHGY9ZLqUyjGQxcI/
         7Qz/RccShSWqC9gXnNKjfT2JCBqAdKZm6lFtjuDKUaKyLG2Vg5WEZrRxgxzVHpT14bO2
         UEfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679954682;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IPwePibMbAmj+me1DnLNC2ebL/saQbDYvEut7C3wxzs=;
        b=oSA5d8lTz5Qc6Yke8x/PZnyXkU2TaU6DvAaDIKypOa5xT5RKQ/uxxOmdUdi0+Ik4Ko
         B959+vSByrW/Rd8rp4rQdcM9rtZVU9GVIKlOMLDkYC+BZEMMusQO1EnHsqQ6BHhlLp6u
         7iJj5cr+EDsuvGKVdu4WZ23CgGkB0jJaF5IHT8cqEy9M2YJf94vMCwwfUPeLgYGqtTIO
         /i/QibwaDJ6bsQ3oD0aCvlGM19jr7sE8dZ945mGbVs2SKSYdtaDJlEBApnuuqJ6yQ55a
         npCa5Q7CoyvP2KnM+iPhQLunAZcFJ0CKAa1OdsRSBr2y/OMa8iRkFiq3Dp/+gbpW5FCo
         2cRQ==
X-Gm-Message-State: AAQBX9eyRDUkT2EclG9lBA3GQLrrEfWAXKUTi9aH9i0kcc0AOUq7cMwg
        8X5ZL3646oOA6u90q8+lZpiByUkeZUWk/ZJ/6yfTIxT3Qiu+J44h0If+kBEzJHOGSdUB/J+mfNN
        Q34YzJrAVPzS9c6HiT6kAatUMFSdyDh1Fe1BZfkeyaqCjb+CWIt/tc6tVMN5kUTCC7aWSrRx5Pu
        uUlw==
X-Google-Smtp-Source: AKy350alsV/ZBTpOWFXRbnSOsxLCKR9HpXkWeFW/Te4Onj4JtyzJMfVmXDlwglSPCJLqlCJLN5JqH9iYQPJZ6IzsTSQ=
X-Received: from nobelbarakat.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:62d])
 (user=nobelbarakat job=sendgmr) by 2002:a81:ec08:0:b0:545:6250:58ec with SMTP
 id j8-20020a81ec08000000b00545625058ecmr5741336ywm.4.1679954682119; Mon, 27
 Mar 2023 15:04:42 -0700 (PDT)
Date:   Mon, 27 Mar 2023 22:04:32 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230327220432.4165615-1-nobelbarakat@google.com>
Subject: [PATCH 5.15] act_mirred: use the backlog for nested calls to mirred ingress
From:   Nobel Barakat <nobelbarakat@google.com>
To:     stable@vger.kernel.org
Cc:     Davide Caratti <dcaratti@redhat.com>,
        William Zhao <wizhao@redhat.com>,
        Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Nobel Barakat <nobelbarakat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

commit ca22da2fbd693b54dc8e3b7b54ccc9f7e9ba3640 upstream

William reports kernel soft-lockups on some OVS topologies when TC mirred
egress->ingress action is hit by local TCP traffic [1].
The same can also be reproduced with SCTP (thanks Xin for verifying), when
client and server reach themselves through mirred egress to ingress, and
one of the two peers sends a "heartbeat" packet (from within a timer).

Enqueueing to backlog proved to fix this soft lockup; however, as Cong
noticed [2], we should preserve - when possible - the current mirred
behavior that counts as "overlimits" any eventual packet drop subsequent to
the mirred forwarding action [3]. A compromise solution might use the
backlog only when tcf_mirred_act() has a nest level greater than one:
change tcf_mirred_forward() accordingly.

Also, add a kselftest that can reproduce the lockup and verifies TC mirred
ability to account for further packet drops after TC mirred egress->ingress
(when the nest level is 1).

 [1] https://lore.kernel.org/netdev/33dc43f587ec1388ba456b4915c75f02a8aae226.1663945716.git.dcaratti@redhat.com/
 [2] https://lore.kernel.org/netdev/Y0w%2FWWY60gqrtGLp@pop-os.localdomain/
 [3] such behavior is not guaranteed: for example, if RPS or skb RX
     timestamping is enabled on the mirred target device, the kernel
     can defer receiving the skb and return NET_RX_SUCCESS inside
     tcf_mirred_forward().

Reported-by: William Zhao <wizhao@redhat.com>
CC: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Nobel Barakat <nobelbarakat@google.com>
---
 net/sched/act_mirred.c                        |  7 ++
 .../selftests/net/forwarding/tc_actions.sh    | 92 ++++++++++++++++++-
 2 files changed, 98 insertions(+), 1 deletion(-)

diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index d64b0eeccbe4..120fd3ef8827 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -203,12 +203,19 @@ static int tcf_mirred_init(struct net *net, struct nlattr *nla,
 	return err;
 }

+static bool is_mirred_nested(void)
+{
+	return unlikely(__this_cpu_read(mirred_nest_level) > 1);
+}
+
 static int tcf_mirred_forward(bool want_ingress, struct sk_buff *skb)
 {
 	int err;

 	if (!want_ingress)
 		err = tcf_dev_queue_xmit(skb, dev_queue_xmit);
+	else if (is_mirred_nested())
+		err = netif_rx(skb);
 	else
 		err = netif_receive_skb(skb);

diff --git a/tools/testing/selftests/net/forwarding/tc_actions.sh b/tools/testing/selftests/net/forwarding/tc_actions.sh
index d9eca227136b..f9070b3bdba2 100755
--- a/tools/testing/selftests/net/forwarding/tc_actions.sh
+++ b/tools/testing/selftests/net/forwarding/tc_actions.sh
@@ -3,7 +3,8 @@

 ALL_TESTS="gact_drop_and_ok_test mirred_egress_redirect_test \
 	mirred_egress_mirror_test matchall_mirred_egress_mirror_test \
-	gact_trap_test"
+	gact_trap_test mirred_egress_to_ingress_test \
+	mirred_egress_to_ingress_tcp_test"
 NUM_NETIFS=4
 source tc_common.sh
 source lib.sh
@@ -153,6 +154,95 @@ gact_trap_test()
 	log_test "trap ($tcflags)"
 }

+mirred_egress_to_ingress_test()
+{
+	RET=0
+
+	tc filter add dev $h1 protocol ip pref 100 handle 100 egress flower \
+		ip_proto icmp src_ip 192.0.2.1 dst_ip 192.0.2.2 type 8 action \
+			ct commit nat src addr 192.0.2.2 pipe \
+			ct clear pipe \
+			ct commit nat dst addr 192.0.2.1 pipe \
+			mirred ingress redirect dev $h1
+
+	tc filter add dev $swp1 protocol ip pref 11 handle 111 ingress flower \
+		ip_proto icmp src_ip 192.0.2.1 dst_ip 192.0.2.2 type 8 action drop
+	tc filter add dev $swp1 protocol ip pref 12 handle 112 ingress flower \
+		ip_proto icmp src_ip 192.0.2.1 dst_ip 192.0.2.2 type 0 action pass
+
+	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac -A 192.0.2.1 -B 192.0.2.2 \
+		-t icmp "ping,id=42,seq=10" -q
+
+	tc_check_packets "dev $h1 egress" 100 1
+	check_err $? "didn't mirror first packet"
+
+	tc_check_packets "dev $swp1 ingress" 111 1
+	check_fail $? "didn't redirect first packet"
+	tc_check_packets "dev $swp1 ingress" 112 1
+	check_err $? "didn't receive reply to first packet"
+
+	ping 192.0.2.2 -I$h1 -c1 -w1 -q 1>/dev/null 2>&1
+
+	tc_check_packets "dev $h1 egress" 100 2
+	check_err $? "didn't mirror second packet"
+	tc_check_packets "dev $swp1 ingress" 111 1
+	check_fail $? "didn't redirect second packet"
+	tc_check_packets "dev $swp1 ingress" 112 2
+	check_err $? "didn't receive reply to second packet"
+
+	tc filter del dev $h1 egress protocol ip pref 100 handle 100 flower
+	tc filter del dev $swp1 ingress protocol ip pref 11 handle 111 flower
+	tc filter del dev $swp1 ingress protocol ip pref 12 handle 112 flower
+
+	log_test "mirred_egress_to_ingress ($tcflags)"
+}
+
+mirred_egress_to_ingress_tcp_test()
+{
+	local tmpfile=$(mktemp) tmpfile1=$(mktemp)
+
+	RET=0
+	dd conv=sparse status=none if=/dev/zero bs=1M count=2 of=$tmpfile
+	tc filter add dev $h1 protocol ip pref 100 handle 100 egress flower \
+		$tcflags ip_proto tcp src_ip 192.0.2.1 dst_ip 192.0.2.2 \
+			action ct commit nat src addr 192.0.2.2 pipe \
+			action ct clear pipe \
+			action ct commit nat dst addr 192.0.2.1 pipe \
+			action ct clear pipe \
+			action skbedit ptype host pipe \
+			action mirred ingress redirect dev $h1
+	tc filter add dev $h1 protocol ip pref 101 handle 101 egress flower \
+		$tcflags ip_proto icmp \
+			action mirred ingress redirect dev $h1
+	tc filter add dev $h1 protocol ip pref 102 handle 102 ingress flower \
+		ip_proto icmp \
+			action drop
+
+	ip vrf exec v$h1 nc --recv-only -w10 -l -p 12345 -o $tmpfile1  &
+	local rpid=$!
+	ip vrf exec v$h1 nc -w1 --send-only 192.0.2.2 12345 <$tmpfile
+	wait -n $rpid
+	cmp -s $tmpfile $tmpfile1
+	check_err $? "server output check failed"
+
+	$MZ $h1 -c 10 -p 64 -a $h1mac -b $h1mac -A 192.0.2.1 -B 192.0.2.1 \
+		-t icmp "ping,id=42,seq=5" -q
+	tc_check_packets "dev $h1 egress" 101 10
+	check_err $? "didn't mirred redirect ICMP"
+	tc_check_packets "dev $h1 ingress" 102 10
+	check_err $? "didn't drop mirred ICMP"
+	local overlimits=$(tc_rule_stats_get ${h1} 101 egress .overlimits)
+	test ${overlimits} = 10
+	check_err $? "wrong overlimits, expected 10 got ${overlimits}"
+
+	tc filter del dev $h1 egress protocol ip pref 100 handle 100 flower
+	tc filter del dev $h1 egress protocol ip pref 101 handle 101 flower
+	tc filter del dev $h1 ingress protocol ip pref 102 handle 102 flower
+
+	rm -f $tmpfile $tmpfile1
+	log_test "mirred_egress_to_ingress_tcp ($tcflags)"
+}
+
 setup_prepare()
 {
 	h1=${NETIFS[p1]}
--
2.40.0.348.gf938b09366-goog
