Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99AE14DB29E
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 15:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345348AbiCPOS0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 10:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356590AbiCPOSY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 10:18:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 888FB68F89;
        Wed, 16 Mar 2022 07:17:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34DF6B81B08;
        Wed, 16 Mar 2022 14:17:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D24C340EC;
        Wed, 16 Mar 2022 14:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647440227;
        bh=6zLz/9Zh1RR3ggBa17qzUrw7ZSDAunI0M98e6yogLJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bgJjQJK0RTD3reI6B4Q6dcuCvqmz7jwcJpCJUTaiO/rY3/GO2O3WqN96WWF2wIj6F
         lY/UL6EcqjQRhCxgcJ/+eKESuPFPJ6cFb2cF2ZMbdbo9xS9gyf7uNmJ8MHLW4Kwc+E
         xkZ4N3S0hQPPT9sYzpyQvgnqTyDsNtZkIQB0JJtbihmoD18STLOpmavTWft/iO8xMD
         Q7aFQTUBGi8vWCF2es8mr6KBMpIsHCNjjqsYVpwv1Yyj8y27KlRlr8FM1Tn9R3zBqn
         rIuV9y9aHFIecNu5nItbsPPswokMsiYV+tTdr2/c/0FTB5MYPz4BVkbLL7KpFLbDR0
         ad2acdiJl8KBg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Si-Wei Liu <si-wei.liu@oracle.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Eli Cohen <elic@nvidia.com>, Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>, parav@nvidia.com,
        xieyongji@bytedance.com, virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.10 06/12] vdpa/mlx5: should verify CTRL_VQ feature exists for MQ
Date:   Wed, 16 Mar 2022 10:16:30 -0400
Message-Id: <20220316141636.248324-6-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220316141636.248324-1-sashal@kernel.org>
References: <20220316141636.248324-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Si-Wei Liu <si-wei.liu@oracle.com>

[ Upstream commit 30c22f3816ffef8aa21a000e93c4ee1402a6ea65 ]

Per VIRTIO v1.1 specification, section 5.1.3.1 Feature bit requirements:
"VIRTIO_NET_F_MQ Requires VIRTIO_NET_F_CTRL_VQ".

There's assumption in the mlx5_vdpa multiqueue code that MQ must come
together with CTRL_VQ. However, there's nowhere in the upper layer to
guarantee this assumption would hold. Were there an untrusted driver
sending down MQ without CTRL_VQ, it would compromise various spots for
e.g. is_index_valid() and is_ctrl_vq_idx(). Although this doesn't end
up with immediate panic or security loophole as of today's code, the
chance for this to be taken advantage of due to future code change is
not zero.

Harden the crispy assumption by failing the set_driver_features() call
when seeing (MQ && !CTRL_VQ). For that end, verify_min_features() is
renamed to verify_driver_features() to reflect the fact that it now does
more than just validate the minimum features. verify_driver_features()
is now used to accommodate various checks against the driver features
for set_driver_features().

Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
Link: https://lore.kernel.org/r/1642206481-30721-3-git-send-email-si-wei.liu@oracle.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Eli Cohen <elic@nvidia.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 65d6f8fd81e7..577ff786f11b 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1482,11 +1482,25 @@ static u64 mlx5_vdpa_get_features(struct vdpa_device *vdev)
 	return ndev->mvdev.mlx_features;
 }
 
-static int verify_min_features(struct mlx5_vdpa_dev *mvdev, u64 features)
+static int verify_driver_features(struct mlx5_vdpa_dev *mvdev, u64 features)
 {
+	/* Minimum features to expect */
 	if (!(features & BIT_ULL(VIRTIO_F_ACCESS_PLATFORM)))
 		return -EOPNOTSUPP;
 
+	/* Double check features combination sent down by the driver.
+	 * Fail invalid features due to absence of the depended feature.
+	 *
+	 * Per VIRTIO v1.1 specification, section 5.1.3.1 Feature bit
+	 * requirements: "VIRTIO_NET_F_MQ Requires VIRTIO_NET_F_CTRL_VQ".
+	 * By failing the invalid features sent down by untrusted drivers,
+	 * we're assured the assumption made upon is_index_valid() and
+	 * is_ctrl_vq_idx() will not be compromised.
+	 */
+	if ((features & (BIT_ULL(VIRTIO_NET_F_MQ) | BIT_ULL(VIRTIO_NET_F_CTRL_VQ))) ==
+            BIT_ULL(VIRTIO_NET_F_MQ))
+		return -EINVAL;
+
 	return 0;
 }
 
@@ -1544,7 +1558,7 @@ static int mlx5_vdpa_set_features(struct vdpa_device *vdev, u64 features)
 
 	print_features(mvdev, features, true);
 
-	err = verify_min_features(mvdev, features);
+	err = verify_driver_features(mvdev, features);
 	if (err)
 		return err;
 
-- 
2.34.1

