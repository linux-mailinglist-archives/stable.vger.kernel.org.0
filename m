Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A941A2171C0
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbgGGPZ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:25:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:39436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730194AbgGGPZZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:25:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92BEC2065D;
        Tue,  7 Jul 2020 15:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135525;
        bh=LYtkAmNPwTE3I2L0i3DtyAATiDsVjeos3MXb8NnbuBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PKs01yrNpUs+3mO73YKMmtUg4lHHScCl1ZBbN2/IkYk3tkWhLlkuRx9C7ikLhv1GA
         Py9xJ2escGbQA5gnUDtBOgRCCNBwTyIBeTkP//jEOKUaQswfxbD+FgAGNnEOf6IVQ1
         Kx1lvZHOALmUMpudsqntL25HoE3+fNUGkhzS0oe4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Tao <houtao1@huawei.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 075/112] virtio-blk: free vblk-vqs in error path of virtblk_probe()
Date:   Tue,  7 Jul 2020 17:17:20 +0200
Message-Id: <20200707145804.566974539@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit e7eea44eefbdd5f0345a0a8b80a3ca1c21030d06 ]

Else there will be memory leak if alloc_disk() fails.

Fixes: 6a27b656fc02 ("block: virtio-blk: support multi virt queues per virtio-blk device")
Signed-off-by: Hou Tao <houtao1@huawei.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/virtio_blk.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 9d21bf0f155ee..980df853ee497 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -878,6 +878,7 @@ static int virtblk_probe(struct virtio_device *vdev)
 	put_disk(vblk->disk);
 out_free_vq:
 	vdev->config->del_vqs(vdev);
+	kfree(vblk->vqs);
 out_free_vblk:
 	kfree(vblk);
 out_free_index:
-- 
2.25.1



