Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78E7959D5CC
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243675AbiHWIco (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244052AbiHWIaq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:30:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B922C105;
        Tue, 23 Aug 2022 01:15:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB26D61347;
        Tue, 23 Aug 2022 08:14:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD105C433C1;
        Tue, 23 Aug 2022 08:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242487;
        bh=ybewNcAyiMT2IKRPezU22xC7+zcYjaE58rdzZyjjN+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x/SVChI57QKowY6BeG18fbTkHdjVoo64R3ThEYcOKprD+/+Ln+YbViYcQ3hVhbC0J
         MB9baPuCNbrIW75bDdGUTAy7btt6qaT4CgI6BM3Po3jC/AP4SicKpJjO/mbBYMhlHk
         ciZaPkL3IOF5NpCZJ3HnbWNMP1OALT+G8zHUNqkY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        Matthias May <matthias.may@westermo.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.19 122/365] mlx5: do not use RT_TOS for IPv6 flowlabel
Date:   Tue, 23 Aug 2022 10:00:23 +0200
Message-Id: <20220823080123.293782169@linuxfoundation.org>
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

From: Matthias May <matthias.may@westermo.com>

commit bcb0da7fffee9464073998b267ce5543da2356d2 upstream.

According to Guillaume Nault RT_TOS should never be used for IPv6.

Quote:
RT_TOS() is an old macro used to interprete IPv4 TOS as described in
the obsolete RFC 1349. It's conceptually wrong to use it even in IPv4
code, although, given the current state of the code, most of the
existing calls have no consequence.

But using RT_TOS() in IPv6 code is always a bug: IPv6 never had a "TOS"
field to be interpreted the RFC 1349 way. There's no historical
compatibility to worry about.

Fixes: ce99f6b97fcd ("net/mlx5e: Support SRIOV TC encapsulation offloads for IPv6 tunnels")
Acked-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Matthias May <matthias.may@westermo.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -506,7 +506,7 @@ int mlx5e_tc_tun_create_header_ipv6(stru
 	int err;
 
 	attr.ttl = tun_key->ttl;
-	attr.fl.fl6.flowlabel = ip6_make_flowinfo(RT_TOS(tun_key->tos), tun_key->label);
+	attr.fl.fl6.flowlabel = ip6_make_flowinfo(tun_key->tos, tun_key->label);
 	attr.fl.fl6.daddr = tun_key->u.ipv6.dst;
 	attr.fl.fl6.saddr = tun_key->u.ipv6.src;
 
@@ -620,7 +620,7 @@ int mlx5e_tc_tun_update_header_ipv6(stru
 
 	attr.ttl = tun_key->ttl;
 
-	attr.fl.fl6.flowlabel = ip6_make_flowinfo(RT_TOS(tun_key->tos), tun_key->label);
+	attr.fl.fl6.flowlabel = ip6_make_flowinfo(tun_key->tos, tun_key->label);
 	attr.fl.fl6.daddr = tun_key->u.ipv6.dst;
 	attr.fl.fl6.saddr = tun_key->u.ipv6.src;
 


