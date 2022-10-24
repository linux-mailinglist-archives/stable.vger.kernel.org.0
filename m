Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC4D560BA9B
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234524AbiJXUjb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234731AbiJXUjE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:39:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 510A7AA3F9;
        Mon, 24 Oct 2022 11:49:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CAB8DB819C7;
        Mon, 24 Oct 2022 12:44:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B62AC433C1;
        Mon, 24 Oct 2022 12:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615491;
        bh=NE6qWbZMRBP1atF7+3F7wOLqV0coY/zY42IzVeA9UKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mr6E26To14YhGyaHMeqD5RW1g71Me8R8gtzIHhuxuSDalQ5WcNXnSTlNZuv6iCsFv
         OskjKvqfJMO/7mDmsmjVK8+ItJZrEDrwF2Qyq5/or+kZnQUt/0g6TJr2W5yvULu5Le
         U4ViZHA9UsBo+SmnEDfO/nJbXsW5z1SsxB914u3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aharon Landau <aharonl@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 272/530] RDMA/mlx5: Dont compare mkey tags in DEVX indirect mkey
Date:   Mon, 24 Oct 2022 13:30:16 +0200
Message-Id: <20221024113057.389667312@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 8664bcf6d3f5..827ee3040bea 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1847,6 +1847,9 @@ static int set_ucontext_resp(struct ib_ucontext *uctx,
 	if (MLX5_CAP_GEN(dev->mdev, drain_sigerr))
 		resp->comp_mask |= MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_SQD2RTS;
 
+	resp->comp_mask |=
+		MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_MKEY_UPDATE_TAG;
+
 	return 0;
 }
 
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index d0d98e584ebc..fcf6447b4a4e 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -792,7 +792,8 @@ static bool mkey_is_eq(struct mlx5_core_mkey *mmkey, u32 key)
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



