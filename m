Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1996829C6AE
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1827175AbgJ0SV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 14:21:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:49634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438662AbgJ0OBv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:01:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85105221F8;
        Tue, 27 Oct 2020 14:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807311;
        bh=SBkxYVyJD6g5LSEeSgtiHjd3WiPlaeyAddD+i1RKgXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qG5LaAfihf4iXQAekV/ShmUMUEJIp+31Csibo7e/L64u+MY8Owg6Pde9Mj2ZXQsk/
         qR9D8ZE9PFLJ2DOkaYHkfViwv8pA4jfLCNOH1OK8Sj4IUarrjVmp1BhPYYlOU3i4Fj
         GMGefhHkrx/2sIOS7W+b3jK6+8FnepLzx4EwHsiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyrel Datwyler <tyreld@linux.ibm.com>,
        Jing Xiangfeng <jingxiangfeng@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 100/112] scsi: ibmvfc: Fix error return in ibmvfc_probe()
Date:   Tue, 27 Oct 2020 14:50:10 +0100
Message-Id: <20201027134905.273216624@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134900.532249571@linuxfoundation.org>
References: <20201027134900.532249571@linuxfoundation.org>
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
index 0526a47e30a3f..db80ab8335dfb 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -4790,6 +4790,7 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	if (IS_ERR(vhost->work_thread)) {
 		dev_err(dev, "Couldn't create kernel thread: %ld\n",
 			PTR_ERR(vhost->work_thread));
+		rc = PTR_ERR(vhost->work_thread);
 		goto free_host_mem;
 	}
 
-- 
2.25.1



