Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE8AB6BB10F
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232400AbjCOMY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231892AbjCOMYJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:24:09 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1378D97FC3
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:22:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 89375CE19B7
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:22:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 965CFC433EF;
        Wed, 15 Mar 2023 12:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882932;
        bh=2lIyccPcnd1ycR/X3I7gs8AVjAP1LgfQrJRyVUm7Nvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YSLqWKRTFkhruX/UXrs2N1aG2BWiMnGejc679Eo8mFb+aDEtQhfPkLAy1JuKMXUTD
         hrW5PUS9vKYDHZzbGMddKddmhhK79EoxXK1u6i8ZeErvsI1nm7goooHf42h5j8E6ZR
         lrYZwfxde2b1BYr6wol8AEOr30UdEIIj8I71gDjs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hangbin Liu <liuhangbin@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 039/104] selftests: nft_nat: ensuring the listening side is up before starting the client
Date:   Wed, 15 Mar 2023 13:12:10 +0100
Message-Id: <20230315115733.643084823@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115731.942692602@linuxfoundation.org>
References: <20230315115731.942692602@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 2067e7a00aa604b94de31d64f29b8893b1696f26 ]

The test_local_dnat_portonly() function initiates the client-side as
soon as it sets the listening side to the background. This could lead to
a race condition where the server may not be ready to listen. To ensure
that the server-side is up and running before initiating the
client-side, a delay is introduced to the test_local_dnat_portonly()
function.

Before the fix:
  # ./nft_nat.sh
  PASS: netns routing/connectivity: ns0-rthlYrBU can reach ns1-rthlYrBU and ns2-rthlYrBU
  PASS: ping to ns1-rthlYrBU was ip NATted to ns2-rthlYrBU
  PASS: ping to ns1-rthlYrBU OK after ip nat output chain flush
  PASS: ipv6 ping to ns1-rthlYrBU was ip6 NATted to ns2-rthlYrBU
  2023/02/27 04:11:03 socat[6055] E connect(5, AF=2 10.0.1.99:2000, 16): Connection refused
  ERROR: inet port rewrite

After the fix:
  # ./nft_nat.sh
  PASS: netns routing/connectivity: ns0-9sPJV6JJ can reach ns1-9sPJV6JJ and ns2-9sPJV6JJ
  PASS: ping to ns1-9sPJV6JJ was ip NATted to ns2-9sPJV6JJ
  PASS: ping to ns1-9sPJV6JJ OK after ip nat output chain flush
  PASS: ipv6 ping to ns1-9sPJV6JJ was ip6 NATted to ns2-9sPJV6JJ
  PASS: inet port rewrite without l3 address

Fixes: 282e5f8fe907 ("netfilter: nat: really support inet nat without l3 address")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/netfilter/nft_nat.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/netfilter/nft_nat.sh b/tools/testing/selftests/netfilter/nft_nat.sh
index 4e15e81673104..67697d8ea59a5 100755
--- a/tools/testing/selftests/netfilter/nft_nat.sh
+++ b/tools/testing/selftests/netfilter/nft_nat.sh
@@ -404,6 +404,8 @@ EOF
 	echo SERVER-$family | ip netns exec "$ns1" timeout 5 socat -u STDIN TCP-LISTEN:2000 &
 	sc_s=$!
 
+	sleep 1
+
 	result=$(ip netns exec "$ns0" timeout 1 socat TCP:$daddr:2000 STDOUT)
 
 	if [ "$result" = "SERVER-inet" ];then
-- 
2.39.2



