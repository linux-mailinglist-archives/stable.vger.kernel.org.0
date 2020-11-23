Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAB52C0BB2
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729891AbgKWN3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:29:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:40532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729814AbgKWM35 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:29:57 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDEFA20781;
        Mon, 23 Nov 2020 12:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134595;
        bh=rAcPQE4Pyb89krisL2VuBtbaVMFIUWmxdljlRMhVbjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xUhDfMeDzvmHUNC2Zf/o3B+rTUAfGyW2WEqQZ4eCJIHK08bzhlD9KRS6bcMc/hUJ0
         m3M4bXG+GRMNjTZemFiwoofmkX8or0GOKfK7TUZsMKG30cE52UNL+NsN0B8VsZnMFT
         5INcWF/OF3Fmya6eycq6sLszfX4/nySPBrI+y7vA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 15/91] net/mlx4_core: Fix init_hca fields offset
Date:   Mon, 23 Nov 2020 13:21:35 +0100
Message-Id: <20201123121810.045221651@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121809.285416732@linuxfoundation.org>
References: <20201123121809.285416732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

[ Upstream commit 6d9c8d15af0ef20a66a0b432cac0d08319920602 ]

Slave function read the following capabilities from the wrong offset:
1. log_mc_entry_sz
2. fs_log_entry_sz
3. log_mc_hash_sz

Fix that by adjusting these capabilities offset to match firmware
layout.

Due to the wrong offset read, the following issues might occur:
1+2. Negative value reported at max_mcast_qp_attach.
3. Driver to init FW with multicast hash size of zero.

Fixes: a40ded604365 ("net/mlx4_core: Add masking for a few queries on HCA caps")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Eran Ben Elisha <eranbe@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://lore.kernel.org/r/20201118081922.553-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx4/fw.c |    6 +++---
 drivers/net/ethernet/mellanox/mlx4/fw.h |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -1861,8 +1861,8 @@ int mlx4_INIT_HCA(struct mlx4_dev *dev,
 #define	 INIT_HCA_LOG_RD_OFFSET		 (INIT_HCA_QPC_OFFSET + 0x77)
 #define INIT_HCA_MCAST_OFFSET		 0x0c0
 #define	 INIT_HCA_MC_BASE_OFFSET	 (INIT_HCA_MCAST_OFFSET + 0x00)
-#define	 INIT_HCA_LOG_MC_ENTRY_SZ_OFFSET (INIT_HCA_MCAST_OFFSET + 0x12)
-#define	 INIT_HCA_LOG_MC_HASH_SZ_OFFSET	 (INIT_HCA_MCAST_OFFSET + 0x16)
+#define	 INIT_HCA_LOG_MC_ENTRY_SZ_OFFSET (INIT_HCA_MCAST_OFFSET + 0x13)
+#define	 INIT_HCA_LOG_MC_HASH_SZ_OFFSET	 (INIT_HCA_MCAST_OFFSET + 0x17)
 #define  INIT_HCA_UC_STEERING_OFFSET	 (INIT_HCA_MCAST_OFFSET + 0x18)
 #define	 INIT_HCA_LOG_MC_TABLE_SZ_OFFSET (INIT_HCA_MCAST_OFFSET + 0x1b)
 #define  INIT_HCA_DEVICE_MANAGED_FLOW_STEERING_EN	0x6
@@ -1870,7 +1870,7 @@ int mlx4_INIT_HCA(struct mlx4_dev *dev,
 #define  INIT_HCA_DRIVER_VERSION_SZ       0x40
 #define  INIT_HCA_FS_PARAM_OFFSET         0x1d0
 #define  INIT_HCA_FS_BASE_OFFSET          (INIT_HCA_FS_PARAM_OFFSET + 0x00)
-#define  INIT_HCA_FS_LOG_ENTRY_SZ_OFFSET  (INIT_HCA_FS_PARAM_OFFSET + 0x12)
+#define  INIT_HCA_FS_LOG_ENTRY_SZ_OFFSET  (INIT_HCA_FS_PARAM_OFFSET + 0x13)
 #define  INIT_HCA_FS_A0_OFFSET		  (INIT_HCA_FS_PARAM_OFFSET + 0x18)
 #define  INIT_HCA_FS_LOG_TABLE_SZ_OFFSET  (INIT_HCA_FS_PARAM_OFFSET + 0x1b)
 #define  INIT_HCA_FS_ETH_BITS_OFFSET      (INIT_HCA_FS_PARAM_OFFSET + 0x21)
--- a/drivers/net/ethernet/mellanox/mlx4/fw.h
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.h
@@ -182,8 +182,8 @@ struct mlx4_init_hca_param {
 	u64 cmpt_base;
 	u64 mtt_base;
 	u64 global_caps;
-	u16 log_mc_entry_sz;
-	u16 log_mc_hash_sz;
+	u8 log_mc_entry_sz;
+	u8 log_mc_hash_sz;
 	u16 hca_core_clock; /* Internal Clock Frequency (in MHz) */
 	u8  log_num_qps;
 	u8  log_num_srqs;


