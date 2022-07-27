Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7392582CA7
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240546AbiG0QtB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240447AbiG0QsU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:48:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0A861109;
        Wed, 27 Jul 2022 09:32:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65BB7619FF;
        Wed, 27 Jul 2022 16:32:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F8D9C433D7;
        Wed, 27 Jul 2022 16:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939544;
        bh=Mgs8FsaAKn40ItH1NKl9X56eyuelu26sO/CXIYkJYHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YsQTLuR1eaxwWymbvBFb+wl2KaUOghcZenKO4r4U9HH/0WF6h6U8TFtDsJP/faxvX
         cdfsf5NEDSc6r3iHGSrJJgxB42UdkZDOeLdD5VRBn1JrLdZMrfneZrlkM1/DLM45st
         9zaWmTfb7FNThC97DfYpan6a4fBF7q4AWQk87ueQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 003/105] mlxsw: spectrum_router: Fix IPv4 nexthop gateway indication
Date:   Wed, 27 Jul 2022 18:09:49 +0200
Message-Id: <20220727161012.189064558@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161012.056867467@linuxfoundation.org>
References: <20220727161012.056867467@linuxfoundation.org>
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
@@ -4003,7 +4003,7 @@ static bool mlxsw_sp_fi_is_gateway(const
 {
 	const struct fib_nh *nh = fib_info_nh(fi, 0);
 
-	return nh->fib_nh_scope == RT_SCOPE_LINK ||
+	return nh->fib_nh_gw_family ||
 	       mlxsw_sp_nexthop4_ipip_type(mlxsw_sp, nh, NULL);
 }
 


