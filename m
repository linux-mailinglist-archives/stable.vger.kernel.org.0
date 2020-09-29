Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD3327CCF3
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729018AbgI2LOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:14:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:57432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728480AbgI2LO3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:14:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EBD220848;
        Tue, 29 Sep 2020 11:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378068;
        bh=xLEf58mjGmbH0CWWabSTZzpE4t32riFaLBMWYf6Q/rg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PqIuPjRrPij/5RPAFtFyyCqIcXSVP1C6ziGADElMAGY5HuNuT8YlD56wewJ+sVrmU
         lcjpOauwH1R++pwB/Z4VWGdYFKc9kAwCHuE+EGmEY/lRchMrSyoEcRa1tpvnYIWcvJ
         c63qSwUpkvuX1McZYSJwmNJ2/TNS3bY62t076VUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 023/166] media: smiapp: Fix error handling at NVM reading
Date:   Tue, 29 Sep 2020 12:58:55 +0200
Message-Id: <20200929105936.351959864@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
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
index e4d7f2febf00c..05b3974bd9202 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2338,11 +2338,12 @@ smiapp_sysfs_nvm_read(struct device *dev, struct device_attribute *attr,
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



