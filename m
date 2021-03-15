Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E3633BA38
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234185AbhCOOIg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:08:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234051AbhCOOCv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:02:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5033464E83;
        Mon, 15 Mar 2021 14:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816971;
        bh=SmdmaZTN+u6rfsWiropW41TLad6UjFZn7PrwplJm2Uc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZKM5tNKpP5FhnLl0JMtFLEvQObM2UaSyPwsFGy2nbV6nxm2VqeiUyE8Xg9NMPe1Oh
         x74120irxSrY1rhZW9QOnHG2bDckSa/u3p1yIs/fcKhp7bF3PMSavpoRqfZVdLcmab
         b5tQFkKnKbxkuoXCcYtkEnXbn6Wgbd1Nm+nSi5eA=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Alex Veber <alexve@nvidia.com>,
        Petr Machata <petrm@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 237/306] mlxsw: spectrum_router: Ignore routes using a deleted nexthop object
Date:   Mon, 15 Mar 2021 14:55:00 +0100
Message-Id: <20210315135515.652097611@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit dc860b88ce0a7ed9a048d5042cbb175daf60b657 ]

Routes are currently processed from a workqueue whereas nexthop objects
are processed in system call context. This can result in the driver not
finding a suitable nexthop group for a route and issuing a warning [1].

Fix this by ignoring such routes earlier in the process. The subsequent
deletion notification will be ignored as well.

[1]
 WARNING: CPU: 2 PID: 7754 at drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c:4853 mlxsw_sp_router_fib_event_work+0x1112/0x1e00 [mlxsw_spectrum]
 [...]
 CPU: 2 PID: 7754 Comm: kworker/u8:0 Not tainted 5.11.0-rc6-cq-20210207-1 #16
 Hardware name: Mellanox Technologies Ltd. MSN2100/SA001390, BIOS 5.6.5 05/24/2018
 Workqueue: mlxsw_core_ordered mlxsw_sp_router_fib_event_work [mlxsw_spectrum]
 RIP: 0010:mlxsw_sp_router_fib_event_work+0x1112/0x1e00 [mlxsw_spectrum]

Fixes: cdd6cfc54c64 ("mlxsw: spectrum_router: Allow programming routes with nexthop objects")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reported-by: Alex Veber <alexve@nvidia.com>
Tested-by: Alex Veber <alexve@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 41424ee909a0..23d9fe18adba 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -5861,6 +5861,10 @@ mlxsw_sp_router_fib4_replace(struct mlxsw_sp *mlxsw_sp,
 	if (mlxsw_sp->router->aborted)
 		return 0;
 
+	if (fen_info->fi->nh &&
+	    !mlxsw_sp_nexthop_obj_group_lookup(mlxsw_sp, fen_info->fi->nh->id))
+		return 0;
+
 	fib_node = mlxsw_sp_fib_node_get(mlxsw_sp, fen_info->tb_id,
 					 &fen_info->dst, sizeof(fen_info->dst),
 					 fen_info->dst_len,
@@ -6511,6 +6515,9 @@ static int mlxsw_sp_router_fib6_replace(struct mlxsw_sp *mlxsw_sp,
 	if (mlxsw_sp_fib6_rt_should_ignore(rt))
 		return 0;
 
+	if (rt->nh && !mlxsw_sp_nexthop_obj_group_lookup(mlxsw_sp, rt->nh->id))
+		return 0;
+
 	fib_node = mlxsw_sp_fib_node_get(mlxsw_sp, rt->fib6_table->tb6_id,
 					 &rt->fib6_dst.addr,
 					 sizeof(rt->fib6_dst.addr),
-- 
2.30.1



