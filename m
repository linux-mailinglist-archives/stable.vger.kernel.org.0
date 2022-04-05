Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCC34F44BA
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 00:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356322AbiDEMXH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356220AbiDEKXa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:23:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60BE8BAB88;
        Tue,  5 Apr 2022 03:07:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F09B46167E;
        Tue,  5 Apr 2022 10:07:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105EFC385A1;
        Tue,  5 Apr 2022 10:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153276;
        bh=sUjtqpLKMHu18jX7PBFfofAGO5LsbRcb2dWLAoSItpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VWHCwsj4NkcRgOdQMPRrc/YVAgHKnowNtgLY/c96OdWLAEXfQeclrxU8+zPzY+iXs
         oKN7lwrLbL3tDhWwEPhD+8/KM0e5nl+jY8mIN0obkhPlwMVAU7faaBi5hYEIa8LJPJ
         Gs7hydBweaMw4CDI60DAYsEV6mKR2j1mMJ2bFeCg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Hilman <khilman@baylibre.com>,
        Johan Hovold <johan@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.10 117/599] media: davinci: vpif: fix unbalanced runtime PM enable
Date:   Tue,  5 Apr 2022 09:26:51 +0200
Message-Id: <20220405070302.322672550@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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
 	static struct resource	*res, *res_irq;
 	struct platform_device *pdev_capture, *pdev_display;
 	struct device_node *endpoint = NULL;
+	int ret;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	vpif_base = devm_ioremap_resource(&pdev->dev, res);
@@ -458,8 +459,8 @@ static int vpif_probe(struct platform_de
 	res_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (!res_irq) {
 		dev_warn(&pdev->dev, "Missing IRQ resource.\n");
-		pm_runtime_put(&pdev->dev);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_put_rpm;
 	}
 
 	pdev_capture = devm_kzalloc(&pdev->dev, sizeof(*pdev_capture),
@@ -493,6 +494,12 @@ static int vpif_probe(struct platform_de
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


