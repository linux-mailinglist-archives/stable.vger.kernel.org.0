Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00EE256FA79
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbiGKJSG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbiGKJRi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:17:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B30C4AD43;
        Mon, 11 Jul 2022 02:11:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D6DEB80E7E;
        Mon, 11 Jul 2022 09:11:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C18C341C0;
        Mon, 11 Jul 2022 09:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530688;
        bh=pbH4+/eifaogvlXXGDGFmEoG1UUw+Kn1yNbwrEJfSsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GgwD5iRrItoivj7ZaEG3P+B9S9zM5DeMLGKO1pZhVqQW2nzRW2uvHQDyvQQOrSFJ7
         QSzZhwCgr05QdH1bQg32qF7qVlDpzh6fUQQ84feW9nRHpSB0Roobp2o9295ccBa182
         v0t+XzV5Rg5u/kRoMYTDUjkcI+B2iEmiMtw12wBA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 25/38] selftests: forwarding: fix flood_unicast_test when h2 supports IFF_UNICAST_FLT
Date:   Mon, 11 Jul 2022 11:07:07 +0200
Message-Id: <20220711090539.472540621@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090538.722676354@linuxfoundation.org>
References: <20220711090538.722676354@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit b8e629b05f5d23f9649c901bef09fab8b0c2e4b9 ]

As mentioned in the blamed commit, flood_unicast_test() works by
checking the match count on a tc filter placed on the receiving
interface.

But the second host interface (host2_if) has no interest in receiving a
packet with MAC DA de:ad:be:ef:13:37, so its RX filter drops it even
before the ingress tc filter gets to be executed. So we will incorrectly
get the message "Packet was not flooded when should", when in fact, the
packet was flooded as expected but dropped due to an unrelated reason,
at some other layer on the receiving side.

Force h2 to accept this packet by temporarily placing it in promiscuous
mode. Alternatively we could either deliver to its MAC address or use
tcpdump_start, but this has the fewest complications.

This fixes the "flooding" test from bridge_vlan_aware.sh and
bridge_vlan_unaware.sh, which calls flood_test from the lib.

Fixes: 236dd50bf67a ("selftests: forwarding: Add a test for flooded traffic")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/lib.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 85c587a03c8a..be977cd4bfe3 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -960,6 +960,7 @@ flood_test_do()
 
 	# Add an ACL on `host2_if` which will tell us whether the packet
 	# was flooded to it or not.
+	ip link set $host2_if promisc on
 	tc qdisc add dev $host2_if ingress
 	tc filter add dev $host2_if ingress protocol ip pref 1 handle 101 \
 		flower dst_mac $mac action drop
@@ -977,6 +978,7 @@ flood_test_do()
 
 	tc filter del dev $host2_if ingress protocol ip pref 1 handle 101 flower
 	tc qdisc del dev $host2_if ingress
+	ip link set $host2_if promisc off
 
 	return $err
 }
-- 
2.35.1



