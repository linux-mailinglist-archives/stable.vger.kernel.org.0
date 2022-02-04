Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3ABF4A9694
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357906AbiBDJ1Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:27:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358189AbiBDJZu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:25:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE65C0617A9;
        Fri,  4 Feb 2022 01:25:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7623B836EF;
        Fri,  4 Feb 2022 09:25:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB473C004E1;
        Fri,  4 Feb 2022 09:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966732;
        bh=4+7MceMecYWOvPMGIDx+1UxoxBhhhIlOqFjbf6KJEtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M9j+oPCRsZ7n11ForRQq040+9HwaxkTbSjzOwzXBbIbvmVdbul1w9+7m+I+pItSMV
         IwLqcI3V1iMyJU968gJPNQihCDHkU5bfpRtF8Za7ZGD1rk1evwgU0E6cauu+FM/2qy
         lAvzxfVS1GxRxDBvnjaR/p3doh5BarUN1nX3+zbU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dima Chumak <dchumak@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.16 21/43] net/mlx5: Fix offloading with ESWITCH_IPV4_TTL_MODIFY_ENABLE
Date:   Fri,  4 Feb 2022 10:22:28 +0100
Message-Id: <20220204091917.867657197@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091917.166033635@linuxfoundation.org>
References: <20220204091917.166033635@linuxfoundation.org>
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


