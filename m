Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20F8D47299F
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242362AbhLMKXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:23:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236863AbhLMJrg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:47:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 166FEC07E5F2;
        Mon, 13 Dec 2021 01:42:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B15B3B80E18;
        Mon, 13 Dec 2021 09:42:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA0D9C00446;
        Mon, 13 Dec 2021 09:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388576;
        bh=waDXZOXkgSUQ5tSZ0B7ihVQ/POu+BCMaFvW/aQwnbnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U5Lsyjj0WLe6PMVMgr/gbYyjrmCNEINlZTnfYDlTvlHJn0Fd/j4ZyTwz5mE/wFJWG
         ax9QGsF6As+w3J4UlddQum0KsxdA9rSNHf2zz9FfhEM4PThBxb4VcA15HRBhmypOc+
         qldN5YDJQiS7Khc5EXikBfGTA1AaV/WXPaKNnanw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eugene Crosser <crosser@average.org>,
        Lahav Schlesinger <lschlesinger@drivenets.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 16/88] selftests: netfilter: add a vrf+conntrack testcase
Date:   Mon, 13 Dec 2021 10:29:46 +0100
Message-Id: <20211213092933.771996032@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092933.250314515@linuxfoundation.org>
References: <20211213092933.250314515@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

commit 33b8aad21ac175eba9577a73eb62b0aa141c241c upstream.

Rework the reproducer for the vrf+conntrack regression reported
by Eugene into a selftest and also add a test for ip masquerading
that Lahav fixed recently.

With net or net-next tree, the first test fails and the latter
two pass.

With 09e856d54bda5f28 ("vrf: Reset skb conntrack connection on VRF rcv")
reverted first test passes but the last two fail.

A proper fix needs more work, for time being a revert seems to be
the best choice, snat/masquerade did not work before the fix.

Link: https://lore.kernel.org/netdev/378ca299-4474-7e9a-3d36-2350c8c98995@gmail.com/T/#m95358a31810df7392f541f99d187227bc75c9963
Reported-by: Eugene Crosser <crosser@average.org>
Cc: Lahav Schlesinger <lschlesinger@drivenets.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/netfilter/conntrack_vrf.sh |  219 +++++++++++++++++++++
 1 file changed, 219 insertions(+)
 create mode 100755 tools/testing/selftests/netfilter/conntrack_vrf.sh

--- /dev/null
+++ b/tools/testing/selftests/netfilter/conntrack_vrf.sh
@@ -0,0 +1,219 @@
+#!/bin/sh
+
+# This script demonstrates interaction of conntrack and vrf.
+# The vrf driver calls the netfilter hooks again, with oif/iif
+# pointing at the VRF device.
+#
+# For ingress, this means first iteration has iifname of lower/real
+# device.  In this script, thats veth0.
+# Second iteration is iifname set to vrf device, tvrf in this script.
+#
+# For egress, this is reversed: first iteration has the vrf device,
+# second iteration is done with the lower/real/veth0 device.
+#
+# test_ct_zone_in demonstrates unexpected change of nftables
+# behavior # caused by commit 09e856d54bda5f28 "vrf: Reset skb conntrack
+# connection on VRF rcv"
+#
+# It was possible to assign conntrack zone to a packet (or mark it for
+# `notracking`) in the prerouting chain before conntrack, based on real iif.
+#
+# After the change, the zone assignment is lost and the zone is assigned based
+# on the VRF master interface (in case such a rule exists).
+# assignment is lost. Instead, assignment based on the `iif` matching
+# Thus it is impossible to distinguish packets based on the original
+# interface.
+#
+# test_masquerade_vrf and test_masquerade_veth0 demonstrate the problem
+# that was supposed to be fixed by the commit mentioned above to make sure
+# that any fix to test case 1 won't break masquerade again.
+
+ksft_skip=4
+
+IP0=172.30.30.1
+IP1=172.30.30.2
+PFXL=30
+ret=0
+
+sfx=$(mktemp -u "XXXXXXXX")
+ns0="ns0-$sfx"
+ns1="ns1-$sfx"
+
+cleanup()
+{
+	ip netns pids $ns0 | xargs kill 2>/dev/null
+	ip netns pids $ns1 | xargs kill 2>/dev/null
+
+	ip netns del $ns0 $ns1
+}
+
+nft --version > /dev/null 2>&1
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not run test without nft tool"
+	exit $ksft_skip
+fi
+
+ip -Version > /dev/null 2>&1
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not run test without ip tool"
+	exit $ksft_skip
+fi
+
+ip netns add "$ns0"
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not create net namespace $ns0"
+	exit $ksft_skip
+fi
+ip netns add "$ns1"
+
+trap cleanup EXIT
+
+ip netns exec $ns0 sysctl -q -w net.ipv4.conf.default.rp_filter=0
+ip netns exec $ns0 sysctl -q -w net.ipv4.conf.all.rp_filter=0
+ip netns exec $ns0 sysctl -q -w net.ipv4.conf.all.rp_filter=0
+
+ip link add veth0 netns "$ns0" type veth peer name veth0 netns "$ns1" > /dev/null 2>&1
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not add veth device"
+	exit $ksft_skip
+fi
+
+ip -net $ns0 li add tvrf type vrf table 9876
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not add vrf device"
+	exit $ksft_skip
+fi
+
+ip -net $ns0 li set lo up
+
+ip -net $ns0 li set veth0 master tvrf
+ip -net $ns0 li set tvrf up
+ip -net $ns0 li set veth0 up
+ip -net $ns1 li set veth0 up
+
+ip -net $ns0 addr add $IP0/$PFXL dev veth0
+ip -net $ns1 addr add $IP1/$PFXL dev veth0
+
+ip netns exec $ns1 iperf3 -s > /dev/null 2>&1&
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not start iperf3"
+	exit $ksft_skip
+fi
+
+# test vrf ingress handling.
+# The incoming connection should be placed in conntrack zone 1,
+# as decided by the first iteration of the ruleset.
+test_ct_zone_in()
+{
+ip netns exec $ns0 nft -f - <<EOF
+table testct {
+	chain rawpre {
+		type filter hook prerouting priority raw;
+
+		iif { veth0, tvrf } counter meta nftrace set 1
+		iif veth0 counter ct zone set 1 counter return
+		iif tvrf counter ct zone set 2 counter return
+		ip protocol icmp counter
+		notrack counter
+	}
+
+	chain rawout {
+		type filter hook output priority raw;
+
+		oif veth0 counter ct zone set 1 counter return
+		oif tvrf counter ct zone set 2 counter return
+		notrack counter
+	}
+}
+EOF
+	ip netns exec $ns1 ping -W 1 -c 1 -I veth0 $IP0 > /dev/null
+
+	# should be in zone 1, not zone 2
+	count=$(ip netns exec $ns0 conntrack -L -s $IP1 -d $IP0 -p icmp --zone 1 2>/dev/null | wc -l)
+	if [ $count -eq 1 ]; then
+		echo "PASS: entry found in conntrack zone 1"
+	else
+		echo "FAIL: entry not found in conntrack zone 1"
+		count=$(ip netns exec $ns0 conntrack -L -s $IP1 -d $IP0 -p icmp --zone 2 2> /dev/null | wc -l)
+		if [ $count -eq 1 ]; then
+			echo "FAIL: entry found in zone 2 instead"
+		else
+			echo "FAIL: entry not in zone 1 or 2, dumping table"
+			ip netns exec $ns0 conntrack -L
+			ip netns exec $ns0 nft list ruleset
+		fi
+	fi
+}
+
+# add masq rule that gets evaluated w. outif set to vrf device.
+# This tests the first iteration of the packet through conntrack,
+# oifname is the vrf device.
+test_masquerade_vrf()
+{
+	ip netns exec $ns0 conntrack -F 2>/dev/null
+
+ip netns exec $ns0 nft -f - <<EOF
+flush ruleset
+table ip nat {
+	chain postrouting {
+		type nat hook postrouting priority 0;
+		# NB: masquerade should always be combined with 'oif(name) bla',
+		# lack of this is intentional here, we want to exercise double-snat.
+		ip saddr 172.30.30.0/30 counter masquerade random
+	}
+}
+EOF
+	ip netns exec $ns0 ip vrf exec tvrf iperf3 -t 1 -c $IP1 >/dev/null
+	if [ $? -ne 0 ]; then
+		echo "FAIL: iperf3 connect failure with masquerade + sport rewrite on vrf device"
+		ret=1
+		return
+	fi
+
+	# must also check that nat table was evaluated on second (lower device) iteration.
+	ip netns exec $ns0 nft list table ip nat |grep -q 'counter packets 2'
+	if [ $? -eq 0 ]; then
+		echo "PASS: iperf3 connect with masquerade + sport rewrite on vrf device"
+	else
+		echo "FAIL: vrf masq rule has unexpected counter value"
+		ret=1
+	fi
+}
+
+# add masq rule that gets evaluated w. outif set to veth device.
+# This tests the 2nd iteration of the packet through conntrack,
+# oifname is the lower device (veth0 in this case).
+test_masquerade_veth()
+{
+	ip netns exec $ns0 conntrack -F 2>/dev/null
+ip netns exec $ns0 nft -f - <<EOF
+flush ruleset
+table ip nat {
+	chain postrouting {
+		type nat hook postrouting priority 0;
+		meta oif veth0 ip saddr 172.30.30.0/30 counter masquerade random
+	}
+}
+EOF
+	ip netns exec $ns0 ip vrf exec tvrf iperf3 -t 1 -c $IP1 > /dev/null
+	if [ $? -ne 0 ]; then
+		echo "FAIL: iperf3 connect failure with masquerade + sport rewrite on veth device"
+		ret=1
+		return
+	fi
+
+	# must also check that nat table was evaluated on second (lower device) iteration.
+	ip netns exec $ns0 nft list table ip nat |grep -q 'counter packets 2'
+	if [ $? -eq 0 ]; then
+		echo "PASS: iperf3 connect with masquerade + sport rewrite on veth device"
+	else
+		echo "FAIL: vrf masq rule has unexpected counter value"
+		ret=1
+	fi
+}
+
+test_ct_zone_in
+test_masquerade_vrf
+test_masquerade_veth
+
+exit $ret


