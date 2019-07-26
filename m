Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85B6876A78
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbfGZN66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:58:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:46690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387494AbfGZNkf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:40:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 797172238C;
        Fri, 26 Jul 2019 13:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148434;
        bh=WBmTu2Fyi8tNJWqCNIYXELdgtJfwsS2xAvJNFYw9wIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1yPRYtubYFSggdm+E/P83d+WPHhZsP+FRv+X0zI0Ee6XduTBoj9IRm/a7d71sktza
         vpqzwOY4Ibd+/PUylw6dcIqMAJg/YQiiem58HAF3dMjvD3mpTY3bdF+aUxgTvt5EYu
         gJGm/Iq8FgYtRnXdyVR5ZsUeCB4HsfMmriOUZCtE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ihor Matushchak <ihor.matushchak@foobox.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        "Ivan T . Ivanov" <iivanov.xz@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.2 36/85] virtio-mmio: add error check for platform_get_irq
Date:   Fri, 26 Jul 2019 09:38:46 -0400
Message-Id: <20190726133936.11177-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726133936.11177-1-sashal@kernel.org>
References: <20190726133936.11177-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ihor Matushchak <ihor.matushchak@foobox.net>

[ Upstream commit 5e663f0410fa2f355042209154029842ba1abd43 ]

in vm_find_vqs() irq has a wrong type
so, in case of no IRQ resource defined,
wrong parameter will be passed to request_irq()

Signed-off-by: Ihor Matushchak <ihor.matushchak@foobox.net>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Ivan T. Ivanov <iivanov.xz@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_mmio.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index f363fbeb5ab0..e09edb5c5e06 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -463,9 +463,14 @@ static int vm_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 		       struct irq_affinity *desc)
 {
 	struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vdev);
-	unsigned int irq = platform_get_irq(vm_dev->pdev, 0);
+	int irq = platform_get_irq(vm_dev->pdev, 0);
 	int i, err, queue_idx = 0;
 
+	if (irq < 0) {
+		dev_err(&vdev->dev, "Cannot get IRQ resource\n");
+		return irq;
+	}
+
 	err = request_irq(irq, vm_interrupt, IRQF_SHARED,
 			dev_name(&vdev->dev), vm_dev);
 	if (err)
-- 
2.20.1

