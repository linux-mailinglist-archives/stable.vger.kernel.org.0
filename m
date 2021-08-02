Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8653DD9EB
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234508AbhHBOFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:05:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:49254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235374AbhHBODf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 10:03:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DB3761213;
        Mon,  2 Aug 2021 13:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912644;
        bh=oX+PPv98BJSxwT/n1DseA7FzU7nRbflS69hyA3nJO5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dN0i4s9mJcQEvv778Is+h92wzuqqgNJ+niPa1GrU0/NQU+hvuzzHAAonPjyoOqdtL
         IN+Crof5f19ewl/9fh+Ik1lTT4Sc33+IQkdsOyuL0zYQaFcUD3enDf1vVQjtUvkzkZ
         YTwXtsbXG+TdKqMnh6w1/cpSitIdDkblR9LbEVSA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ariel Levkovich <lariel@nvidia.com>,
        Chris Mi <cmi@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 085/104] net/mlx5: Fix mlx5_vport_tbl_attr chain from u16 to u32
Date:   Mon,  2 Aug 2021 15:45:22 +0200
Message-Id: <20210802134346.806357505@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

[ Upstream commit 740452e09cf5fc489ce60831cf11abef117b5d26 ]

The offending refactor commit uses u16 chain wrongly. Actually, it
should be u32.

Fixes: c620b772152b ("net/mlx5: Refactor tc flow attributes structure")
CC: Ariel Levkovich <lariel@nvidia.com>
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 64ccb2bc0b58..e0f6f75fd9d6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -629,7 +629,7 @@ struct esw_vport_tbl_namespace {
 };
 
 struct mlx5_vport_tbl_attr {
-	u16 chain;
+	u32 chain;
 	u16 prio;
 	u16 vport;
 	const struct esw_vport_tbl_namespace *vport_ns;
-- 
2.30.2



