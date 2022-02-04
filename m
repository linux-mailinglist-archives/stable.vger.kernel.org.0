Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95CA74A9605
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357450AbiBDJWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:22:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357453AbiBDJVe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:21:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F656C061401;
        Fri,  4 Feb 2022 01:21:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47E52B836EC;
        Fri,  4 Feb 2022 09:21:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D739C004E1;
        Fri,  4 Feb 2022 09:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966491;
        bh=t6fosH+/jo0oyk3kX5RJYCWAgBNoLIkcuTpouivDE3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w4X6R4zdwaRWCPk7Q8xOtCXiduOiMqI2VYUPHPList7nq0c3KGulx7eYQUHtvP5Oe
         SF6mCeovVSYtNrMHUphXTPAjBsgRnoUa12chZompe4cestSKRhvHLISKfaLRbz5V1L
         Hl8ClXGJyqBoDZtmojec7hBK/TaHB8oRUcwhdcIk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.10 16/25] net/mlx5: E-Switch, Fix uninitialized variable modact
Date:   Fri,  4 Feb 2022 10:20:23 +0100
Message-Id: <20220204091914.813309593@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091914.280602669@linuxfoundation.org>
References: <20220204091914.280602669@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

commit d8e5883d694bb053b19c4142a2d1f43a34f6fe2c upstream.

The variable modact is not initialized before used in command
modify header allocation which can cause command to fail.

Fix by initializing modact with zeros.

Addresses-Coverity: ("Uninitialized scalar variable")
Fixes: 8f1e0b97cc70 ("net/mlx5: E-Switch, Mark miss packets with new chain id mapping")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
@@ -292,7 +292,7 @@ static int
 create_chain_restore(struct fs_chain *chain)
 {
 	struct mlx5_eswitch *esw = chain->chains->dev->priv.eswitch;
-	char modact[MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)];
+	u8 modact[MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)] = {};
 	struct mlx5_fs_chains *chains = chain->chains;
 	enum mlx5e_tc_attr_to_reg chain_to_reg;
 	struct mlx5_modify_hdr *mod_hdr;


