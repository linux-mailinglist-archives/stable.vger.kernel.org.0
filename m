Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF1304DB2AF
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 15:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356630AbiCPOSu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 10:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356614AbiCPOSg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 10:18:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4744469298;
        Wed, 16 Mar 2022 07:17:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D68276113D;
        Wed, 16 Mar 2022 14:17:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16C6CC340F0;
        Wed, 16 Mar 2022 14:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647440236;
        bh=M9qg1+MP8/boX48RlfUxEw5j6AKp+bmFAwZvpIQBwdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bYhc0aIrTZZlKN8cvii5fr3fmIbOlMtGT15g7UTeKw486yMzJK+FrOLyxfQ45nnUd
         SzncjWtuomEO8jFDCD5wic9mph+UBMxr6evCkz4ZoFvnXdWRbgZ7VGOtEoi2aC8z1y
         YqkM/r4KTh1nu7LrLDgFzhmgD5UmZDfvmpG5ZP7ydtPsrB1XQvbnBb2aWmlKJY3OP3
         yi/SLhSCRDB7n4Va4iTJMJLiVGU2wnvAkVGYfENTZmGoQwgaT0A00NQMuZMEvWrlRr
         /eKcflnNCdvWf50vNgnXEc/AjV+E/gxSOBaLiEXirbK3gNxJjRrmizKeVy7/g9i2pY
         +MMcAptrz3aTQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.10 08/12] tools/virtio: fix virtio_test execution
Date:   Wed, 16 Mar 2022 10:16:32 -0400
Message-Id: <20220316141636.248324-8-sashal@kernel.org>
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

From: Stefano Garzarella <sgarzare@redhat.com>

[ Upstream commit 32f1b53fe8f03d962423ba81f8e92af5839814da ]

virtio_test hangs on __vring_new_virtqueue() because `vqs_list_lock`
is not initialized.

Let's initialize it in vdev_info_init().

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://lore.kernel.org/r/20220118150631.167015-1-sgarzare@redhat.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/virtio/virtio_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
index cb3f29c09aff..23f142af544a 100644
--- a/tools/virtio/virtio_test.c
+++ b/tools/virtio/virtio_test.c
@@ -130,6 +130,7 @@ static void vdev_info_init(struct vdev_info* dev, unsigned long long features)
 	memset(dev, 0, sizeof *dev);
 	dev->vdev.features = features;
 	INIT_LIST_HEAD(&dev->vdev.vqs);
+	spin_lock_init(&dev->vdev.vqs_list_lock);
 	dev->buf_size = 1024;
 	dev->buf = malloc(dev->buf_size);
 	assert(dev->buf);
-- 
2.34.1

