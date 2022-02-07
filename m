Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71F064ABD8A
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 13:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384538AbiBGLoy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:44:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385250AbiBGLb0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:31:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52437C02B64B;
        Mon,  7 Feb 2022 03:29:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12A10B80EBD;
        Mon,  7 Feb 2022 11:29:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 409CEC004E1;
        Mon,  7 Feb 2022 11:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233395;
        bh=IzGcumH0UBveEX4Z1EvcBvjQJNsagxoSQnbTgSwJPG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rbpg17KapGLYWkKQFTYu6f/JtNd+drIdpiOyg5x7TWqKn9XMKKcCybyl7lLYI0PgX
         4BWuAvUrS2C7DrZcPy9mTsvwkExPF3TJjP/kO3rHyX5PnxdjGtxgumJZHLWoMsPw6r
         cH4S6o1GXdoI7cvc6WqhcRz6sJsBeZjtkZ9Xqu8E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Stefano Brivio <sbrivio@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.15 109/110] selftests: nft_concat_range: add test for reload with no element add/del
Date:   Mon,  7 Feb 2022 12:07:22 +0100
Message-Id: <20220207103806.081081409@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103802.280120990@linuxfoundation.org>
References: <20220207103802.280120990@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

commit eda0cf1202acf1ef47f93d8f92d4839213431424 upstream.

Add a specific test for the reload issue fixed with
commit 23c54263efd7cb ("netfilter: nft_set_pipapo: allocate pcpu scratch maps on clone").

Add to set, then flush set content + restore without other add/remove in
the transaction.

On kernels before the fix, this test case fails:
  net,mac with reload    [FAIL]

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/netfilter/nft_concat_range.sh |   72 +++++++++++++++++-
 1 file changed, 71 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/netfilter/nft_concat_range.sh
+++ b/tools/testing/selftests/netfilter/nft_concat_range.sh
@@ -27,7 +27,7 @@ TYPES="net_port port_net net6_port port_
        net_port_mac_proto_net"
 
 # Reported bugs, also described by TYPE_ variables below
-BUGS="flush_remove_add"
+BUGS="flush_remove_add reload"
 
 # List of possible paths to pktgen script from kernel tree for performance tests
 PKTGEN_SCRIPT_PATHS="
@@ -337,6 +337,23 @@ TYPE_flush_remove_add="
 display		Add two elements, flush, re-add
 "
 
+TYPE_reload="
+display		net,mac with reload
+type_spec	ipv4_addr . ether_addr
+chain_spec	ip daddr . ether saddr
+dst		addr4
+src		mac
+start		1
+count		1
+src_delta	2000
+tools		sendip nc bash
+proto		udp
+
+race_repeat	0
+
+perf_duration	0
+"
+
 # Set template for all tests, types and rules are filled in depending on test
 set_template='
 flush ruleset
@@ -1455,6 +1472,59 @@ test_bug_flush_remove_add() {
 	nft flush ruleset
 }
 
+# - add ranged element, check that packets match it
+# - reload the set, check packets still match
+test_bug_reload() {
+	setup veth send_"${proto}" set || return ${KSELFTEST_SKIP}
+	rstart=${start}
+
+	range_size=1
+	for i in $(seq "${start}" $((start + count))); do
+		end=$((start + range_size))
+
+		# Avoid negative or zero-sized port ranges
+		if [ $((end / 65534)) -gt $((start / 65534)) ]; then
+			start=${end}
+			end=$((end + 1))
+		fi
+		srcstart=$((start + src_delta))
+		srcend=$((end + src_delta))
+
+		add "$(format)" || return 1
+		range_size=$((range_size + 1))
+		start=$((end + range_size))
+	done
+
+	# check kernel does allocate pcpu sctrach map
+	# for reload with no elemet add/delete
+	( echo flush set inet filter test ;
+	  nft list set inet filter test ) | nft -f -
+
+	start=${rstart}
+	range_size=1
+
+	for i in $(seq "${start}" $((start + count))); do
+		end=$((start + range_size))
+
+		# Avoid negative or zero-sized port ranges
+		if [ $((end / 65534)) -gt $((start / 65534)) ]; then
+			start=${end}
+			end=$((end + 1))
+		fi
+		srcstart=$((start + src_delta))
+		srcend=$((end + src_delta))
+
+		for j in $(seq ${start} $((range_size / 2 + 1)) ${end}); do
+			send_match "${j}" $((j + src_delta)) || return 1
+		done
+
+		range_size=$((range_size + 1))
+		start=$((end + range_size))
+	done
+
+	nft flush ruleset
+}
+
 test_reported_issues() {
 	eval test_bug_"${subtest}"
 }


