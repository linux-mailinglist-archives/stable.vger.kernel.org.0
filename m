Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81BFE4F01AA
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 14:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241685AbiDBMyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 08:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232747AbiDBMyW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 08:54:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2BEC18C0C9
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 05:52:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A97B61488
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 12:52:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78CB0C340EC;
        Sat,  2 Apr 2022 12:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648903949;
        bh=CGuC4XOHVKk3+0ZUHl3Z8+N9svGaUfLKBeVsAhGZUjk=;
        h=Subject:To:Cc:From:Date:From;
        b=XFGr6RlshoXvFrQVPHdf1MfmvamnNX3oPbxkxSVVhSXHNz8AIIpoZbV9K+oj5ZUsc
         wylwXqCIsEn3U/DLwH2PyZZQsycVcWQBraChFMmn529tGO1oLB2lXBZPloHkV5M6b2
         3ts05HxzmWAR/CxEhDdPR6IXlWCkw31mwCsHNMXQ=
Subject: FAILED: patch "[PATCH] media: davinci: vpif: fix unbalanced runtime PM enable" failed to apply to 5.4-stable tree
To:     johan@kernel.org, hverkuil-cisco@xs4all.nl, khilman@baylibre.com,
        mchehab@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 02 Apr 2022 14:52:27 +0200
Message-ID: <16489039477879@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d42b3ad105b5d3481f6a56bc789aa2b27aa09325 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Wed, 22 Dec 2021 15:20:23 +0100
Subject: [PATCH] media: davinci: vpif: fix unbalanced runtime PM enable

Make sure to disable runtime PM before returning on probe errors.

Fixes: 479f7a118105 ("[media] davinci: vpif: adaptions for DT support")
Cc: stable@vger.kernel.org
Cc: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>

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

