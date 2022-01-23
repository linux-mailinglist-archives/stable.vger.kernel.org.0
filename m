Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE595497594
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 21:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240143AbiAWUvz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 15:51:55 -0500
Received: from www.linuxtv.org ([130.149.80.248]:60208 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237715AbiAWUvy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 23 Jan 2022 15:51:54 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1nBjLX-004u69-Tz; Sun, 23 Jan 2022 20:20:19 +0000
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
Date:   Sun, 23 Jan 2022 20:18:42 +0000
Subject: [git:media_stage/master] media: davinci: vpif: fix unbalanced runtime PM enable
To:     linuxtv-commits@linuxtv.org
Cc:     Johan Hovold <johan@kernel.org>, stable@vger.kernel.org,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Kevin Hilman <khilman@baylibre.com>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1nBjLX-004u69-Tz@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: davinci: vpif: fix unbalanced runtime PM enable
Author:  Johan Hovold <johan@kernel.org>
Date:    Wed Dec 22 15:20:23 2021 +0100

Make sure to disable runtime PM before returning on probe errors.

Fixes: 479f7a118105 ("[media] davinci: vpif: adaptions for DT support")
Cc: stable@vger.kernel.org
Cc: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>

 drivers/media/platform/davinci/vpif.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

---

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
