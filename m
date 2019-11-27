Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29E7210BC67
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732588AbfK0VHV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:07:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:33486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731987AbfK0VHV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:07:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1855B2176D;
        Wed, 27 Nov 2019 21:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888840;
        bh=3zZtjhCk8Ii8Ma3TZ07AaIFsbKaaFjikQMnZkSiNm8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VTwUfNtv3BZn+R7yNGuI0myKu+1UWs1zssJB1zWFByfEP4SggBoLI+2DlbMcBROoB
         45MmaNdWFP3Rhkk3k/6iDViAsmVQGDNEr6nYqwJ1x8UMiP3GTHDqO0WOIQcbCJw0kj
         1gGZLMgjPYsyF3tDo9UxxxqzoE+Yz4CE2CsOXyfU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 291/306] virtio_ring: fix return code on DMA mapping fails
Date:   Wed, 27 Nov 2019 21:32:21 +0100
Message-Id: <20191127203136.015950334@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Halil Pasic <pasic@linux.ibm.com>

[ Upstream commit f7728002c1c7bfa787b276a31c3ef458739b8e7c ]

Commit 780bc7903a32 ("virtio_ring: Support DMA APIs")  makes
virtqueue_add() return -EIO when we fail to map our I/O buffers. This is
a very realistic scenario for guests with encrypted memory, as swiotlb
may run out of space, depending on it's size and the I/O load.

The virtio-blk driver interprets -EIO form virtqueue_add() as an IO
error, despite the fact that swiotlb full is in absence of bugs a
recoverable condition.

Let us change the return code to -ENOMEM, and make the block layer
recover form these failures when virtio-blk encounters the condition
described above.

Cc: stable@vger.kernel.org
Fixes: 780bc7903a32 ("virtio_ring: Support DMA APIs")
Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Tested-by: Michael Mueller <mimu@linux.ibm.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_ring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 9529e28e18222..6228b48d1e127 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -431,7 +431,7 @@ unmap_release:
 		kfree(desc);
 
 	END_USE(vq);
-	return -EIO;
+	return -ENOMEM;
 }
 
 /**
-- 
2.20.1



