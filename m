Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75037582BBB
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238247AbiG0Qgj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238381AbiG0Qfm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:35:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E404F67E;
        Wed, 27 Jul 2022 09:27:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98A3FB821B8;
        Wed, 27 Jul 2022 16:27:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F400EC433C1;
        Wed, 27 Jul 2022 16:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939274;
        bh=ovd6V4NmZ+Qv5MuBP6kCDQrWTrx06853QQqr7hUwoBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XILHpY9w2unSD3+XAkJ3++ErUDm7Znxt4/xtxCSr960ap1Av6ZZJDJSr/kVTT6T1b
         0OJTX29ItEl7dC7C597iFcnvaLB4AOnDJC8cK8Vm+aShKTJi0rv/zlS+5ogsan5qNP
         LHw8JFF6+d9AvMhMepLuA9YuD7YTeHFZnaq9rVGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 03/87] mlxsw: spectrum_router: Fix IPv4 nexthop gateway indication
Date:   Wed, 27 Jul 2022 18:09:56 +0200
Message-Id: <20220727161009.141332848@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161008.993711844@linuxfoundation.org>
References: <20220727161008.993711844@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

commit e5ec6a2513383fe2ecc2ee3b5f51d97acbbcd4d8 upstream.

mlxsw needs to distinguish nexthops with a gateway from connected
nexthops in order to write the former to the adjacency table of the
device. The check used to rely on the fact that nexthops with a gateway
have a 'link' scope whereas connected nexthops have a 'host' scope. This
is no longer correct after commit 747c14307214 ("ip: fix dflt addr
selection for connected nexthop").

Fix that by instead checking the address family of the gateway IP. This
is a more direct way and also consistent with the IPv6 counterpart in
mlxsw_sp_rt6_is_gateway().

Cc: stable@vger.kernel.org
Fixes: 747c14307214 ("ip: fix dflt addr selection for connected nexthop")
Fixes: 597cfe4fc339 ("nexthop: Add support for IPv4 nexthops")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -3871,7 +3871,7 @@ static bool mlxsw_sp_fi_is_gateway(const
 {
 	const struct fib_nh *nh = fib_info_nh(fi, 0);
 
-	return nh->fib_nh_scope == RT_SCOPE_LINK ||
+	return nh->fib_nh_gw_family ||
 	       mlxsw_sp_nexthop4_ipip_type(mlxsw_sp, nh, NULL);
 }
 


