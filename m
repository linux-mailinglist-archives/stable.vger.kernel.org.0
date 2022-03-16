Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39DF64DB271
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 15:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356504AbiCPORh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 10:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356513AbiCPORX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 10:17:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8BB668FA7;
        Wed, 16 Mar 2022 07:16:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82628B81B40;
        Wed, 16 Mar 2022 14:16:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B15C340E9;
        Wed, 16 Mar 2022 14:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647440165;
        bh=/GX5gvBpjGqRM7edOPSnX8uF6IzUyP5E9lPPX789yKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YLckyylUSZY77XAoRb3vAJOp1l3M8gDa46qMEoCEfrEot1Al3/4DOo+WO541Gfnmm
         iOtUBWmneazGCECF68M1V8zRZ4+wgmAQsqZoF7I8MxuZPW/5EsT872fHxhkykuarSC
         okk2+1/FnMEbDdqs49J0zVwMpUphNwXrg+/E/DiDxpjXu9bnlt6hT5AmwPdNkSgVU7
         f6+UUAM5l1Jj3mfU2+0CxwG5oHF4APIPcw8syOylCTcXMntK0Rg4YIM7sWaj6hqHJk
         giKnM0Xm/OeW31G9I+Yl8pNK8VpbFssuXGwY2Xs1QVgOEbUJMlsA63+a1PiJYQcRu9
         a4+Gg0UZ+Ewiw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Si-Wei Liu <si-wei.liu@oracle.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Eli Cohen <elic@nvidia.com>, Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>, parav@nvidia.com,
        xieyongji@bytedance.com, virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.15 07/13] vdpa/mlx5: should verify CTRL_VQ feature exists for MQ
Date:   Wed, 16 Mar 2022 10:15:07 -0400
Message-Id: <20220316141513.247965-7-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220316141513.247965-1-sashal@kernel.org>
References: <20220316141513.247965-1-sashal@kernel.org>
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
index 1afbda216df5..6abbf1a4b06c 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1857,11 +1857,25 @@ static u64 mlx5_vdpa_get_features(struct vdpa_device *vdev)
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
 
@@ -1937,7 +1951,7 @@ static int mlx5_vdpa_set_features(struct vdpa_device *vdev, u64 features)
 
 	print_features(mvdev, features, true);
 
-	err = verify_min_features(mvdev, features);
+	err = verify_driver_features(mvdev, features);
 	if (err)
 		return err;
 
-- 
2.34.1

