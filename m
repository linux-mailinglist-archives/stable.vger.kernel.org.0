Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7854548849
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383705AbiFMO1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384030AbiFMOYb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:24:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A478447ACB;
        Mon, 13 Jun 2022 04:46:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2114BB80D3A;
        Mon, 13 Jun 2022 11:46:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89B51C34114;
        Mon, 13 Jun 2022 11:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120790;
        bh=WSnIb8c1EK7S1Ug1rp1Uyxgzi6wIMQAdTOBGWLHDaWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ilDXSdL/CMXSJypmoKQ6v7UqDA2MndPJlbVLkPS3BmTcnDXiZn9H0Y4LdbC5RFEEh
         oTXI9BBG6KNP1mGePKQbVmqJmOeRvQ4OQfJ/xW4qAvXOarosM6Fs3/9TkvN5ZvcJyr
         AYp3GOztr6uPnZhFckz+iHoyYeH07ID5Z5286hR0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yi Chen <yiche@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 158/298] netfilter: nat: really support inet nat without l3 address
Date:   Mon, 13 Jun 2022 12:10:52 +0200
Message-Id: <20220613094929.728184662@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 282e5f8fe907dc3f2fbf9f2103b0e62ffc3a68a5 ]

When no l3 address is given, priv->family is set to NFPROTO_INET and
the evaluation function isn't called.

Call it too so l4-only rewrite can work.
Also add a test case for this.

Fixes: a33f387ecd5aa ("netfilter: nft_nat: allow to specify layer 4 protocol NAT only")
Reported-by: Yi Chen <yiche@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_nat.c                      |  3 +-
 tools/testing/selftests/netfilter/nft_nat.sh | 43 ++++++++++++++++++++
 2 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index be1595d6979d..db8f9116eeb4 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -334,7 +334,8 @@ static void nft_nat_inet_eval(const struct nft_expr *expr,
 {
 	const struct nft_nat *priv = nft_expr_priv(expr);
 
-	if (priv->family == nft_pf(pkt))
+	if (priv->family == nft_pf(pkt) ||
+	    priv->family == NFPROTO_INET)
 		nft_nat_eval(expr, regs, pkt);
 }
 
diff --git a/tools/testing/selftests/netfilter/nft_nat.sh b/tools/testing/selftests/netfilter/nft_nat.sh
index eb8543b9a5c4..924ecb3f1f73 100755
--- a/tools/testing/selftests/netfilter/nft_nat.sh
+++ b/tools/testing/selftests/netfilter/nft_nat.sh
@@ -374,6 +374,45 @@ EOF
 	return $lret
 }
 
+test_local_dnat_portonly()
+{
+	local family=$1
+	local daddr=$2
+	local lret=0
+	local sr_s
+	local sr_r
+
+ip netns exec "$ns0" nft -f /dev/stdin <<EOF
+table $family nat {
+	chain output {
+		type nat hook output priority 0; policy accept;
+		meta l4proto tcp dnat to :2000
+
+	}
+}
+EOF
+	if [ $? -ne 0 ]; then
+		if [ $family = "inet" ];then
+			echo "SKIP: inet port test"
+			test_inet_nat=false
+			return
+		fi
+		echo "SKIP: Could not add $family dnat hook"
+		return
+	fi
+
+	echo SERVER-$family | ip netns exec "$ns1" timeout 5 socat -u STDIN TCP-LISTEN:2000 &
+	sc_s=$!
+
+	result=$(ip netns exec "$ns0" timeout 1 socat TCP:$daddr:2000 STDOUT)
+
+	if [ "$result" = "SERVER-inet" ];then
+		echo "PASS: inet port rewrite without l3 address"
+	else
+		echo "ERROR: inet port rewrite"
+		ret=1
+	fi
+}
 
 test_masquerade6()
 {
@@ -1148,6 +1187,10 @@ fi
 reset_counters
 test_local_dnat ip
 test_local_dnat6 ip6
+
+reset_counters
+test_local_dnat_portonly inet 10.0.1.99
+
 reset_counters
 $test_inet_nat && test_local_dnat inet
 $test_inet_nat && test_local_dnat6 inet
-- 
2.35.1



