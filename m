Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7203CE40B
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348247AbhGSPlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:41:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:57466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347639AbhGSPfN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFDBF61481;
        Mon, 19 Jul 2021 16:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711156;
        bh=5QbTwExUp1UTPRwJHHTgQo//nXTz38qu/mHRbBx4Q/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l/ZFgvivqrVRPwViN5cuexG9izfbSgEtS3YXEA+L7AXWVVZt+zgQbx9FF73GLHnWR
         VFWw8u2BuLN9v6DEKt7ILFzHeLjd5LtoTAMdxXvD9zUgr8ht+N/uRUQuA0a176rbqE
         Qi7hnLEfoTK8X58h12zTy0jyoNFDSltaNeHq6iv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 249/351] vp_vdpa: correct the return value when fail to map notification
Date:   Mon, 19 Jul 2021 16:53:15 +0200
Message-Id: <20210719144953.190502379@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit 94e48d6aafef23143f92eadd010c505c49487576 ]

We forget to assign a error value when we fail to map the notification
during prove. This patch fixes it.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 11d8ffed00b23 ("vp_vdpa: switch to use vp_modern_map_vq_notify()")
Signed-off-by: Jason Wang <jasowang@redhat.com>
Link: https://lore.kernel.org/r/20210624035939.26618-1-jasowang@redhat.com
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/virtio_pci/vp_vdpa.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vdpa/virtio_pci/vp_vdpa.c b/drivers/vdpa/virtio_pci/vp_vdpa.c
index c76ebb531212..9145e0624565 100644
--- a/drivers/vdpa/virtio_pci/vp_vdpa.c
+++ b/drivers/vdpa/virtio_pci/vp_vdpa.c
@@ -442,6 +442,7 @@ static int vp_vdpa_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 			vp_modern_map_vq_notify(mdev, i,
 						&vp_vdpa->vring[i].notify_pa);
 		if (!vp_vdpa->vring[i].notify) {
+			ret = -EINVAL;
 			dev_warn(&pdev->dev, "Fail to map vq notify %d\n", i);
 			goto err;
 		}
-- 
2.30.2



