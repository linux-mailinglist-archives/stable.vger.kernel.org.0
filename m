Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 050B7676F5E
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbjAVPUl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:20:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbjAVPUk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:20:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9473222E9
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:20:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84EA860BC5
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:20:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990F9C433EF;
        Sun, 22 Jan 2023 15:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400839;
        bh=1W7Sxg3m3FAirHvv7eCwJQaeygqaPzmEqsB+Q9Q+2vs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tcqjDd9jf2JKlz6XrA7bi9aKblwBffvnHJrAcD7W5FYNtExuQtpPqdcEokDPzTEcm
         8p+R1NSiQA/K2Mc2CnWF4UqYQxDycJAZtbLWNqCcTtSfTcjRa+DsvmN1FnXEo6MvhX
         i29fJugdDX0xk0peRStEOkYeVh89vmP2pdGDLl6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Angus Chen <angus.chen@jaguarmicro.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 011/193] virtio_pci: modify ENOENT to EINVAL
Date:   Sun, 22 Jan 2023 16:02:20 +0100
Message-Id: <20230122150246.889255915@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
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
index c3b9f2761849..edf2e18014cd 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -303,7 +303,7 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 	int err;
 
 	if (index >= vp_modern_get_num_queues(mdev))
-		return ERR_PTR(-ENOENT);
+		return ERR_PTR(-EINVAL);
 
 	/* Check if queue is either not available or already active. */
 	num = vp_modern_get_queue_size(mdev, index);
-- 
2.35.1



