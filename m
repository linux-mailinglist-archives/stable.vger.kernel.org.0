Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10B6B35BF21
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239315AbhDLJC4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:02:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:48830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238884AbhDLI6C (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:58:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35C2F6134F;
        Mon, 12 Apr 2021 08:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217827;
        bh=3u/jVZ/Y7bhEqs3VQyPQsYwwBd5mqye4jhWmRgEOtd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rsLuYwj70jt83ZztEVTNOuDj79tZdyWjpXHufOLvTxeuq6dI/GKXrWjDi9y4eljG0
         xFeN0t+jxVT2yzfhjMn1Rvg3PnU7KVbI1QUGuflWXapJA9YPc+oW/OUHt3ZwT5qB9p
         /knL7+ek+TNFvL1uMtp2Yu7UZ2Mh5ufUVWenjA2U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 159/188] net/mlx5: Fix PPLM register mapping
Date:   Mon, 12 Apr 2021 10:41:13 +0200
Message-Id: <20210412084018.920659080@linuxfoundation.org>
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

From: Aya Levin <ayal@nvidia.com>

[ Upstream commit ce28f0fd670ddffcd564ce7119bdefbaf08f02d3 ]

Add reserved mapping to cover all the register in order to avoid
setting arbitrary values to newer FW which implements the reserved
fields.

Fixes: a58837f52d43 ("net/mlx5e: Expose FEC feilds and related capability bit")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mlx5/mlx5_ifc.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 19c1cb214953..4b3b2bf83720 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -8719,6 +8719,8 @@ struct mlx5_ifc_pplm_reg_bits {
 
 	u8         fec_override_admin_100g_2x[0x10];
 	u8         fec_override_admin_50g_1x[0x10];
+
+	u8         reserved_at_140[0x140];
 };
 
 struct mlx5_ifc_ppcnt_reg_bits {
-- 
2.30.2



