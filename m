Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB0D4C7528
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239145AbiB1Rvv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:51:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239072AbiB1RvJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:51:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA4EA2F2F;
        Mon, 28 Feb 2022 09:39:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B69661540;
        Mon, 28 Feb 2022 17:39:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A0DC340E7;
        Mon, 28 Feb 2022 17:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069957;
        bh=/k8eIg1NAH1SmFReaKQmxUVMuexZO0RUQC9sV/M3azk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tnh8paZRUQ+vU0NmtSW6hldxaw1tyylScjMbxh0HJwooyog1UVkg6hTIcCrefDvlb
         GrTJDFyjKnKkAZIBPS6+0xDnZDGWNX5GoIDSxF6c1kx3gyqALIxDDbaab/edF7pJoH
         zZRR0ljyJxKycpz+t7AMQ9ekVm8iKGH6ZWUtivPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Mi <cmi@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.15 046/139] net/mlx5: Fix tc max supported prio for nic mode
Date:   Mon, 28 Feb 2022 18:23:40 +0100
Message-Id: <20220228172352.534990702@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

commit be7f4b0ab149afd19514929fad824b2117d238c9 upstream.

Only prio 1 is supported if firmware doesn't support ignore flow
level for nic mode. The offending commit removed the check wrongly.
Add it back.

Fixes: 9a99c8f1253a ("net/mlx5e: E-Switch, Offload all chain 0 priorities when modify header and forward action is not supported")
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
@@ -121,6 +121,9 @@ u32 mlx5_chains_get_nf_ft_chain(struct m
 
 u32 mlx5_chains_get_prio_range(struct mlx5_fs_chains *chains)
 {
+	if (!mlx5_chains_prios_supported(chains))
+		return 1;
+
 	if (mlx5_chains_ignore_flow_level_supported(chains))
 		return UINT_MAX;
 


