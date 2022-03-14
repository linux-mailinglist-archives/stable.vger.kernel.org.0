Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D436F4D8469
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241085AbiCNMYO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243917AbiCNMVX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:21:23 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B3312AB0;
        Mon, 14 Mar 2022 05:18:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1C3B1CE116D;
        Mon, 14 Mar 2022 12:18:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 148EEC340E9;
        Mon, 14 Mar 2022 12:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647260281;
        bh=H5PrVNJ9RgkeRrsR7UrsrQ5G4Bj6FAhEeIAnrs3d6CU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pNuUhsUf5+cJRnA+2xLq2Oit32SeQt9bqDk8skNx/gURBIQsTwSnEYz5kJCA+xARx
         5NpAAixibXaSGhDo2Iame/NsPNv3NiGyeSXYkqj2SOZ+KH6OGNDC2amGDZb9FTa8Y7
         L0IXkNlstzjbJ1a++lwR8GFcqZ0Q7FAKH7lW3S18=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dima Chumak <dchumak@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.16 103/121] net/mlx5: Fix offloading with ESWITCH_IPV4_TTL_MODIFY_ENABLE
Date:   Mon, 14 Mar 2022 12:54:46 +0100
Message-Id: <20220314112746.988662178@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
References: <20220314112744.120491875@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dima Chumak <dchumak@nvidia.com>

commit 39bab83b119faac4bf7f07173a42ed35be95147e upstream.

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
 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
@@ -121,9 +121,6 @@ u32 mlx5_chains_get_nf_ft_chain(struct m
 
 u32 mlx5_chains_get_prio_range(struct mlx5_fs_chains *chains)
 {
-	if (!mlx5_chains_prios_supported(chains))
-		return 1;
-
 	if (mlx5_chains_ignore_flow_level_supported(chains))
 		return UINT_MAX;
 


