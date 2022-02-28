Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61CAF4C7693
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237273AbiB1SFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:05:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240144AbiB1SDB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:03:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D092E54685;
        Mon, 28 Feb 2022 09:46:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C334B81187;
        Mon, 28 Feb 2022 17:46:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E97A2C340E7;
        Mon, 28 Feb 2022 17:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070396;
        bh=4SDR2zPe+STyu+dK5B43Nh1E+LcW275FuOXqcL8NV6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tiVxsMHzqnlayHZpAWKkpBG5y9O8F2gESyIkqR8UGDKZgyDmXm5ZuBc/yzSqOjdkT
         spJM+Jdx05NdfRPn9KOeOsAVgHkt8l4MICuMeod+N1w2cWuXBk5ShLjiPv22EU09by
         /9JcnWWx3xDxQEbNTTJ0AcgGZORlh3+TbbBiRKfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ariel Levkovich <lariel@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.16 092/164] net/mlx5: Fix wrong limitation of metadata match on ecpf
Date:   Mon, 28 Feb 2022 18:24:14 +0100
Message-Id: <20220228172408.161564826@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ariel Levkovich <lariel@nvidia.com>

commit 07666c75ad17d7389b18ac0235c8cf41e1504ea8 upstream.

Match metadata support check returns false for ecpf device.
However, this support does exist for ecpf and therefore this
limitation should be removed to allow feature such as stacked
devices and internal port offloaded to be supported.

Fixes: 92ab1eb392c6 ("net/mlx5: E-Switch, Enable vport metadata matching if firmware supports it")
Signed-off-by: Ariel Levkovich <lariel@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2838,10 +2838,6 @@ bool mlx5_esw_vport_match_metadata_suppo
 	if (!MLX5_CAP_ESW_FLOWTABLE(esw->dev, flow_source))
 		return false;
 
-	if (mlx5_core_is_ecpf_esw_manager(esw->dev) ||
-	    mlx5_ecpf_vport_exists(esw->dev))
-		return false;
-
 	return true;
 }
 


