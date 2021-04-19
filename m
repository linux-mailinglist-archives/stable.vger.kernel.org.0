Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFB723642FA
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239888AbhDSNNJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:13:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:45730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239896AbhDSNLk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:11:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 756FB61360;
        Mon, 19 Apr 2021 13:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837869;
        bh=sqV40KsaWSBrmBX/siej+IC7DA/O1R8B/GxGLbUiZDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lNZCLYeV9HyTpS/YP26phDLkcZ1f0J3OOSCcr2K+TsDajvg6VjH6DVTXKy/+Cc0vI
         aYC1fnTDdKdUK5DmCcVq9HUvHR11SRlXMnfZFvhyUeTquwXD9Nl0b+yrVI8vOGyaC7
         A3pjDiM/l0OA2/uwB+g+Gf/WdN5mv1LBezq32Qhc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.11 083/122] net/mlx5e: Fix setting of RS FEC mode
Date:   Mon, 19 Apr 2021 15:06:03 +0200
Message-Id: <20210419130532.978230519@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

commit 7a320c9db3e73fb6c4f9a331087df9df18767221 upstream.

Change register setting from bit number to bit mask.

Fixes: b5ede32d3329 ("net/mlx5e: Add support for FEC modes based on 50G per lane links")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Eran Ben Elisha <eranbe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c |   23 +++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
@@ -387,21 +387,6 @@ enum mlx5e_fec_supported_link_mode {
 			*_policy = MLX5_GET(pplm_reg, _buf, fec_override_admin_##link);	\
 	} while (0)
 
-#define MLX5E_FEC_OVERRIDE_ADMIN_50G_POLICY(buf, policy, write, link)			\
-	do {										\
-		unsigned long policy_long;						\
-		u16 *__policy = &(policy);						\
-		bool _write = (write);							\
-											\
-		policy_long = *__policy;						\
-		if (_write && *__policy)						\
-			*__policy = find_first_bit(&policy_long,			\
-						   sizeof(policy_long) * BITS_PER_BYTE);\
-		MLX5E_FEC_OVERRIDE_ADMIN_POLICY(buf, *__policy, _write, link);		\
-		if (!_write && *__policy)						\
-			*__policy = 1 << *__policy;					\
-	} while (0)
-
 /* get/set FEC admin field for a given speed */
 static int mlx5e_fec_admin_field(u32 *pplm, u16 *fec_policy, bool write,
 				 enum mlx5e_fec_supported_link_mode link_mode)
@@ -423,16 +408,16 @@ static int mlx5e_fec_admin_field(u32 *pp
 		MLX5E_FEC_OVERRIDE_ADMIN_POLICY(pplm, *fec_policy, write, 100g);
 		break;
 	case MLX5E_FEC_SUPPORTED_LINK_MODE_50G_1X:
-		MLX5E_FEC_OVERRIDE_ADMIN_50G_POLICY(pplm, *fec_policy, write, 50g_1x);
+		MLX5E_FEC_OVERRIDE_ADMIN_POLICY(pplm, *fec_policy, write, 50g_1x);
 		break;
 	case MLX5E_FEC_SUPPORTED_LINK_MODE_100G_2X:
-		MLX5E_FEC_OVERRIDE_ADMIN_50G_POLICY(pplm, *fec_policy, write, 100g_2x);
+		MLX5E_FEC_OVERRIDE_ADMIN_POLICY(pplm, *fec_policy, write, 100g_2x);
 		break;
 	case MLX5E_FEC_SUPPORTED_LINK_MODE_200G_4X:
-		MLX5E_FEC_OVERRIDE_ADMIN_50G_POLICY(pplm, *fec_policy, write, 200g_4x);
+		MLX5E_FEC_OVERRIDE_ADMIN_POLICY(pplm, *fec_policy, write, 200g_4x);
 		break;
 	case MLX5E_FEC_SUPPORTED_LINK_MODE_400G_8X:
-		MLX5E_FEC_OVERRIDE_ADMIN_50G_POLICY(pplm, *fec_policy, write, 400g_8x);
+		MLX5E_FEC_OVERRIDE_ADMIN_POLICY(pplm, *fec_policy, write, 400g_8x);
 		break;
 	default:
 		return -EINVAL;


