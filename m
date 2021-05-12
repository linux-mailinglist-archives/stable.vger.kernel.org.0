Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4CCA37CD6A
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240176AbhELQyz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:54:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:33484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243898AbhELQmM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14C66619A8;
        Wed, 12 May 2021 16:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835691;
        bh=4EIPDa9+DwiT5wnyibwULpKA1znI2FhkEU3tx5v+jQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sPLESnDZepbDzjBGfBkyBVFSd8Y6KZOEl0JLMxHt9BfPUdJ4pXKLOjlTsinPQW/uB
         MQlin2om8Z/zKBl755NwztYb7zDgTowFJg4YTA1QqhvFFyfvdYwoKQp5Cv4TOfKcNL
         ICGn6b/nfWnUTC5kNyqu9qx1grFyCM1na6bRzdyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Vesker <valex@mellanox.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 445/677] net/mlx5: DR, Add missing vhca_id consume from STEv1
Date:   Wed, 12 May 2021 16:48:11 +0200
Message-Id: <20210512144852.137708286@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

[ Upstream commit cc82a2e6c8af956d894fa58a040dc0d532dd9978 ]

The field source_eswitch_owner_vhca_id was not consumed
in the same way as in STEv0. Added the missing set.

Fixes: 10b694186410 ("net/mlx5: DR, Add HW STEv1 match logic")
Signed-off-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
index 9143ec326ebf..f146c618a78e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
@@ -1532,6 +1532,7 @@ static void dr_ste_v1_build_src_gvmi_qpn_bit_mask(struct mlx5dr_match_param *val
 
 	DR_STE_SET_ONES(src_gvmi_qp_v1, bit_mask, source_gvmi, misc_mask, source_port);
 	DR_STE_SET_ONES(src_gvmi_qp_v1, bit_mask, source_qp, misc_mask, source_sqn);
+	misc_mask->source_eswitch_owner_vhca_id = 0;
 }
 
 static int dr_ste_v1_build_src_gvmi_qpn_tag(struct mlx5dr_match_param *value,
-- 
2.30.2



