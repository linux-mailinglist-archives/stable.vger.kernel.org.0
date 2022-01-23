Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF5C4496ECD
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 01:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235344AbiAWAOg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jan 2022 19:14:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235696AbiAWANt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jan 2022 19:13:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934C8C0613EC;
        Sat, 22 Jan 2022 16:12:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3078060F2F;
        Sun, 23 Jan 2022 00:12:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5C6C340E7;
        Sun, 23 Jan 2022 00:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642896774;
        bh=lH0A/QKBIqfiGBlevd1r6WIjiQ9AhbmQphx2kvuwohU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pRom+PTLmI76gvyjygvc5D5/th3QRawMAcU6h/C8rv3z0vhAhd3d3ZRf/BXznhMIZ
         6EsSzLX8v4GlsYmHM44Z4jqRlm0u3Q1TwapFeWZzQwicP3hjM42LvOpoc7JbijrgJ5
         Z3yT83Gqb255qGojbcmiFDfPKTeoV+0dkCSoQZdTJOIdjpjLk0fHFs30ckxADd3Fs2
         6Nu1u8D4Md5/EV1v0IOp7u/+OT0lPOuEO4GLWwmfpImmFOvOrMHYLLqYV3Xs5fBR8r
         b7ZCtw5AwF7VK8NnBXNX4m1/G91OG0aejTzjDhIr7v3j83DJRDIV6dygpXlFgh0TH8
         TSBnwU6TjVSpA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eli Cohen <elic@nvidia.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>, parav@nvidia.com,
        xieyongji@bytedance.com, virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.15 14/16] vdpa/mlx5: Fix is_index_valid() to refer to features
Date:   Sat, 22 Jan 2022 19:12:13 -0500
Message-Id: <20220123001216.2460383-14-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220123001216.2460383-1-sashal@kernel.org>
References: <20220123001216.2460383-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

[ Upstream commit f8ae3a489b21b05c39a0a1a7734f2a0188852177 ]

Make sure the decision whether an index received through a callback is
valid or not consults the negotiated features.

The motivation for this was due to a case encountered where I shut down
the VM. After the reset operation was called features were already
clear, I got get_vq_state() call which caused out array bounds
access since is_index_valid() reported the index value.

So this is more of not hit a bug since the call shouldn't have been made
first place.

Signed-off-by: Eli Cohen <elic@nvidia.com>
Link: https://lore.kernel.org/r/20220111183400.38418-4-elic@nvidia.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Si-Wei Liu<si-wei.liu@oracle.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index ae85d2dd6eb76..d538fbc472666 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -137,10 +137,14 @@ struct mlx5_vdpa_virtqueue {
 
 static bool is_index_valid(struct mlx5_vdpa_dev *mvdev, u16 idx)
 {
-	if (unlikely(idx > mvdev->max_idx))
-		return false;
+	if (!(mvdev->actual_features & BIT_ULL(VIRTIO_NET_F_MQ))) {
+		if (!(mvdev->actual_features & BIT_ULL(VIRTIO_NET_F_CTRL_VQ)))
+			return idx < 2;
+		else
+			return idx < 3;
+	}
 
-	return true;
+	return idx <= mvdev->max_idx;
 }
 
 struct mlx5_vdpa_net {
-- 
2.34.1

