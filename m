Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD2E35BD94
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238475AbhDLIwZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:52:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:42984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238657AbhDLIuS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:50:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 447926109E;
        Mon, 12 Apr 2021 08:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217400;
        bh=4+ClA8wOFRun7HPBB/E9Gz5nKTQl7aK+eqQ96ydXl34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cjj81wSpv4c55vn2LDTby0UQ6eOCVC5M6e0k76BZLmLlAvS0eFYU8eRgeznNGnqBA
         f8K9JGkWPBKq9nCXCZRt0YwvHUbYAWHnq+hXmavYdmgYLS19d/XbuwcGuV0ixxkXJ7
         OkoQC5PVCdYf28AQ7mp2lpmi1ezIZoMgqaZW8Iuc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 090/111] net/mlx5: Fix placement of log_max_flow_counter
Date:   Mon, 12 Apr 2021 10:41:08 +0200
Message-Id: <20210412084007.241096063@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084004.200986670@linuxfoundation.org>
References: <20210412084004.200986670@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raed Salem <raeds@nvidia.com>

[ Upstream commit a14587dfc5ad2312dabdd42a610d80ecd0dc8bea ]

The cited commit wrongly placed log_max_flow_counter field of
mlx5_ifc_flow_table_prop_layout_bits, align it to the HW spec intended
placement.

Fixes: 16f1c5bb3ed7 ("net/mlx5: Check device capability for maximum flow counters")
Signed-off-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mlx5/mlx5_ifc.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 75e5a7fe341f..8099517e2e61 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -415,11 +415,11 @@ struct mlx5_ifc_flow_table_prop_layout_bits {
 	u8         reserved_at_60[0x18];
 	u8         log_max_ft_num[0x8];
 
-	u8         reserved_at_80[0x18];
+	u8         reserved_at_80[0x10];
+	u8         log_max_flow_counter[0x8];
 	u8         log_max_destination[0x8];
 
-	u8         log_max_flow_counter[0x8];
-	u8         reserved_at_a8[0x10];
+	u8         reserved_at_a0[0x18];
 	u8         log_max_flow[0x8];
 
 	u8         reserved_at_c0[0x40];
-- 
2.30.2



