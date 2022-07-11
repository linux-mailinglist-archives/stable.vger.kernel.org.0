Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5C0656FC00
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233004AbiGKJhq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232799AbiGKJhE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:37:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D76F4D4DE;
        Mon, 11 Jul 2022 02:19:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3C0D612B7;
        Mon, 11 Jul 2022 09:19:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D1AC34115;
        Mon, 11 Jul 2022 09:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531161;
        bh=13USmbIN3HFkiw1i02GRSczp16nmyxwwPWc6C2ThZb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fOsG8kTSUWExCk95r5st4sNHLxcKgUT3wLjJhIvhtoI5SDS2Hj4kMa7Si9Ap1amn9
         Mh7FwnfLgmsXeyKhkJgsLZQQkx+qqmJmWcNa6JH9Wa1gBrCY3rOIGX0dJQe2wQB9jM
         ONVeoj1+U3M/llD/fAzLIa1wr60WXpVcYIPbl9Tw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 083/112] selftests: forwarding: fix learning_test when h1 supports IFF_UNICAST_FLT
Date:   Mon, 11 Jul 2022 11:07:23 +0200
Message-Id: <20220711090551.927835704@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
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

[ Upstream commit 1a635d3e1c80626237fdae47a5545b6655d8d81c ]

The first host interface has by default no interest in receiving packets
MAC DA de:ad:be:ef:13:37, so it might drop them before they hit the tc
filter and this might confuse the selftest.

Enable promiscuous mode such that the filter properly counts received
packets.

Fixes: d4deb01467ec ("selftests: forwarding: Add a test for FDB learning")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/lib.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 823e5cef062d..412e52e89071 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -1176,6 +1176,7 @@ learning_test()
 	# FDB entry was installed.
 	bridge link set dev $br_port1 flood off
 
+	ip link set $host1_if promisc on
 	tc qdisc add dev $host1_if ingress
 	tc filter add dev $host1_if ingress protocol ip pref 1 handle 101 \
 		flower dst_mac $mac action drop
@@ -1225,6 +1226,7 @@ learning_test()
 
 	tc filter del dev $host1_if ingress protocol ip pref 1 handle 101 flower
 	tc qdisc del dev $host1_if ingress
+	ip link set $host1_if promisc off
 
 	bridge link set dev $br_port1 flood on
 
-- 
2.35.1



