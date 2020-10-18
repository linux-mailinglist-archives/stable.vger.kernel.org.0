Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F421291BFC
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731631AbgJRT0T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:26:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:41390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731619AbgJRT0S (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:26:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EF66222EC;
        Sun, 18 Oct 2020 19:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049177;
        bh=l83XoGev7/j113GM7Lzz2Jh5ztG8Aodju2TukKVp2fk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q/ah7KCN/1foFXdVC1MgkApg4iFIa3EHBR9jR4xw8u+IFZx8lRGPFKhGQcSfchLwS
         eLwH+Sn7Mhlsh80FONCjttjCeGIP0fN0RpdYaw1eW/JMEywBtovQQz4mDfuaPnm3aq
         w6036LNBDWD41rcVoIlurh0i2nzcxZk/ES87N2vs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.14 39/52] scsi: ibmvfc: Fix error return in ibmvfc_probe()
Date:   Sun, 18 Oct 2020 15:25:16 -0400
Message-Id: <20201018192530.4055730-39-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192530.4055730-1-sashal@kernel.org>
References: <20201018192530.4055730-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 34612add3829f..dbacd9830d3df 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -4797,6 +4797,7 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	if (IS_ERR(vhost->work_thread)) {
 		dev_err(dev, "Couldn't create kernel thread: %ld\n",
 			PTR_ERR(vhost->work_thread));
+		rc = PTR_ERR(vhost->work_thread);
 		goto free_host_mem;
 	}
 
-- 
2.25.1

