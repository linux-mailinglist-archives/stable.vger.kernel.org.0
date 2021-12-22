Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8A947D38B
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 15:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237093AbhLVOU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 09:20:56 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48750 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241186AbhLVOUy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 09:20:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 490B0B81CD6;
        Wed, 22 Dec 2021 14:20:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1215AC36AE8;
        Wed, 22 Dec 2021 14:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640182852;
        bh=p2tpqMrb/8u2b/uYsVHFj/Wz9xJRNpu0RJPMbbPGvlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a3BASscMyF0R4HGLKoTEBurIYADhcBzP9jhTmWA4UdQjbSbv0Va/qUJF9eWHmHBby
         TSNqk70vB47i2IQH4aI6VGQMb077ogJb87lAYEeChGTDhc/oekuvyNBBL7+OwbNn2g
         jBt6fIK6CQxomlYAUiZviTe/cS7ZitShwlvida/wneRTIcmMJPj6Et/7ahLSZre3hJ
         7DkqUUxW98ihcbGN8fYiGZCm3+NBpXtIQs35pI40F6HP3rR5cvOg2FH9ivhmfCqyhn
         O/bPV6nouRJILBXUCgIwkWmtu9XnI4TmzGX+F/3QUPidHHpk3lS4f7kWy7/yBig28x
         4+GaJumA8w2+w==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1n02U0-0007ul-P5; Wed, 22 Dec 2021 15:20:44 +0100
From:   Johan Hovold <johan@kernel.org>
To:     "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 2/4] media: davinci: vpif: fix unbalanced runtime PM enable
Date:   Wed, 22 Dec 2021 15:20:23 +0100
Message-Id: <20211222142025.30364-3-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211222142025.30364-1-johan@kernel.org>
References: <20211222142025.30364-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure to disable runtime PM before returning on probe errors.

Fixes: 479f7a118105 ("[media] davinci: vpif: adaptions for DT support")
Cc: stable@vger.kernel.org      # 4.12: 4024d6f601e3c
Cc: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/media/platform/davinci/vpif.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
index 9752a5ec36f7..1f5eacf48580 100644
--- a/drivers/media/platform/davinci/vpif.c
+++ b/drivers/media/platform/davinci/vpif.c
@@ -428,6 +428,7 @@ static int vpif_probe(struct platform_device *pdev)
 	static struct resource *res_irq;
 	struct platform_device *pdev_capture, *pdev_display;
 	struct device_node *endpoint = NULL;
+	int ret;
 
 	vpif_base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(vpif_base))
@@ -456,8 +457,8 @@ static int vpif_probe(struct platform_device *pdev)
 	res_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (!res_irq) {
 		dev_warn(&pdev->dev, "Missing IRQ resource.\n");
-		pm_runtime_put(&pdev->dev);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_put_rpm;
 	}
 
 	pdev_capture = devm_kzalloc(&pdev->dev, sizeof(*pdev_capture),
@@ -491,6 +492,12 @@ static int vpif_probe(struct platform_device *pdev)
 	}
 
 	return 0;
+
+err_put_rpm:
+	pm_runtime_put(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+
+	return ret;
 }
 
 static int vpif_remove(struct platform_device *pdev)
-- 
2.32.0

