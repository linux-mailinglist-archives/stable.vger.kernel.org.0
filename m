Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07B374A9640
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357588AbiBDJYP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:24:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52278 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357684AbiBDJXb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:23:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F227BB836EF;
        Fri,  4 Feb 2022 09:23:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B8AAC004E1;
        Fri,  4 Feb 2022 09:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966608;
        bh=4+7MceMecYWOvPMGIDx+1UxoxBhhhIlOqFjbf6KJEtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lt1Wugam6qHUw67mIDyFDpM5xePyogWQTmF6MbmtZCKCDksLj7sh1EH5IQ/3NBn2D
         1myNETm8xDYxdQAG29WHuxUceWCxqWy8YJbYM6zjBlf2YRrYQUYUSe60kaL3yk9v+s
         4J1C6l1TQ2BfbCo6kJMWc8oBwR+a/pAMXz0KMcmM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dima Chumak <dchumak@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.15 17/32] net/mlx5: Fix offloading with ESWITCH_IPV4_TTL_MODIFY_ENABLE
Date:   Fri,  4 Feb 2022 10:22:27 +0100
Message-Id: <20220204091915.826342216@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091915.247906930@linuxfoundation.org>
References: <20220204091915.247906930@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dima Chumak <dchumak@nvidia.com>

commit 55b2ca702cfa744a9eb108915996a2294da47e71 upstream.

Only prio 1 is supported for nic mode when there is no ignore flow level
support in firmware. But for switchdev mode, which supports fixed number
of statically pre-allocated prios, this restriction is not relevant so
it can be relaxed.

Fixes: d671e109bd85 ("net/mlx5: Fix tc max supported prio for nic mode")
Signed-off-by: Dima Chumak <dchumak@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
@@ -121,12 +121,13 @@ u32 mlx5_chains_get_nf_ft_chain(struct m
 
 u32 mlx5_chains_get_prio_range(struct mlx5_fs_chains *chains)
 {
-	if (!mlx5_chains_prios_supported(chains))
-		return 1;
-
 	if (mlx5_chains_ignore_flow_level_supported(chains))
 		return UINT_MAX;
 
+	if (!chains->dev->priv.eswitch ||
+	    chains->dev->priv.eswitch->mode != MLX5_ESWITCH_OFFLOADS)
+		return 1;
+
 	/* We should get here only for eswitch case */
 	return FDB_TC_MAX_PRIO;
 }


