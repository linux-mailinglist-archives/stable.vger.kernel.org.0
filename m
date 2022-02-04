Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD35D4A964F
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357901AbiBDJYo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:24:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357534AbiBDJX7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:23:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C35ACC061748;
        Fri,  4 Feb 2022 01:23:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E734CB836EB;
        Fri,  4 Feb 2022 09:23:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2C97C004E1;
        Fri,  4 Feb 2022 09:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966622;
        bh=gAiEkRCmxoxeR1wsBoW65hMxfhjyd5QKm8WnZv5DEoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OCCwDDEDzyQIgNwmZavMzkTXu5bra1ihlGlXijEUAQXhPq8nTsVD+UrzC91y8EXeH
         THx031zD5y6EniQBDu01A4qzsJk/K7uK566rWkNBbITjyPlCI3DxmyOSoo1xXNDI+3
         gC9L5y0Y6VowCrPPDW9z2icz+BsTK3Rb05JNFrEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.15 20/32] net/mlx5: E-Switch, Fix uninitialized variable modact
Date:   Fri,  4 Feb 2022 10:22:30 +0100
Message-Id: <20220204091915.919230917@linuxfoundation.org>
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
@@ -212,7 +212,7 @@ static int
 create_chain_restore(struct fs_chain *chain)
 {
 	struct mlx5_eswitch *esw = chain->chains->dev->priv.eswitch;
-	char modact[MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)];
+	u8 modact[MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)] = {};
 	struct mlx5_fs_chains *chains = chain->chains;
 	enum mlx5e_tc_attr_to_reg chain_to_reg;
 	struct mlx5_modify_hdr *mod_hdr;


