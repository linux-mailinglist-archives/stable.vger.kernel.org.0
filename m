Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A884635BEC9
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238754AbhDLJCC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:02:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:50126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238618AbhDLI6G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:58:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE73661360;
        Mon, 12 Apr 2021 08:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217830;
        bh=mihkCc7YF2IU+tlWPGrDUJG6EteBh93IevV7csjBgWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O2nz2ZAvK90wGrjg9Va5/Gqv0RZnWSXOb/KmcEN6lYbxtpFPrYVoOyxRjm2XMeikz
         yVYNE3hIbYfMvnrAiS79NBdK/yJ2YH2uswZWyv2BZYqmxKI5CwwxuS0W7tGyVDfjE5
         1QCbgJ8UOsb9TygJIF4tmpDRhe1mJ/EIsUQO1bgk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 160/188] net/mlx5: Fix PBMC register mapping
Date:   Mon, 12 Apr 2021 10:41:14 +0200
Message-Id: <20210412084018.951583705@linuxfoundation.org>
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
index 4b3b2bf83720..cc9ee0776974 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -10058,7 +10058,7 @@ struct mlx5_ifc_pbmc_reg_bits {
 
 	struct mlx5_ifc_bufferx_reg_bits buffer[10];
 
-	u8         reserved_at_2e0[0x40];
+	u8         reserved_at_2e0[0x80];
 };
 
 struct mlx5_ifc_qtct_reg_bits {
-- 
2.30.2



