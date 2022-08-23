Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0157C59D90F
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242668AbiHWJwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:52:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352245AbiHWJv0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:51:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3CBF9F0D5;
        Tue, 23 Aug 2022 01:45:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 591CF6123D;
        Tue, 23 Aug 2022 08:45:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D329C433D6;
        Tue, 23 Aug 2022 08:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244350;
        bh=9b1xcz5ZdzJJW2NlfVI2a27n7SsK5+EFJIyllGw0yIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RoUv2KeAIZboMqBXJlnfAJxOi56sN8wLjXssDZMObUhkBL9e+FIvOsBAH92+oFyv7
         qm+/PtPeFcbOTzsy6qqymmrfrT8fA7TuRe8sTryiiwxu5DnHpYjnpsnKbYSdX325Uf
         x4ZUwW77JyGdkBSftHkdA3nLutkBAOg1OuhU5Kpo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        Matthias May <matthias.may@westermo.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 077/244] mlx5: do not use RT_TOS for IPv6 flowlabel
Date:   Tue, 23 Aug 2022 10:23:56 +0200
Message-Id: <20220823080101.624025877@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
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
@@ -497,7 +497,7 @@ int mlx5e_tc_tun_create_header_ipv6(stru
 	int err;
 
 	attr.ttl = tun_key->ttl;
-	attr.fl.fl6.flowlabel = ip6_make_flowinfo(RT_TOS(tun_key->tos), tun_key->label);
+	attr.fl.fl6.flowlabel = ip6_make_flowinfo(tun_key->tos, tun_key->label);
 	attr.fl.fl6.daddr = tun_key->u.ipv6.dst;
 	attr.fl.fl6.saddr = tun_key->u.ipv6.src;
 
@@ -611,7 +611,7 @@ int mlx5e_tc_tun_update_header_ipv6(stru
 
 	attr.ttl = tun_key->ttl;
 
-	attr.fl.fl6.flowlabel = ip6_make_flowinfo(RT_TOS(tun_key->tos), tun_key->label);
+	attr.fl.fl6.flowlabel = ip6_make_flowinfo(tun_key->tos, tun_key->label);
 	attr.fl.fl6.daddr = tun_key->u.ipv6.dst;
 	attr.fl.fl6.saddr = tun_key->u.ipv6.src;
 


