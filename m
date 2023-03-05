Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E83AD6AB019
	for <lists+stable@lfdr.de>; Sun,  5 Mar 2023 14:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbjCENwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Mar 2023 08:52:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjCENwy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Mar 2023 08:52:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA946158AC;
        Sun,  5 Mar 2023 05:52:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FADE60B06;
        Sun,  5 Mar 2023 13:52:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4310CC433D2;
        Sun,  5 Mar 2023 13:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678024349;
        bh=cghi09Wbzn7gRbEilv55hS/JW49IJkg0VYRCod5bCys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cbjVW1/agSxqO2GdSR3t7AvCbMR5Sq1DExHjlmcLUKytHw7GybkZ0SQDw2Vfr+kpn
         sP8vN8LTlyvkbWG605BGEPj7xjUsLbdLjHKn09kFJp3tGNO/XY37IcnBKMePc7/znh
         tpc+Xam5aTfJjBQTKCI+OMoOX7XSLx9fZIFxJCWCQGK92y54vxZ3qm5cdBwKf30vqc
         6ZAe/eOxEkYw629DmIlrgLjgsTsKDEI8joQN18ofQBvwuGrC//10UGcWJhuftepGOn
         1JqUnCc7pYpg6QnGXwLcAIJy3UztAE6FDb+CLhDqHP/isBI1XwmXI8Os1fU74nGpPx
         /c6NA+yNxEC6A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Gordeev <agordeev@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, cohuck@redhat.com,
        pasic@linux.ibm.com, farman@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 05/16] s390/virtio: sort out physical vs virtual pointers usage
Date:   Sun,  5 Mar 2023 08:51:56 -0500
Message-Id: <20230305135207.1793266-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230305135207.1793266-1-sashal@kernel.org>
References: <20230305135207.1793266-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit 5fc5b94a273655128159186c87662105db8afeb5 ]

This does not fix a real bug, since virtual addresses
are currently indentical to physical ones.

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/virtio/virtio_ccw.c | 46 +++++++++++++++++---------------
 1 file changed, 24 insertions(+), 22 deletions(-)

diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index a10dbe632ef9b..954fc31b4bc74 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -363,7 +363,7 @@ static void virtio_ccw_drop_indicator(struct virtio_ccw_device *vcdev,
 		thinint_area->isc = VIRTIO_AIRQ_ISC;
 		ccw->cmd_code = CCW_CMD_SET_IND_ADAPTER;
 		ccw->count = sizeof(*thinint_area);
-		ccw->cda = (__u32)(unsigned long) thinint_area;
+		ccw->cda = (__u32)virt_to_phys(thinint_area);
 	} else {
 		/* payload is the address of the indicators */
 		indicatorp = ccw_device_dma_zalloc(vcdev->cdev,
@@ -373,7 +373,7 @@ static void virtio_ccw_drop_indicator(struct virtio_ccw_device *vcdev,
 		*indicatorp = 0;
 		ccw->cmd_code = CCW_CMD_SET_IND;
 		ccw->count = sizeof(indicators(vcdev));
-		ccw->cda = (__u32)(unsigned long) indicatorp;
+		ccw->cda = (__u32)virt_to_phys(indicatorp);
 	}
 	/* Deregister indicators from host. */
 	*indicators(vcdev) = 0;
@@ -417,7 +417,7 @@ static int virtio_ccw_read_vq_conf(struct virtio_ccw_device *vcdev,
 	ccw->cmd_code = CCW_CMD_READ_VQ_CONF;
 	ccw->flags = 0;
 	ccw->count = sizeof(struct vq_config_block);
-	ccw->cda = (__u32)(unsigned long)(&vcdev->dma_area->config_block);
+	ccw->cda = (__u32)virt_to_phys(&vcdev->dma_area->config_block);
 	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_READ_VQ_CONF);
 	if (ret)
 		return ret;
@@ -454,7 +454,7 @@ static void virtio_ccw_del_vq(struct virtqueue *vq, struct ccw1 *ccw)
 	}
 	ccw->cmd_code = CCW_CMD_SET_VQ;
 	ccw->flags = 0;
-	ccw->cda = (__u32)(unsigned long)(info->info_block);
+	ccw->cda = (__u32)virt_to_phys(info->info_block);
 	ret = ccw_io_helper(vcdev, ccw,
 			    VIRTIO_CCW_DOING_SET_VQ | index);
 	/*
@@ -556,7 +556,7 @@ static struct virtqueue *virtio_ccw_setup_vq(struct virtio_device *vdev,
 	}
 	ccw->cmd_code = CCW_CMD_SET_VQ;
 	ccw->flags = 0;
-	ccw->cda = (__u32)(unsigned long)(info->info_block);
+	ccw->cda = (__u32)virt_to_phys(info->info_block);
 	err = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_SET_VQ | i);
 	if (err) {
 		dev_warn(&vcdev->cdev->dev, "SET_VQ failed\n");
@@ -590,6 +590,7 @@ static int virtio_ccw_register_adapter_ind(struct virtio_ccw_device *vcdev,
 {
 	int ret;
 	struct virtio_thinint_area *thinint_area = NULL;
+	unsigned long indicator_addr;
 	struct airq_info *info;
 
 	thinint_area = ccw_device_dma_zalloc(vcdev->cdev,
@@ -599,21 +600,22 @@ static int virtio_ccw_register_adapter_ind(struct virtio_ccw_device *vcdev,
 		goto out;
 	}
 	/* Try to get an indicator. */
-	thinint_area->indicator = get_airq_indicator(vqs, nvqs,
-						     &thinint_area->bit_nr,
-						     &vcdev->airq_info);
-	if (!thinint_area->indicator) {
+	indicator_addr = get_airq_indicator(vqs, nvqs,
+					    &thinint_area->bit_nr,
+					    &vcdev->airq_info);
+	if (!indicator_addr) {
 		ret = -ENOSPC;
 		goto out;
 	}
+	thinint_area->indicator = virt_to_phys((void *)indicator_addr);
 	info = vcdev->airq_info;
 	thinint_area->summary_indicator =
-		(unsigned long) get_summary_indicator(info);
+		virt_to_phys(get_summary_indicator(info));
 	thinint_area->isc = VIRTIO_AIRQ_ISC;
 	ccw->cmd_code = CCW_CMD_SET_IND_ADAPTER;
 	ccw->flags = CCW_FLAG_SLI;
 	ccw->count = sizeof(*thinint_area);
-	ccw->cda = (__u32)(unsigned long)thinint_area;
+	ccw->cda = (__u32)virt_to_phys(thinint_area);
 	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_SET_IND_ADAPTER);
 	if (ret) {
 		if (ret == -EOPNOTSUPP) {
@@ -686,7 +688,7 @@ static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 		ccw->cmd_code = CCW_CMD_SET_IND;
 		ccw->flags = 0;
 		ccw->count = sizeof(indicators(vcdev));
-		ccw->cda = (__u32)(unsigned long) indicatorp;
+		ccw->cda = (__u32)virt_to_phys(indicatorp);
 		ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_SET_IND);
 		if (ret)
 			goto out;
@@ -697,7 +699,7 @@ static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 	ccw->cmd_code = CCW_CMD_SET_CONF_IND;
 	ccw->flags = 0;
 	ccw->count = sizeof(indicators2(vcdev));
-	ccw->cda = (__u32)(unsigned long) indicatorp;
+	ccw->cda = (__u32)virt_to_phys(indicatorp);
 	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_SET_CONF_IND);
 	if (ret)
 		goto out;
@@ -759,7 +761,7 @@ static u64 virtio_ccw_get_features(struct virtio_device *vdev)
 	ccw->cmd_code = CCW_CMD_READ_FEAT;
 	ccw->flags = 0;
 	ccw->count = sizeof(*features);
-	ccw->cda = (__u32)(unsigned long)features;
+	ccw->cda = (__u32)virt_to_phys(features);
 	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_READ_FEAT);
 	if (ret) {
 		rc = 0;
@@ -776,7 +778,7 @@ static u64 virtio_ccw_get_features(struct virtio_device *vdev)
 	ccw->cmd_code = CCW_CMD_READ_FEAT;
 	ccw->flags = 0;
 	ccw->count = sizeof(*features);
-	ccw->cda = (__u32)(unsigned long)features;
+	ccw->cda = (__u32)virt_to_phys(features);
 	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_READ_FEAT);
 	if (ret == 0)
 		rc |= (u64)le32_to_cpu(features->features) << 32;
@@ -829,7 +831,7 @@ static int virtio_ccw_finalize_features(struct virtio_device *vdev)
 	ccw->cmd_code = CCW_CMD_WRITE_FEAT;
 	ccw->flags = 0;
 	ccw->count = sizeof(*features);
-	ccw->cda = (__u32)(unsigned long)features;
+	ccw->cda = (__u32)virt_to_phys(features);
 	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_WRITE_FEAT);
 	if (ret)
 		goto out_free;
@@ -843,7 +845,7 @@ static int virtio_ccw_finalize_features(struct virtio_device *vdev)
 	ccw->cmd_code = CCW_CMD_WRITE_FEAT;
 	ccw->flags = 0;
 	ccw->count = sizeof(*features);
-	ccw->cda = (__u32)(unsigned long)features;
+	ccw->cda = (__u32)virt_to_phys(features);
 	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_WRITE_FEAT);
 
 out_free:
@@ -875,7 +877,7 @@ static void virtio_ccw_get_config(struct virtio_device *vdev,
 	ccw->cmd_code = CCW_CMD_READ_CONF;
 	ccw->flags = 0;
 	ccw->count = offset + len;
-	ccw->cda = (__u32)(unsigned long)config_area;
+	ccw->cda = (__u32)virt_to_phys(config_area);
 	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_READ_CONFIG);
 	if (ret)
 		goto out_free;
@@ -922,7 +924,7 @@ static void virtio_ccw_set_config(struct virtio_device *vdev,
 	ccw->cmd_code = CCW_CMD_WRITE_CONF;
 	ccw->flags = 0;
 	ccw->count = offset + len;
-	ccw->cda = (__u32)(unsigned long)config_area;
+	ccw->cda = (__u32)virt_to_phys(config_area);
 	ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_WRITE_CONFIG);
 
 out_free:
@@ -946,7 +948,7 @@ static u8 virtio_ccw_get_status(struct virtio_device *vdev)
 	ccw->cmd_code = CCW_CMD_READ_STATUS;
 	ccw->flags = 0;
 	ccw->count = sizeof(vcdev->dma_area->status);
-	ccw->cda = (__u32)(unsigned long)&vcdev->dma_area->status;
+	ccw->cda = (__u32)virt_to_phys(&vcdev->dma_area->status);
 	ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_READ_STATUS);
 /*
  * If the channel program failed (should only happen if the device
@@ -975,7 +977,7 @@ static void virtio_ccw_set_status(struct virtio_device *vdev, u8 status)
 	ccw->cmd_code = CCW_CMD_WRITE_STATUS;
 	ccw->flags = 0;
 	ccw->count = sizeof(status);
-	ccw->cda = (__u32)(unsigned long)&vcdev->dma_area->status;
+	ccw->cda = (__u32)virt_to_phys(&vcdev->dma_area->status);
 	/* We use ssch for setting the status which is a serializing
 	 * instruction that guarantees the memory writes have
 	 * completed before ssch.
@@ -1274,7 +1276,7 @@ static int virtio_ccw_set_transport_rev(struct virtio_ccw_device *vcdev)
 	ccw->cmd_code = CCW_CMD_SET_VIRTIO_REV;
 	ccw->flags = 0;
 	ccw->count = sizeof(*rev);
-	ccw->cda = (__u32)(unsigned long)rev;
+	ccw->cda = (__u32)virt_to_phys(rev);
 
 	vcdev->revision = VIRTIO_CCW_REV_MAX;
 	do {
-- 
2.39.2

