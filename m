Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F06649A479
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2371422AbiAYAIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:08:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2364075AbiAXXqo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:46:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D12C061341;
        Mon, 24 Jan 2022 13:42:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0794161502;
        Mon, 24 Jan 2022 21:42:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1BA0C340E4;
        Mon, 24 Jan 2022 21:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060529;
        bh=3gCsW3Bzejtk0VzmibWuV4DlZ1YanDbwS2MEgP2bdzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ANO0HvrLUVzHNLYlaAxKKFzMb5l21Yt3r5WYR3Rm4apozDZ3xIOWdOxe0B86Q60Ik
         o9kRAzmPR1eOsufLe+/Buk++nVC92baJcmoADiijk+s9HImv8RVX8sPm9uRSPK2Ffn
         ejucKZ0t+HxG9abW/4ap711yPKRwCwYbXCK3ExdE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.16 0946/1039] mlx5: Dont accidentally set RTO_ONLINK before mlx5e_route_lookup_ipv4_get()
Date:   Mon, 24 Jan 2022 19:45:35 +0100
Message-Id: <20220124184157.094780705@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>

commit 48d67543e01d73292e0bb66d3f10fc422e79e031 upstream.

Mask the ECN bits before calling mlx5e_route_lookup_ipv4_get(). The
tunnel key might have the last ECN bit set. This interferes with the
route lookup process as ip_route_output_key_hash() interpretes this bit
specially (to restrict the route scope).

Found by code inspection, compile tested only.

Fixes: c7b9038d8af6 ("net/mlx5e: TC preparation refactoring for routing update event")
Fixes: 9a941117fb76 ("net/mlx5e: Maximize ip tunnel key usage on the TC offloading path")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
 /* Copyright (c) 2018 Mellanox Technologies. */
 
+#include <net/inet_ecn.h>
 #include <net/vxlan.h>
 #include <net/gre.h>
 #include <net/geneve.h>
@@ -235,7 +236,7 @@ int mlx5e_tc_tun_create_header_ipv4(stru
 	int err;
 
 	/* add the IP fields */
-	attr.fl.fl4.flowi4_tos = tun_key->tos;
+	attr.fl.fl4.flowi4_tos = tun_key->tos & ~INET_ECN_MASK;
 	attr.fl.fl4.daddr = tun_key->u.ipv4.dst;
 	attr.fl.fl4.saddr = tun_key->u.ipv4.src;
 	attr.ttl = tun_key->ttl;
@@ -350,7 +351,7 @@ int mlx5e_tc_tun_update_header_ipv4(stru
 	int err;
 
 	/* add the IP fields */
-	attr.fl.fl4.flowi4_tos = tun_key->tos;
+	attr.fl.fl4.flowi4_tos = tun_key->tos & ~INET_ECN_MASK;
 	attr.fl.fl4.daddr = tun_key->u.ipv4.dst;
 	attr.fl.fl4.saddr = tun_key->u.ipv4.src;
 	attr.ttl = tun_key->ttl;


