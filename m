Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00A3859D43C
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242765AbiHWISn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243091AbiHWIQf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:16:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C101D26E9;
        Tue, 23 Aug 2022 01:11:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5234F612D7;
        Tue, 23 Aug 2022 08:11:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD84C433D6;
        Tue, 23 Aug 2022 08:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242284;
        bh=xzFXTcj5rZlnFvpKISIdjBybio5fBX5Hp895vlOgAWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hs1PYo6pvHoKjs9bt9MV+Y+3UuhW+Wry5J4VCvCNzlu6CPbCCadxY6ALB6LcYJQVP
         pI8mxVso8UzTfpHJyiCxVpF7wELwLyk9al8QaGHrexGkbVmr2PftV0VBKQSR44ifls
         agGUV3nVwuUmGThRZTx4/qPeoD5QTklF7GgPAlqM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ivan Vecera <ivecera@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.19 088/365] selftests: forwarding: Fix failing tests with old libnet
Date:   Tue, 23 Aug 2022 09:59:49 +0200
Message-Id: <20220823080121.870034612@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ido Schimmel <idosch@nvidia.com>

commit 8bcfb4ae4d970b9a9724ddfbac26c387934e0e94 upstream.

The custom multipath hash tests use mausezahn in order to test how
changes in various packet fields affect the packet distribution across
the available nexthops.

The tool uses the libnet library for various low-level packet
construction and injection. The library started using the
"SO_BINDTODEVICE" socket option for IPv6 sockets in version 1.1.6 and
for IPv4 sockets in version 1.2.

When the option is not set, packets are not routed according to the
table associated with the VRF master device and tests fail.

Fix this by prefixing the command with "ip vrf exec", which will cause
the route lookup to occur in the VRF routing table. This makes the tests
pass regardless of the libnet library version.

Fixes: 511e8db54036 ("selftests: forwarding: Add test for custom multipath hash")
Fixes: 185b0c190bb6 ("selftests: forwarding: Add test for custom multipath hash with IPv4 GRE")
Fixes: b7715acba4d3 ("selftests: forwarding: Add test for custom multipath hash with IPv6 GRE")
Reported-by: Ivan Vecera <ivecera@redhat.com>
Tested-by: Ivan Vecera <ivecera@redhat.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
Link: https://lore.kernel.org/r/20220809113320.751413-1-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/forwarding/custom_multipath_hash.sh        |   24 ++++++----
 tools/testing/selftests/net/forwarding/gre_custom_multipath_hash.sh    |   24 ++++++----
 tools/testing/selftests/net/forwarding/ip6gre_custom_multipath_hash.sh |   24 ++++++----
 3 files changed, 48 insertions(+), 24 deletions(-)

--- a/tools/testing/selftests/net/forwarding/custom_multipath_hash.sh
+++ b/tools/testing/selftests/net/forwarding/custom_multipath_hash.sh
@@ -181,37 +181,43 @@ ping_ipv6()
 
 send_src_ipv4()
 {
-	$MZ $h1 -q -p 64 -A "198.51.100.2-198.51.100.253" -B 203.0.113.2 \
+	ip vrf exec v$h1 $MZ $h1 -q -p 64 \
+		-A "198.51.100.2-198.51.100.253" -B 203.0.113.2 \
 		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
 }
 
 send_dst_ipv4()
 {
-	$MZ $h1 -q -p 64 -A 198.51.100.2 -B "203.0.113.2-203.0.113.253" \
+	ip vrf exec v$h1 $MZ $h1 -q -p 64 \
+		-A 198.51.100.2 -B "203.0.113.2-203.0.113.253" \
 		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
 }
 
 send_src_udp4()
 {
-	$MZ $h1 -q -p 64 -A 198.51.100.2 -B 203.0.113.2 \
+	ip vrf exec v$h1 $MZ $h1 -q -p 64 \
+		-A 198.51.100.2 -B 203.0.113.2 \
 		-d 1msec -t udp "sp=0-32768,dp=30000"
 }
 
 send_dst_udp4()
 {
-	$MZ $h1 -q -p 64 -A 198.51.100.2 -B 203.0.113.2 \
+	ip vrf exec v$h1 $MZ $h1 -q -p 64 \
+		-A 198.51.100.2 -B 203.0.113.2 \
 		-d 1msec -t udp "sp=20000,dp=0-32768"
 }
 
 send_src_ipv6()
 {
-	$MZ -6 $h1 -q -p 64 -A "2001:db8:1::2-2001:db8:1::fd" -B 2001:db8:4::2 \
+	ip vrf exec v$h1 $MZ -6 $h1 -q -p 64 \
+		-A "2001:db8:1::2-2001:db8:1::fd" -B 2001:db8:4::2 \
 		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
 }
 
 send_dst_ipv6()
 {
-	$MZ -6 $h1 -q -p 64 -A 2001:db8:1::2 -B "2001:db8:4::2-2001:db8:4::fd" \
+	ip vrf exec v$h1 $MZ -6 $h1 -q -p 64 \
+		-A 2001:db8:1::2 -B "2001:db8:4::2-2001:db8:4::fd" \
 		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
 }
 
@@ -226,13 +232,15 @@ send_flowlabel()
 
 send_src_udp6()
 {
-	$MZ -6 $h1 -q -p 64 -A 2001:db8:1::2 -B 2001:db8:4::2 \
+	ip vrf exec v$h1 $MZ -6 $h1 -q -p 64 \
+		-A 2001:db8:1::2 -B 2001:db8:4::2 \
 		-d 1msec -t udp "sp=0-32768,dp=30000"
 }
 
 send_dst_udp6()
 {
-	$MZ -6 $h1 -q -p 64 -A 2001:db8:1::2 -B 2001:db8:4::2 \
+	ip vrf exec v$h1 $MZ -6 $h1 -q -p 64 \
+		-A 2001:db8:1::2 -B 2001:db8:4::2 \
 		-d 1msec -t udp "sp=20000,dp=0-32768"
 }
 
--- a/tools/testing/selftests/net/forwarding/gre_custom_multipath_hash.sh
+++ b/tools/testing/selftests/net/forwarding/gre_custom_multipath_hash.sh
@@ -276,37 +276,43 @@ ping_ipv6()
 
 send_src_ipv4()
 {
-	$MZ $h1 -q -p 64 -A "198.51.100.2-198.51.100.253" -B 203.0.113.2 \
+	ip vrf exec v$h1 $MZ $h1 -q -p 64 \
+		-A "198.51.100.2-198.51.100.253" -B 203.0.113.2 \
 		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
 }
 
 send_dst_ipv4()
 {
-	$MZ $h1 -q -p 64 -A 198.51.100.2 -B "203.0.113.2-203.0.113.253" \
+	ip vrf exec v$h1 $MZ $h1 -q -p 64 \
+		-A 198.51.100.2 -B "203.0.113.2-203.0.113.253" \
 		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
 }
 
 send_src_udp4()
 {
-	$MZ $h1 -q -p 64 -A 198.51.100.2 -B 203.0.113.2 \
+	ip vrf exec v$h1 $MZ $h1 -q -p 64 \
+		-A 198.51.100.2 -B 203.0.113.2 \
 		-d 1msec -t udp "sp=0-32768,dp=30000"
 }
 
 send_dst_udp4()
 {
-	$MZ $h1 -q -p 64 -A 198.51.100.2 -B 203.0.113.2 \
+	ip vrf exec v$h1 $MZ $h1 -q -p 64 \
+		-A 198.51.100.2 -B 203.0.113.2 \
 		-d 1msec -t udp "sp=20000,dp=0-32768"
 }
 
 send_src_ipv6()
 {
-	$MZ -6 $h1 -q -p 64 -A "2001:db8:1::2-2001:db8:1::fd" -B 2001:db8:2::2 \
+	ip vrf exec v$h1 $MZ -6 $h1 -q -p 64 \
+		-A "2001:db8:1::2-2001:db8:1::fd" -B 2001:db8:2::2 \
 		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
 }
 
 send_dst_ipv6()
 {
-	$MZ -6 $h1 -q -p 64 -A 2001:db8:1::2 -B "2001:db8:2::2-2001:db8:2::fd" \
+	ip vrf exec v$h1 $MZ -6 $h1 -q -p 64 \
+		-A 2001:db8:1::2 -B "2001:db8:2::2-2001:db8:2::fd" \
 		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
 }
 
@@ -321,13 +327,15 @@ send_flowlabel()
 
 send_src_udp6()
 {
-	$MZ -6 $h1 -q -p 64 -A 2001:db8:1::2 -B 2001:db8:2::2 \
+	ip vrf exec v$h1 $MZ -6 $h1 -q -p 64 \
+		-A 2001:db8:1::2 -B 2001:db8:2::2 \
 		-d 1msec -t udp "sp=0-32768,dp=30000"
 }
 
 send_dst_udp6()
 {
-	$MZ -6 $h1 -q -p 64 -A 2001:db8:1::2 -B 2001:db8:2::2 \
+	ip vrf exec v$h1 $MZ -6 $h1 -q -p 64 \
+		-A 2001:db8:1::2 -B 2001:db8:2::2 \
 		-d 1msec -t udp "sp=20000,dp=0-32768"
 }
 
--- a/tools/testing/selftests/net/forwarding/ip6gre_custom_multipath_hash.sh
+++ b/tools/testing/selftests/net/forwarding/ip6gre_custom_multipath_hash.sh
@@ -278,37 +278,43 @@ ping_ipv6()
 
 send_src_ipv4()
 {
-	$MZ $h1 -q -p 64 -A "198.51.100.2-198.51.100.253" -B 203.0.113.2 \
+	ip vrf exec v$h1 $MZ $h1 -q -p 64 \
+		-A "198.51.100.2-198.51.100.253" -B 203.0.113.2 \
 		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
 }
 
 send_dst_ipv4()
 {
-	$MZ $h1 -q -p 64 -A 198.51.100.2 -B "203.0.113.2-203.0.113.253" \
+	ip vrf exec v$h1 $MZ $h1 -q -p 64 \
+		-A 198.51.100.2 -B "203.0.113.2-203.0.113.253" \
 		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
 }
 
 send_src_udp4()
 {
-	$MZ $h1 -q -p 64 -A 198.51.100.2 -B 203.0.113.2 \
+	ip vrf exec v$h1 $MZ $h1 -q -p 64 \
+		-A 198.51.100.2 -B 203.0.113.2 \
 		-d 1msec -t udp "sp=0-32768,dp=30000"
 }
 
 send_dst_udp4()
 {
-	$MZ $h1 -q -p 64 -A 198.51.100.2 -B 203.0.113.2 \
+	ip vrf exec v$h1 $MZ $h1 -q -p 64 \
+		-A 198.51.100.2 -B 203.0.113.2 \
 		-d 1msec -t udp "sp=20000,dp=0-32768"
 }
 
 send_src_ipv6()
 {
-	$MZ -6 $h1 -q -p 64 -A "2001:db8:1::2-2001:db8:1::fd" -B 2001:db8:2::2 \
+	ip vrf exec v$h1 $MZ -6 $h1 -q -p 64 \
+		-A "2001:db8:1::2-2001:db8:1::fd" -B 2001:db8:2::2 \
 		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
 }
 
 send_dst_ipv6()
 {
-	$MZ -6 $h1 -q -p 64 -A 2001:db8:1::2 -B "2001:db8:2::2-2001:db8:2::fd" \
+	ip vrf exec v$h1 $MZ -6 $h1 -q -p 64 \
+		-A 2001:db8:1::2 -B "2001:db8:2::2-2001:db8:2::fd" \
 		-d 1msec -c 50 -t udp "sp=20000,dp=30000"
 }
 
@@ -323,13 +329,15 @@ send_flowlabel()
 
 send_src_udp6()
 {
-	$MZ -6 $h1 -q -p 64 -A 2001:db8:1::2 -B 2001:db8:2::2 \
+	ip vrf exec v$h1 $MZ -6 $h1 -q -p 64 \
+		-A 2001:db8:1::2 -B 2001:db8:2::2 \
 		-d 1msec -t udp "sp=0-32768,dp=30000"
 }
 
 send_dst_udp6()
 {
-	$MZ -6 $h1 -q -p 64 -A 2001:db8:1::2 -B 2001:db8:2::2 \
+	ip vrf exec v$h1 $MZ -6 $h1 -q -p 64 \
+		-A 2001:db8:1::2 -B 2001:db8:2::2 \
 		-d 1msec -t udp "sp=20000,dp=0-32768"
 }
 


