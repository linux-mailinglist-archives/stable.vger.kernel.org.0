Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2677B4A9697
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358170AbiBDJ1S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:27:18 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43806 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358198AbiBDJZw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:25:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEDA5617B5;
        Fri,  4 Feb 2022 09:25:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08387C004E1;
        Fri,  4 Feb 2022 09:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966751;
        bh=gAiEkRCmxoxeR1wsBoW65hMxfhjyd5QKm8WnZv5DEoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yP8bmKUzQIG4BY+lXge4xr4uCygXTTz1lzbq4uWM1d9GN366DRvC/jPLArhHgnEJO
         qwGL6weYLqYxKi9J3N807IWdAXcMBX0mBAm9fJYe6C1NGZ8lUOpkOdwrCzm1ogLlNd
         +mgFPqQ6h5+S6/rgeuIWkFHOAWnCFn1fpgwJfGyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.16 27/43] net/mlx5: E-Switch, Fix uninitialized variable modact
Date:   Fri,  4 Feb 2022 10:22:34 +0100
Message-Id: <20220204091918.050742976@linuxfoundation.org>
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


