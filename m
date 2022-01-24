Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEB94499692
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445816AbiAXVFA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:05:00 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42360 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391751AbiAXUsb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:48:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3E1C60B03;
        Mon, 24 Jan 2022 20:48:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A061EC340E5;
        Mon, 24 Jan 2022 20:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057310;
        bh=SDi7XQa+z8hhY9e0ahfyHw+jU0VjxJ7j6c3Gh+na9HI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GDLO6lAdqTcX4vxMENuGmQpx88pVFG/WUaqw0NEc16mpuTWhujkwQTDzAAkJLowK9
         y1zlSfkAn/rxsXo8Z2jHYiSnh3H/s2GNGfejLPE3m1J3UchoH+Br6963GO3z3hECy/
         gQW8tTYu55iO+/rGlsaylGV2GpLbzrF0Bc+CWPDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 771/846] mlx5: Dont accidentally set RTO_ONLINK before mlx5e_route_lookup_ipv4_get()
Date:   Mon, 24 Jan 2022 19:44:48 +0100
Message-Id: <20220124184127.561936108@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
@@ -229,7 +230,7 @@ int mlx5e_tc_tun_create_header_ipv4(stru
 	int err;
 
 	/* add the IP fields */
-	attr.fl.fl4.flowi4_tos = tun_key->tos;
+	attr.fl.fl4.flowi4_tos = tun_key->tos & ~INET_ECN_MASK;
 	attr.fl.fl4.daddr = tun_key->u.ipv4.dst;
 	attr.fl.fl4.saddr = tun_key->u.ipv4.src;
 	attr.ttl = tun_key->ttl;
@@ -344,7 +345,7 @@ int mlx5e_tc_tun_update_header_ipv4(stru
 	int err;
 
 	/* add the IP fields */
-	attr.fl.fl4.flowi4_tos = tun_key->tos;
+	attr.fl.fl4.flowi4_tos = tun_key->tos & ~INET_ECN_MASK;
 	attr.fl.fl4.daddr = tun_key->u.ipv4.dst;
 	attr.fl.fl4.saddr = tun_key->u.ipv4.src;
 	attr.ttl = tun_key->ttl;


