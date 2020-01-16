Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45D4613E22C
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731717AbgAPQyU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:54:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:38826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731690AbgAPQyU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:54:20 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCAEB22522;
        Thu, 16 Jan 2020 16:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193659;
        bh=jtvRupTc1Mw82Ewwh9SuTBLa/9W9+7eOJ4DfX2MQnTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fptXVkBqtl+ClbWEJEpxJxE6arQErQPWyn3rGyChzOWtQC2sKjM3bORNhKkLw6e57
         g1CImuCwUbuFa9/AWXZ9pb0+LdJTwF/6EW0i9mAkYWm7Wvm6DMehfrXWzDTZ73/RQL
         WXRMorJoblwwyIV2K9R/02j9mPK5zEgsi/HI8ZuM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wen Yang <wenyang@linux.alibaba.com>,
        Benson Leung <bleung@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Nick Crews <ncrews@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 187/205] platform/chrome: wilco_ec: fix use after free issue
Date:   Thu, 16 Jan 2020 11:42:42 -0500
Message-Id: <20200116164300.6705-187-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Yang <wenyang@linux.alibaba.com>

[ Upstream commit 856a0a6e2d09d31fd8f00cc1fc6645196a509d56 ]

This is caused by dereferencing 'dev_data' after put_device() in
the telem_device_remove() function.
This patch just moves the put_device() down a bit to avoid this
issue.

Fixes: 1210d1e6bad1 ("platform/chrome: wilco_ec: Add telemetry char device interface")
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
Cc: Benson Leung <bleung@chromium.org>
Cc: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Cc: Nick Crews <ncrews@chromium.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/wilco_ec/telemetry.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/chrome/wilco_ec/telemetry.c b/drivers/platform/chrome/wilco_ec/telemetry.c
index b9d03c33d8dc..1176d543191a 100644
--- a/drivers/platform/chrome/wilco_ec/telemetry.c
+++ b/drivers/platform/chrome/wilco_ec/telemetry.c
@@ -406,8 +406,8 @@ static int telem_device_remove(struct platform_device *pdev)
 	struct telem_device_data *dev_data = platform_get_drvdata(pdev);
 
 	cdev_device_del(&dev_data->cdev, &dev_data->dev);
-	put_device(&dev_data->dev);
 	ida_simple_remove(&telem_ida, MINOR(dev_data->dev.devt));
+	put_device(&dev_data->dev);
 
 	return 0;
 }
-- 
2.20.1

