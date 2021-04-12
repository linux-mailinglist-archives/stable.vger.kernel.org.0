Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A06F35C0C1
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241362AbhDLJPw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:15:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:34712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240708AbhDLJKx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:10:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC1E0613A7;
        Mon, 12 Apr 2021 09:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218389;
        bh=on9LE10NcRX2a3fn8VBAG/aq0VTV1KB3TLpSG7YI/Fo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NY7iWqYVJY2Zd93+e38/v2a5mQPsq3TX1SsfxKGNeV0KS+VJCzh7NbIH3ccrHj4r1
         WyMthKQvrneuXMhsGZVD3PySAKLhwafg57Mhd2/hQNwtRp37yzXf+EcCO/1otgioeU
         fA1P6kZEuXI8pd5uzGYOPZSpYm38LD49j25WpHv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 180/210] net/mlx5: Fix PPLM register mapping
Date:   Mon, 12 Apr 2021 10:41:25 +0200
Message-Id: <20210412084022.005219377@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
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
index def58d333357..443dda54d851 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -8769,6 +8769,8 @@ struct mlx5_ifc_pplm_reg_bits {
 
 	u8         fec_override_admin_100g_2x[0x10];
 	u8         fec_override_admin_50g_1x[0x10];
+
+	u8         reserved_at_140[0x140];
 };
 
 struct mlx5_ifc_ppcnt_reg_bits {
-- 
2.30.2



