Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE964F2F45
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238071AbiDEJEh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243547AbiDEIuk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:50:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 261D0205E3;
        Tue,  5 Apr 2022 01:39:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7E7361535;
        Tue,  5 Apr 2022 08:39:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40DAC385A3;
        Tue,  5 Apr 2022 08:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147944;
        bh=AE8siXgTZ1H7IScJ7cFvEU7Ff6JT4XzexfIs6peE5Z8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SizHnFxf8y5VdRkO9tae6BtkxTekJvB+Id1H72VpLr2u9UVH2rkoZT8LynPgjjI1J
         bZQH8M79Axh9AXoSvWu4SjYb16QXFYEcxehYicSSB0jh4imb7mqLcVS4QfKAts5PUk
         MX7a29JzslSaKoLovycbddghTp8MVuZIxeWG0FYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Hilman <khilman@baylibre.com>,
        Johan Hovold <johan@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.16 0178/1017] media: davinci: vpif: fix unbalanced runtime PM enable
Date:   Tue,  5 Apr 2022 09:18:11 +0200
Message-Id: <20220405070359.518863423@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Johan Hovold <johan@kernel.org>

commit d42b3ad105b5d3481f6a56bc789aa2b27aa09325 upstream.

Make sure to disable runtime PM before returning on probe errors.

Fixes: 479f7a118105 ("[media] davinci: vpif: adaptions for DT support")
Cc: stable@vger.kernel.org
Cc: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/davinci/vpif.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/media/platform/davinci/vpif.c
+++ b/drivers/media/platform/davinci/vpif.c
@@ -428,6 +428,7 @@ static int vpif_probe(struct platform_de
 	static struct resource *res_irq;
 	struct platform_device *pdev_capture, *pdev_display;
 	struct device_node *endpoint = NULL;
+	int ret;
 
 	vpif_base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(vpif_base))
@@ -456,8 +457,8 @@ static int vpif_probe(struct platform_de
 	res_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (!res_irq) {
 		dev_warn(&pdev->dev, "Missing IRQ resource.\n");
-		pm_runtime_put(&pdev->dev);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_put_rpm;
 	}
 
 	pdev_capture = devm_kzalloc(&pdev->dev, sizeof(*pdev_capture),
@@ -491,6 +492,12 @@ static int vpif_probe(struct platform_de
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


