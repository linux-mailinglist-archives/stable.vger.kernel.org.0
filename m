Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF1B16C180B
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232589AbjCTPTs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232596AbjCTPT3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:19:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 991BB25E12
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:13:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41A02615B0
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:13:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523F7C433EF;
        Mon, 20 Mar 2023 15:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325232;
        bh=jh2dfid1ONh5OaZ03G+ZERFLYYsNXqd9iPxgNYkofz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aRBjVQ9LLPKjaaJMa/5JmnfA61ZU5WaKAmpvToyEUbS2v6v3GpISEFaVsHvxIrRp4
         A1YUHJjYyPku3tJqX74+JbWdzeycl2NXpUVNe9FhQqNyi462tWg6Q7cNG1BZQ1G19+
         un0QfveV4DW3lOT7mkjkv4sQfYcbf0fkiyi+vzrs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Maksym Yaremchuk <maksymy@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 058/198] mlxsw: spectrum: Fix incorrect parsing depth after reload
Date:   Mon, 20 Mar 2023 15:53:16 +0100
Message-Id: <20230320145509.959668473@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 35c356924fe3669dfbb1185607ce3b37f70bfa80 ]

Spectrum ASICs have a configurable limit on how deep into the packet
they parse. By default, the limit is 96 bytes.

There are several cases where this parsing depth is not enough and there
is a need to increase it. For example, timestamping of PTP packets and a
FIB multipath hash policy that requires hashing on inner fields. The
driver therefore maintains a reference count that reflects the number of
consumers that require an increased parsing depth.

During reload_down() the parsing depth reference count does not
necessarily drop to zero, but the parsing depth itself is restored to
the default during reload_up() when the firmware is reset. It is
therefore possible to end up in situations where the driver thinks that
the parsing depth was increased (reference count is non-zero), when it
is not.

Fix by making sure that all the consumers that increase the parsing
depth reference count also decrease it during reload_down().
Specifically, make sure that when the routing code is de-initialized it
drops the reference count if it was increased because of a FIB multipath
hash policy that requires hashing on inner fields.

Add a warning if the reference count is not zero after the driver was
de-initialized and explicitly reset it to zero during initialization for
good measures.

Fixes: 2d91f0803b84 ("mlxsw: spectrum: Add infrastructure for parsing configuration")
Reported-by: Maksym Yaremchuk <maksymy@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Link: https://lore.kernel.org/r/9c35e1b3e6c1d8f319a2449d14e2b86373f3b3ba.1678727526.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |  2 ++
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  | 14 ++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 5bcf5bceff710..67ecdb9e708f9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2931,6 +2931,7 @@ static int mlxsw_sp_netdevice_event(struct notifier_block *unused,
 
 static void mlxsw_sp_parsing_init(struct mlxsw_sp *mlxsw_sp)
 {
+	refcount_set(&mlxsw_sp->parsing.parsing_depth_ref, 0);
 	mlxsw_sp->parsing.parsing_depth = MLXSW_SP_DEFAULT_PARSING_DEPTH;
 	mlxsw_sp->parsing.vxlan_udp_dport = MLXSW_SP_DEFAULT_VXLAN_UDP_DPORT;
 	mutex_init(&mlxsw_sp->parsing.lock);
@@ -2939,6 +2940,7 @@ static void mlxsw_sp_parsing_init(struct mlxsw_sp *mlxsw_sp)
 static void mlxsw_sp_parsing_fini(struct mlxsw_sp *mlxsw_sp)
 {
 	mutex_destroy(&mlxsw_sp->parsing.lock);
+	WARN_ON_ONCE(refcount_read(&mlxsw_sp->parsing.parsing_depth_ref));
 }
 
 struct mlxsw_sp_ipv6_addr_node {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 48f1fa62a4fd4..ab0aa1a61d4aa 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -10313,11 +10313,23 @@ static int mlxsw_sp_mp_hash_init(struct mlxsw_sp *mlxsw_sp)
 					      old_inc_parsing_depth);
 	return err;
 }
+
+static void mlxsw_sp_mp_hash_fini(struct mlxsw_sp *mlxsw_sp)
+{
+	bool old_inc_parsing_depth = mlxsw_sp->router->inc_parsing_depth;
+
+	mlxsw_sp_mp_hash_parsing_depth_adjust(mlxsw_sp, old_inc_parsing_depth,
+					      false);
+}
 #else
 static int mlxsw_sp_mp_hash_init(struct mlxsw_sp *mlxsw_sp)
 {
 	return 0;
 }
+
+static void mlxsw_sp_mp_hash_fini(struct mlxsw_sp *mlxsw_sp)
+{
+}
 #endif
 
 static int mlxsw_sp_dscp_init(struct mlxsw_sp *mlxsw_sp)
@@ -10547,6 +10559,7 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 err_register_inetaddr_notifier:
 	mlxsw_core_flush_owq();
 err_dscp_init:
+	mlxsw_sp_mp_hash_fini(mlxsw_sp);
 err_mp_hash_init:
 	mlxsw_sp_neigh_fini(mlxsw_sp);
 err_neigh_init:
@@ -10587,6 +10600,7 @@ void mlxsw_sp_router_fini(struct mlxsw_sp *mlxsw_sp)
 	unregister_inet6addr_notifier(&mlxsw_sp->router->inet6addr_nb);
 	unregister_inetaddr_notifier(&mlxsw_sp->router->inetaddr_nb);
 	mlxsw_core_flush_owq();
+	mlxsw_sp_mp_hash_fini(mlxsw_sp);
 	mlxsw_sp_neigh_fini(mlxsw_sp);
 	mlxsw_sp_lb_rif_fini(mlxsw_sp);
 	mlxsw_sp_vrs_fini(mlxsw_sp);
-- 
2.39.2



