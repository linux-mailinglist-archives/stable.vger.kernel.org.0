Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2A968D7B5
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbjBGNC6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:02:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232009AbjBGNCk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:02:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F11439CE5
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:02:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 165BEB81990
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:01:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44205C4339B;
        Tue,  7 Feb 2023 13:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774914;
        bh=AN0rWPhTLXTfuFqjNMIEjnL7HE2H8ZjobQUqNTchmqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TnItS68Sj3+cdoWZsbPSE+qBGRIcK/RKXks3+5At7sZpq0Y6SLGBLPCBZVadKrxXj
         0WmEh6USLFmqqHsJ8RK6fkncPo4lLcMd4gor/y9L2NeFmx21PL0a1InVhxBYdr2A2f
         cNhbLNs1nAjjDemIsQh8AS0YEnoiP124j3i7RufY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Thomas Winter <Thomas.Winter@alliedtelesis.co.nz>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 075/208] ip/ip6_gre: Fix non-point-to-point tunnel not generating IPv6 link local address
Date:   Tue,  7 Feb 2023 13:55:29 +0100
Message-Id: <20230207125637.725944003@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Winter <Thomas.Winter@alliedtelesis.co.nz>

[ Upstream commit 30e2291f61f93f7132c060190f8360df52644ec1 ]

We recently found that our non-point-to-point tunnels were not
generating any IPv6 link local address and instead generating an
IPv6 compat address, breaking IPv6 communication on the tunnel.

Previously, addrconf_gre_config always would call addrconf_addr_gen
and generate a EUI64 link local address for the tunnel.
Then commit e5dd729460ca changed the code path so that add_v4_addrs
is called but this only generates a compat IPv6 address for
non-point-to-point tunnels.

I assume the compat address is specifically for SIT tunnels so
have kept that only for SIT - GRE tunnels now always generate link
local addresses.

Fixes: e5dd729460ca ("ip/ip6_gre: use the same logic as SIT interfaces when computing v6LL address")
Signed-off-by: Thomas Winter <Thomas.Winter@alliedtelesis.co.nz>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index eaecaf2ffe00..e6c7edcf6834 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3127,17 +3127,17 @@ static void add_v4_addrs(struct inet6_dev *idev)
 		offset = sizeof(struct in6_addr) - 4;
 	memcpy(&addr.s6_addr32[3], idev->dev->dev_addr + offset, 4);
 
-	if (idev->dev->flags&IFF_POINTOPOINT) {
+	if (!(idev->dev->flags & IFF_POINTOPOINT) && idev->dev->type == ARPHRD_SIT) {
+		scope = IPV6_ADDR_COMPATv4;
+		plen = 96;
+		pflags |= RTF_NONEXTHOP;
+	} else {
 		if (idev->cnf.addr_gen_mode == IN6_ADDR_GEN_MODE_NONE)
 			return;
 
 		addr.s6_addr32[0] = htonl(0xfe800000);
 		scope = IFA_LINK;
 		plen = 64;
-	} else {
-		scope = IPV6_ADDR_COMPATv4;
-		plen = 96;
-		pflags |= RTF_NONEXTHOP;
 	}
 
 	if (addr.s6_addr32[3]) {
-- 
2.39.0



