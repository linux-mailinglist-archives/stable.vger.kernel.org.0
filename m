Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2FE34122D3
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377307AbhITSSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:18:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:37204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358808AbhITSQN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:16:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDB8561414;
        Mon, 20 Sep 2021 17:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158512;
        bh=PHPVcQ5YHYDkAXSwAUXuZYpebFQsZFiC3EuP0KlIyJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=moEklfMLbM/I/3VIZE7kSdFbfd/b0WLJ2AMpZ+TB3ks+YZOeP9EZ4Rhi8z29eT/Fu
         g4Zb3hnc89X6JJOcS9OFbUx8TXAY4rqzHKEYcBmpXbs+Giin2Heh0tt21lheOO/nZ1
         b9cBpYurTpUk0fgD8s2WxTKdhkGbygeFoNkaCaXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nadezda Lutovinova <lutovinova@ispras.ru>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 158/260] usb: musb: musb_dsps: request_irq() after initializing musb
Date:   Mon, 20 Sep 2021 18:42:56 +0200
Message-Id: <20210920163936.468801161@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nadezda Lutovinova <lutovinova@ispras.ru>

[ Upstream commit 7c75bde329d7e2a93cf86a5c15c61f96f1446cdc ]

If IRQ occurs between calling  dsps_setup_optional_vbus_irq()
and  dsps_create_musb_pdev(), then null pointer dereference occurs
since glue->musb wasn't initialized yet.

The patch puts initializing of neccesery data before registration
of the interrupt handler.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Nadezda Lutovinova <lutovinova@ispras.ru>
Link: https://lore.kernel.org/r/20210819163323.17714-1-lutovinova@ispras.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/musb/musb_dsps.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index 327d4f7baaf7..89d659cef5c6 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -890,23 +890,22 @@ static int dsps_probe(struct platform_device *pdev)
 	if (!glue->usbss_base)
 		return -ENXIO;
 
-	if (usb_get_dr_mode(&pdev->dev) == USB_DR_MODE_PERIPHERAL) {
-		ret = dsps_setup_optional_vbus_irq(pdev, glue);
-		if (ret)
-			goto err_iounmap;
-	}
-
 	platform_set_drvdata(pdev, glue);
 	pm_runtime_enable(&pdev->dev);
 	ret = dsps_create_musb_pdev(glue, pdev);
 	if (ret)
 		goto err;
 
+	if (usb_get_dr_mode(&pdev->dev) == USB_DR_MODE_PERIPHERAL) {
+		ret = dsps_setup_optional_vbus_irq(pdev, glue);
+		if (ret)
+			goto err;
+	}
+
 	return 0;
 
 err:
 	pm_runtime_disable(&pdev->dev);
-err_iounmap:
 	iounmap(glue->usbss_base);
 	return ret;
 }
-- 
2.30.2



