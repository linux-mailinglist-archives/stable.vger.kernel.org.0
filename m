Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B169626F481
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbgIRDOx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 23:14:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726476AbgIRCBo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:01:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBF5322211;
        Fri, 18 Sep 2020 02:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394496;
        bh=D9Mmu44ONv5Ajq1SJwLkYrBw/Ft5CgqnmIC5zOjSj+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oTAac59j1QfDBeM4F3Lz3++DLWk0/nwQ4mqfExjyH6ogIg+KXryIV+GiNfBr9xnZ8
         3ZEWfWf4E5GVZVCJmgsr4EhLKBYPHLzMk4nuLUi1dKj2J1VlgtUiJ5bwCVKpfIK58X
         IAOn5K8K6DmCBO8JH8S7s8FGoiEUL3ICwpd1VJMo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 021/330] media: smiapp: Fix error handling at NVM reading
Date:   Thu, 17 Sep 2020 21:56:01 -0400
Message-Id: <20200918020110.2063155-21-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
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

