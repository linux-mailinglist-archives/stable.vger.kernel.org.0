Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 987E564A000
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232661AbiLLNSM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:18:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232753AbiLLNRY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:17:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9EE9E97
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:17:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 898806105A
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:17:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D87EC433EF;
        Mon, 12 Dec 2022 13:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670851041;
        bh=qxhcBJ7OP2O4MBzO55lc5kEM8kriSGccyTuUthPMi00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yIXv1aTraNBZXSfmIpeAUKCaTNsOiCXSo/up4Si1nKxBrps/lF/WKDPgwdx307cUU
         4qfUUL6FSNKFg3hvJb5Czu8exUtPke7Ll+8VQErAdRGijOBmWEWYtffH3QoinD4Ne/
         ZUPO9wg8JzLXv4kuhAeGb9RJt2gtwIcfpWXX78FI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ido Schimmel <idosch@nvidia.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 096/106] ipv4: Fix incorrect route flushing when source address is deleted
Date:   Mon, 12 Dec 2022 14:10:39 +0100
Message-Id: <20221212130929.051120879@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit f96a3d74554df537b6db5c99c27c80e7afadc8d1 ]

Cited commit added the table ID to the FIB info structure, but did not
prevent structures with different table IDs from being consolidated.
This can lead to routes being flushed from a VRF when an address is
deleted from a different VRF.

Fix by taking the table ID into account when looking for a matching FIB
info. This is already done for FIB info structures backed by a nexthop
object in fib_find_info_nh().

Add test cases that fail before the fix:

 # ./fib_tests.sh -t ipv4_del_addr

 IPv4 delete address route tests
     Regular FIB info
     TEST: Route removed from VRF when source address deleted            [ OK ]
     TEST: Route in default VRF not removed                              [ OK ]
     TEST: Route removed in default VRF when source address deleted      [ OK ]
     TEST: Route in VRF is not removed by address delete                 [ OK ]
     Identical FIB info with different table ID
     TEST: Route removed from VRF when source address deleted            [FAIL]
     TEST: Route in default VRF not removed                              [ OK ]
 RTNETLINK answers: File exists
     TEST: Route removed in default VRF when source address deleted      [ OK ]
     TEST: Route in VRF is not removed by address delete                 [FAIL]

 Tests passed:   6
 Tests failed:   2

And pass after:

 # ./fib_tests.sh -t ipv4_del_addr

 IPv4 delete address route tests
     Regular FIB info
     TEST: Route removed from VRF when source address deleted            [ OK ]
     TEST: Route in default VRF not removed                              [ OK ]
     TEST: Route removed in default VRF when source address deleted      [ OK ]
     TEST: Route in VRF is not removed by address delete                 [ OK ]
     Identical FIB info with different table ID
     TEST: Route removed from VRF when source address deleted            [ OK ]
     TEST: Route in default VRF not removed                              [ OK ]
     TEST: Route removed in default VRF when source address deleted      [ OK ]
     TEST: Route in VRF is not removed by address delete                 [ OK ]

 Tests passed:   8
 Tests failed:   0

Fixes: 5a56a0b3a45d ("net: Don't delete routes in different VRFs")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/fib_semantics.c                 |  1 +
 tools/testing/selftests/net/fib_tests.sh | 27 ++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 52ec0c43e6b8..ab9fcc6231b8 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -423,6 +423,7 @@ static struct fib_info *fib_find_info(struct fib_info *nfi)
 		    nfi->fib_prefsrc == fi->fib_prefsrc &&
 		    nfi->fib_priority == fi->fib_priority &&
 		    nfi->fib_type == fi->fib_type &&
+		    nfi->fib_tb_id == fi->fib_tb_id &&
 		    memcmp(nfi->fib_metrics, fi->fib_metrics,
 			   sizeof(u32) * RTAX_MAX) == 0 &&
 		    !((nfi->fib_flags ^ fi->fib_flags) & ~RTNH_COMPARE_MASK) &&
diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
index a7f53c2a9580..a7b40dc56cae 100755
--- a/tools/testing/selftests/net/fib_tests.sh
+++ b/tools/testing/selftests/net/fib_tests.sh
@@ -1622,13 +1622,19 @@ ipv4_del_addr_test()
 
 	$IP addr add dev dummy1 172.16.104.1/24
 	$IP addr add dev dummy1 172.16.104.11/24
+	$IP addr add dev dummy1 172.16.104.12/24
 	$IP addr add dev dummy2 172.16.104.1/24
 	$IP addr add dev dummy2 172.16.104.11/24
+	$IP addr add dev dummy2 172.16.104.12/24
 	$IP route add 172.16.105.0/24 via 172.16.104.2 src 172.16.104.11
+	$IP route add 172.16.106.0/24 dev lo src 172.16.104.12
 	$IP route add vrf red 172.16.105.0/24 via 172.16.104.2 src 172.16.104.11
+	$IP route add vrf red 172.16.106.0/24 dev lo src 172.16.104.12
 	set +e
 
 	# removing address from device in vrf should only remove route from vrf table
+	echo "    Regular FIB info"
+
 	$IP addr del dev dummy2 172.16.104.11/24
 	$IP ro ls vrf red | grep -q 172.16.105.0/24
 	log_test $? 1 "Route removed from VRF when source address deleted"
@@ -1646,6 +1652,27 @@ ipv4_del_addr_test()
 	$IP ro ls vrf red | grep -q 172.16.105.0/24
 	log_test $? 0 "Route in VRF is not removed by address delete"
 
+	# removing address from device in vrf should only remove route from vrf
+	# table even when the associated fib info only differs in table ID
+	echo "    Identical FIB info with different table ID"
+
+	$IP addr del dev dummy2 172.16.104.12/24
+	$IP ro ls vrf red | grep -q 172.16.106.0/24
+	log_test $? 1 "Route removed from VRF when source address deleted"
+
+	$IP ro ls | grep -q 172.16.106.0/24
+	log_test $? 0 "Route in default VRF not removed"
+
+	$IP addr add dev dummy2 172.16.104.12/24
+	$IP route add vrf red 172.16.106.0/24 dev lo src 172.16.104.12
+
+	$IP addr del dev dummy1 172.16.104.12/24
+	$IP ro ls | grep -q 172.16.106.0/24
+	log_test $? 1 "Route removed in default VRF when source address deleted"
+
+	$IP ro ls vrf red | grep -q 172.16.106.0/24
+	log_test $? 0 "Route in VRF is not removed by address delete"
+
 	$IP li del dummy1
 	$IP li del dummy2
 	cleanup
-- 
2.35.1



