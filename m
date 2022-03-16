Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCB844DB27E
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 15:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356481AbiCPOQ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 10:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356420AbiCPOQL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 10:16:11 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 741D82B277;
        Wed, 16 Mar 2022 07:14:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CDFE4CE1F58;
        Wed, 16 Mar 2022 14:14:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E5D9C36AE2;
        Wed, 16 Mar 2022 14:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647440087;
        bh=M9qg1+MP8/boX48RlfUxEw5j6AKp+bmFAwZvpIQBwdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=skTJqjLKr6SW16xRzrhcFjBxMwpG5M1KWFmF6LgQA3jzwvy+lX3/7iYTjjs93gVY4
         CzkJqcbxUMH6vmqyZ2VvprJP0MF1wqiD+9WvStQdCeqfFFLUYAcyQ0klYw1v7KYHAi
         QjxFh+g6pObNOvdiezhUiOWvmIF4qt+HRifjHm1BtN5TXB+zz2ydyy6ML60FSzOYKv
         Wdg/iO2joS6g0IZNX+4pgv38l+9pKdBejiYE4n3mHyvfp34mIhN88MsNBL2+H11OWh
         1AT68PgamWjaEq6Zl5jMSVkBa1kjY5Eb66Z/jHSFTG1HTwDvcWkJT6qsLErB0YzMqm
         V+ecdrpiWa/og==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.16 09/13] tools/virtio: fix virtio_test execution
Date:   Wed, 16 Mar 2022 10:13:50 -0400
Message-Id: <20220316141354.247750-9-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220316141354.247750-1-sashal@kernel.org>
References: <20220316141354.247750-1-sashal@kernel.org>
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

