Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1181729C481
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2508852AbgJ0OQl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:16:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:38900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757193AbgJ0OQl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:16:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2AB6206F7;
        Tue, 27 Oct 2020 14:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808200;
        bh=l83XoGev7/j113GM7Lzz2Jh5ztG8Aodju2TukKVp2fk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=maF+miIwZ0XVts+xWIRVB89tK+z0L8jljVE3d07szgL68/RSrxoJzKjbTKGWC09u/
         kkGu+QjNPIpUtPzJto/7i3h5RapvRxI6ywMhVQEvIknxylnpEIBfOZjCo5hC0Fgafb
         Eba1XDKJ3FZ81CE4xmdh0Lw13GRDcZci+nNs9C7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyrel Datwyler <tyreld@linux.ibm.com>,
        Jing Xiangfeng <jingxiangfeng@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 172/191] scsi: ibmvfc: Fix error return in ibmvfc_probe()
Date:   Tue, 27 Oct 2020 14:50:27 +0100
Message-Id: <20201027134917.996358348@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134909.701581493@linuxfoundation.org>
References: <20201027134909.701581493@linuxfoundation.org>
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



