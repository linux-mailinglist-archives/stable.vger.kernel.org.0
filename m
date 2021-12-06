Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3AD469E18
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348761AbhLFPgK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:36:10 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47986 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387705AbhLFPbp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:31:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2799F612D3;
        Mon,  6 Dec 2021 15:28:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D439C34900;
        Mon,  6 Dec 2021 15:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804495;
        bh=Tzzy4LAHl3h1AWlxJtkLsu1MACLFCVkZX2M5PZZoIow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qM0ZOfURvfiTtGXYlxjHDaxVO+4w50wZpIR0hEicPH+msTkKWYzFNoQ8Ck/jAD5US
         AaWOI1Ipfdx6EpQsV8R4LJ+7oScBJrCOdvokCAtMWWPEKLTc8wkS9eWxJHp3D5Ijo8
         nqQ3XiNSXLewFKL1ETL2phtk18vEAGzM1gOE0KM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmytro Linkin <dlinkin@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 166/207] net/mlx5: E-Switch, Check group pointer before reading bw_share value
Date:   Mon,  6 Dec 2021 15:57:00 +0100
Message-Id: <20211206145616.018015013@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

[ Upstream commit 5c4e8ae7aa4875041102406801ee434e6c581aef ]

If log_esw_max_sched_depth is not supported group pointer of the vport
is NULL. Hence, check the pointer before reading bw_share value.

Fixes: 0fe132eac38c ("net/mlx5: E-switch, Allow to add vports to rate groups")
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
index 4501e3d737f80..d377ddc70fc70 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
@@ -130,7 +130,7 @@ static u32 esw_qos_calculate_min_rate_divider(struct mlx5_eswitch *esw,
 	/* If vports min rate divider is 0 but their group has bw_share configured, then
 	 * need to set bw_share for vports to minimal value.
 	 */
-	if (!group_level && !max_guarantee && group->bw_share)
+	if (!group_level && !max_guarantee && group && group->bw_share)
 		return 1;
 	return 0;
 }
-- 
2.33.0



