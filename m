Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E92EB5F296A
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbiJCHSf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbiJCHRm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:17:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F6D41509;
        Mon,  3 Oct 2022 00:14:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4521AB80E6A;
        Mon,  3 Oct 2022 07:14:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94EF1C433D7;
        Mon,  3 Oct 2022 07:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781262;
        bh=5QJ/+JSs+/bk79947/sX6z4eJz/85AcEUZ1unOH+44M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kn/dK2hB2DY5VbPYo/CXDbkCm+Z9IXc242eZQI4G484gABly02+AQSH8Q1EmTskpM
         Bdh2DEno20+IUcMo9oltuNI6eP9TvkUzuxfBAgDVNG0EKltPAcRDYQZ2/vUFX/Wp2a
         s9io7ULQgeefWKDk83Uy3GuFtVMm7CCWj2n/kN4M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" 
        <nfraprado@collabora.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.19 049/101] media: mediatek: vcodec: Drop platform_get_resource(IORESOURCE_IRQ)
Date:   Mon,  3 Oct 2022 09:10:45 +0200
Message-Id: <20221003070725.679375705@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAD_ENC_HEADER,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

commit a2d2e593d39bc2f29a1cd5e3779af457fd26490c upstream.

Commit a1a2b7125e10 ("of/platform: Drop static setup of IRQ resource
from DT core") removed support for calling platform_get_resource(...,
IORESOURCE_IRQ, ...) on DT-based drivers, but the probe() function of
mtk-vcodec's encoder was still making use of it. This caused the encoder
driver to fail probe.

Since the platform_get_resource() call was only being used to check for
the presence of the interrupt (its returned resource wasn't even used)
and platform_get_irq() was already being used to get the IRQ, simply
drop the use of platform_get_resource(IORESOURCE_IRQ) and handle the
failure of platform_get_irq(), to get the driver probing again.

[hverkuil: drop unused struct resource *res]

Fixes: a1a2b7125e10 ("of/platform: Drop static setup of IRQ resource from DT core")
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/mediatek/vcodec/mtk_vcodec_enc_drv.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_enc_drv.c
+++ b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_enc_drv.c
@@ -228,7 +228,6 @@ static int mtk_vcodec_probe(struct platf
 {
 	struct mtk_vcodec_dev *dev;
 	struct video_device *vfd_enc;
-	struct resource *res;
 	phandle rproc_phandle;
 	enum mtk_vcodec_fw_type fw_type;
 	int ret;
@@ -272,14 +271,12 @@ static int mtk_vcodec_probe(struct platf
 		goto err_res;
 	}
 
-	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	if (res == NULL) {
-		dev_err(&pdev->dev, "failed to get irq resource");
-		ret = -ENOENT;
+	dev->enc_irq = platform_get_irq(pdev, 0);
+	if (dev->enc_irq < 0) {
+		ret = dev->enc_irq;
 		goto err_res;
 	}
 
-	dev->enc_irq = platform_get_irq(pdev, 0);
 	irq_set_status_flags(dev->enc_irq, IRQ_NOAUTOEN);
 	ret = devm_request_irq(&pdev->dev, dev->enc_irq,
 			       mtk_vcodec_enc_irq_handler,


