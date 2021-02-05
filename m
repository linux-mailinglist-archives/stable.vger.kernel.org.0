Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAEDD311415
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbhBEV6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 16:58:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:44974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233002AbhBEO70 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:59:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99A3A65044;
        Fri,  5 Feb 2021 14:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534316;
        bh=0Y+Ws3COArS+NyJ+wxC+vkH7w0LMbrLFHRB07k5dsik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HEw8Cqcxtznv0NSDPg3664bw/emxMilOEKq0pa+j7zxJGOjEaL5ZlYsPvRhflHOU2
         nlVxRfgF2cUsl2IfJScSdPyf7N44p41ZhS+os0j522zizdPJy3SWtXTs6O8cIj4EBl
         X0EWZx+fRZHdh7LpNbhcW84YO9r1L2nPKAwK1fiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Karan Tilak Kumar <kartilak@cisco.com>,
        Dinghao Liu <dinghao.liu@zju.edu.cn>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 28/57] scsi: fnic: Fix memleak in vnic_dev_init_devcmd2
Date:   Fri,  5 Feb 2021 15:06:54 +0100
Message-Id: <20210205140657.181239841@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140655.982616732@linuxfoundation.org>
References: <20210205140655.982616732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit d6e3ae76728ccde49271d9f5acfebbea0c5625a3 ]

When ioread32() returns 0xFFFFFFFF, we should execute cleanup functions
like other error handling paths before returning.

Link: https://lore.kernel.org/r/20201225083520.22015-1-dinghao.liu@zju.edu.cn
Acked-by: Karan Tilak Kumar <kartilak@cisco.com>
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/fnic/vnic_dev.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fnic/vnic_dev.c b/drivers/scsi/fnic/vnic_dev.c
index a2beee6e09f06..5988c300cc82e 100644
--- a/drivers/scsi/fnic/vnic_dev.c
+++ b/drivers/scsi/fnic/vnic_dev.c
@@ -444,7 +444,8 @@ static int vnic_dev_init_devcmd2(struct vnic_dev *vdev)
 	fetch_index = ioread32(&vdev->devcmd2->wq.ctrl->fetch_index);
 	if (fetch_index == 0xFFFFFFFF) { /* check for hardware gone  */
 		pr_err("error in devcmd2 init");
-		return -ENODEV;
+		err = -ENODEV;
+		goto err_free_wq;
 	}
 
 	/*
@@ -460,7 +461,7 @@ static int vnic_dev_init_devcmd2(struct vnic_dev *vdev)
 	err = vnic_dev_alloc_desc_ring(vdev, &vdev->devcmd2->results_ring,
 			DEVCMD2_RING_SIZE, DEVCMD2_DESC_SIZE);
 	if (err)
-		goto err_free_wq;
+		goto err_disable_wq;
 
 	vdev->devcmd2->result =
 		(struct devcmd2_result *) vdev->devcmd2->results_ring.descs;
@@ -481,8 +482,9 @@ static int vnic_dev_init_devcmd2(struct vnic_dev *vdev)
 
 err_free_desc_ring:
 	vnic_dev_free_desc_ring(vdev, &vdev->devcmd2->results_ring);
-err_free_wq:
+err_disable_wq:
 	vnic_wq_disable(&vdev->devcmd2->wq);
+err_free_wq:
 	vnic_wq_free(&vdev->devcmd2->wq);
 err_free_devcmd2:
 	kfree(vdev->devcmd2);
-- 
2.27.0



