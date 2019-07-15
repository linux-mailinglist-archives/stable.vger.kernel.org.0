Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A58E3693E3
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405217AbfGOOrm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:47:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:43030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404361AbfGOOrl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:47:41 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6B2420C01;
        Mon, 15 Jul 2019 14:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563202060;
        bh=S89wtKpOCJz7nJ6m9Ov9WsEA1pWOQbr17/Vr/qbYNIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=12BZew0OOK+YRzyG0m+mRny+9KbS8eGHnM1Cv1ULzfFBjifEGBadd+Pq1Q0REAdDD
         ljFfjyEgpSVLzDP/cD20ZnsXjvLOxty0eQ8cDJz9ex5o+Arhnp92niCuR9j7dBkwBk
         wKMkw36BpQ2+VjNuV5+1POHKi0L4JSGSmGrYVDec=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anders Roxell <anders.roxell@linaro.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 35/53] media: i2c: fix warning same module names
Date:   Mon, 15 Jul 2019 10:45:17 -0400
Message-Id: <20190715144535.11636-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715144535.11636-1-sashal@kernel.org>
References: <20190715144535.11636-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anders Roxell <anders.roxell@linaro.org>

[ Upstream commit b2ce5617dad254230551feda3599f2cc68e53ad8 ]

When building with CONFIG_VIDEO_ADV7511 and CONFIG_DRM_I2C_ADV7511
enabled as loadable modules, we see the following warning:

  drivers/gpu/drm/bridge/adv7511/adv7511.ko
  drivers/media/i2c/adv7511.ko

Rework so that the file is named adv7511-v4l2.c.

Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/Makefile                      | 2 +-
 drivers/media/i2c/{adv7511.c => adv7511-v4l2.c} | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)
 rename drivers/media/i2c/{adv7511.c => adv7511-v4l2.c} (99%)

diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index 07db257abfc1..d5711def1fff 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -28,7 +28,7 @@ obj-$(CONFIG_VIDEO_ADV7393) += adv7393.o
 obj-$(CONFIG_VIDEO_ADV7604) += adv7604.o
 obj-$(CONFIG_VIDEO_ADV7842) += adv7842.o
 obj-$(CONFIG_VIDEO_AD9389B) += ad9389b.o
-obj-$(CONFIG_VIDEO_ADV7511) += adv7511.o
+obj-$(CONFIG_VIDEO_ADV7511) += adv7511-v4l2.o
 obj-$(CONFIG_VIDEO_VPX3220) += vpx3220.o
 obj-$(CONFIG_VIDEO_VS6624)  += vs6624.o
 obj-$(CONFIG_VIDEO_BT819) += bt819.o
diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511-v4l2.c
similarity index 99%
rename from drivers/media/i2c/adv7511.c
rename to drivers/media/i2c/adv7511-v4l2.c
index c24839cfcc35..b35400e4e9af 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511-v4l2.c
@@ -17,6 +17,11 @@
  * SOFTWARE.
  */
 
+/*
+ * This file is named adv7511-v4l2.c so it doesn't conflict with the Analog
+ * Device ADV7511 (config fragment CONFIG_DRM_I2C_ADV7511).
+ */
+
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-- 
2.20.1

