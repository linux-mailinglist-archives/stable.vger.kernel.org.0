Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39FAF311105
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 20:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233666AbhBERjk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 12:39:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:54094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233446AbhBEP5X (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 10:57:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F26966507A;
        Fri,  5 Feb 2021 14:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534391;
        bh=Y+ixUP1Ec25lKYwt/7pjnJG/ADSoVOxNvnDCOXgwmNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=teZ/P5gKoV6brzr6osbe1olqLYo7IYlOmMf1qfk3NU0Lznzqaxj+HULVU0SO7QCUh
         s1Wk1VFb3V7rLUd2z/QvF3WbhYmIT8AflmqMcpP1cef8xbMfAiaTUY6yP86hflTJa2
         P9Be7tKGevH4VcUZ+Fr2pQoC7i06SMuiYMiFg3Cc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Karan Tilak Kumar <kartilak@cisco.com>,
        Dinghao Liu <dinghao.liu@zju.edu.cn>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 20/32] scsi: fnic: Fix memleak in vnic_dev_init_devcmd2
Date:   Fri,  5 Feb 2021 15:07:35 +0100
Message-Id: <20210205140653.212222311@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140652.348864025@linuxfoundation.org>
References: <20210205140652.348864025@linuxfoundation.org>
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
index 522636e946282..c8bf8c7ada6a7 100644
--- a/drivers/scsi/fnic/vnic_dev.c
+++ b/drivers/scsi/fnic/vnic_dev.c
@@ -444,7 +444,8 @@ int vnic_dev_init_devcmd2(struct vnic_dev *vdev)
 	fetch_index = ioread32(&vdev->devcmd2->wq.ctrl->fetch_index);
 	if (fetch_index == 0xFFFFFFFF) { /* check for hardware gone  */
 		pr_err("error in devcmd2 init");
-		return -ENODEV;
+		err = -ENODEV;
+		goto err_free_wq;
 	}
 
 	/*
@@ -460,7 +461,7 @@ int vnic_dev_init_devcmd2(struct vnic_dev *vdev)
 	err = vnic_dev_alloc_desc_ring(vdev, &vdev->devcmd2->results_ring,
 			DEVCMD2_RING_SIZE, DEVCMD2_DESC_SIZE);
 	if (err)
-		goto err_free_wq;
+		goto err_disable_wq;
 
 	vdev->devcmd2->result =
 		(struct devcmd2_result *) vdev->devcmd2->results_ring.descs;
@@ -481,8 +482,9 @@ int vnic_dev_init_devcmd2(struct vnic_dev *vdev)
 
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



