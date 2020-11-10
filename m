Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 683EC2ACC90
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 04:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387482AbgKJD4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 22:56:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:57822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387474AbgKJD4D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 22:56:03 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA54621534;
        Tue, 10 Nov 2020 03:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604980562;
        bh=cpf2rMftQf7xL/9QBBlS7qxPonhitPWGCCg9v88FIY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CPri1TYuekaEBImqXVZsZjAVC88uFXjSuCsjitrGPcnrsvGjg0p+cuShxheI0BZX7
         hDNniijIwH3nBq/s1QWk+RyQo7pQby5YFEe3+AwuSyBjSFsejZu6NsqEz5+diqojlQ
         gO0Sn810t0XCoLm+etaNQ48HmeDwCQUv1Sab9UDE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Qilong <zhangqilong3@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 16/21] vfio: platform: fix reference leak in vfio_platform_open
Date:   Mon,  9 Nov 2020 22:55:36 -0500
Message-Id: <20201110035541.424648-16-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110035541.424648-1-sashal@kernel.org>
References: <20201110035541.424648-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

