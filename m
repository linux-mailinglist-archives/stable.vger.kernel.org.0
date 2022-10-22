Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 573CD60893B
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233947AbiJVIbz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234227AbiJVIaE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:30:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 881832E32D9;
        Sat, 22 Oct 2022 01:02:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 050E4B82E11;
        Sat, 22 Oct 2022 07:51:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D038CC433C1;
        Sat, 22 Oct 2022 07:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425069;
        bh=GGfMeq0Y2E3Tt4hU/JXQhleUHqj5ipTavMY9Ad79xMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mwokMRQ52ijagpbWduhcQ0KHynY0dxHloom3b1Ysm4s+FQYhh/jCKm/tNp6EMsIjX
         dToLN1Hrcmt/vKqQs2wJm4v+ojlJQsi0hssjT+vhQLviTR8Phi+3AZkIwt4FXns+i5
         TWdeBszFwiogub75Ks+5pSBm6MXi0ALyM6DvmA8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aharon Landau <aharonl@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 379/717] RDMA/mlx5: Dont compare mkey tags in DEVX indirect mkey
Date:   Sat, 22 Oct 2022 09:24:18 +0200
Message-Id: <20221022072513.991553805@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

[ Upstream commit 13ad1125b941a5f257d9d3ae70485773abd34792 ]

According to the ib spec:
If the CI supports the Base Memory Management Extensions defined in this
specification, the L_Key format must consist of:
24 bit index in the most significant bits of the R_Key, and
8 bit key in the least significant bits of the R_Key
Through a successful Allocate L_Key verb invocation, the CI must let the
consumer own the key portion of the returned R_Key

Therefore, when creating a mkey using DEVX, the consumer is allowed to
change the key part. The kernel should compare only the index part of a
R_Key to determine equality with another R_Key.

Adding capability in order not to break backward compatibility.

Fixes: 534fd7aac56a ("IB/mlx5: Manage indirection mkey upon DEVX flow for ODP")
Link: https://lore.kernel.org/r/3d669aacea85a3a15c3b3b953b3eaba3f80ef9be.1659255945.git.leonro@nvidia.com
Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 3 +++
 drivers/infiniband/hw/mlx5/odp.c  | 3 ++-
 include/uapi/rdma/mlx5-abi.h      | 1 +
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index bb13164124fd..aa4a2a9cb0d5 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1826,6 +1826,9 @@ static int set_ucontext_resp(struct ib_ucontext *uctx,
 	if (MLX5_CAP_GEN(dev->mdev, drain_sigerr))
 		resp->comp_mask |= MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_SQD2RTS;
 
+	resp->comp_mask |=
+		MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_MKEY_UPDATE_TAG;
+
 	return 0;
 }
 
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 84da5674e1ab..9151852f04a1 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -795,7 +795,8 @@ static bool mkey_is_eq(struct mlx5_ib_mkey *mmkey, u32 key)
 {
 	if (!mmkey)
 		return false;
-	if (mmkey->type == MLX5_MKEY_MW)
+	if (mmkey->type == MLX5_MKEY_MW ||
+	    mmkey->type == MLX5_MKEY_INDIRECT_DEVX)
 		return mlx5_base_mkey(mmkey->key) == mlx5_base_mkey(key);
 	return mmkey->key == key;
 }
diff --git a/include/uapi/rdma/mlx5-abi.h b/include/uapi/rdma/mlx5-abi.h
index 86be4a92b67b..a96b7d2770e1 100644
--- a/include/uapi/rdma/mlx5-abi.h
+++ b/include/uapi/rdma/mlx5-abi.h
@@ -104,6 +104,7 @@ enum mlx5_ib_alloc_ucontext_resp_mask {
 	MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_ECE               = 1UL << 2,
 	MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_SQD2RTS           = 1UL << 3,
 	MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_REAL_TIME_TS	   = 1UL << 4,
+	MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_MKEY_UPDATE_TAG   = 1UL << 5,
 };
 
 enum mlx5_user_cmds_supp_uhw {
-- 
2.35.1



