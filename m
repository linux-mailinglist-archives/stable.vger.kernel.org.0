Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E2C35BD96
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238501AbhDLIw1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:52:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:41562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238673AbhDLIuV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:50:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 003AF61244;
        Mon, 12 Apr 2021 08:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217403;
        bh=fzqAs5/YzJXtkkxEdtON6yNfKrTBewolnD95yAlU674=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nf16ww3g1vNZIZ5KX7/7stkMk+I7rLNp1M/70XWnxiViASp8q2jkXQEL6dbA8H43K
         7yLQT9ZX58UArDBJm6mtwgYQKN6l5AVA3I/e1kp7I6kpsozfW9xYUjJ459xFK7p7Al
         tBVxzFAzChx7hWfmlUmCRj4Nd5WPVDrM++ZytNYU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 091/111] net/mlx5: Fix PBMC register mapping
Date:   Mon, 12 Apr 2021 10:41:09 +0200
Message-Id: <20210412084007.271525013@linuxfoundation.org>
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

From: Aya Levin <ayal@nvidia.com>

[ Upstream commit 534b1204ca4694db1093b15cf3e79a99fcb6a6da ]

Add reserved mapping to cover all the register in order to avoid setting
arbitrary values to newer FW which implements the reserved fields.

Fixes: 50b4a3c23646 ("net/mlx5: PPTB and PBMC register firmware command support")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mlx5/mlx5_ifc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 8099517e2e61..36516fe86fe7 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -9669,7 +9669,7 @@ struct mlx5_ifc_pbmc_reg_bits {
 
 	struct mlx5_ifc_bufferx_reg_bits buffer[10];
 
-	u8         reserved_at_2e0[0x40];
+	u8         reserved_at_2e0[0x80];
 };
 
 struct mlx5_ifc_qtct_reg_bits {
-- 
2.30.2



