Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C81B7676EFC
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbjAVPQd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:16:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbjAVPQb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:16:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D7F2202A
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:16:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8F5860C5C
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:16:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BDE9C433EF;
        Sun, 22 Jan 2023 15:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400590;
        bh=3JwqRMZc5tfGC22WlGKEdb+e+9/N6D74RINrzqMZUKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yCoBdrEaTQg7C+M7xKyAzVlmDJEiRtbuEZR/59ZeEgJUHhFDoBijurAd+e5G2TyWU
         WOJzUQ7CxeoSeBIvTM4ulSE1okQgvQnisHjYfebbuLKxKVk5tGjh+3dgacDbI1GG0s
         VQan0tENUSdmd5b+vOGNfrKWPlbYQpqhrM8miQ30=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Angus Chen <angus.chen@jaguarmicro.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 005/117] virtio_pci: modify ENOENT to EINVAL
Date:   Sun, 22 Jan 2023 16:03:15 +0100
Message-Id: <20230122150232.961523979@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Angus Chen <angus.chen@jaguarmicro.com>

[ Upstream commit b66ead2d0ecac00c3a06a6218af5411cb5fcb5d5 ]

Virtio_crypto use max_data_queues+1 to setup vqs,
we use vp_modern_get_num_queues to protect the vq range in setup_vq.
We could enter index >= vp_modern_get_num_queues(mdev) in setup_vq
if common->num_queues is not set well,and it return -ENOENT.
It is better to use -EINVAL instead.

Signed-off-by: Angus Chen <angus.chen@jaguarmicro.com>
Message-Id: <20221101111655.1947-1-angus.chen@jaguarmicro.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_pci_modern.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index 30654d3a0b41..a274261f36d6 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -196,7 +196,7 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 	int err;
 
 	if (index >= vp_modern_get_num_queues(mdev))
-		return ERR_PTR(-ENOENT);
+		return ERR_PTR(-EINVAL);
 
 	/* Check if queue is either not available or already active. */
 	num = vp_modern_get_queue_size(mdev, index);
-- 
2.35.1



