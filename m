Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBA54AFAA3
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240062AbiBISjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:39:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239881AbiBISib (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:38:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC5C6C043181;
        Wed,  9 Feb 2022 10:38:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69756B82378;
        Wed,  9 Feb 2022 18:38:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B3DC340E7;
        Wed,  9 Feb 2022 18:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644431895;
        bh=ZkyDCKrwRMu8qzzsrtkdxdg3GIqhrh6ZC4SSxTOXvq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fZ/IG5gZUffzn4Id7aKiXMepo8fJ21MuEROxA0TKLVwYiqaIDql5GbZ64xa1X0PNt
         nSgERCr7KwdqFsa4OSF2NWXOynNc1UuqQTlt8/NW/1jOwA7ZbfW82XvLdFAd+9mh1c
         jOrvZd0DmrW8AAAUQkkTSG4sRsQt9FBo1QC4VdiTeHbLiZolcnK0NrNYZ5Vb4GM9dm
         wKDyP7psHxZcrk5rEkPdR0k16v+bvDy1Cy2JT1oXd0T2M8YcUe64bM5j4drCKhGxFC
         cGjwDmuwoy120YHpmG3H6f3ThKx5hSc2TL7X0dj5a8sMrXzBjUA8+zInP7OkiwuZzx
         QA69lRat2W5+A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>, shuah@kernel.org, phil@nwl.cc,
        eric@garver.life, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 06/36] selftests: netfilter: check stateless nat udp checksum fixup
Date:   Wed,  9 Feb 2022 13:37:29 -0500
Message-Id: <20220209183759.47134-6-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209183759.47134-1-sashal@kernel.org>
References: <20220209183759.47134-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit aad51ca71ad83273e8826d6cfdcf53c98748d1fa ]

Add a test that sends large udp packet (which is fragmented)
via a stateless nft nat rule, i.e. 'ip saddr set 10.2.3.4'
and check that the datagram is received by peer.

On kernels without
commit 4e1860a38637 ("netfilter: nft_payload: do not update layer 4 checksum when mangling fragments")',
this will fail with:

cmp: EOF on /tmp/tmp.V1q0iXJyQF which is empty
-rw------- 1 root root 4096 Jan 24 22:03 /tmp/tmp.Aaqnq4rBKS
-rw------- 1 root root    0 Jan 24 22:03 /tmp/tmp.V1q0iXJyQF
ERROR: in and output file mismatch when checking udp with stateless nat
FAIL: nftables v1.0.0 (Fearless Fosdick #2)

On patched kernels, this will show:
PASS: IP statless for ns2-PFp89amx

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/netfilter/nft_nat.sh | 152 +++++++++++++++++++
 1 file changed, 152 insertions(+)

diff --git a/tools/testing/selftests/netfilter/nft_nat.sh b/tools/testing/selftests/netfilter/nft_nat.sh
index da1c1e4b6c86b..781fa2d9ea9d5 100755
--- a/tools/testing/selftests/netfilter/nft_nat.sh
+++ b/tools/testing/selftests/netfilter/nft_nat.sh
@@ -885,6 +885,144 @@ EOF
 	ip netns exec "$ns0" nft delete table $family nat
 }
 
+test_stateless_nat_ip()
+{
+	local lret=0
+
+	ip netns exec "$ns0" sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
+	ip netns exec "$ns0" sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
+
+	ip netns exec "$ns2" ping -q -c 1 10.0.1.99 > /dev/null # ping ns2->ns1
+	if [ $? -ne 0 ] ; then
+		echo "ERROR: cannot ping $ns1 from $ns2 before loading stateless rules"
+		return 1
+	fi
+
+ip netns exec "$ns0" nft -f /dev/stdin <<EOF
+table ip stateless {
+	map xlate_in {
+		typeof meta iifname . ip saddr . ip daddr : ip daddr
+		elements = {
+			"veth1" . 10.0.2.99 . 10.0.1.99 : 10.0.2.2,
+		}
+	}
+	map xlate_out {
+		typeof meta iifname . ip saddr . ip daddr : ip daddr
+		elements = {
+			"veth0" . 10.0.1.99 . 10.0.2.2 : 10.0.2.99
+		}
+	}
+
+	chain prerouting {
+		type filter hook prerouting priority -400; policy accept;
+		ip saddr set meta iifname . ip saddr . ip daddr map @xlate_in
+		ip daddr set meta iifname . ip saddr . ip daddr map @xlate_out
+	}
+}
+EOF
+	if [ $? -ne 0 ]; then
+		echo "SKIP: Could not add ip statless rules"
+		return $ksft_skip
+	fi
+
+	reset_counters
+
+	ip netns exec "$ns2" ping -q -c 1 10.0.1.99 > /dev/null # ping ns2->ns1
+	if [ $? -ne 0 ] ; then
+		echo "ERROR: cannot ping $ns1 from $ns2 with stateless rules"
+		lret=1
+	fi
+
+	# ns1 should have seen packets from .2.2, due to stateless rewrite.
+	expect="packets 1 bytes 84"
+	cnt=$(ip netns exec "$ns1" nft list counter inet filter ns0insl | grep -q "$expect")
+	if [ $? -ne 0 ]; then
+		bad_counter "$ns1" ns0insl "$expect" "test_stateless 1"
+		lret=1
+	fi
+
+	for dir in "in" "out" ; do
+		cnt=$(ip netns exec "$ns2" nft list counter inet filter ns1${dir} | grep -q "$expect")
+		if [ $? -ne 0 ]; then
+			bad_counter "$ns2" ns1$dir "$expect" "test_stateless 2"
+			lret=1
+		fi
+	done
+
+	# ns1 should not have seen packets from ns2, due to masquerade
+	expect="packets 0 bytes 0"
+	for dir in "in" "out" ; do
+		cnt=$(ip netns exec "$ns1" nft list counter inet filter ns2${dir} | grep -q "$expect")
+		if [ $? -ne 0 ]; then
+			bad_counter "$ns1" ns0$dir "$expect" "test_stateless 3"
+			lret=1
+		fi
+
+		cnt=$(ip netns exec "$ns0" nft list counter inet filter ns1${dir} | grep -q "$expect")
+		if [ $? -ne 0 ]; then
+			bad_counter "$ns0" ns1$dir "$expect" "test_stateless 4"
+			lret=1
+		fi
+	done
+
+	reset_counters
+
+	socat -h > /dev/null 2>&1
+	if [ $? -ne 0 ];then
+		echo "SKIP: Could not run stateless nat frag test without socat tool"
+		if [ $lret -eq 0 ]; then
+			return $ksft_skip
+		fi
+
+		ip netns exec "$ns0" nft delete table ip stateless
+		return $lret
+	fi
+
+	local tmpfile=$(mktemp)
+	dd if=/dev/urandom of=$tmpfile bs=4096 count=1 2>/dev/null
+
+	local outfile=$(mktemp)
+	ip netns exec "$ns1" timeout 3 socat -u UDP4-RECV:4233 OPEN:$outfile < /dev/null &
+	sc_r=$!
+
+	sleep 1
+	# re-do with large ping -> ip fragmentation
+	ip netns exec "$ns2" timeout 3 socat - UDP4-SENDTO:"10.0.1.99:4233" < "$tmpfile" > /dev/null
+	if [ $? -ne 0 ] ; then
+		echo "ERROR: failed to test udp $ns1 to $ns2 with stateless ip nat" 1>&2
+		lret=1
+	fi
+
+	wait
+
+	cmp "$tmpfile" "$outfile"
+	if [ $? -ne 0 ]; then
+		ls -l "$tmpfile" "$outfile"
+		echo "ERROR: in and output file mismatch when checking udp with stateless nat" 1>&2
+		lret=1
+	fi
+
+	rm -f "$tmpfile" "$outfile"
+
+	# ns1 should have seen packets from 2.2, due to stateless rewrite.
+	expect="packets 3 bytes 4164"
+	cnt=$(ip netns exec "$ns1" nft list counter inet filter ns0insl | grep -q "$expect")
+	if [ $? -ne 0 ]; then
+		bad_counter "$ns1" ns0insl "$expect" "test_stateless 5"
+		lret=1
+	fi
+
+	ip netns exec "$ns0" nft delete table ip stateless
+	if [ $? -ne 0 ]; then
+		echo "ERROR: Could not delete table ip stateless" 1>&2
+		lret=1
+	fi
+
+	test $lret -eq 0 && echo "PASS: IP statless for $ns2"
+
+	return $lret
+}
+
 # ip netns exec "$ns0" ping -c 1 -q 10.0.$i.99
 for i in 0 1 2; do
 ip netns exec ns$i-$sfx nft -f /dev/stdin <<EOF
@@ -951,6 +1089,19 @@ table inet filter {
 EOF
 done
 
+# special case for stateless nat check, counter needs to
+# be done before (input) ip defragmentation
+ip netns exec ns1-$sfx nft -f /dev/stdin <<EOF
+table inet filter {
+	counter ns0insl {}
+
+	chain pre {
+		type filter hook prerouting priority -400; policy accept;
+		ip saddr 10.0.2.2 counter name "ns0insl"
+	}
+}
+EOF
+
 sleep 3
 # test basic connectivity
 for i in 1 2; do
@@ -1005,6 +1156,7 @@ $test_inet_nat && test_redirect inet
 $test_inet_nat && test_redirect6 inet
 
 test_port_shadowing
+test_stateless_nat_ip
 
 if [ $ret -ne 0 ];then
 	echo -n "FAIL: "
-- 
2.34.1

