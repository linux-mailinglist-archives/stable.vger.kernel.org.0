Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D657A2B619B
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730780AbgKQNUk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:20:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:54150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730574AbgKQNUk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:20:40 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52D01206D5;
        Tue, 17 Nov 2020 13:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619240;
        bh=cpf2rMftQf7xL/9QBBlS7qxPonhitPWGCCg9v88FIY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q70VLBZLu0ea4tkKwVKr20JTVn7ciGfPLpQGXZTM81sVD8ARHXUqg4/Yrwur5MIVJ
         PujnRJL28SRx78cvmFhCMcGf3101FYTKcwEC5r3v7vAGONd1KngA1rhdu7NKlH/SET
         5ug8vy2iDhc8pJyP+pucryRRp5Jh1wTbonWsi9Ew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 045/101] vfio: platform: fix reference leak in vfio_platform_open
Date:   Tue, 17 Nov 2020 14:05:12 +0100
Message-Id: <20201117122115.291403772@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122113.128215851@linuxfoundation.org>
References: <20201117122113.128215851@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit bb742ad01961a3b9d1f9d19375487b879668b6b2 ]

pm_runtime_get_sync() will increment pm usage counter even it
failed. Forgetting to call pm_runtime_put will result in
reference leak in vfio_platform_open, so we should fix it.

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Acked-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/platform/vfio_platform_common.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index c0cd824be2b76..460760d0becfe 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -273,7 +273,7 @@ static int vfio_platform_open(void *device_data)
 
 		ret = pm_runtime_get_sync(vdev->device);
 		if (ret < 0)
-			goto err_pm;
+			goto err_rst;
 
 		ret = vfio_platform_call_reset(vdev, &extra_dbg);
 		if (ret && vdev->reset_required) {
@@ -290,7 +290,6 @@ static int vfio_platform_open(void *device_data)
 
 err_rst:
 	pm_runtime_put(vdev->device);
-err_pm:
 	vfio_platform_irq_cleanup(vdev);
 err_irq:
 	vfio_platform_regions_cleanup(vdev);
-- 
2.27.0



