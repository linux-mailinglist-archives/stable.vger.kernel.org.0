Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8E52F46B
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729219AbfE3EiJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:38:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:56214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728205AbfE3DMq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:46 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 136A524502;
        Thu, 30 May 2019 03:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185966;
        bh=ID128AdOvohhUlVirNhpCMtz499mR40R1nvT+k2SiIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=no7b5bvPK+FmpKMdbAPqihNuaYf7WxOBb2uwkzUr/9L/ISAIXpNxbhogJsP8vAqav
         S+L+UCxN9A0uGvlpzdNAHDkTkTf65NtCAa8mls103mf3C9gvRpOkhllAcVRT9FM97W
         Wq+OW21IY7PLckB12k9uR41yCmQpEpBDYKCkbFQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Anholt <eric@anholt.net>,
        Dave Emett <david.emett@broadcom.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 394/405] drm/v3d: Handle errors from IRQ setup.
Date:   Wed, 29 May 2019 20:06:32 -0700
Message-Id: <20190530030600.532094254@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit fc22771547e7e8a63679f0218e943d72b107de65 ]

Noted in review by Dave Emett for V3D 4.2 support.

Signed-off-by: Eric Anholt <eric@anholt.net>
Link: https://patchwork.freedesktop.org/patch/msgid/20190308174336.7866-1-eric@anholt.net
Reviewed-by: Dave Emett <david.emett@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/v3d/v3d_drv.c |  8 ++++++--
 drivers/gpu/drm/v3d/v3d_drv.h |  2 +-
 drivers/gpu/drm/v3d/v3d_irq.c | 13 +++++++++++--
 3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/v3d/v3d_drv.c b/drivers/gpu/drm/v3d/v3d_drv.c
index f0afcec72c348..30ae1c74edaa8 100644
--- a/drivers/gpu/drm/v3d/v3d_drv.c
+++ b/drivers/gpu/drm/v3d/v3d_drv.c
@@ -312,14 +312,18 @@ static int v3d_platform_drm_probe(struct platform_device *pdev)
 	if (ret)
 		goto dev_destroy;
 
-	v3d_irq_init(v3d);
+	ret = v3d_irq_init(v3d);
+	if (ret)
+		goto gem_destroy;
 
 	ret = drm_dev_register(drm, 0);
 	if (ret)
-		goto gem_destroy;
+		goto irq_disable;
 
 	return 0;
 
+irq_disable:
+	v3d_irq_disable(v3d);
 gem_destroy:
 	v3d_gem_destroy(drm);
 dev_destroy:
diff --git a/drivers/gpu/drm/v3d/v3d_drv.h b/drivers/gpu/drm/v3d/v3d_drv.h
index fdda3037f7af7..2fdb456b72d32 100644
--- a/drivers/gpu/drm/v3d/v3d_drv.h
+++ b/drivers/gpu/drm/v3d/v3d_drv.h
@@ -310,7 +310,7 @@ void v3d_reset(struct v3d_dev *v3d);
 void v3d_invalidate_caches(struct v3d_dev *v3d);
 
 /* v3d_irq.c */
-void v3d_irq_init(struct v3d_dev *v3d);
+int v3d_irq_init(struct v3d_dev *v3d);
 void v3d_irq_enable(struct v3d_dev *v3d);
 void v3d_irq_disable(struct v3d_dev *v3d);
 void v3d_irq_reset(struct v3d_dev *v3d);
diff --git a/drivers/gpu/drm/v3d/v3d_irq.c b/drivers/gpu/drm/v3d/v3d_irq.c
index 69338da70ddce..29d746cfce572 100644
--- a/drivers/gpu/drm/v3d/v3d_irq.c
+++ b/drivers/gpu/drm/v3d/v3d_irq.c
@@ -156,7 +156,7 @@ v3d_hub_irq(int irq, void *arg)
 	return status;
 }
 
-void
+int
 v3d_irq_init(struct v3d_dev *v3d)
 {
 	int ret, core;
@@ -173,13 +173,22 @@ v3d_irq_init(struct v3d_dev *v3d)
 	ret = devm_request_irq(v3d->dev, platform_get_irq(v3d->pdev, 0),
 			       v3d_hub_irq, IRQF_SHARED,
 			       "v3d_hub", v3d);
+	if (ret)
+		goto fail;
+
 	ret = devm_request_irq(v3d->dev, platform_get_irq(v3d->pdev, 1),
 			       v3d_irq, IRQF_SHARED,
 			       "v3d_core0", v3d);
 	if (ret)
-		dev_err(v3d->dev, "IRQ setup failed: %d\n", ret);
+		goto fail;
 
 	v3d_irq_enable(v3d);
+	return 0;
+
+fail:
+	if (ret != -EPROBE_DEFER)
+		dev_err(v3d->dev, "IRQ setup failed: %d\n", ret);
+	return ret;
 }
 
 void
-- 
2.20.1



