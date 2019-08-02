Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6E17F1FF
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405019AbfHBJnE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:43:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:45760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404322AbfHBJnD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:43:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AF8A2087E;
        Fri,  2 Aug 2019 09:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738982;
        bh=BlEdPilXp9d7jLs4b/BFZL+lQ7YBoX8RWs64fzT+mww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mQpVV3fFywUXmyVh1HdrHekZNRiIV3XbnJZmPpw0U62z27tGyw4rwv0nrozTnzAm0
         ah/yY77EKtCILan6a6gtsDY6kEnRhUI131soqlbqHC2IlHKW1YoD1mTXyDjN0lDLCo
         sckMnmgDg3GhXQa/JrMIWfG+RZVUIP8duUtXRspU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anders Roxell <anders.roxell@linaro.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 046/223] media: i2c: fix warning same module names
Date:   Fri,  2 Aug 2019 11:34:31 +0200
Message-Id: <20190802092241.921660572@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 92773b2e6225..bfe0afc209b8 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -29,7 +29,7 @@ obj-$(CONFIG_VIDEO_ADV7393) += adv7393.o
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
index 5f1c8ee8a50e..b87c9e7ff146 100644
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



