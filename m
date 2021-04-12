Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5EA35BEC8
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238706AbhDLJCB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:02:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:50004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238551AbhDLI6C (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:58:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 739EB61262;
        Mon, 12 Apr 2021 08:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217825;
        bh=rsq5Kkvw7JHM4ECBbCd0fHBorHbQBroRioNMSGx3f4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iCtw+6J7Tr7C+KiyyV6x7ED8hU2n4126Rkpta/KnL51YU0o5ghB331JEuchOPvcFM
         rIPsLbOv7pkAoWIsPCK6QWLGsUio8XkYyn7ZDdbptQ1NsQmrFKBWEAe+35Yf3QyWLe
         KBxasj8OtLcFPcJrJO5SYRMuUkz7TP8GT/4NWj4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 158/188] net/mlx5: Fix placement of log_max_flow_counter
Date:   Mon, 12 Apr 2021 10:41:12 +0200
Message-Id: <20210412084018.886607551@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
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
index 233352447b1a..19c1cb214953 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -435,11 +435,11 @@ struct mlx5_ifc_flow_table_prop_layout_bits {
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



