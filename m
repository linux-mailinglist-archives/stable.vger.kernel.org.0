Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F379291C73
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731168AbgJRTZJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:25:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731167AbgJRTZJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:25:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EED5C2137B;
        Sun, 18 Oct 2020 19:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049108;
        bh=8wlKawfhytZkCmkTMNOR1p8shCmwP4n+GekvhZnIxEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gMPRtP/xW7FWdGiZDJ9Liu8VGAkRSNc491ue+J5iF/S+Ul9O4j1pW+jk0XD/dNwg+
         wKerzlz2rqJOgesBZBnXbZzvGyFEUISOmgm8J3uGzfQeJG4ubLCIh/ZYHpoqIcUbjX
         2WjfSn65mh5FuiXb1BNZ4+ajxftOHCn+/Xej12aE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 42/56] scsi: ibmvfc: Fix error return in ibmvfc_probe()
Date:   Sun, 18 Oct 2020 15:24:03 -0400
Message-Id: <20201018192417.4055228-42-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192417.4055228-1-sashal@kernel.org>
References: <20201018192417.4055228-1-sashal@kernel.org>
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
index 71d53bb239e25..090ab377f65e5 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -4795,6 +4795,7 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	if (IS_ERR(vhost->work_thread)) {
 		dev_err(dev, "Couldn't create kernel thread: %ld\n",
 			PTR_ERR(vhost->work_thread));
+		rc = PTR_ERR(vhost->work_thread);
 		goto free_host_mem;
 	}
 
-- 
2.25.1

