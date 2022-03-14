Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 115314D835F
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241149AbiCNMM6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240996AbiCNMIM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:08:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 895A02C11B;
        Mon, 14 Mar 2022 05:04:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9B34612FF;
        Mon, 14 Mar 2022 12:04:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE96C340E9;
        Mon, 14 Mar 2022 12:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259456;
        bh=At0yOp44yBOPqKzhP7VM/vYRI679WH5Wi1WwGfgayn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fzwU7DOIXWVroSNysUGLBueJSZE3QA6SQHX0vCRoObGYyopPvJ2EGnLeBExA4gFek
         XyLxv1MCVTRj313RmtC5NIN6tKlWZDJk+WqMUDrg6XWpz/GQjkkMqvnChPu1zd6WI2
         mUdxYDGo4qhNsmKWxj12mNkX8/OO3LSVHHOuf2B4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Si-Wei Liu <si-wei.liu@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Eli Cohen <elic@nvidia.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 011/110] vdpa/mlx5: add validation for VIRTIO_NET_CTRL_MQ_VQ_PAIRS_SET command
Date:   Mon, 14 Mar 2022 12:53:13 +0100
Message-Id: <20220314112743.348334045@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112743.029192918@linuxfoundation.org>
References: <20220314112743.029192918@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

[ Upstream commit ed0f849fc3a63ed2ddf5e72cdb1de3bdbbb0f8eb ]

When control vq receives a VIRTIO_NET_CTRL_MQ_VQ_PAIRS_SET command
request from the driver, presently there is no validation against the
number of queue pairs to configure, or even if multiqueue had been
negotiated or not is unverified. This may lead to kernel panic due to
uninitialized resource for the queues were there any bogus request
sent down by untrusted driver. Tie up the loose ends there.

Fixes: 52893733f2c5 ("vdpa/mlx5: Add multiqueue support")
Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
Link: https://lore.kernel.org/r/1642206481-30721-4-git-send-email-si-wei.liu@oracle.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Eli Cohen <elic@nvidia.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 1afbda216df5..902aad29456f 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1529,11 +1529,27 @@ static virtio_net_ctrl_ack handle_ctrl_mq(struct mlx5_vdpa_dev *mvdev, u8 cmd)
 
 	switch (cmd) {
 	case VIRTIO_NET_CTRL_MQ_VQ_PAIRS_SET:
+		/* This mq feature check aligns with pre-existing userspace
+		 * implementation.
+		 *
+		 * Without it, an untrusted driver could fake a multiqueue config
+		 * request down to a non-mq device that may cause kernel to
+		 * panic due to uninitialized resources for extra vqs. Even with
+		 * a well behaving guest driver, it is not expected to allow
+		 * changing the number of vqs on a non-mq device.
+		 */
+		if (!MLX5_FEATURE(mvdev, VIRTIO_NET_F_MQ))
+			break;
+
 		read = vringh_iov_pull_iotlb(&cvq->vring, &cvq->riov, (void *)&mq, sizeof(mq));
 		if (read != sizeof(mq))
 			break;
 
 		newqps = mlx5vdpa16_to_cpu(mvdev, mq.virtqueue_pairs);
+		if (newqps < VIRTIO_NET_CTRL_MQ_VQ_PAIRS_MIN ||
+		    newqps > mlx5_vdpa_max_qps(mvdev->max_vqs))
+			break;
+
 		if (ndev->cur_num_vqs == 2 * newqps) {
 			status = VIRTIO_NET_OK;
 			break;
-- 
2.34.1



