Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD1026F17C
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbgIRCIU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:08:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:59476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728069AbgIRCIT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:08:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F410C23976;
        Fri, 18 Sep 2020 02:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394896;
        bh=vawbVYzuOVeJn+j5hJ/QMNQt5FhYIupGwnPF8g0WWcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nepeQtGo6pCNm9zg1bQOEhscJOr46pZAv9E41WKCYJca0WFQvPHHIc5wrYryz4NJT
         nu4cdyc5/aZJkvVUYxHW7um4Uh1LrcwWvvOIWAs7wsy/Q08oWqUw4cNVCiGk/MHlE8
         rmIu4rL6e3hKUqzew+Yk/gyXt1OtfAXhMhUdPml8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 011/206] media: smiapp: Fix error handling at NVM reading
Date:   Thu, 17 Sep 2020 22:04:47 -0400
Message-Id: <20200918020802.2065198-11-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 4731e1c72f960..0a434bdce3b3b 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2337,11 +2337,12 @@ smiapp_sysfs_nvm_read(struct device *dev, struct device_attribute *attr,
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

