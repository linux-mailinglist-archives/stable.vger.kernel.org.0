Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8962ACDC2
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 05:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732490AbgKJDyQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 22:54:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:55028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732472AbgKJDyP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 22:54:15 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EA0920829;
        Tue, 10 Nov 2020 03:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604980454;
        bh=344KYCt8JlqhsBDq1b3hVsvLmu/FPHqauM+mTbm2F80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UWEb8rgrFHl36MzI6EbJySdXTyh8OWu7HNBkd46WwBeyFsF7t00rzRjdbs9GJlJc0
         X84S6sbopSqfpAdQWVK2R6WYrxarSTw0LyjFLoyNkDzFIf137v+/QzpErpjxNx/gHq
         w9D8DsI/DYmrk/wx4HmEmpE9T35FB9SFdEqYAKr8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Qilong <zhangqilong3@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 39/55] vfio: platform: fix reference leak in vfio_platform_open
Date:   Mon,  9 Nov 2020 22:53:02 -0500
Message-Id: <20201110035318.423757-39-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110035318.423757-1-sashal@kernel.org>
References: <20201110035318.423757-1-sashal@kernel.org>
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
index c0771a9567fb5..fb4b385191f28 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -267,7 +267,7 @@ static int vfio_platform_open(void *device_data)
 
 		ret = pm_runtime_get_sync(vdev->device);
 		if (ret < 0)
-			goto err_pm;
+			goto err_rst;
 
 		ret = vfio_platform_call_reset(vdev, &extra_dbg);
 		if (ret && vdev->reset_required) {
@@ -284,7 +284,6 @@ static int vfio_platform_open(void *device_data)
 
 err_rst:
 	pm_runtime_put(vdev->device);
-err_pm:
 	vfio_platform_irq_cleanup(vdev);
 err_irq:
 	vfio_platform_regions_cleanup(vdev);
-- 
2.27.0

