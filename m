Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABB4E29BC5B
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802526AbgJ0Pt4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:49:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:52292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1795788AbgJ0PPV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:15:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E37CA20728;
        Tue, 27 Oct 2020 15:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811721;
        bh=D4zjN5/SB8CO5872b2Os3idW0tfPlzkQWmu5vObtLck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G0X81XoyRDmBCZA5ROLngW2Cj1/u6/OWICmI8CeUTyf+M3Bwueycu2WwkNZ9wvz/Z
         8+BXS76uuLp4vguuiR3/8LoVMkJm6EIkTW1AQ5hNHStrnxz4sO597n+IUy4ZyK3tIm
         cCE3Id436tKMmbo8ofBdwDsUOuh6DPW7uqhQG98Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyrel Datwyler <tyreld@linux.ibm.com>,
        Jing Xiangfeng <jingxiangfeng@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 594/633] scsi: ibmvfc: Fix error return in ibmvfc_probe()
Date:   Tue, 27 Oct 2020 14:55:37 +0100
Message-Id: <20201027135550.683366459@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jing Xiangfeng <jingxiangfeng@huawei.com>

[ Upstream commit 5e48a084f4e824e1b624d3fd7ddcf53d2ba69e53 ]

Fix to return error code PTR_ERR() from the error handling case instead of
0.

Link: https://lore.kernel.org/r/20200907083949.154251-1-jingxiangfeng@huawei.com
Acked-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 635f6f9cffc40..ef91f3d01f989 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -4928,6 +4928,7 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	if (IS_ERR(vhost->work_thread)) {
 		dev_err(dev, "Couldn't create kernel thread: %ld\n",
 			PTR_ERR(vhost->work_thread));
+		rc = PTR_ERR(vhost->work_thread);
 		goto free_host_mem;
 	}
 
-- 
2.25.1



