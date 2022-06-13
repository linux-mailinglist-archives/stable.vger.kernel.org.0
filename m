Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A25A4548AC4
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380537AbiFMN7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380162AbiFMNxn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:53:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B6BB7FB;
        Mon, 13 Jun 2022 04:34:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C6396124B;
        Mon, 13 Jun 2022 11:34:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A06C34114;
        Mon, 13 Jun 2022 11:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120039;
        bh=swWzbn2TpIpi73RFLngVo0lUDHXK3tIvjiipGZ76mpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bulihAumDrGz1nt1YOF3aZ17Dw8UtvuWytsIalqp9vy6MOGvBJM0tBX7py9q7dRYD
         orJPLveiFZgtyGnUmFedWcD836/wzCiM98JZHY/Mlo/ZQOlr5Wn+X5NXd3TSD0ewgG
         NXgaT7zPrunHh85YMIRiTqkoscTfnrT9yDj+aH3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anton Makarov <am@3a-alliance.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 221/339] net: seg6: fix seg6_lookup_any_nexthop() to handle VRFs using flowi_l3mdev
Date:   Mon, 13 Jun 2022 12:10:46 +0200
Message-Id: <20220613094933.359666192@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
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

From: Andrea Mayer <andrea.mayer@uniroma2.it>

[ Upstream commit a3bd2102e464202b58d57390a538d96f57ffc361 ]

Commit 40867d74c374 ("net: Add l3mdev index to flow struct and avoid oif
reset for port devices") adds a new entry (flowi_l3mdev) in the common
flow struct used for indicating the l3mdev index for later rule and
table matching.
The l3mdev_update_flow() has been adapted to properly set the
flowi_l3mdev based on the flowi_oif/flowi_iif. In fact, when a valid
flowi_iif is supplied to the l3mdev_update_flow(), this function can
update the flowi_l3mdev entry only if it has not yet been set (i.e., the
flowi_l3mdev entry is equal to 0).

The SRv6 End.DT6 behavior in VRF mode leverages a VRF device in order to
force the routing lookup into the associated routing table. This routing
operation is performed by seg6_lookup_any_nextop() preparing a flowi6
data structure used by ip6_route_input_lookup() which, in turn,
(indirectly) invokes l3mdev_update_flow().

However, seg6_lookup_any_nexthop() does not initialize the new
flowi_l3mdev entry which is filled with random garbage data. This
prevents l3mdev_update_flow() from properly updating the flowi_l3mdev
with the VRF index, and thus SRv6 End.DT6 (VRF mode)/DT46 behaviors are
broken.

This patch correctly initializes the flowi6 instance allocated and used
by seg6_lookup_any_nexhtop(). Specifically, the entire flowi6 instance
is wiped out: in case new entries are added to flowi/flowi6 (as happened
with the flowi_l3mdev entry), we should no longer have incorrectly
initialized values. As a result of this operation, the value of
flowi_l3mdev is also set to 0.

The proposed fix can be tested easily. Starting from the commit
referenced in the Fixes, selftests [1],[2] indicate that the SRv6
End.DT6 (VRF mode)/DT46 behaviors no longer work correctly. By applying
this patch, those behaviors are back to work properly again.

[1] - tools/testing/selftests/net/srv6_end_dt46_l3vpn_test.sh
[2] - tools/testing/selftests/net/srv6_end_dt6_l3vpn_test.sh

Fixes: 40867d74c374 ("net: Add l3mdev index to flow struct and avoid oif reset for port devices")
Reported-by: Anton Makarov <am@3a-alliance.com>
Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20220608091917.20345-1-andrea.mayer@uniroma2.it
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/seg6_local.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index 9fbe243a0e81..98a34287439c 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -218,6 +218,7 @@ seg6_lookup_any_nexthop(struct sk_buff *skb, struct in6_addr *nhaddr,
 	struct flowi6 fl6;
 	int dev_flags = 0;
 
+	memset(&fl6, 0, sizeof(fl6));
 	fl6.flowi6_iif = skb->dev->ifindex;
 	fl6.daddr = nhaddr ? *nhaddr : hdr->daddr;
 	fl6.saddr = hdr->saddr;
-- 
2.35.1



