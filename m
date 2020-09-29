Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A56727CA42
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732333AbgI2MRl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:17:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:50012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730001AbgI2Lgx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:36:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 172A723E51;
        Tue, 29 Sep 2020 11:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379115;
        bh=D9Mmu44ONv5Ajq1SJwLkYrBw/Ft5CgqnmIC5zOjSj+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jMrSE2e/w1cHxMCewZKu5lz5kbbSRkfR+s8AYf+Rp3pSkcGNdKAzGFSLbUOHrAFs1
         KJUGZ2eBg+PZHzxoMMPmDADucU3NDtzVQ87sTmvqcYdOw4ZFkNybTlCFpLjbZhTWf3
         Q28QBtplzJkJd49B2xLFa3Y5qzLY+hrVBGSeIm2c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 020/388] media: smiapp: Fix error handling at NVM reading
Date:   Tue, 29 Sep 2020 12:55:51 +0200
Message-Id: <20200929110011.461358505@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit a5b1d5413534607b05fb34470ff62bf395f5c8d0 ]

If NVM reading failed, the device was left powered on. Fix that.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 42805dfbffeb9..06edbe8749c64 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2327,11 +2327,12 @@ smiapp_sysfs_nvm_read(struct device *dev, struct device_attribute *attr,
 		if (rval < 0) {
 			if (rval != -EBUSY && rval != -EAGAIN)
 				pm_runtime_set_active(&client->dev);
-			pm_runtime_put(&client->dev);
+			pm_runtime_put_noidle(&client->dev);
 			return -ENODEV;
 		}
 
 		if (smiapp_read_nvm(sensor, sensor->nvm)) {
+			pm_runtime_put(&client->dev);
 			dev_err(&client->dev, "nvm read failed\n");
 			return -ENODEV;
 		}
-- 
2.25.1



