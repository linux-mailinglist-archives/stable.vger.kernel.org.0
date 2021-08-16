Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6BC43ED636
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238402AbhHPNSb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:18:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:43052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239116AbhHPNQd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:16:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61721632E8;
        Mon, 16 Aug 2021 13:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119592;
        bh=fArbgl+/scpmangpUQZshNqHMCHt8W4wStYztp6fXHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HwAUl/YjabgchqzvKgQVawVPRNYDqcdoHhoiDEy5bsPb6WsbiOu9WOSoU8fWFpVXt
         VLKAtSb+2gJBoZZOi3DCbp9gAvTkxdJQhUd1TWHskjLPAfBUWjRDIRPgcYBOXHuQvc
         GftPNl1tY7NUc2VkqUNUCperJxIG08GvmzfIQJTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Mi <cmi@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 085/151] net/mlx5e: TC, Fix error handling memory leak
Date:   Mon, 16 Aug 2021 15:01:55 +0200
Message-Id: <20210816125446.873409998@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

[ Upstream commit 88bbd7b2369aca4598eb8f38c5f16be98c3bb5d4 ]

Free the offload sample action on error.

Fixes: f94d6389f6a8 ("net/mlx5e: TC, Add support to offload sample action")
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/sample.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.c
index 794012c5c476..d3ad78aa9d45 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.c
@@ -501,6 +501,7 @@ err_sampler:
 err_offload_rule:
 	mlx5_esw_vporttbl_put(esw, &per_vport_tbl_attr);
 err_default_tbl:
+	kfree(sample_flow);
 	return ERR_PTR(err);
 }
 
-- 
2.30.2



